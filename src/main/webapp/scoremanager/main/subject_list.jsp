<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="java.sql.*,java.util.*,bean.Teacher" %>
<%@ include file="/common/dbutil.jspf" %>
<%
Teacher user = (Teacher) session.getAttribute("user");
if (user == null) { response.sendRedirect(request.getContextPath() + "/Login.action"); return; }
String schoolCd = user.getSchoolCd();
String flash = (String)request.getAttribute("flash"); 
String error = (String)request.getAttribute("errorMsg");
List<Map<String,String>> subjects = new ArrayList<>();

try (Connection con = getDbConnection()) {
    ensureAssumedTables(con);
    String action = nv(request.getParameter("formAction"));
    // Логика удаления остается здесь, так как она вызывается из таблицы
    if ("delete".equals(action)) {
        String cd = nv(request.getParameter("cd"));
        try (PreparedStatement st1 = con.prepareStatement("DELETE FROM TEST_SCORE WHERE SUBJECT_CD=? AND SCHOOL_CD=?");
             PreparedStatement st2 = con.prepareStatement("DELETE FROM SUBJECT WHERE CD=? AND SCHOOL_CD=?")) {
            st1.setString(1, cd); st1.setString(2, schoolCd); st1.executeUpdate();
            st2.setString(1, cd); st2.setString(2, schoolCd); st2.executeUpdate();
            flash = "科目を削除しました。";
        }
    }
    // Загрузка данных для таблицы
    try (PreparedStatement st = con.prepareStatement("SELECT CD, NAME FROM SUBJECT WHERE SCHOOL_CD=? ORDER BY CD")) {
        st.setString(1, schoolCd);
        try (ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Map<String,String> m = new HashMap<>();
                m.put("cd", rs.getString("CD"));
                m.put("name", rs.getString("NAME"));
                subjects.add(m);
            }
        }
    }
}
request.setAttribute("subjects", subjects);
%>
<c:import url="/common/base.jsp">
    <c:param name="title">科目管理</c:param>
    <c:param name="content">
        <section class="me-4">
            <h2 class="h3 mb-3 fw-norma bg-secondary bg-opacity-10 py-2 px-4">科目管理</h2>
            <c:if test="${not empty flash}"><div class="alert alert-success mx-4">${flash}</div></c:if>
            <div class="px-4 mb-3">
                <a href="subject_regist.jsp" class="btn btn-primary">新規登録</a>
            </div>
            <div class="px-4">
                <table class="table table-bordered table-striped align-middle">
                    <thead><tr><th>科目コード</th><th>科目名</th><th style="width:180px;">操作</th></tr></thead>
                    <tbody>
                        <c:forEach var="s" items="${subjects}">
                            <tr>
                                <td>${s.cd}</td><td>${s.name}</td>
                                <td>
                                    <a class="btn btn-sm btn-outline-primary" href="subject_regist.jsp?editCd=${s.cd}">編集</a>
                                    <form action="subject_list.jsp" method="post" style="display:inline;" onsubmit="return confirm('削除しますか？');">
                                        <input type="hidden" name="formAction" value="delete"><input type="hidden" name="cd" value="${s.cd}">
                                        <button class="btn btn-sm btn-outline-danger" type="submit">削除</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </section>
    </c:param>
</c:import>