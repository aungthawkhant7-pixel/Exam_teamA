<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:import url="/common/base.jsp">
<c:param name="title">成績管理</c:param>

<c:param name="content">

<h2 class="mb-4 bg-light p-2">成績管理</h2>

<div class="alert alert-success text-center">
    登録が完了しました
</div>

<br><br>

<a href="${pageContext.request.contextPath}/scoremanager/main/test_regist.jsp">戻る</a>
　　　
<!-- 成績参照 -->
<a href="TestList.action">成績参照</a>
</c:param>
</c:import>