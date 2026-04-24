<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="java.sql.*,java.util.*,bean.Teacher" %>
<%@ include file="/common/dbutil.jspf" %>

<%
Teacher user = (Teacher) session.getAttribute("user");
if (user == null) {
    response.sendRedirect(request.getContextPath() + "/Login.action");
    return;
}

String schoolCd = user.getSchoolCd();

List<String> entYears = new ArrayList<>();
List<String> classNums = new ArrayList<>();
List<Map<String,String>> subjects = new ArrayList<>();

String entYear = nv(request.getParameter("entYear"));
String classNum = nv(request.getParameter("classNum"));
String subjectCd = nv(request.getParameter("subjectCd"));
String studentNo = nv(request.getParameter("studentNo"));
String searchType = nv(request.getParameter("searchType"));

String pageTitle = "成績参照";
String errorMsg = "";
String infoMsg = "科目情報を選択または学生情報を入力して検索ボタンをクリックしてください";
String subjectName = "";
String studentName = "";

List<Map<String,String>> subjectRows = new ArrayList<>();
List<Map<String,String>> studentRows = new ArrayList<>();
List<Integer> testNos = new ArrayList<>();

try (Connection con = getDbConnection()) {

    try (PreparedStatement st = con.prepareStatement(
            "SELECT DISTINCT ENT_YEAR FROM STUDENT WHERE TRIM(SCHOOL_CD)=TRIM(?) AND IS_ATTEND=TRUE ORDER BY ENT_YEAR DESC")) {
        st.setString(1, schoolCd);
        try (ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                String y = rs.getString("ENT_YEAR");
                if (y != null && !y.isEmpty()) entYears.add(y);
            }
        }
    }

    try (PreparedStatement st = con.prepareStatement(
            "SELECT DISTINCT CLASS_NUM FROM STUDENT WHERE TRIM(SCHOOL_CD)=TRIM(?) AND IS_ATTEND=TRUE ORDER BY CLASS_NUM")) {
        st.setString(1, schoolCd);
        try (ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                String c = rs.getString("CLASS_NUM");
                if (c != null && !c.isEmpty()) classNums.add(c);
            }
        }
    }

    try (PreparedStatement st = con.prepareStatement(
            "SELECT CD, NAME FROM SUBJECT WHERE TRIM(SCHOOL_CD)=TRIM(?) ORDER BY CD")) {
        st.setString(1, schoolCd);
        try (ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Map<String,String> m = new HashMap<>();
                m.put("cd", rs.getString("CD"));
                m.put("name", rs.getString("NAME"));
                subjects.add(m);

                if (rs.getString("CD").equals(subjectCd)) {
                    subjectName = rs.getString("NAME");
                }
            }
        }
    }

    if ("subject".equals(searchType)) {
        pageTitle = "成績一覧（科目）";
        infoMsg = "";

        if (entYear.isEmpty() || classNum.isEmpty() || subjectCd.isEmpty()) {
            errorMsg = "入学年度とクラスと科目を選択してください";
        } else {
            try (PreparedStatement st = con.prepareStatement(
                    "SELECT DISTINCT TEST_NO FROM TEST_SCORE WHERE TRIM(SCHOOL_CD)=TRIM(?) AND TRIM(SUBJECT_CD)=TRIM(?) ORDER BY TEST_NO")) {
                st.setString(1, schoolCd);
                st.setString(2, subjectCd);
                try (ResultSet rs = st.executeQuery()) {
                    while (rs.next()) testNos.add(rs.getInt("TEST_NO"));
                }
            }

            if (testNos.isEmpty()) {
                testNos.add(1);
                testNos.add(2);
            }

            String sql =
                "SELECT S.ENT_YEAR, S.CLASS_NUM, S.NO, S.NAME, T.TEST_NO, T.POINT " +
                "FROM STUDENT S " +
                "LEFT JOIN TEST_SCORE T ON TRIM(S.NO)=TRIM(T.STUDENT_NO) " +
                "AND TRIM(S.SCHOOL_CD)=TRIM(T.SCHOOL_CD) " +
                "AND TRIM(T.SUBJECT_CD)=TRIM(?) " +
                "WHERE TRIM(S.SCHOOL_CD)=TRIM(?) " +
                "AND S.IS_ATTEND=TRUE " +
                "AND S.ENT_YEAR=? " +
                "AND TRIM(S.CLASS_NUM)=TRIM(?) " +
                "ORDER BY S.NO, T.TEST_NO";

            Map<String, Map<String,String>> rowMap = new LinkedHashMap<>();

            try (PreparedStatement st = con.prepareStatement(sql)) {
                st.setString(1, subjectCd);
                st.setString(2, schoolCd);
                st.setString(3, entYear);
                st.setString(4, classNum);

                try (ResultSet rs = st.executeQuery()) {
                    while (rs.next()) {
                        String no = rs.getString("NO").trim();
                        Map<String,String> row = rowMap.get(no);

                        if (row == null) {
                            row = new HashMap<>();
                            row.put("entYear", rs.getString("ENT_YEAR"));
                            row.put("classNum", rs.getString("CLASS_NUM"));
                            row.put("studentNo", no);
                            row.put("studentName", rs.getString("NAME"));
                            rowMap.put(no, row);
                        }

                        int tn = rs.getInt("TEST_NO");
                        if (!rs.wasNull()) {
                            row.put("test" + tn, String.valueOf(rs.getInt("POINT")));
                            if (!testNos.contains(tn)) testNos.add(tn);
                        }
                    }
                }
            }

            subjectRows.addAll(rowMap.values());

            if (subjectRows.isEmpty()) {
                errorMsg = "学生情報が存在しませんでした";
            }
        }
    }

    if ("student".equals(searchType)) {
        pageTitle = "成績一覧（学生）";
        infoMsg = "";

        if (studentNo.isEmpty()) {
            errorMsg = "学生番号を入力してください";
        } else {

            try (PreparedStatement st = con.prepareStatement(
                    "SELECT NAME FROM STUDENT WHERE TRIM(SCHOOL_CD)=TRIM(?) AND TRIM(NO)=TRIM(?)")) {
                st.setString(1, schoolCd);
                st.setString(2, studentNo);

                try (ResultSet rs = st.executeQuery()) {
                    if (rs.next()) {
                        studentName = rs.getString("NAME");
                    } else {
                        errorMsg = "学生情報が存在しませんでした";
                    }
                }
            }

            if (errorMsg.isEmpty()) {
                try (PreparedStatement st = con.prepareStatement(
                        "SELECT SU.NAME AS SUBJECT_NAME, TS.SUBJECT_CD, TS.TEST_NO, TS.POINT " +
                        "FROM TEST_SCORE TS " +
                        "LEFT JOIN SUBJECT SU ON TRIM(TS.SUBJECT_CD)=TRIM(SU.CD) " +
                        "AND TRIM(TS.SCHOOL_CD)=TRIM(SU.SCHOOL_CD) " +
                        "WHERE TRIM(TS.SCHOOL_CD)=TRIM(?) " +
                        "AND TRIM(TS.STUDENT_NO)=TRIM(?) " +
                        "ORDER BY TS.SUBJECT_CD, TS.TEST_NO")) {

                    st.setString(1, schoolCd);
                    st.setString(2, studentNo);

                    try (ResultSet rs = st.executeQuery()) {
                        while (rs.next()) {
                            Map<String,String> row = new HashMap<>();

                            String subName = rs.getString("SUBJECT_NAME");
                            String subCd = rs.getString("SUBJECT_CD");

                            row.put("subjectName", subName != null ? subName : "");
                            row.put("subjectCd", subCd != null ? subCd.trim() : "");
                            row.put("testNo", rs.getString("TEST_NO"));
                            row.put("point", rs.getString("POINT"));

                            studentRows.add(row);
                        }
                    }
                }
            }
        }
    }
}

