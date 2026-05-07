<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:import url="/common/base.jsp">
<c:param name="title">学生情報登録</c:param>

<c:param name="content">

<h2 class="mb-4 bg-light p-2">学生情報登録</h2>

<div class="alert alert-success text-center">
    登録が完了しました
</div>

<br><br>

<a href="StudentCreate.action">戻る</a>
　　　
<a href="StudentList.action">学生一覧</a>

</c:param>
</c:import>