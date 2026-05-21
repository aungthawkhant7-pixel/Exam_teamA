<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:import url="/common/base.jsp">
<c:param name="title">科目登録</c:param>

<c:param name="content">
<section class="mx-4">

<h2 class="h3 mb-3">
<c:choose>
<c:when test="${empty originalCd}">
科目登録
</c:when>
<c:otherwise>
科目更新
</c:otherwise>
</c:choose>
</h2>

<c:if test="${not empty errorMsg}">
<div class="alert alert-danger">${errorMsg}</div>
</c:if>

<div class="card p-4">
<form action="SubjectRegist.action" method="post" class="row g-3">

<input type="hidden" name="formAction" value="save">
<input type="hidden" name="originalCd" value="${originalCd}">

<div class="col-md-3">
<label>科目コード</label>
<input class="form-control"
name="cd"
value="${subject.cd}"
required>
</div>

<div class="col-md-5">
<label>科目名</label>
<input class="form-control"
name="name"
value="${subject.name}"
required>
</div>

<div class="col-12">
<button class="btn btn-primary" type="submit">
登録
</button>

<a class="btn btn-secondary" href="SubjectList.action">
戻る
</a>
</div>

</form>
</div>

</section>
</c:param>
</c:import>
