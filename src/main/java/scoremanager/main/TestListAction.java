package scoremanager.main;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import bean.Teacher;
import dao.TestScoreDAO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tool.Action;

public class TestListAction extends Action {

    @Override
    public String execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        Teacher user = (Teacher) req.getSession().getAttribute("user");

        if (user == null) {
            return "/login.jsp";
        }

        // 「登録して終了」ボタン
        String finish = req.getParameter("finish");

        if ("true".equals(finish)) {
            return "/scoremanager/main/test_list_done.jsp";
        }

        String schoolCd = user.getSchoolCd();

        String entYear    = nv(req.getParameter("entYear"));
        String classNum   = nv(req.getParameter("classNum"));
        String subjectCd  = nv(req.getParameter("subjectCd"));
        String studentNo  = nv(req.getParameter("studentNo"));
        String searchType = nv(req.getParameter("searchType"));

        String errorMsg    = "";
        String studentName = "";

        List<Map<String, String>> studentRows = new ArrayList<>();
        List<Map<String, String>> subjectRows = new ArrayList<>();

        TestScoreDAO dao = new TestScoreDAO();

        List<String> entYearSet = dao.getEntYears(schoolCd);
        List<String> classNumSet = dao.getClassNums(schoolCd);
        List<Map<String, String>> subjectSet = dao.getSubjects(schoolCd);

        // 学生情報検索
        if ("student".equals(searchType)) {

            if (studentNo.isEmpty()) {

                errorMsg = "学生番号を入力してください";

            } else {

                studentName = dao.getStudentName(schoolCd, studentNo);

                if (studentName == null) {

                    errorMsg = "学生情報が存在しませんでした";

                } else {

                    studentRows = dao.getStudentScores(schoolCd, studentNo);

                    if (studentRows.isEmpty()) {
                        errorMsg = "成績情報が存在しませんでした";
                    }
                }
            }
        }

        // 科目情報検索
        if ("subject".equals(searchType)) {

            if (entYear.isEmpty() || classNum.isEmpty() || subjectCd.isEmpty()) {

                errorMsg = "入学年度とクラスと科目を選択してください";

            } else {

                subjectRows = dao.getSubjectScores(
                        schoolCd,
                        entYear,
                        classNum,
                        subjectCd
                );

                if (subjectRows.isEmpty()) {
                    errorMsg = "成績情報が存在しませんでした";
                }
            }
        }

        req.setAttribute("entYearSet", entYearSet);
        req.setAttribute("classNumSet", classNumSet);
        req.setAttribute("subjectSet", subjectSet);

        req.setAttribute("entYear", entYear);
        req.setAttribute("classNum", classNum);
        req.setAttribute("subjectCd", subjectCd);
        req.setAttribute("studentNo", studentNo);
        req.setAttribute("searchType", searchType);

        req.setAttribute("errorMsg", errorMsg);
        req.setAttribute("studentName", studentName);
        req.setAttribute("studentRows", studentRows);
        req.setAttribute("subjectRows", subjectRows);

        return "/scoremanager/main/test_list.jsp";
    }

    private String nv(String value) {
        return value == null ? "" : value.trim();
    }
}