<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<c:import url="/common/base.jsp">
    <c:param name="title">科目管理</c:param>
    <c:param name="content">
        <section class="me-4">
            <h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">
                科目管理
            </h2>
            <c:if test="${not empty flash}">
                <div class="alert alert-success mx-4">${flash}</div>
            </c:if>
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger mx-4">${errorMsg}</div>
            </c:if>
            <div class="mx-4 mb-3 text-end">
                <a href="${pageContext.request.contextPath}/SubjectRegist.action">新規登録</a>
            </div>
            <div class="px-4">
                <table class="table table-bordered table-striped align-middle">
                    <thead>
                        <tr>
                            <th>科目コード</th>
                            <th>科目名</th>
                            <th style="width:180px;"></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="s" items="${subjects}">
                            <tr>
                                <td>${s.cd}</td>
                                <td>${s.name}</td>
                                <td class="text-end">
                                    <a href="${pageContext.request.contextPath}/SubjectRegist.action?editCd=${s.cd}">変更</a>
                                    &nbsp;
                                    <form action="${pageContext.request.contextPath}/SubjectList.action"
                                          method="post"
                                          style="display:inline;"
                                          onsubmit="return confirm('削除しますか？');">
                                        <input type="hidden" name="formAction" value="delete">
                                        <input type="hidden" name="cd" value="${s.cd}">
                                        <button type="submit"
                                                style="background:none;border:none;padding:0;color:#0d6efd;cursor:pointer;text-decoration:underline;">
                                            削除
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <c:if test="${empty subjects}">
                    <p>科目情報が存在しませんでした。</p>
                </c:if>
            </div>
        </section>
    </c:param>
</c:import>
