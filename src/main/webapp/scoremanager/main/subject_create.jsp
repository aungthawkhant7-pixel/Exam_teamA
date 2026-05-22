<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:import url="/common/base.jsp">
    <c:param name="title">科目情報登録</c:param>

    <c:param name="content">
        <section class="mx-4">
            <h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">
                科目情報登録
            </h2>

            <form action="${pageContext.request.contextPath}/SubjectCreateDone.action" method="post">

                <div class="mb-3">
                    <label class="form-label">科目コード</label>
                    <input type="text"
                           name="cd"
                           class="form-control"
                           value="${subject.cd}"
                           placeholder="科目コードを入力してください"
                           required>

                    <c:if test="${not empty errorCd}">
                        <div class="text-warning mt-1">${errorCd}</div>
                    </c:if>
                </div>

                <div class="mb-3">
                    <label class="form-label">科目名</label>
                    <input type="text"
                           name="name"
                           class="form-control"
                           value="${subject.name}"
                           placeholder="科目名を入力してください"
                           required>
                </div>

                <button type="submit" class="btn btn-primary">登録</button>

                <div class="mt-3">
                    <a href="${pageContext.request.contextPath}/SubjectList.action">戻る</a>
                </div>

            </form>
        </section>
    </c:param>
</c:import>