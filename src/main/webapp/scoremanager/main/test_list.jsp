<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:import url="/common/base.jsp">
    <c:param name="title">成績参照</c:param>
    <c:param name="scripts"></c:param>

    <c:param name="content">
        <section class="me-4">

            <h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">
                成績参照
            </h2>

            <div class="px-4">

                <form action="${pageContext.request.contextPath}/TestList.action"
                      method="post"
                      class="mb-3">

                    <input type="hidden" name="searchType" value="subject">

                    <div class="row align-items-end">
                        <div class="col-md-2 fw-bold">
                            科目情報
                        </div>

                        <div class="col-md-2">
                            <label class="form-label">入学年度</label>
                            <select name="entYear" class="form-select">
                                <option value="">--------</option>
                                <c:forEach var="year" items="${entYears}">
                                    <option value="${year}" <c:if test="${year == entYear}">selected</c:if>>
                                        ${year}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-2">
                            <label class="form-label">クラス</label>
                            <select name="classNum" class="form-select">
                                <option value="">--------</option>
                                <c:forEach var="num" items="${classNums}">
                                    <option value="${num}" <c:if test="${num == classNum}">selected</c:if>>
                                        ${num}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">科目</label>
                            <select name="subjectCd" class="form-select">
                                <option value="">----------</option>
                                <c:forEach var="subject" items="${subjects}">
                                    <option value="${subject.cd}" <c:if test="${subject.cd == subjectCd}">selected</c:if>>
                                        ${subject.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-1">
                            <button class="btn btn-secondary" type="submit">
                                検索
                            </button>
                        </div>
                    </div>
                </form>

                <form action="${pageContext.request.contextPath}/TestList.action"
                      method="post"
                      class="mb-3">

                    <input type="hidden" name="searchType" value="student">

                    <div class="row align-items-end">
                        <div class="col-md-2 fw-bold">
                            学生情報
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">学生番号</label>
                            <input type="text"
                                   name="studentNo"
                                   value="${studentNo}"
                                   class="form-control"
                                   placeholder="学生番号を入力してください">
                        </div>

                        <div class="col-md-1">
                            <button class="btn btn-secondary" type="submit">
                                検索
                            </button>
                        </div>
                    </div>
                </form>

                <c:if test="${empty errorMsg and empty studentRows and empty subjectRows}">
                    <p style="color:#00bfff;">
                        科目情報を選択または学生情報を入力して検索ボタンをクリックしてください
                    </p>
                </c:if>

                <c:if test="${not empty errorMsg}">
                    <p style="color:#f0ad4e;">
                        ${errorMsg}
                    </p>
                </c:if>

                <c:if test="${not empty studentName and empty studentRows and empty errorMsg}">
                    <p class="mb-2">
                        氏名：${studentName} (${studentNo})
                    </p>
                    <p>成績情報が存在しませんでした</p>
                </c:if>

                <c:if test="${not empty studentRows}">
                    <p class="mb-2">
                        氏名：${studentName} (${studentNo})
                    </p>

                    <table class="table table-hover">
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
                                    <td>${r.subjectName}</td>
                                    <td>${r.subjectCd}</td>
                                    <td>${r.testNo}</td>
                                    <td>${r.point}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>

                <c:if test="${not empty subjectRows}">
                    <p class="mb-2">
                        科目：${subjectName}
                    </p>

                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>入学年度</th>
                                <th>クラス</th>
                                <th>学生番号</th>
                                <th>氏名</th>
                                <th>回数</th>
                                <th>点数</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="r" items="${subjectRows}">
                                <tr>
                                    <td>${r.entYear}</td>
                                    <td>${r.classNum}</td>
                                    <td>${r.studentNo}</td>
                                    <td>${r.studentName}</td>
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