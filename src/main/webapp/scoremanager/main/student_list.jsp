<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:import url="/common/base.jsp">
<c:param name="title">学生管理</c:param>

<c:param name="content">

<section class="me-4">

    <h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">
        学生管理
    </h2>

    <div class="my-2 text-end px-4">
        <a href="StudentCreate.action">新規登録</a>
    </div>

    <form method="get" action="StudentList.action">
        <div class="row border mx-3 mb-3 py-3 align-items-end rounded">

            <div class="col-4">
                <label class="form-label">入学年度</label>
                <select class="form-select" name="entYear">
                    <option value="">--------</option>

                    <c:forEach var="year" items="${entYearSet}">
                        <option value="${year}"
                            <c:if test="${year == entYear}">selected</c:if>>
                            ${year}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="col-4">
                <label class="form-label">クラス</label>
                <select class="form-select" name="classNum">
                    <option value="">--------</option>

                    <c:forEach var="num" items="${classNumSet}">
                        <option value="${num}"
                            <c:if test="${num == classNum}">selected</c:if>>
                            ${num}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="col-2">
                <div class="form-check">
                    <input class="form-check-input"
                           type="checkbox"
                           name="isAttend"
                           value="true"
                           id="isAttend"
                           <c:if test="${isAttend}">checked</c:if>>

                    <label class="form-check-label" for="isAttend">
                        在学中
                    </label>
                </div>
            </div>

            <div class="col-2 text-center">
                <button class="btn btn-secondary" type="submit">
                    絞込み
                </button>
            </div>

        </div>
    </form>

    <c:choose>
        <c:when test="${not empty students}">

            <div class="px-4">
                <p>検索結果：${students.size()}件</p>

                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>入学年度</th>
                            <th>学生番号</th>
                            <th>氏名</th>
                            <th>クラス</th>
                            <th>在学中</th>
                            <th></th>
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
                                        <c:when test="${student.attend}">
                                            ○
                                        </c:when>
                                        <c:otherwise>
                                            ×
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="StudentUpdate.action?no=${student.no}">
                                        変更
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

        </c:when>

        <c:otherwise>
            <p class="px-4">学生情報が存在しませんでした</p>
        </c:otherwise>
    </c:choose>

</section>

</c:param>
</c:import>