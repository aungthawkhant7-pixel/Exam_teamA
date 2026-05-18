<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="java.sql.*,java.util.*,bean.Teacher" %>
<%@ include file="/common/dbutil.jspf" %>
<%
Teacher user = (Teacher) session.getAttribute("user");
if (user == null) { response.sendRedirect(request.getContextPath() + "/Login.action"); return; }
 
String schoolCd = user.getSchoolCd();
String flash = null;
String error = null;
boolean searched = false;
 
List<String> entYears = new ArrayList<>();
List<String> classNums = new ArrayList<>();
List<Map<String,String>> subjects = new ArrayList<>();
List<Map<String,String>> scoreRows = new ArrayList<>();
Map<String,String> rowErrors = new HashMap<>();
 
String entYear = nv(request.getParameter("entYear"));
String classNum = nv(request.getParameter("classNum"));
String subjectCd = nv(request.getParameter("subjectCd"));
String testNoStr = nv(request.getParameter("testNo"));
String formAction = nv(request.getParameter("formAction"));
String subjectName = "";
 
try (Connection con = getDbConnection()) {
    ensureAssumedTables(con);
 
    try (PreparedStatement st = con.prepareStatement(
            "SELECT DISTINCT ENT_YEAR FROM STUDENT WHERE SCHOOL_CD=? AND IS_ATTEND=TRUE ORDER BY ENT_YEAR DESC")) {
        st.setString(1, schoolCd);
        try (ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                String v = rs.getString("ENT_YEAR");
                if (v != null && !v.isEmpty()) entYears.add(v);
            }
        }
    }
 
    try (PreparedStatement st = con.prepareStatement(
            "SELECT DISTINCT CLASS_NUM FROM STUDENT WHERE SCHOOL_CD=? AND IS_ATTEND=TRUE ORDER BY CLASS_NUM")) {
        st.setString(1, schoolCd);
        try (ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                String v = rs.getString("CLASS_NUM");
                if (v != null && !v.isEmpty()) classNums.add(v);
            }
        }
    }
 
    try (PreparedStatement st = con.prepareStatement(
            "SELECT CD, NAME FROM SUBJECT WHERE SCHOOL_CD=? ORDER BY CD")) {
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
 
    boolean shouldShowList = "search".equals(formAction) || "save".equals(formAction)
        || (!entYear.isEmpty() && !classNum.isEmpty() && !subjectCd.isEmpty() && !testNoStr.isEmpty());
 
    if ("save".equals(formAction)) {
        searched = true;
        int testNo = toInt(testNoStr, 0);
        String[] studentNos = request.getParameterValues("studentNo");
 
        if (entYear.isEmpty() || classNum.isEmpty() || subjectCd.isEmpty() || testNoStr.isEmpty()) {
            error = "入学年度・クラス・科目・回数を選択してください。";
        } else if (testNo <= 0) {
            error = "回数は1以上を入力してください。";
        } else if (studentNos == null || studentNos.length == 0) {
            error = "対象の学生が見つかりません。";
        } else {
            for (String studentNo : studentNos) {
                String p = nv(request.getParameter("point_" + studentNo));
                if (p.isEmpty()) {
                    rowErrors.put(studentNo, "0〜100の範囲で入力してください");
                    continue;
                }
                try {
                    int point = Integer.parseInt(p);
                    if (point < 0 || point > 100) {
                        rowErrors.put(studentNo, "0〜100の範囲で入力してください");
                    }
                } catch (Exception e) {
                    rowErrors.put(studentNo, "0〜100の範囲で入力してください");
                }
            }
 
            if (rowErrors.isEmpty()) {
                try (PreparedStatement up = con.prepareStatement(
                        "UPDATE TEST_SCORE SET POINT=? WHERE STUDENT_NO=? AND SUBJECT_CD=? AND TEST_NO=? AND SCHOOL_CD=?");
                     PreparedStatement ins = con.prepareStatement(
                        "INSERT INTO TEST_SCORE(STUDENT_NO, SUBJECT_CD, TEST_NO, POINT, SCHOOL_CD) VALUES(?, ?, ?, ?, ?)")) {
 
                    for (String studentNo : studentNos) {
                        int point = Integer.parseInt(nv(request.getParameter("point_" + studentNo)));
                        up.setInt(1, point);
                        up.setString(2, studentNo);
                        up.setString(3, subjectCd);
                        up.setInt(4, testNo);
                        up.setString(5, schoolCd);
                        int count = up.executeUpdate();
                        if (count == 0) {
                            ins.setString(1, studentNo);
                            ins.setString(2, subjectCd);
                            ins.setInt(3, testNo);
                            ins.setInt(4, point);
                            ins.setString(5, schoolCd);
                            ins.executeUpdate();
                        }
                    }
                }
                // ↓ ここだけ変更：完了画面へリダイレクト
                response.sendRedirect(request.getContextPath() + "/scoremanager/main/test_regist_done.jsp");
                return;
            } else {
                error = "入力内容を確認してください。";
            }
        }
        shouldShowList = true;
    }
 
    if (shouldShowList) {
        searched = true;
        Map<String,String> existingPoints = new HashMap<>();
        int testNo = toInt(testNoStr, 0);
 
        if (!subjectCd.isEmpty() && testNo > 0) {
            try (PreparedStatement st = con.prepareStatement(
                    "SELECT STUDENT_NO, POINT FROM TEST_SCORE WHERE SCHOOL_CD=? AND SUBJECT_CD=? AND TEST_NO=?")) {
                st.setString(1, schoolCd);
                st.setString(2, subjectCd);
                st.setInt(3, testNo);
                try (ResultSet rs = st.executeQuery()) {
                    while (rs.next()) {
                        existingPoints.put(rs.getString("STUDENT_NO"), String.valueOf(rs.getInt("POINT")));
                    }
                }
            }
        }
 
        if (!entYear.isEmpty() && !classNum.isEmpty()) {
            try (PreparedStatement st = con.prepareStatement(
                    "SELECT ENT_YEAR, CLASS_NUM, NO, NAME FROM STUDENT " +
                    "WHERE SCHOOL_CD=? AND IS_ATTEND=TRUE AND ENT_YEAR=? AND CLASS_NUM=? ORDER BY NO")) {
                st.setString(1, schoolCd);
                st.setString(2, entYear);
                st.setString(3, classNum);
                try (ResultSet rs = st.executeQuery()) {
                    while (rs.next()) {
                        String studentNo = rs.getString("NO");
                        Map<String,String> row = new HashMap<>();
                        row.put("entYear", rs.getString("ENT_YEAR"));
                        row.put("classNum", rs.getString("CLASS_NUM"));
                        row.put("studentNo", studentNo);
                        row.put("studentName", rs.getString("NAME"));
 
                        String inputPoint = nv(request.getParameter("point_" + studentNo));
                        if (inputPoint.isEmpty()) inputPoint = existingPoints.getOrDefault(studentNo, "");
                        row.put("point", inputPoint);
                        scoreRows.add(row);
                    }
                }
            }
        }
    }
}
 
