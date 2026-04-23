<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="java.sql.*,java.util.*" %>
<%@ include file="/common/dbutil.jspf" %>
<%
Teacher user = (Teacher) session.getAttribute("user");
if (user == null) { response.sendRedirect(request.getContextPath() + "/Login.action"); return; }
String schoolCd = user.getSchoolCd();
List<Map<String,String>> subjects = new ArrayList<>();
List<Map<String,String>> classes = new ArrayList<>();
List<Map<String,Object>> scores = new ArrayList<>();
String selectedSubjectCd = nv(request.getParameter("subjectCd"));
String selectedClassNum = nv(request.getParameter("classNum"));
String selectedStudentNo = nv(request.getParameter("studentNo"));
String selectedTestNo = nv(request.getParameter("testNo"));
try (Connection con = getDbConnection()) {
    ensureAssumedTables(con);
    try (PreparedStatement st = con.prepareStatement("SELECT CD, NAME FROM SUBJECT WHERE SCHOOL_CD=? ORDER BY CD")) {
        st.setString(1, schoolCd);
        try (ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Map<String,String> m = new HashMap<>(); m.put("cd", rs.getString("CD")); m.put("name", rs.getString("NAME")); subjects.add(m);
            }
        }
    }
    try (PreparedStatement st = con.prepareStatement("SELECT CLASS_NUM FROM CLASS_NUM WHERE SCHOOL_CD=? ORDER BY CLASS_NUM")) {
        st.setString(1, schoolCd);
        try (ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Map<String,String> m = new HashMap<>(); m.put("classNum", rs.getString("CLASS_NUM")); classes.add(m);
            }
        }
    }
    StringBuilder sql = new StringBuilder(
        "SELECT t.ID, s.NO, s.NAME AS STUDENT_NAME, s.CLASS_NUM, sb.CD AS SUBJECT_CD, sb.NAME AS SUBJECT_NAME, t.TEST_NO, t.POINT " +
        "FROM TEST_SCORE t JOIN STUDENT s ON t.STUDENT_NO=s.NO AND t.SCHOOL_CD=s.SCHOOL_CD " +
        "LEFT JOIN SUBJECT sb ON t.SUBJECT_CD=sb.CD AND t.SCHOOL_CD=sb.SCHOOL_CD WHERE t.SCHOOL_CD=?");
    List<Object> params = new ArrayList<>(); params.add(schoolCd);
    if (!selectedSubjectCd.isEmpty()) { sql.append(" AND t.SUBJECT_CD=?"); params.add(selectedSubjectCd); }
    if (!selectedClassNum.isEmpty()) { sql.append(" AND s.CLASS_NUM=?"); params.add(selectedClassNum); }
    if (!selectedStudentNo.isEmpty()) { sql.append(" AND s.NO LIKE ?"); params.add("%" + selectedStudentNo + "%"); }
    if (!selectedTestNo.isEmpty()) { sql.append(" AND t.TEST_NO=?"); params.add(toInt(selectedTestNo, 0)); }
    sql.append(" ORDER BY s.NO, t.SUBJECT_CD, t.TEST_NO");
    try (PreparedStatement st = con.prepareStatement(sql.toString())) {
        for (int i = 0; i < params.size(); i++) st.setObject(i + 1, params.get(i));
        try (ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Map<String,Object> m = new HashMap<>();
                m.put("studentNo", rs.getString("NO"));
                m.put("studentName", rs.getString("STUDENT_NAME"));
                m.put("classNum", rs.getString("CLASS_NUM"));
                m.put("subjectCd", rs.getString("SUBJECT_CD"));
                m.put("subjectName", rs.getString("SUBJECT_NAME"));
                m.put("testNo", rs.getInt("TEST_NO"));
                m.put("point", rs.getInt("POINT"));
                scores.add(m);
            }
        }
    }
}
request.setAttribute("subjects", subjects);
request.setAttribute("classes", classes);
request.setAttribute("scores", scores);
request.setAttribute("selectedSubjectCd", selectedSubjectCd);
request.setAttribute("selectedClassNum", selectedClassNum);
request.setAttribute("selectedStudentNo", selectedStudentNo);
request.setAttribute("selectedTestNo", selectedTestNo);
%>
<c:import url="/common/base.jsp">
    <c:param name="title">成績参照</c:param>
    <c:param name="scripts"></c:param>
    <c:param name="content">
        <section class="me-4">
            <h2 class="h3 mb-3 fw-norma bg-secondary bg-opacity-10 py-2 px-4">成績参照</h2>
            <form action="${pageContext.request.contextPath}/scoremanager/main/test_list.jsp" method="get" class="row g-3 px-4 mb-4 align-items-end">
                <div class="col-md-3"><label class="form-label">学生番号</label><input type="text" class="form-control" name="studentNo" value="${selectedStudentNo}"></div>
                <div class="col-md-2"><label class="form-label">クラス</label><select class="form-select" name="classNum"><option value="">----</option><c:forEach var="c" items="${classes}"><option value="${c.classNum}" <c:if test="${selectedClassNum == c.classNum}">selected</c:if>>${c.classNum}</option></c:forEach></select></div>
                <div class="col-md-3"><label class="form-label">科目</label><select class="form-select" name="subjectCd"><option value="">----</option><c:forEach var="s" items="${subjects}"><option value="${s.cd}" <c:if test="${selectedSubjectCd == s.cd}">selected</c:if>>${s.cd} - ${s.name}</option></c:forEach></select></div>
                <div class="col-md-2"><label class="form-label">回数</label><input type="number" class="form-control" name="testNo" value="${selectedTestNo}"></div>
                <div class="col-md-2"><button class="btn btn-primary" type="submit">検索</button> <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/scoremanager/main/test_list.jsp">解除</a></div>
            </form>
            <div class="px-4">
                <table class="table table-bordered table-striped align-middle">
                    <thead><tr><th>学生番号</th><th>氏名</th><th>クラス</th><th>科目</th><th>回数</th><th>点数</th></tr></thead>
                    <tbody>
                        <c:forEach var="t" items="${scores}">
                            <tr>
                                <td>${t.studentNo}</td><td>${t.studentName}</td><td>${t.classNum}</td><td>${t.subjectCd} - ${t.subjectName}</td><td>${t.testNo}</td><td>${t.point}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <c:if test="${empty scores}"><p>成績情報が存在しませんでした。</p></c:if>
            </div>
        </section>
    </c:param>
</c:import>