request.setAttribute("entYears", entYears);
request.setAttribute("classNums", classNums);
request.setAttribute("subjects", subjects);
request.setAttribute("entYear", entYear);
request.setAttribute("classNum", classNum);
request.setAttribute("subjectCd", subjectCd);
request.setAttribute("studentNo", studentNo);
request.setAttribute("pageTitle", pageTitle);
request.setAttribute("errorMsg", errorMsg);
request.setAttribute("infoMsg", infoMsg);
request.setAttribute("subjectName", subjectName);
request.setAttribute("studentName", studentName);
request.setAttribute("subjectRows", subjectRows);
request.setAttribute("studentRows", studentRows);
request.setAttribute("testNos", testNos);
%>

<c:import url="/common/base.jsp">
    <c:param name="title">${pageTitle}</c:param>
    <c:param name="scripts"></c:param>

    <c:param name="content">
        <section class="me-4">
            <h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">${pageTitle}</h2>

            <div class="card mx-4 mb-4">
                <div class="card-body">

                    <form action="${pageContext.request.contextPath}/scoremanager/main/test_list.jsp" method="post">
                        <input type="hidden" name="searchType" value="subject">

                        <div class="row g-3 align-items-end">
                            <div class="col-md-2">
                                <label class="form-label">科目情報</label>
                            </div>

                            <div class="col-md-2">
                                <label class="form-label">入学年度</label>
                                <select name="entYear" class="form-select">
                                    <option value="">---------</option>
                                    <c:forEach var="y" items="${entYears}">
                                        <option value="${y}" <c:if test="${entYear == y}">selected</c:if>>${y}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-2">
                                <label class="form-label">クラス</label>
                                <select name="classNum" class="form-select">
                                    <option value="">---------</option>
                                    <c:forEach var="c" items="${classNums}">
                                        <option value="${c}" <c:if test="${classNum == c}">selected</c:if>>${c}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label">科目</label>
                                <select name="subjectCd" class="form-select">
                                    <option value="">---------</option>
                                    <c:forEach var="s" items="${subjects}">
                                        <option value="${s.cd}" <c:if test="${subjectCd == s.cd}">selected</c:if>>${s.name}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-2">
                                <button class="btn btn-secondary w-100" type="submit">検索</button>
                            </div>
                        </div>
                    </form>

                    <hr>

                    <form action="${pageContext.request.contextPath}/scoremanager/main/test_list.jsp" method="post">
                        <input type="hidden" name="searchType" value="student">

                        <div class="row g-3 align-items-end">
                            <div class="col-md-2">
                                <label class="form-label">学生情報</label>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label">学生番号</label>
                                <input type="text" name="studentNo" value="${studentNo}" class="form-control" placeholder="学生番号を入力してください">
                            </div>

                            <div class="col-md-2">
                                <button class="btn btn-secondary w-100" type="submit">検索</button>
                            </div>
                        </div>
                    </form>

                </div>
            </div>

            <div class="px-4">

                <c:if test="${not empty errorMsg}">
                    <p style="color:#f0ad4e; margin-bottom: 1rem;">${errorMsg}</p>
                </c:if>

                <c:if test="${empty errorMsg and not empty infoMsg}">
                    <p style="color:#5bc0de; margin-bottom: 1rem;">${infoMsg}</p>
                </c:if>

                <c:if test="${not empty subjectRows}">
                    <p class="mb-2">科目：${subjectName}</p>

                    <table class="table">
                        <thead>
                            <tr>
                                <th>入学年度</th>
                                <th>クラス</th>
                                <th>学生番号</th>
                                <th>氏名</th>
                                <c:forEach var="n" items="${testNos}">
                                    <th>${n}回</th>
                                </c:forEach>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach var="r" items="${subjectRows}">
                                <tr>
                                    <td>${r.entYear}</td>
                                    <td>${r.classNum}</td>
                                    <td>${r.studentNo}</td>
                                    <td>${r.studentName}</td>

                                    <c:forEach var="n" items="${testNos}">
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty r['test'.concat(n)]}">
                                                    ${r['test'.concat(n)]}
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                    </c:forEach>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>

                <c:if test="${not empty studentName and empty studentRows and pageTitle == '成績一覧（学生）' and empty errorMsg}">
                    <p class="mb-2">氏名：${studentName} (${studentNo})</p>
                    <p>成績情報が存在しませんでした</p>
                </c:if>

                <c:if test="${not empty studentRows}">
                    <p class="mb-2">氏名：${studentName} (${studentNo})</p>

                    <table class="table">
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
                                        <c:choose>
                                            <c:when test="${not empty r.subjectName}">
                                                ${r.subjectName}
                                            </c:when>
                                            <c:otherwise>
                                                未登録
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${r.subjectCd}</td>
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