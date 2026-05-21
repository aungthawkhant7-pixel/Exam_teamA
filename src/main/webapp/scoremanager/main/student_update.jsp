<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:import url="/common/base.jsp">

<c:param name="title">学生情報変更</c:param>

<c:param name="content">

<section class="me-4">

    <!-- タイトル -->
    <h2 class="h3 mb-4 fw-bold bg-secondary bg-opacity-10 py-2 px-4">
        学生情報変更
    </h2>

    <!-- フォーム -->
    <form method="post" action="StudentUpdateExecute.action">

        <!-- 入学年度 -->
        <div class="mb-4">
            <label class="form-label">入学年度</label>

            <select name="entYear" class="form-select">

                <option value="2022"
                    <c:if test="${student.entYear == 2022}">
                        selected
                    </c:if>>
                    2022
                </option>

                <option value="2023"
                    <c:if test="${student.entYear == 2023}">
                        selected
                    </c:if>>
                    2023
                </option>

                <option value="2024"
                    <c:if test="${student.entYear == 2024}">
                        selected
                    </c:if>>
                    2024
                </option>

                <option value="2025"
                    <c:if test="${student.entYear == 2025}">
                        selected
                    </c:if>>
                    2025
                </option>

            </select>
        </div>

        <!-- 学生番号 -->
        <div class="mb-4">
            <label class="form-label">学生番号</label>

            <input type="text"
                   name="no"
                   class="form-control"
                   value="${student.no}"
                   required>
        </div>

        <!-- 氏名 -->
        <div class="mb-4">
            <label class="form-label">氏名</label>

            <input type="text"
                   name="name"
                   class="form-control"
                   value="${student.name}"
                   required>
        </div>

        <!-- クラス -->
        <div class="mb-4">
            <label class="form-label">クラス</label>

            <select name="classNum" class="form-select">

                <option value="101"
                    <c:if test="${student.classNum == '101'}">
                        selected
                    </c:if>>
                    101
                </option>

                <option value="102"
                    <c:if test="${student.classNum == '102'}">
                        selected
                    </c:if>>
                    102
                </option>

                <option value="201"
                    <c:if test="${student.classNum == '201'}">
                        selected
                    </c:if>>
                    201
                </option>

                <option value="202"
                    <c:if test="${student.classNum == '202'}">
                        selected
                    </c:if>>
                    202
                </option>

            </select>
        </div>

        <!-- 在学中 -->
        <div class="form-check mb-4">

            <input class="form-check-input"
                   type="checkbox"
                   name="isAttend"
                   value="true"
                   id="isAttend"
                   <c:if test="${student.attend}">
                       checked
                   </c:if>>

            <label class="form-check-label" for="isAttend">
                在学中
            </label>

        </div>

        <!-- ボタン -->
        <div class="mb-3">
            <button class="btn btn-primary" type="submit">
                変更
            </button>
        </div>

        <!-- 戻る -->
        <div>
            <a href="StudentList.action">戻る</a>
        </div>

    </form>

</section>

</c:param>

</c:import>