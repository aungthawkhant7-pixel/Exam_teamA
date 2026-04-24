<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:import url="/common/base.jsp">
    <c:param name="title">${pageTitle}</c:param>
    <c:param name="scripts"></c:param>

    <c:param name="content">
        <section class="me-4">
            <h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">${pageTitle}</h2>

            <div class="card mx-4 mb-4">
                <div class="card-body">

                    <form action="${pageContext.request.contextPath}/TestList.action" method="post">
                        <input type="hidden" name="searchType" value="student">

                        <div class="row g-3 align-items-end">
                            <div class="col-md-2">
                                <label class="form-label">学生情報</label>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label">学生番号</label>
                                <input type="text" name="studentNo" value="${studentNo}" class="form-control" placeholder="学生番号を入力してください">
                            </div>

                            <div class="col-md-2">
                                <button class="btn btn-secondary w-100" type="submit">検索</button>
                            </div>
                        </div>
                    </form>

                </div>
            </div>

            <div class="px-4">

                <c:if test="${not empty errorMsg}">
                    <p style="color:#f0ad4e; margin-bottom: 1rem;">${errorMsg}</p>
                </c:if>

                <c:if test="${empty errorMsg and not empty infoMsg}">
                    <p style="color:#5bc0de; margin-bottom: 1rem;">${infoMsg}</p>
                </c:if>

                <c:if test="${not empty studentName and empty studentRows and pageTitle == '成績一覧（学生）' and empty errorMsg}">
                    <p class="mb-2">氏名：${studentName} (${studentNo})</p>
                    <p>成績情報が存在しませんでした</p>
                </c:if>

                <c:if test="${not empty studentRows}">
                    <p class="mb-2">氏名：${studentName} (${studentNo})</p>

                    <table class="table">
                        <thead>
                            <tr>
                                <th>科目名</th>
                                <th>科目コード</th>
                                <th>回数</th>
                                <th>点数</th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach var="r" items="${studentRows}">
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty r.subjectName}">
                                                ${r.subjectName}
                                            </c:when>
                                            <c:otherwise>
                                                未登録
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${r.subjectCd}</td>
                                    <td>${r.testNo}</td>
                                    <td>${r.point}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>

            </div>
        </section>
    </c:param>
</c:import>