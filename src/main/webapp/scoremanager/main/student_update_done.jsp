<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:import url="/common/base.jsp">
<c:param name="title">学生情報変更完了</c:param>

<c:param name="content">
<section class="me-4">
    <h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">
        学生情報変更
    </h2>

    <div class="alert alert-success mx-4">
        変更が完了しました
    </div>

    <div class="mx-4">
        <a href="StudentList.action">学生一覧</a>
    </div>
</section>
</c:param>
</c:import>