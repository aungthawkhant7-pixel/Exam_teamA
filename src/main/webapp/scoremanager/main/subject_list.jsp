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
String formCd = "";
String formName = "";
String originalCd = nv(request.getParameter("originalCd"));
List<Map<String,String>> subjects = new ArrayList<>();
try (Connection con = getDbConnection()) {
    ensureAssumedTables(con);
    String action = nv(request.getParameter("formAction"));
    if ("save".equals(action)) {
        formCd = nv(request.getParameter("cd")).trim();
        formName = nv(request.getParameter("name")).trim();
        if (formCd.isEmpty() || formName.isEmpty()) {
            error = "科目コードと科目名は必須です。";
        } else if (originalCd.isEmpty()) {
            try (PreparedStatement st = con.prepareStatement("INSERT INTO SUBJECT(CD, NAME, SCHOOL_CD) VALUES(?, ?, ?)")) {
                st.setString(1, formCd); st.setString(2, formName); st.setString(3, schoolCd); st.executeUpdate();
                flash = "科目を登録しました。";
            } catch (SQLException ex) { error = "登録に失敗しました。科目コードが重複している可能性があります。"; }
        } else {
            try (PreparedStatement st = con.prepareStatement("UPDATE SUBJECT SET CD=?, NAME=? WHERE CD=? AND SCHOOL_CD=?")) {
                st.setString(1, formCd); st.setString(2, formName); st.setString(3, originalCd); st.setString(4, schoolCd); st.executeUpdate();
                flash = "科目を更新しました。";
            } catch (SQLException ex) { error = "更新に失敗しました。科目コードが重複している可能性があります。"; }
        }
    } else if ("delete".equals(action)) {
        String cd = nv(request.getParameter("cd"));
        try (PreparedStatement st1 = con.prepareStatement("DELETE FROM TEST_SCORE WHERE SUBJECT_CD=? AND SCHOOL_CD=?");
             PreparedStatement st2 = con.prepareStatement("DELETE FROM SUBJECT WHERE CD=? AND SCHOOL_CD=?")) {
            st1.setString(1, cd); st1.setString(2, schoolCd); st1.executeUpdate();
            st2.setString(1, cd); st2.setString(2, schoolCd); st2.executeUpdate();
            flash = "科目を削除しました。";
        }
    }
    String editCd = nv(request.getParameter("editCd"));
    if (!editCd.isEmpty()) {
        try (PreparedStatement st = con.prepareStatement("SELECT * FROM SUBJECT WHERE CD=? AND SCHOOL_CD=?")) {
            st.setString(1, editCd); st.setString(2, schoolCd);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    formCd = rs.getString("CD");
                    formName = rs.getString("NAME");
                    originalCd = formCd;
                }
            }
        }
    }
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
request.setAttribute("flash", flash);
request.setAttribute("errorMsg", error);
request.setAttribute("formCd", formCd);
request.setAttribute("formName", formName);
request.setAttribute("originalCd", originalCd);
%>
<c:import url="/common/base.jsp">
    <c:param name="title">科目管理</c:param>
    <c:param name="scripts"></c:param>
    <c:param name="content">
        <section class="me-4">
            <h2 class="h3 mb-3 fw-norma bg-secondary bg-opacity-10 py-2 px-4">科目管理</h2>
            <c:if test="${not empty flash}"><div class="alert alert-success mx-4">${flash}</div></c:if>
            <c:if test="${not empty errorMsg}"><div class="alert alert-danger mx-4">${errorMsg}</div></c:if>
            <div class="card mx-4 mb-4">
                <div class="card-header">${empty originalCd ? '科目登録' : '科目更新'}</div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/scoremanager/main/subject_list.jsp" method="post" class="row g-3">
                        <input type="hidden" name="formAction" value="save">
                        <input type="hidden" name="originalCd" value="${originalCd}">
                        <div class="col-md-3"><label class="form-label">科目コード</label><input class="form-control" type="text" name="cd" value="${formCd}" required></div>
                        <div class="col-md-5"><label class="form-label">科目名</label><input class="form-control" type="text" name="name" value="${formName}" required></div>
                        <div class="col-12"><button class="btn btn-primary" type="submit">${empty originalCd ? '登録' : '更新'}</button> <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/scoremanager/main/subject_list.jsp">クリア</a></div>
                    </form>
                </div>
            </div>
            <div class="px-4">
                <table class="table table-bordered table-striped align-middle">
                    <thead><tr><th>科目コード</th><th>科目名</th><th style="width:180px;">操作</th></tr></thead>
                    <tbody>
                        <c:forEach var="s" items="${subjects}">
                            <tr>
                                <td>${s.cd}</td><td>${s.name}</td>
                                <td>
                                    <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/scoremanager/main/subject_list.jsp?editCd=${s.cd}">編集</a>
                                    <form action="${pageContext.request.contextPath}/scoremanager/main/subject_list.jsp" method="post" style="display:inline;" onsubmit="return confirm('削除しますか？');">
                                        <input type="hidden" name="formAction" value="delete"><input type="hidden" name="cd" value="${s.cd}">
                                        <button class="btn btn-sm btn-outline-danger" type="submit">削除</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <c:if test="${empty subjects}"><p>科目情報が存在しませんでした。</p></c:if>
            </div>
        </section>
    </c:param>
</c:import>
