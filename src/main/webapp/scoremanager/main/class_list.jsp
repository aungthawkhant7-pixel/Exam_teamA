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
String formClassNum = "";
List<Map<String,Object>> classes = new ArrayList<>();
try (Connection con = getDbConnection()) {
    ensureAssumedTables(con);
    String action = nv(request.getParameter("formAction"));
    if ("save".equals(action)) {
        formClassNum = nv(request.getParameter("classNum")).trim();
        if (formClassNum.isEmpty()) {
            error = "クラスコードは必須です。";
        } else {
            try (PreparedStatement st = con.prepareStatement("INSERT INTO CLASS_NUM(CLASS_NUM, SCHOOL_CD) VALUES(?, ?)")) {
                st.setString(1, formClassNum); st.setString(2, schoolCd); st.executeUpdate();
                flash = "クラスを登録しました。";
            } catch (SQLException ex) { error = "登録に失敗しました。クラスコードが重複している可能性があります。"; }
        }
    } else if ("delete".equals(action)) {
        String classNum = nv(request.getParameter("classNum"));
        try (PreparedStatement st = con.prepareStatement("SELECT COUNT(*) FROM STUDENT WHERE CLASS_NUM=? AND SCHOOL_CD=?")) {
            st.setString(1, classNum); st.setString(2, schoolCd);
            try (ResultSet rs = st.executeQuery()) {
                rs.next();
                if (rs.getInt(1) > 0) {
                    error = "このクラスには学生がいるため削除できません。";
                }
            }
        }
        if (error == null) {
            try (PreparedStatement st = con.prepareStatement("DELETE FROM CLASS_NUM WHERE CLASS_NUM=? AND SCHOOL_CD=?")) {
                st.setString(1, classNum); st.setString(2, schoolCd); st.executeUpdate();
                flash = "クラスを削除しました。";
            }
        }
    }
    try (PreparedStatement st = con.prepareStatement(
            "SELECT c.CLASS_NUM, (SELECT COUNT(*) FROM STUDENT s WHERE s.CLASS_NUM=c.CLASS_NUM AND s.SCHOOL_CD=c.SCHOOL_CD) AS STUDENT_COUNT FROM CLASS_NUM c WHERE c.SCHOOL_CD=? ORDER BY c.CLASS_NUM")) {
        st.setString(1, schoolCd);
        try (ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Map<String,Object> m = new HashMap<>();
                m.put("classNum", rs.getString("CLASS_NUM"));
                m.put("studentCount", rs.getInt("STUDENT_COUNT"));
                classes.add(m);
            }
        }
    }
}
request.setAttribute("classes", classes);
request.setAttribute("flash", flash);
request.setAttribute("errorMsg", error);
request.setAttribute("formClassNum", formClassNum);
%>
<c:import url="/common/base.jsp">
    <c:param name="title">クラス管理</c:param>
    <c:param name="scripts"></c:param>
    <c:param name="content">
        <section class="me-4">
            <h2 class="h3 mb-3 fw-norma bg-secondary bg-opacity-10 py-2 px-4">クラス管理</h2>
            <c:if test="${not empty flash}"><div class="alert alert-success mx-4">${flash}</div></c:if>
            <c:if test="${not empty errorMsg}"><div class="alert alert-danger mx-4">${errorMsg}</div></c:if>
            <div class="card mx-4 mb-4">
                <div class="card-header">クラス登録</div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/scoremanager/main/class_list.jsp" method="post" class="row g-3">
                        <input type="hidden" name="formAction" value="save">
                        <div class="col-md-4"><label class="form-label">クラスコード</label><input class="form-control" type="text" name="classNum" value="${formClassNum}" required></div>
                        <div class="col-12"><button class="btn btn-primary" type="submit">登録</button></div>
                    </form>
                </div>
            </div>
            <div class="px-4">
                <table class="table table-bordered table-striped align-middle">
                    <thead><tr><th>クラスコード</th><th>所属学生数</th><th style="width:120px;">操作</th></tr></thead>
                    <tbody>
                        <c:forEach var="c" items="${classes}">
                            <tr>
                                <td>${c.classNum}</td><td>${c.studentCount}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/scoremanager/main/class_list.jsp" method="post" onsubmit="return confirm('削除しますか？');">
                                        <input type="hidden" name="formAction" value="delete"><input type="hidden" name="classNum" value="${c.classNum}">
                                        <button class="btn btn-sm btn-outline-danger" type="submit">削除</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <c:if test="${empty classes}"><p>クラス情報が存在しませんでした。</p></c:if>
            </div>
        </section>
    </c:param>
</c:import>
