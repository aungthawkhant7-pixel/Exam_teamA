<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:import url="/common/base.jsp">
    <c:param name="title">クラス管理</c:param>

    <c:param name="content">
        <section class="me-4">

            <h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">
                クラス管理
            </h2>

            <c:if test="${not empty flash}">
                <div class="alert alert-success mx-4">${flash}</div>
            </c:if>

            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger mx-4">${errorMsg}</div>
            </c:if>

            <div class="card mx-4 mb-4">
                <div class="card-header">クラス登録</div>

                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/ClassList.action"
                          method="post"
                          class="row g-3">

                        <input type="hidden" name="formAction" value="save">

                        <div class="col-md-4">
                            <label class="form-label">クラスコード</label>
                            <input class="form-control"
                                   type="text"
                                   name="classNum"
                                   value="${formClassNum}"
                                   required>
                        </div>

                        <div class="col-12">
                            <button class="btn btn-primary" type="submit">
                                登録
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="px-4">
                <table class="table table-bordered table-striped align-middle">
                    <thead>
                        <tr>
                            <th>クラスコード</th>
                            <th>所属学生数</th>
                            <th style="width:120px;">操作</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach var="c" items="${classes}">
                            <tr>
                                <td>${c.classNum}</td>
                                <td>${c.studentCount}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/ClassList.action"
                                          method="post"
                                          onsubmit="return confirm('削除しますか？');">

                                        <input type="hidden" name="formAction" value="delete">
                                        <input type="hidden" name="classNum" value="${c.classNum}">

                                        <button class="btn btn-sm btn-outline-danger" type="submit">
                                            削除
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <c:if test="${empty classes}">
                    <p>クラス情報が存在しませんでした。</p>
                </c:if>
            </div>

        </section>
    </c:param>
</c:import>