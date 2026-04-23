<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="java.sql.*,java.util.*" %>
<%@ include file="/common/dbutil.jspf" %>
<%
Teacher user = (Teacher) session.getAttribute("user");
if (user == null) { response.sendRedirect(request.getContextPath() + "/Login.action"); return; }
String schoolCd = user.getSchoolCd();
String flash = null;
String error = null;
List<Map<String,String>> students = new ArrayList<>();
List<Map<String,String>> subjects = new ArrayList<>();
List<Map<String,Object>> scores = new ArrayList<>();
String studentNo = nv(request.getParameter("studentNo"));
String subjectCd = nv(request.getParameter("subjectCd"));
String testNoStr = nv(request.getParameter("testNo"));
String pointStr = nv(request.getParameter("point"));
try (Connection con = getDbConnection()) {
    ensureAssumedTables(con);
    String action = nv(request.getParameter("formAction"));
    if ("save".equals(action)) {
        studentNo = nv(request.getParameter("studentNo"));
        subjectCd = nv(request.getParameter("subjectCd"));
        testNoStr = nv(request.getParameter("testNo"));
        pointStr = nv(request.getParameter("point"));
        if (studentNo.isEmpty() || subjectCd.isEmpty() || testNoStr.isEmpty() || pointStr.isEmpty()) {
            error = "学生・科目・回数・点数は必須です。";
        } else {
            int testNo = toInt(testNoStr, 0);
            int point = toInt(pointStr, -1);
            if (point < 0 || point > 100) {
                error = "点数は0〜100で入力してください。";
            } else {
                try (PreparedStatement up = con.prepareStatement("UPDATE TEST_SCORE SET POINT=? WHERE STUDENT_NO=? AND SUBJECT_CD=? AND TEST_NO=? AND SCHOOL_CD=?")) {
                    up.setInt(1, point); up.setString(2, studentNo); up.setString(3, subjectCd); up.setInt(4, testNo); up.setString(5, schoolCd);
                    int count = up.executeUpdate();
                    if (count == 0) {
                        try (PreparedStatement ins = con.prepareStatement("INSERT INTO TEST_SCORE(STUDENT_NO, SUBJECT_CD, TEST_NO, POINT, SCHOOL_CD) VALUES(?, ?, ?, ?, ?)")) {
                            ins.setString(1, studentNo); ins.setString(2, subjectCd); ins.setInt(3, testNo); ins.setInt(4, point); ins.setString(5, schoolCd); ins.executeUpdate();
                        }
                    }
                    flash = "成績を保存しました。";
                }
            }
        }
    } else if ("delete".equals(action)) {
        String id = nv(request.getParameter("id"));
        try (PreparedStatement st = con.prepareStatement("DELETE FROM TEST_SCORE WHERE ID=? AND SCHOOL_CD=?")) {
            st.setLong(1, Long.parseLong(id)); st.setString(2, schoolCd); st.executeUpdate();
            flash = "成績を削除しました。";
        }
    } else if ("edit".equals(action)) {
        String id = nv(request.getParameter("id"));
        try (PreparedStatement st = con.prepareStatement("SELECT * FROM TEST_SCORE WHERE ID=? AND SCHOOL_CD=?")) {
            st.setLong(1, Long.parseLong(id)); st.setString(2, schoolCd);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    studentNo = rs.getString("STUDENT_NO");
                    subjectCd = rs.getString("SUBJECT_CD");
                    testNoStr = String.valueOf(rs.getInt("TEST_NO"));
                    pointStr = String.valueOf(rs.getInt("POINT"));
                }
            }
        }
    }
    try (PreparedStatement st = con.prepareStatement("SELECT NO, NAME FROM STUDENT WHERE SCHOOL_CD=? ORDER BY NO")) {
        st.setString(1, schoolCd);
        try (ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Map<String,String> m = new HashMap<>(); m.put("no", rs.getString("NO")); m.put("name", rs.getString("NAME")); students.add(m);
            }
        }
    }
    try (PreparedStatement st = con.prepareStatement("SELECT CD, NAME FROM SUBJECT WHERE SCHOOL_CD=? ORDER BY CD")) {
        st.setString(1, schoolCd);
        try (ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Map<String,String> m = new HashMap<>(); m.put("cd", rs.getString("CD")); m.put("name", rs.getString("NAME")); subjects.add(m);
            }
        }
    }
    try (PreparedStatement st = con.prepareStatement(
            "SELECT t.ID, t.STUDENT_NO, s.NAME AS STUDENT_NAME, t.SUBJECT_CD, sb.NAME AS SUBJECT_NAME, t.TEST_NO, t.POINT " +
            "FROM TEST_SCORE t JOIN STUDENT s ON t.STUDENT_NO=s.NO AND t.SCHOOL_CD=s.SCHOOL_CD " +
            "LEFT JOIN SUBJECT sb ON t.SUBJECT_CD=sb.CD AND t.SCHOOL_CD=sb.SCHOOL_CD " +
            "WHERE t.SCHOOL_CD=? ORDER BY t.ID DESC")) {
        st.setString(1, schoolCd);
        try (ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Map<String,Object> m = new HashMap<>();
                m.put("id", rs.getLong("ID"));
                m.put("studentNo", rs.getString("STUDENT_NO"));
                m.put("studentName", rs.getString("STUDENT_NAME"));
                m.put("subjectCd", rs.getString("SUBJECT_CD"));
                m.put("subjectName", rs.getString("SUBJECT_NAME"));
                m.put("testNo", rs.getInt("TEST_NO"));
                m.put("point", rs.getInt("POINT"));
                scores.add(m);
            }
        }
    }
}
request.setAttribute("students", students);
request.setAttribute("subjects", subjects);
request.setAttribute("scores", scores);
request.setAttribute("flash", flash);
request.setAttribute("errorMsg", error);
request.setAttribute("studentNo", studentNo);
request.setAttribute("subjectCd", subjectCd);
request.setAttribute("testNo", testNoStr);
request.setAttribute("point", pointStr);
%>
<c:import url="/common/base.jsp">
    <c:param name="title">成績登録</c:param>
    <c:param name="scripts"></c:param>
    <c:param name="content">
        <section class="me-4">
            <h2 class="h3 mb-3 fw-norma bg-secondary bg-opacity-10 py-2 px-4">成績登録</h2>
            <c:if test="${not empty flash}"><div class="alert alert-success mx-4">${flash}</div></c:if>
            <c:if test="${not empty errorMsg}"><div class="alert alert-danger mx-4">${errorMsg}</div></c:if>
            <div class="card mx-4 mb-4">
                <div class="card-header">成績入力</div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/scoremanager/main/test_regist.jsp" method="post" class="row g-3">
                        <input type="hidden" name="formAction" value="save">
                        <div class="col-md-4">
                            <label class="form-label">学生</label>
                            <select name="studentNo" class="form-select" required>
                                <option value="">----</option>
                                <c:forEach var="s" items="${students}">
                                    <option value="${s.no}" <c:if test="${studentNo == s.no}">selected</c:if>>${s.no} - ${s.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">科目</label>
                            <select name="subjectCd" class="form-select" required>
                                <option value="">----</option>
                                <c:forEach var="s" items="${subjects}">
                                    <option value="${s.cd}" <c:if test="${subjectCd == s.cd}">selected</c:if>>${s.cd} - ${s.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2"><label class="form-label">回数</label><input type="number" min="1" name="testNo" value="${testNo}" class="form-control" required></div>
                        <div class="col-md-2"><label class="form-label">点数</label><input type="number" min="0" max="100" name="point" value="${point}" class="form-control" required></div>
                        <div class="col-12"><button class="btn btn-primary" type="submit">保存</button> <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/scoremanager/main/test_regist.jsp">クリア</a></div>
                    </form>
                </div>
            </div>
            <div class="px-4">
                <table class="table table-bordered table-striped align-middle">
                    <thead><tr><th>ID</th><th>学生</th><th>科目</th><th>回数</th><th>点数</th><th style="width:180px;">操作</th></tr></thead>
                    <tbody>
                        <c:forEach var="t" items="${scores}">
                            <tr>
                                <td>${t.id}</td>
                                <td>${t.studentNo} - ${t.studentName}</td>
                                <td>${t.subjectCd} - ${t.subjectName}</td>
                                <td>${t.testNo}</td>
                                <td>${t.point}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/scoremanager/main/test_regist.jsp" method="post" style="display:inline;">
                                        <input type="hidden" name="formAction" value="edit"><input type="hidden" name="id" value="${t.id}">
                                        <button class="btn btn-sm btn-outline-primary" type="submit">読込</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/scoremanager/main/test_regist.jsp" method="post" style="display:inline;" onsubmit="return confirm('削除しますか？');">
                                        <input type="hidden" name="formAction" value="delete"><input type="hidden" name="id" value="${t.id}">
                                        <button class="btn btn-sm btn-outline-danger" type="submit">削除</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <c:if test="${empty scores}"><p>成績情報が存在しませんでした。</p></c:if>
            </div>
        </section>
    </c:param>
</c:import>
