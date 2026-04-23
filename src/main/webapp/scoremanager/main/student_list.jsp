<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="java.sql.*,java.util.*,bean.*" %>
<%@ include file="/common/dbutil.jspf" %>
<%
Teacher user = (Teacher) session.getAttribute("user");
if (user == null) {
    response.sendRedirect(request.getContextPath() + "/Login.action");
    return;
}
String schoolCd = user.getSchoolCd();
String flash = null;
String error = null;
Student editStudent = null;
List<Student> students = new ArrayList<>();
List<ClassNum> classNums = new ArrayList<>();
List<Integer> entYearSet = new ArrayList<>();
int currentYear = Calendar.getInstance().get(Calendar.YEAR);
for (int i = currentYear - 10; i <= currentYear + 1; i++) entYearSet.add(i);
String selectedEntYear = nv(request.getParameter("entYear"));
String selectedClassNum = nv(request.getParameter("classNum"));
boolean checkedAttend = "true".equals(request.getParameter("isAttend"));
String formNo = "";
String formName = "";
String formEntYear = "";
String formClassNum = "";
boolean formAttend = true;
String originalNo = nv(request.getParameter("originalNo"));

try (Connection con = getDbConnection()) {
    ensureAssumedTables(con);
    String action = nv(request.getParameter("formAction"));

    if ("save".equals(action)) {
        formNo = nv(request.getParameter("no")).trim();
        formName = nv(request.getParameter("name")).trim();
        formEntYear = nv(request.getParameter("formEntYear")).trim();
        formClassNum = nv(request.getParameter("formClassNum")).trim();
        formAttend = "true".equals(request.getParameter("formAttend"));

        if (formNo.isEmpty() || formName.isEmpty() || formEntYear.isEmpty() || formClassNum.isEmpty()) {
            error = "学生番号・氏名・入学年度・クラスは必須です。";
        } else {
            int entYear = toInt(formEntYear, 0);
            if (originalNo.isEmpty()) {
                try (PreparedStatement st = con.prepareStatement(
                        "INSERT INTO STUDENT(NO, NAME, ENT_YEAR, CLASS_NUM, IS_ATTEND, SCHOOL_CD) VALUES(?, ?, ?, ?, ?, ?)")) {
                    st.setString(1, formNo);
                    st.setString(2, formName);
                    st.setInt(3, entYear);
                    st.setString(4, formClassNum);
                    st.setBoolean(5, formAttend);
                    st.setString(6, schoolCd);
                    st.executeUpdate();
                    flash = "学生を登録しました。";
                } catch (SQLException ex) {
                    error = "登録に失敗しました。学生番号が重複している可能性があります。";
                }
            } else {
                try (PreparedStatement st = con.prepareStatement(
                        "UPDATE STUDENT SET NO=?, NAME=?, ENT_YEAR=?, CLASS_NUM=?, IS_ATTEND=? WHERE NO=? AND SCHOOL_CD=?")) {
                    st.setString(1, formNo);
                    st.setString(2, formName);
                    st.setInt(3, entYear);
                    st.setString(4, formClassNum);
                    st.setBoolean(5, formAttend);
                    st.setString(6, originalNo);
                    st.setString(7, schoolCd);
                    st.executeUpdate();
                    flash = "学生情報を更新しました。";
                } catch (SQLException ex) {
                    error = "更新に失敗しました。学生番号が重複している可能性があります。";
                }
            }
        }
    } else if ("delete".equals(action)) {
        String no = nv(request.getParameter("no"));
        try (PreparedStatement st1 = con.prepareStatement("DELETE FROM TEST_SCORE WHERE STUDENT_NO=? AND SCHOOL_CD=?");
             PreparedStatement st2 = con.prepareStatement("DELETE FROM STUDENT WHERE NO=? AND SCHOOL_CD=?")) {
            st1.setString(1, no);
            st1.setString(2, schoolCd);
            st1.executeUpdate();
            st2.setString(1, no);
            st2.setString(2, schoolCd);
            st2.executeUpdate();
            flash = "学生を削除しました。";
        }
    }

    String editNo = nv(request.getParameter("editNo"));
    if (!editNo.isEmpty()) {
        try (PreparedStatement st = con.prepareStatement("SELECT * FROM STUDENT WHERE NO=? AND SCHOOL_CD=?")) {
            st.setString(1, editNo);
            st.setString(2, schoolCd);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    editStudent = new Student();
                    editStudent.setNo(rs.getString("NO"));
                    editStudent.setName(rs.getString("NAME"));
                    editStudent.setEntYear(rs.getInt("ENT_YEAR"));
                    editStudent.setClassNum(rs.getString("CLASS_NUM"));
                    editStudent.setAttend(rs.getBoolean("IS_ATTEND"));
                    editStudent.setSchoolCd(rs.getString("SCHOOL_CD"));
                    formNo = editStudent.getNo();
                    formName = editStudent.getName();
                    formEntYear = String.valueOf(editStudent.getEntYear());
                    formClassNum = editStudent.getClassNum();
                    formAttend = editStudent.isAttend();
                    originalNo = editStudent.getNo();
                }
            }
        }
    }

    try (PreparedStatement st = con.prepareStatement("SELECT * FROM CLASS_NUM WHERE SCHOOL_CD=? ORDER BY CLASS_NUM")) {
        st.setString(1, schoolCd);
        try (ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                ClassNum cn = new ClassNum();
                cn.setClassNum(rs.getString("CLASS_NUM"));
                cn.setSchoolCd(rs.getString("SCHOOL_CD"));
                classNums.add(cn);
            }
        }
    }

    StringBuilder sql = new StringBuilder("SELECT * FROM STUDENT WHERE SCHOOL_CD=?");
    List<Object> params = new ArrayList<>();
    params.add(schoolCd);
    if (!selectedEntYear.isEmpty()) { sql.append(" AND ENT_YEAR=?"); params.add(toInt(selectedEntYear, 0)); }
    if (!selectedClassNum.isEmpty()) { sql.append(" AND CLASS_NUM=?"); params.add(selectedClassNum); }
    if (checkedAttend) { sql.append(" AND IS_ATTEND=?"); params.add(Boolean.TRUE); }
    sql.append(" ORDER BY ENT_YEAR DESC, NO");
    try (PreparedStatement st = con.prepareStatement(sql.toString())) {
        for (int i = 0; i < params.size(); i++) st.setObject(i + 1, params.get(i));
        try (ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Student s = new Student();
                s.setNo(rs.getString("NO"));
                s.setName(rs.getString("NAME"));
                s.setEntYear(rs.getInt("ENT_YEAR"));
                s.setClassNum(rs.getString("CLASS_NUM"));
                s.setAttend(rs.getBoolean("IS_ATTEND"));
                s.setSchoolCd(rs.getString("SCHOOL_CD"));
                students.add(s);
            }
        }
    }
}
request.setAttribute("students", students);
request.setAttribute("classNums", classNums);
request.setAttribute("entYearSet", entYearSet);
request.setAttribute("flash", flash);
request.setAttribute("errorMsg", error);
request.setAttribute("formNo", formNo);
request.setAttribute("formName", formName);
request.setAttribute("formEntYear", formEntYear);
request.setAttribute("formClassNum", formClassNum);
request.setAttribute("formAttend", formAttend);
request.setAttribute("originalNo", originalNo);
request.setAttribute("selectedEntYear", selectedEntYear);
request.setAttribute("selectedClassNum", selectedClassNum);
request.setAttribute("checkedAttend", checkedAttend);
%>

