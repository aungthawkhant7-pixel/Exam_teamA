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

    private static final String SEARCH_TYPE_SUBJECT = "subject";
    private static final String SEARCH_TYPE_STUDENT = "student";

    @Override
    public String execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        Teacher user = (Teacher) req.getSession().getAttribute("user");
        if (user == null) {
            return "/login.jsp";
        }

        String schoolCd = user.getSchoolCd();

        String entYear    = nv(req.getParameter("entYear"));
        String classNum   = nv(req.getParameter("classNum"));
        String subjectCd  = nv(req.getParameter("subjectCd"));
        String studentNo  = nv(req.getParameter("studentNo"));
        String searchType = nv(req.getParameter("searchType"));

        TestScoreDAO dao = new TestScoreDAO();

        List<String> entYearSet = dao.getEntYears(schoolCd);
        List<String> classNumSet = dao.getClassNums(schoolCd);
        List<Map<String, String>> subjectSet = dao.getSubjects(schoolCd);

        String errorMsg = "";
        String studentName = "";
        String subjectName = "";

        List<Map<String, String>> studentRows = new ArrayList<>();
        List<Map<String, String>> subjectRows = new ArrayList<>();

        switch (searchType) {

            case SEARCH_TYPE_STUDENT:
                if (studentNo.isEmpty()) {
                    errorMsg = "学生番号を入力してください";
                } else {
                    studentName = dao.getStudentName(schoolCd, studentNo);

                    if (studentName == null || studentName.isEmpty()) {
                        errorMsg = "学生情報が存在しませんでした";
                        studentName = "";
                    } else {
                        studentRows = dao.getStudentScores(schoolCd, studentNo);

                        if (studentRows.isEmpty()) {
                            errorMsg = "成績情報が存在しませんでした";
                        }
                    }
                }
                break;

            case SEARCH_TYPE_SUBJECT:
                if (entYear.isEmpty() || classNum.isEmpty() || subjectCd.isEmpty()) {
                    errorMsg = "入学年度・クラス・科目をすべて選択してください";
                } else {
                    subjectName = dao.getSubjectName(schoolCd, subjectCd);
                    subjectRows = dao.getSubjectScores(schoolCd, entYear, classNum, subjectCd);

                    if (subjectRows.isEmpty()) {
                        errorMsg = "成績情報が存在しませんでした";
                    }
                }
                break;

            default:
                break;
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
        req.setAttribute("subjectName", subjectName);
        req.setAttribute("studentRows", studentRows);
        req.setAttribute("subjectRows", subjectRows);

        return "/scoremanager/main/test_list.jsp";
    }

    private static String nv(String value) {
        return value == null ? "" : value.trim();
    }
}