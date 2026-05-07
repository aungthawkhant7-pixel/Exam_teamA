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

            <div class="card mx-4 mb-4">
                <div class="card-header">
                    <c:choose>
                        <c:when test="${empty originalCd}">科目登録</c:when>
                        <c:otherwise>科目更新</c:otherwise>
                    </c:choose>
                </div>

                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/SubjectList.action"
                          method="post"
                          class="row g-3">

                        <input type="hidden" name="formAction" value="save">
                        <input type="hidden" name="originalCd" value="${originalCd}">

                        <div class="col-md-3">
                            <label class="form-label">科目コード</label>
                            <input class="form-control"
                                   type="text"
                                   name="cd"
                                   value="${subject.cd}"
                                   required>
                        </div>

                        <div class="col-md-5">
                            <label class="form-label">科目名</label>
                            <input class="form-control"
                                   type="text"
                                   name="name"
                                   value="${subject.name}"
                                   required>
                        </div>

                        <div class="col-12">
                            <button class="btn btn-primary" type="submit">
                                <c:choose>
                                    <c:when test="${empty originalCd}">登録</c:when>
                                    <c:otherwise>更新</c:otherwise>
                                </c:choose>
                            </button>

                            <a class="btn btn-outline-secondary"
                               href="${pageContext.request.contextPath}/SubjectList.action">
                                クリア
                            </a>
                        </div>
                    </form>
                </div>
            </div>

            <div class="px-4">
                <table class="table table-bordered table-striped align-middle">
                    <thead>
                        <tr>
                            <th>科目コード</th>
                            <th>科目名</th>
                            <th style="width:180px;">操作</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach var="s" items="${subjects}">
                            <tr>
                                <td>${s.cd}</td>
                                <td>${s.name}</td>
                                <td>
                                    <a class="btn btn-sm btn-outline-primary"
                                       href="${pageContext.request.contextPath}/SubjectList.action?editCd=${s.cd}">
                                        編集
                                    </a>

                                    <form action="${pageContext.request.contextPath}/SubjectList.action"
                                          method="post"
                                          style="display:inline;"
                                          onsubmit="return confirm('削除しますか？');">

                                        <input type="hidden" name="formAction" value="delete">
                                        <input type="hidden" name="cd" value="${s.cd}">

                                        <button class="btn btn-sm btn-outline-danger" type="submit">
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