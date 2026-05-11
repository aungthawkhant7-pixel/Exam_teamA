<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:import url="/common/base.jsp">
<c:param name="title">学生情報登録</c:param>

<c:param name="content">

<h2 class="mb-4 bg-light p-2">学生情報登録</h2>

<form action="StudentCreateDone.action" method="post">

    <div class="mb-3">
        <label class="form-label">入学年度</label>
        <select name="entYear" class="form-select" required>
            <option value="">--------</option>
            <option value="2023" ${entYear == '2023' ? 'selected' : ''}>2023</option>
            <option value="2024" ${entYear == '2024' ? 'selected' : ''}>2024</option>
            <option value="2025" ${entYear == '2025' ? 'selected' : ''}>2025</option>
            <option value="2026" ${entYear == '2026' ? 'selected' : ''}>2026</option>
        </select>

        <c:if test="${not empty entYearError}">
            <div class="text-warning">${entYearError}</div>
        </c:if>
    </div>

    <div class="mb-3">
        <label class="form-label">学生番号</label>
        <input type="text"
               name="no"
               class="form-control"
               value="${no}"
               placeholder="学生番号を入力してください"
               required>

        <c:if test="${not empty noError}">
            <div class="text-warning">${noError}</div>
        </c:if>
    </div>

    <div class="mb-3">
        <label class="form-label">氏名</label>
        <input type="text"
               name="name"
               class="form-control"
               value="${name}"
               placeholder="氏名を入力してください"
               required>

        <c:if test="${not empty nameError}">
            <div class="text-warning">${nameError}</div>
        </c:if>
    </div>

    <div class="mb-3">
        <label class="form-label">クラス</label>
        <select name="classNum" class="form-select" required>
            <option value="101" ${classNum == '101' ? 'selected' : ''}>101</option>
            <option value="102" ${classNum == '102' ? 'selected' : ''}>102</option>
            <option value="201" ${classNum == '201' ? 'selected' : ''}>201</option>
        </select>
    </div>

    <button type="submit" class="btn btn-secondary">登録して終了</button>

</form>

<br>

<a href="StudentList.action">戻る</a>

</c:param>
</c:import>