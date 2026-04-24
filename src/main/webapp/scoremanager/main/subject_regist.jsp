<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="java.sql.*,bean.Teacher" %>
<%@ include file="/common/dbutil.jspf" %>
<%
Teacher user = (Teacher) session.getAttribute("user");
if (user == null) { response.sendRedirect(request.getContextPath() + "/Login.action"); return; }
String schoolCd = user.getSchoolCd();
String flash = null; String error = null;
String formCd = ""; String formName = "";
String originalCd = nv(request.getParameter("originalCd"));

try (Connection con = getDbConnection()) {
    String action = nv(request.getParameter("formAction"));
    // Логика сохранения
    if ("save".equals(action)) {
        formCd = nv(request.getParameter("cd")).trim();
        formName = nv(request.getParameter("name")).trim();
        if (originalCd.isEmpty()) { // Insert
            try (PreparedStatement st = con.prepareStatement("INSERT INTO SUBJECT(CD, NAME, SCHOOL_CD) VALUES(?, ?, ?)")) {
                st.setString(1, formCd); st.setString(2, formName); st.setString(3, schoolCd); st.executeUpdate();
                response.sendRedirect("subject_list.jsp"); return;
            } catch (SQLException ex) { error = "登録に失敗しました。"; }
        } else { // Update
            try (PreparedStatement st = con.prepareStatement("UPDATE SUBJECT SET CD=?, NAME=? WHERE CD=? AND SCHOOL_CD=?")) {
                st.setString(1, formCd); st.setString(2, formName); st.setString(3, originalCd); st.setString(4, schoolCd); st.executeUpdate();
                response.sendRedirect("subject_list.jsp"); return;
            } catch (SQLException ex) { error = "更新に失敗しました।"; }
        }
    }
    // Логика загрузки для редактирования
    String editCd = nv(request.getParameter("editCd"));
    if (!editCd.isEmpty()) {
        try (PreparedStatement st = con.prepareStatement("SELECT * FROM SUBJECT WHERE CD=? AND SCHOOL_CD=?")) {
            st.setString(1, editCd); st.setString(2, schoolCd);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) { formCd = rs.getString("CD"); formName = rs.getString("NAME"); originalCd = formCd; }
            }
        }
    }
}
%>
<c:import url="/common/base.jsp">
    <c:param name="title">科目登録</c:param>
    <c:param name="content">
        <section class="mx-4">
            <h2 class="h3 mb-3">${empty originalCd ? '科目登録' : '科目更新'}</h2>
            <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
            <div class="card p-4">
                <form action="subject_regist.jsp" method="post" class="row g-3">
                    <input type="hidden" name="formAction" value="save">
                    <input type="hidden" name="originalCd" value="<%= originalCd %>">
                    <div class="col-md-3"><label>科目コード</label><input class="form-control" name="cd" value="<%= formCd %>" required></div>
                    <div class="col-md-5"><label>科目名</label><input class="form-control" name="name" value="<%= formName %>" required></div>
                    <div class="col-12">
                        <button class="btn btn-primary" type="submit">登録</button>
                        <a class="btn btn-secondary" href="subject_list.jsp">戻る</a>
                    </div>
                </form>
            </div>
        </section>
    </c:param>
</c:import>