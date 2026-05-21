<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:import url="/common/base.jsp">

<c:param name="title">学生情報登録</c:param>

<c:param name="content">

<section class="me-4">

    <h2 class="h3 mb-3 fw-bold bg-secondary bg-opacity-10 py-2 px-4">
        学生情報登録
    </h2>

    <div class="text-center py-2 mb-5"
         style="background-color:#8fc7aa;">
        登録が完了しました
    </div>

    <div class="mt-5">
        <a href="StudentCreate.action">戻る</a>
        　　　
        <a href="StudentList.action">学生一覧</a>
    </div>

</section>

</c:param>

</c:import>