<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:import url="/common/base.jsp">
<c:param name="title">学生情報変更</c:param>

<c:param name="content">

<section class="me-4">

    <h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">
        学生情報変更
    </h2>

    <form method="post" action="StudentUpdateExecute.action">

        <div class="row border mx-3 mb-3 py-3 rounded">

            <!-- 学生番号 -->
            <div class="col-12 mb-3">
                <label class="form-label">学生番号</label>
                <input type="text" class="form-control" 
                       value="${student.no}" readonly>
                <input type="hidden" name="no" value="${student.no}">
            </div>

            <!-- 氏名 -->
            <div class="col-12 mb-3">
                <label class="form-label">氏名</label>
                <input type="text" name="name" class="form-control"
                       value="${student.name}" required>
            </div>

            <!-- 入学年度 -->
            <div class="col-6 mb-3">
                <label class="form-label">入学年度</label>
                <input type="number" name="entYear" class="form-control"
                       value="${student.entYear}" required>
            </div>

            <!-- クラス -->
            <div class="col-6 mb-3">
                <label class="form-label">クラス</label>
                <input type="text" name="classNum" class="form-control"
                       value="${student.classNum}" required>
            </div>

            <!-- 在学中 -->
            <div class="col-12 mb-3">
                <div class="form-check">
                    <input class="form-check-input"
                           type="checkbox"
                           name="isAttend"
                           value="true"
                           id="isAttend"
                           <c:if test="${student.attend}">checked</c:if>>

                    <label class="form-check-label" for="isAttend">
                        在学中
                    </label>
                </div>
            </div>

            <!-- ボタン -->
            <div class="col-12 text-center mt-3">
                <button class="btn btn-primary" type="submit">
                    変更
                </button>

                <a href="StudentList.action" class="btn btn-secondary ms-2">
                    戻る
                </a>
            </div>

        </div>

    </form>

</section>

</c:param>
</c:import>