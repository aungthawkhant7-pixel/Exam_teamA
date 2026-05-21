<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:import url="/common/base.jsp">

    <c:param name="title">成績参照</c:param>

    <c:param name="scripts"></c:param>

    <c:param name="content">

        <section class="me-4">

            <h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">

                <c:choose>

                    <c:when test="${searchType eq 'subject'}">
                        成績一覧（科目）
                    </c:when>

                    <c:when test="${searchType eq 'student'}">
                        成績一覧（学生）
                    </c:when>

                    <c:otherwise>
                        成績参照
                    </c:otherwise>

                </c:choose>

            </h2>

            <div class="px-4">

                <!-- 科目情報 BOX -->
                <div class="border rounded p-3 mb-0">

                    <form action="${pageContext.request.contextPath}/TestList.action"
                          method="post">

                        <input type="hidden" name="searchType" value="subject">

                        <div class="row align-items-center g-3"
                             style="min-height:90px;">

                            <div class="col-md-2 d-flex justify-content-center align-items-center">

                                <span class="fw-bold">
                                    科目情報
                                </span>

                            </div>

                            <!-- 入学年度 -->
                            <div class="col-md-2">

                                <label class="form-label" for="entYear">
                                    入学年度
                                </label>

                                <select id="entYear"
                                        name="entYear"
                                        class="form-select">

                                    <option value="">--------</option>

                                    <c:forEach var="year" items="${entYearSet}">

                                        <option value="${year}"
                                            <c:if test="${empty searchType and year == entYear}">
                                                selected
                                            </c:if>>

                                            ${year}

                                        </option>

                                    </c:forEach>

                                </select>

                            </div>

                            <!-- クラス -->
                            <div class="col-md-2">

                                <label class="form-label" for="classNum">
                                    クラス
                                </label>

                                <select id="classNum"
                                        name="classNum"
                                        class="form-select">

                                    <option value="">--------</option>

                                    <c:forEach var="num" items="${classNumSet}">

                                        <option value="${num}"
                                            <c:if test="${empty searchType and num == classNum}">
                                                selected
                                            </c:if>>

                                            ${num}

                                        </option>

                                    </c:forEach>

                                </select>

                            </div>

                            <!-- 科目 -->
                            <div class="col-md-3">

                                <label class="form-label" for="subjectCd">
                                    科目
                                </label>

                                <select id="subjectCd"
                                        name="subjectCd"
                                        class="form-select">

                                    <option value="">----------</option>

                                    <c:forEach var="subject" items="${subjectSet}">

                                        <option value="${subject.cd}"
                                            <c:if test="${empty searchType and subject.cd == subjectCd}">
                                                selected
                                            </c:if>>

                                            ${subject.name}

                                        </option>

                                    </c:forEach>

                                </select>

                            </div>

                            <!-- 検索 -->
                            <div class="col-md-2">

                                <label class="form-label invisible">
                                    button
                                </label>

                                <div>
                                    <button type="submit"
                                            class="btn btn-secondary px-4">

                                        検索

                                    </button>
                                </div>

                            </div>

                        </div>

                    </form>

                </div>

                <!-- 学生情報 BOX -->
                <div class="border rounded p-3 mb-4">

                    <form action="${pageContext.request.contextPath}/TestList.action"
                          method="post">

                        <input type="hidden" name="searchType" value="student">

                        <div class="row align-items-center g-3"
                             style="min-height:80px;">

                            <div class="col-md-2 d-flex justify-content-center align-items-center">

                                <span class="fw-bold">
                                    学生情報
                                </span>

                            </div>

                            <!-- 学生番号 -->
                            <div class="col-md-5">

                                <label class="form-label" for="studentNo">
                                    学生番号
                                </label>

                                <input type="text"
                                       id="studentNo"
                                       name="studentNo"
                                       value="${studentNo}"
                                       class="form-control"
                                       placeholder="学生番号を入力してください">

                            </div>

                            <!-- 検索 -->
                            <div class="col-md-2">

                                <label class="form-label invisible">
                                    button
                                </label>

                                <div>
                                    <button type="submit"
                                            class="btn btn-secondary px-4">

                                        検索

                                    </button>
                                </div>

                            </div>

                        </div>

                    </form>

                </div>

                <!-- メッセージ -->
                <c:choose>

                    <c:when test="${not empty errorMsg}">

                        <p class="text-warning">
                            <c:out value="${errorMsg}"/>
                        </p>

                    </c:when>

                    <c:when test="${empty searchType}">

                        <p class="text-info">
                            科目情報を選択または学生情報を入力して検索ボタンをクリックしてください
                        </p>

                    </c:when>

                </c:choose>

                <!-- 学生検索結果 -->
                <c:if test="${not empty studentRows}">

                    <p class="mb-2">

                        氏名：
                        <c:out value="${studentName}"/>

                        (
                        <c:out value="${studentNo}"/>
                        )

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

                                    <td>
                                        <c:out value="${r.subjectName}"/>
                                    </td>

                                    <td>
                                        <c:out value="${r.subjectCd}"/>
                                    </td>

                                    <td>
                                        <c:out value="${r.testNo}"/>
                                    </td>

                                    <td>
                                        <c:out value="${r.point}"/>
                                    </td>

                                </tr>

                            </c:forEach>

                        </tbody>

                    </table>

                </c:if>

                <!-- 科目検索結果 -->
                <c:if test="${not empty subjectRows}">

                    <p class="mb-2">

                        科目：
                        <c:out value="${subjectName}"/>

                    </p>

                    <table class="table table-hover">

                        <thead>

                            <tr>
                                <th>入学年度</th>
                                <th>クラス</th>
                                <th>学生番号</th>
                                <th>氏名</th>
                                <th>1回</th>
                                <th>2回</th>
                            </tr>

                        </thead>

                        <tbody>

                            <c:forEach var="r" items="${subjectRows}">

                                <tr>

                                    <td>
                                        <c:out value="${r.entYear}"/>
                                    </td>

                                    <td>
                                        <c:out value="${r.classNum}"/>
                                    </td>

                                    <td>
                                        <c:out value="${r.studentNo}"/>
                                    </td>

                                    <td>
                                        <c:out value="${r.studentName}"/>
                                    </td>

                                    <td>
                                        <c:out value="${r.point1}"/>
                                    </td>

                                    <td>
                                        <c:out value="${r.point2}"/>
                                    </td>

                                </tr>

                            </c:forEach>

                        </tbody>

                    </table>

                </c:if>

            </div>

        </section>

    </c:param>

</c:import>