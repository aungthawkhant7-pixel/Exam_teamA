<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:import url="/common/base.jsp">

<c:param name="title">学生情報登録</c:param>

<c:param name="content">

<section class="me-4">

    <h2 class="h3 mb-4 fw-bold bg-secondary bg-opacity-10 py-2 px-4">
        学生情報登録
    </h2>

    <form action="StudentCreateDone.action" method="post">

        <!-- 入学年度 -->
        <div class="mb-3">
            <label class="form-label">入学年度</label>

            <select name="entYear" class="form-select">
                <option value="">--------</option>

                <option value="2016" ${entYear == '2016' ? 'selected' : ''}>2016</option>
                <option value="2017" ${entYear == '2017' ? 'selected' : ''}>2017</option>
                <option value="2018" ${entYear == '2018' ? 'selected' : ''}>2018</option>
                <option value="2019" ${entYear == '2019' ? 'selected' : ''}>2019</option>
                <option value="2020" ${entYear == '2020' ? 'selected' : ''}>2020</option>
                <option value="2021" ${entYear == '2021' ? 'selected' : ''}>2021</option>
                <option value="2022" ${entYear == '2022' ? 'selected' : ''}>2022</option>
                <option value="2023" ${entYear == '2023' ? 'selected' : ''}>2023</option>
                <option value="2024" ${entYear == '2024' ? 'selected' : ''}>2024</option>
                <option value="2025" ${entYear == '2025' ? 'selected' : ''}>2025</option>
                <option value="2026" ${entYear == '2026' ? 'selected' : ''}>2026</option>
            </select>

            <c:if test="${not empty entYearError}">
                <div class="text-warning mt-1">
                    ${entYearError}
                </div>
            </c:if>
        </div>

        <!-- 学生番号 -->
        <div class="mb-3">
            <label class="form-label">学生番号</label>

            <input type="text"
                   name="no"
                   class="form-control"
                   value="${no}"
                   placeholder="学生番号を入力してください"
                   required>

            <c:if test="${not empty noError}">
                <div class="text-warning mt-1">
                    ${noError}
                </div>
            </c:if>
        </div>

        <!-- 氏名 -->
        <div class="mb-3">
            <label class="form-label">氏名</label>

            <input type="text"
                   name="name"
                   class="form-control"
                   value="${name}"
                   placeholder="氏名を入力してください"
                   required>

            <c:if test="${not empty nameError}">
                <div class="text-warning mt-1">
                    ${nameError}
                </div>
            </c:if>
        </div>

        <!-- クラス -->
        <div class="mb-3">
            <label class="form-label">クラス</label>

            <select name="classNum" class="form-select">
                <option value="101" ${classNum == '101' ? 'selected' : ''}>101</option>
                <option value="102" ${classNum == '102' ? 'selected' : ''}>102</option>
                <option value="201" ${classNum == '201' ? 'selected' : ''}>201</option>
            </select>
        </div>

        <button type="submit" class="btn btn-secondary">
            登録して終了
        </button>

    </form>

    <div class="mt-3">
        <a href="StudentList.action">戻る</a>
    </div>

</section>

</c:param>

</c:import>