<c:import url="/common/base.jsp">
    <c:param name="title">学生管理</c:param>

    <c:param name="scripts">
        <style>
            .netflix-student-page {
                background: #000;
                color: #fff;
                border-radius: 16px;
                padding: 24px;
                box-shadow: 0 10px 30px rgba(0,0,0,.35);
            }

            .netflix-title {
                background: linear-gradient(90deg, #111, #1a1a1a);
                color: #fff;
                border-left: 6px solid #e50914;
                border-radius: 10px;
                padding: 14px 18px;
                font-weight: 700;
                letter-spacing: .5px;
            }

            .netflix-alert {
                border: none;
                border-radius: 10px;
                padding: 14px 18px;
                font-weight: 600;
                animation: fadeInDown .35s ease;
            }

            .netflix-alert-success {
                background: rgba(25, 135, 84, .18);
                color: #9cf0c0;
                border-left: 4px solid #198754;
            }

            .netflix-alert-danger {
                background: rgba(220, 53, 69, .18);
                color: #ffb3bb;
                border-left: 4px solid #dc3545;
            }

            .netflix-card {
                background: #141414;
                border: 1px solid #252525;
                border-radius: 14px;
                box-shadow: 0 8px 24px rgba(0,0,0,.35);
                overflow: hidden;
            }

            .netflix-card .card-header {
                background: #1b1b1b;
                color: #fff;
                border-bottom: 1px solid #2a2a2a;
                font-weight: 700;
                padding: 14px 18px;
            }

            .netflix-card .card-body {
                background: #141414;
                color: #fff;
            }

            .netflix-form-label {
                color: #d9d9d9;
                font-weight: 600;
                margin-bottom: 6px;
            }

            .netflix-input,
            .netflix-select {
                background: #1d1d1d !important;
                border: 1px solid #333 !important;
                color: #fff !important;
                border-radius: 10px !important;
                padding: 10px 12px !important;
                transition: all .2s ease;
            }

            .netflix-input:focus,
            .netflix-select:focus {
                border-color: #e50914 !important;
                box-shadow: 0 0 0 3px rgba(229,9,20,.18) !important;
                background: #232323 !important;
                color: #fff !important;
            }

            .netflix-input::placeholder {
                color: #999;
            }

            .netflix-check .form-check-input {
                background-color: #1d1d1d;
                border-color: #555;
            }

            .netflix-check .form-check-input:checked {
                background-color: #e50914;
                border-color: #e50914;
            }

            .netflix-check .form-check-label {
                color: #ddd;
                font-weight: 600;
            }

            .netflix-btn {
                border: none;
                border-radius: 10px;
                padding: 10px 18px;
                font-weight: 700;
                text-decoration: none;
                transition: all .2s ease;
                display: inline-block;
            }

            .netflix-btn-primary {
                background: #e50914;
                color: #fff;
            }

            .netflix-btn-primary:hover {
                background: #b20710;
                color: #fff;
                transform: translateY(-1px);
            }

            .netflix-btn-secondary {
                background: #2a2a2a;
                color: #fff;
                border: 1px solid #3a3a3a;
            }

            .netflix-btn-secondary:hover {
                background: #383838;
                color: #fff;
            }

            .netflix-filter-box {
                background: #111;
                border: 1px solid #232323;
                border-radius: 14px;
                padding: 18px;
                box-shadow: 0 8px 24px rgba(0,0,0,.25);
            }

            .netflix-table-wrap {
                background: #141414;
                border: 1px solid #232323;
                border-radius: 14px;
                overflow: hidden;
                box-shadow: 0 8px 24px rgba(0,0,0,.35);
            }

            .netflix-table {
                width: 100%;
                margin-bottom: 0;
                color: #fff;
                border-collapse: collapse;
            }

            .netflix-table thead {
                background: #1b1b1b;
            }

            .netflix-table th,
            .netflix-table td {
                border-color: #2a2a2a !important;
                padding: 14px 12px;
                text-align: center;
                vertical-align: middle;
            }

            .netflix-table th {
                color: #fff;
                font-weight: 700;
                font-size: 14px;
                letter-spacing: .3px;
            }

            .netflix-table tbody tr {
                background: #141414;
                transition: background .2s ease, transform .2s ease;
            }

            .netflix-table tbody tr:hover {
                background: #1c1c1c;
            }

            .netflix-badge-on,
            .netflix-badge-off {
                display: inline-block;
                min-width: 42px;
                padding: 5px 10px;
                border-radius: 999px;
                font-size: 12px;
                font-weight: 700;
            }

            .netflix-badge-on {
                background: rgba(25, 135, 84, .18);
                color: #9cf0c0;
                border: 1px solid rgba(25, 135, 84, .4);
            }

            .netflix-badge-off {
                background: rgba(255,255,255,.08);
                color: #ccc;
                border: 1px solid rgba(255,255,255,.15);
            }

            .netflix-action-btn {
                border-radius: 8px !important;
                font-weight: 700 !important;
                padding: 5px 12px !important;
            }

            .netflix-empty {
                color: #bbb;
                background: #111;
                border: 1px dashed #333;
                border-radius: 12px;
                padding: 24px;
                text-align: center;
                font-weight: 600;
            }

            @keyframes fadeInDown {
                from {
                    opacity: 0;
                    transform: translateY(-8px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
        </style>

        <script>
            document.addEventListener("DOMContentLoaded", function() {
                const flash = document.querySelector(".netflix-alert-success");
                if (flash) {
                    setTimeout(function() {
                        flash.style.transition = "opacity .4s ease";
                        flash.style.opacity = "0";
                        setTimeout(function() {
                            flash.style.display = "none";
                        }, 400);
                    }, 2500);
                }

                const form = document.querySelector("#studentForm");
                if (form) {
                    form.addEventListener("submit", function(e) {
                        const no = document.querySelector('input[name="no"]').value.trim();
                        const name = document.querySelector('input[name="name"]').value.trim();
                        const entYear = document.querySelector('select[name="formEntYear"]').value.trim();
                        const classNum = document.querySelector('select[name="formClassNum"]').value.trim();

                        if (!no || !name || !entYear || !classNum) {
                            e.preventDefault();
                            alert("学生番号・氏名・入学年度・クラスを入力してください。");
                        }
                    });
                }

                const deleteForms = document.querySelectorAll(".delete-form");
                deleteForms.forEach(function(f) {
                    f.addEventListener("submit", function(e) {
                        if (!confirm("削除しますか？")) {
                            e.preventDefault();
                        }
                    });
                });
            });
        </script>
    </c:param>

    <c:param name="content">
        <section class="netflix-student-page me-4">
            <h2 class="h3 mb-4 fw-normal netflix-title">学生管理</h2>

            <c:if test="${not empty flash}">
                <div class="netflix-alert netflix-alert-success mx-1 mb-4">${flash}</div>
            </c:if>

            <c:if test="${not empty errorMsg}">
                <div class="netflix-alert netflix-alert-danger mx-1 mb-4">${errorMsg}</div>
            </c:if>

            <div class="card netflix-card mx-1 mb-4">
                <div class="card-header">${empty originalNo ? '学生登録' : '学生更新'}</div>
                <div class="card-body">
                    <form id="studentForm" action="${pageContext.request.contextPath}/scoremanager/main/student_list.jsp" method="post" class="row g-3">
                        <input type="hidden" name="formAction" value="save">
                        <input type="hidden" name="originalNo" value="${originalNo}">

                        <div class="col-md-3">
                            <label class="form-label netflix-form-label">学生番号</label>
                            <input type="text" name="no" value="${formNo}" class="form-control netflix-input" maxlength="10" required>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label netflix-form-label">氏名</label>
                            <input type="text" name="name" value="${formName}" class="form-control netflix-input" maxlength="50" required>
                        </div>

                        <div class="col-md-2">
                            <label class="form-label netflix-form-label">入学年度</label>
                            <select name="formEntYear" class="form-select netflix-select" required>
                                <option value="">----</option>
                                <c:forEach var="year" items="${entYearSet}">
                                    <option value="${year}" <c:if test="${formEntYear == year.toString()}">selected</c:if>>${year}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-2">
                            <label class="form-label netflix-form-label">クラス</label>
                            <select name="formClassNum" class="form-select netflix-select" required>
                                <option value="">----</option>
                                <c:forEach var="cn" items="${classNums}">
                                    <option value="${cn.classNum}" <c:if test="${formClassNum == cn.classNum}">selected</c:if>>${cn.classNum}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-2 d-flex align-items-end netflix-check">
                            <div class="form-check mb-2">
                                <input type="checkbox" class="form-check-input" id="formAttend" name="formAttend" value="true" <c:if test="${formAttend}">checked</c:if>>
                                <label class="form-check-label" for="formAttend">在学中</label>
                            </div>
                        </div>

                        <div class="col-12">
                            <button class="netflix-btn netflix-btn-primary me-2" type="submit">
                                ${empty originalNo ? '登録' : '更新'}
                            </button>
                            <a class="netflix-btn netflix-btn-secondary" href="${pageContext.request.contextPath}/StudentList.action">クリア</a>
                        </div>
                    </form>
                </div>
            </div>

            <div class="netflix-filter-box mx-1 mb-4">
                <form action="${pageContext.request.contextPath}/StudentList.action" method="get" class="row g-3 align-items-end">
                    <div class="col-auto">
                        <label class="form-label netflix-form-label">入学年度</label>
                        <select name="entYear" class="form-select netflix-select">
                            <option value="">----</option>
                            <c:forEach var="year" items="${entYearSet}">
                                <option value="${year}" <c:if test="${selectedEntYear == year.toString()}">selected</c:if>>${year}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-auto">
                        <label class="form-label netflix-form-label">クラス</label>
                        <select name="classNum" class="form-select netflix-select">
                            <option value="">----</option>
                            <c:forEach var="cn" items="${classNums}">
                                <option value="${cn.classNum}" <c:if test="${selectedClassNum == cn.classNum}">selected</c:if>>${cn.classNum}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-auto form-check mt-4 pt-2 netflix-check">
                        <input class="form-check-input" type="checkbox" name="isAttend" value="true" id="isAttend" <c:if test="${checkedAttend}">checked</c:if>>
                        <label class="form-check-label" for="isAttend">在学中のみ</label>
                    </div>

                    <div class="col-auto">
                        <button type="submit" class="netflix-btn netflix-btn-primary me-2">絞込み</button>
                        <a class="netflix-btn netflix-btn-secondary" href="${pageContext.request.contextPath}/StudentList.action">解除</a>
                    </div>
                </form>
            </div>

            <div class="px-1">
                <div class="netflix-table-wrap">
                    <table class="table netflix-table align-middle">
                        <thead>
                            <tr>
                                <th>入学年度</th>
                                <th>学生番号</th>
                                <th>氏名</th>
                                <th>クラス</th>
                                <th>在学</th>
                                <th style="width: 180px;">操作</th>
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
                                                <span class="netflix-badge-on">○</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="netflix-badge-off">×</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a class="btn btn-sm btn-outline-light netflix-action-btn me-1"
                                           href="${pageContext.request.contextPath}/scoremanager/main/student_list.jsp?editNo=${student.no}">
                                            編集
                                        </a>

                                        <form class="delete-form"
                                              action="${pageContext.request.contextPath}/scoremanager/main/student_list.jsp"
                                              method="post"
                                              style="display:inline;">
                                            <input type="hidden" name="formAction" value="delete">
                                            <input type="hidden" name="no" value="${student.no}">
                                            <button class="btn btn-sm btn-outline-danger netflix-action-btn" type="submit">削除</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <c:if test="${empty students}">
                    <p class="netflix-empty mt-3">学生情報が存在しませんでした。</p>
                </c:if>
            </div>
        </section>
    </c:param>
</c:import>