request.setAttribute("entYears", entYears);
request.setAttribute("classNums", classNums);
request.setAttribute("subjects", subjects);
request.setAttribute("scoreRows", scoreRows);
request.setAttribute("rowErrors", rowErrors);
request.setAttribute("flash", flash);
request.setAttribute("errorMsg", error);
request.setAttribute("searched", searched);
request.setAttribute("entYear", entYear);
request.setAttribute("classNum", classNum);
request.setAttribute("subjectCd", subjectCd);
request.setAttribute("testNo", testNoStr);
request.setAttribute("subjectName", subjectName);
%>
<c:import url="/common/base.jsp">
<c:param name="title">成績管理</c:param>
<c:param name="scripts"></c:param>
<c:param name="content">
<section class="me-4">
<h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">成績管理</h2>
 

 
            <div class="card mx-4 mb-4">
<div class="card-body">
<form action="${pageContext.request.contextPath}/scoremanager/main/test_regist.jsp" method="post">
<input type="hidden" name="formAction" value="search">
<div class="row g-3 align-items-end">
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
<label class="form-label">回数</label>
<select name="testNo" class="form-select">
<option value="">---------</option>
<c:forEach var="n" begin="1" end="10">
<option value="${n}" <c:if test="${testNo == n.toString()}">selected</c:if>>${n}</option>
</c:forEach>
</select>
</div>
<div class="col-md-2">
<button class="btn btn-secondary w-100" type="submit">検索</button>
</div>
</div>
</form>
</div>
</div>
 
            <c:if test="${searched}">
<div class="px-4">
<c:if test="${not empty subjectCd and not empty testNo}">
<p class="mb-2">科目：${subjectName}（${testNo}回）</p>
</c:if>
 
                    <c:if test="${not empty scoreRows}">
<form action="${pageContext.request.contextPath}/scoremanager/main/test_regist.jsp" method="post">
<input type="hidden" name="formAction" value="save">
<input type="hidden" name="entYear" value="${entYear}">
<input type="hidden" name="classNum" value="${classNum}">
<input type="hidden" name="subjectCd" value="${subjectCd}">
<input type="hidden" name="testNo" value="${testNo}">
 
                            <table class="table align-middle">
<thead>
<tr>
<th>入学年度</th>
<th>クラス</th>
<th>学生番号</th>
<th>氏名</th>
<th style="width:260px;">点数</th>
</tr>
</thead>
<tbody>
<c:forEach var="r" items="${scoreRows}">
<tr>
<td>${r.entYear}</td>
<td>${r.classNum}</td>
<td>
                                                ${r.studentNo}
<input type="hidden" name="studentNo" value="${r.studentNo}">
</td>
<td>${r.studentName}</td>
<td>
<input type="text"
class="form-control <c:if test="">is-invalid</c:if>"
name="point_${r.studentNo}"
value="${r.point}"
placeholder="">
<c:if test="${not empty rowErrors[r.studentNo]}">
<div style="color:#f0ad4e; font-size:0.9rem;">${rowErrors[r.studentNo]}</div>
 </c:if>
</td>
</tr>
</c:forEach>
</tbody>
</table>
 
                            <button class="btn btn-secondary" type="submit">登録して終了</button>
</form>
</c:if>
 
                    <c:if test="${empty scoreRows}">
<p>条件に一致する学生が見つかりませんでした。</p>
</c:if>
</div>
</c:if>
</section>
</c:param>
</c:import>
 
 
 