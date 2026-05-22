<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:import url="/common/base.jsp">
    <c:param name="title">科目情報登録</c:param>

    <c:param name="content">
        <section class="mx-4">
            <h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">
                科目情報登録
            </h2>

            <div class="alert alert-success text-center">
                登録が完了しました
            </div>

            <div class="mt-5">
                <a href="${pageContext.request.contextPath}/SubjectCreate.action" class="me-5">戻る</a>
                <a href="${pageContext.request.contextPath}/SubjectList.action">科目一覧</a>
            </div>
        </section>
    </c:param>
</c:import>