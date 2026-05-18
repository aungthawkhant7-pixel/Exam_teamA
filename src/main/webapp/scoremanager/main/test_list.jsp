<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:import url="/common/base.jsp">
    <c:param name="title">成績参照</c:param>
    <c:param name="scripts"></c:param>

    <c:param name="content">
        <section class="me-4">

            <%-- ═══════════════════════════════════════════
                 ページタイトル
            ════════════════════════════════════════════ --%>
            <h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">
                成績参照
            </h2>

            <div class="px-4">

                <%-- ═══════════════════════════════════════════
                     科目情報 検索フォーム
                ════════════════════════════════════════════ --%>
                <form action="${pageContext.request.contextPath}/TestList.action"
                      method="post"
                      class="mb-3">

                    <input type="hidden" name="searchType" value="subject">

                    <div class="row align-items-end g-2">

                        <div class="col-md-2 fw-bold">
                            科目情報
                        </div>

                        <div class="col-md-2">
                            <label class="form-label" for="entYear">入学年度</label>
                            <select id="entYear" name="entYear" class="form-select">
                                <option value="">--------</option>
                                <c:forEach var="year" items="${entYearSet}">
                                    <option value="${year}"
                                        <c:if test="${year == entYear}">selected</c:if>>
                                        ${year}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-2">
                            <label class="form-label" for="classNum">クラス</label>
                            <select id="classNum" name="classNum" class="form-select">
                                <option value="">--------</option>
                                <c:forEach var="num" items="${classNumSet}">
                                    <option value="${num}"
                                        <c:if test="${num == classNum}">selected</c:if>>
                                        ${num}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label" for="subjectCd">科目</label>
                            <select id="subjectCd" name="subjectCd" class="form-select">
                                <option value="">----------</option>
                                <c:forEach var="subject" items="${subjectSet}">
                                    <option value="${subject.cd}"
                                        <c:if test="${subject.cd == subjectCd}">selected</c:if>>
                                        ${subject.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                                 <div class="col-md-2">
                                   <button type="submit"
                                          class="btn btn-secondary w-50 py-2">
                                             検索
                                    </button>
                       </div>

                    </div>
                </form>

                <%-- ═══════════════════════════════════════════
                     学生情報 検索フォーム
                ════════════════════════════════════════════ --%>
                <form action="${pageContext.request.contextPath}/TestList.action"
                      method="post"
                      class="mb-3">

                    <input type="hidden" name="searchType" value="student">

                    <div class="row align-items-end g-2">

                        <div class="col-md-2 fw-bold">
                            学生情報
                        </div>

                        <div class="col-md-3">
                            <label class="form-label" for="studentNo">学生番号</label>
                            <input type="text"
                                   id="studentNo"
                                   name="studentNo"
                                   value="${studentNo}"
                                   class="form-control"
                                   placeholder="学生番号を入力してください">
                        </div>

                                                <div class="col-md-2">
                                     <button type="submit"
                                     class="btn btn-secondary w-50 py-2">
                                             検索
                                      </button>
                                     </div>

                               </div>
                     </form>

                <%-- ═══════════════════════════════════════════
                     メッセージ表示エリア
                     優先順位: errorMsg > 初期案内
                ════════════════════════════════════════════ --%>
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

                <%-- ═══════════════════════════════════════════
                     学生情報 検索結果
                ════════════════════════════════════════════ --%>
                <c:if test="${not empty studentRows}">

                    <p class="mb-2">
                        氏名：<c:out value="${studentName}"/> (<c:out value="${studentNo}"/>)
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
                                    <td><c:out value="${r.subjectName}"/></td>
                                    <td><c:out value="${r.subjectCd}"/></td>
                                    <td><c:out value="${r.testNo}"/></td>
                                    <td><c:out value="${r.point}"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                </c:if>

                <%-- ═══════════════════════════════════════════
                     科目情報 検索結果
                ════════════════════════════════════════════ --%>
                <c:if test="${not empty subjectRows}">

                    <p class="mb-2">
                        科目：<c:out value="${subjectName}"/>
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
                                    <td><c:out value="${r.entYear}"/></td>
                                    <td><c:out value="${r.classNum}"/></td>
                                    <td><c:out value="${r.studentNo}"/></td>
                                    <td><c:out value="${r.studentName}"/></td>
                                    <td><c:out value="${r.testNo}"/></td>
                                    <td><c:out value="${r.point}"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                </c:if>

            </div>
        </section>
    </c:param>
</c:import>