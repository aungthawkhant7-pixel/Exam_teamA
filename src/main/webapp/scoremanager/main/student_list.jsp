<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:import url="/common/base.jsp">
    <c:param name="title">学生管理</c:param>
    <c:param name="scripts"></c:param>

    <c:param name="content">
        <section class="me-4">
            <h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">学生管理</h2>

            <c:if test="${not empty flash}">
                <div class="alert alert-success mx-4">${flash}</div>
            </c:if>

            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger mx-4">${errorMsg}</div>
            </c:if>

            <div class="card mx-4 mb-4">
                <div class="card-header">${empty originalNo ? '学生情報登録' : '学生更新'}</div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/StudentList.action" method="post" class="row g-3">
                        <input type="hidden" name="formAction" value="save">
                        <input type="hidden" name="originalNo" value="${originalNo}">

                        <div class="col-md-3">
                            <label class="form-label">学生番号</label>
                            <input type="text" name="no" value="${formNo}" class="form-control" maxlength="10" required>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">氏名</label>
                            <input type="text" name="name" value="${formName}" class="form-control" maxlength="50" required>
                        </div>

                        <div class="col-md-2">
                            <label class="form-label">入学年度</label>
                            <select name="formEntYear" class="form-select" required>
                                <option value="">----</option>
                                <c:forEach var="year" items="${entYearSet}">
                                    <option value="${year}" <c:if test="${formEntYear == year.toString()}">selected</c:if>>${year}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-2">
                            <label class="form-label">クラス</label>
                            <select name="formClassNum" class="form-select" required>
                                <option value="">----</option>
                                <c:forEach var="cn" items="${classNums}">
                                    <option value="${cn.classNum}" <c:if test="${formClassNum == cn.classNum}">selected</c:if>>${cn.classNum}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-2 d-flex align-items-end">
                            <div class="form-check mb-2">
                                <input type="checkbox" class="form-check-input" id="formAttend" name="formAttend" value="true" <c:if test="${formAttend}">checked</c:if>>
                                <label class="form-check-label" for="formAttend">在学中</label>
                            </div>
                        </div>

                        <div class="col-12">
                            <button class="btn btn-primary me-2" type="submit">
                                ${empty originalNo ? '登録' : '更新'}
                            </button>
                            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/StudentList.action">クリア</a>
                        </div>
                    </form>
                </div>
            </div>

            <div class="card mx-4 mb-4">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/StudentList.action" method="get" class="row g-3 align-items-end">
                        <div class="col-auto">
                            <label class="form-label">入学年度</label>
                            <select name="entYear" class="form-select">
                                <option value="">----</option>
                                <c:forEach var="year" items="${entYearSet}">
                                    <option value="${year}" <c:if test="${selectedEntYear == year.toString()}">selected</c:if>>${year}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-auto">
                            <label class="form-label">クラス</label>
                            <select name="classNum" class="form-select">
                                <option value="">----</option>
                                <c:forEach var="cn" items="${classNums}">
                                    <option value="${cn.classNum}" <c:if test="${selectedClassNum == cn.classNum}">selected</c:if>>${cn.classNum}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-auto form-check mt-4 pt-2">
                            <input class="form-check-input" type="checkbox" name="isAttend" value="true" id="isAttend" <c:if test="${checkedAttend}">checked</c:if>>
                            <label class="form-check-label" for="isAttend">在学中のみ</label>
                        </div>

                        <div class="col-auto">
                            <button type="submit" class="btn btn-primary me-2">絞込み</button>
                            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/StudentList.action">解除</a>
                        </div>
                    </form>
                </div>
            </div>

            <div class="mx-4">
                <table class="table table-hover align-middle">
                    <thead>
                        <tr>
                            <th>入学年度</th>
                            <th>学生番号</th>
                            <th>氏名</th>
                            <th>クラス</th>
                            <th>在学</th>
                            <th style="width: 180px;">操作</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach var="student" items="${students}">
                            <tr>
                                <td>${student.entYear}</td>
                                <td>${student.no}</td>
                                <td>${student.name}</td>
                                <td>${student.classNum}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${student.attend}">○</c:when>
                                        <c:otherwise>×</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a class="btn btn-sm btn-outline-primary me-1"
                                       href="${pageContext.request.contextPath}/StudentList.action?editNo=${student.no}">
                                        編集
                                    </a>

                                    <form action="${pageContext.request.contextPath}/StudentList.action"
                                          method="post"
                                          style="display:inline;">
                                        <input type="hidden" name="formAction" value="delete">
                                        <input type="hidden" name="no" value="${student.no}">
                                        <button class="btn btn-sm btn-outline-danger" type="submit">削除</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <c:if test="${empty students}">
                    <p>学生情報が存在しませんでした。</p>
                </c:if>
            </div>
        </section>
    </c:param>
</c:import>