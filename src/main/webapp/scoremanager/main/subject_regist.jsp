<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:import url="/common/base.jsp">
    <c:param name="title">科目登録</c:param>

    <c:param name="content">
        <section class="mx-4">
            <h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">
                <c:choose>
                    <c:when test="${empty originalCd}">科目情報登録</c:when>
                    <c:otherwise>科目更新</c:otherwise>
                </c:choose>
            </h2>

            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger">${errorMsg}</div>
            </c:if>

            <div class="card p-4 border-0">
                <form action="${pageContext.request.contextPath}/SubjectRegist.action" method="post" class="row g-3">

                    <input type="hidden" name="formAction" value="save">
                    <input type="hidden" name="originalCd" value="${originalCd}">

                    <div class="col-12">
                        <label class="form-label">科目コード</label>
                        <input class="form-control"
                               type="text"
                               name="cd"
                               value="${subject.cd}"
                               placeholder="科目コードを入力してください"
                               required>
                    </div>

                    <div class="col-12">
                        <label class="form-label">科目名</label>
                        <input class="form-control"
                               type="text"
                               name="name"
                               value="${subject.name}"
                               placeholder="科目名を入力してください"
                               required>
                    </div>

                    <div class="col-12 mt-4">
                        <button class="btn btn-primary" type="submit">
                            <c:choose>
                                <c:when test="${empty originalCd}">登録</c:when>
                                <c:otherwise>更新</c:otherwise>
                            </c:choose>
                        </button>
                    </div>

                    <div class="col-12">
                        <a href="${pageContext.request.contextPath}/SubjectList.action">戻る</a>
                    </div>

                </form>
            </div>
        </section>
    </c:param>
</c:import>