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

        String schoolCd = user.getSchoolCd();

        String entYear = nv(req.getParameter("entYear"));
        String classNum = nv(req.getParameter("classNum"));
        String subjectCd = nv(req.getParameter("subjectCd"));
        String studentNo = nv(req.getParameter("studentNo"));
        String searchType = nv(req.getParameter("searchType"));

        String pageTitle = "成績参照";
        String errorMsg = "";
        String infoMsg = "科目情報を選択または学生情報を入力して検索ボタンをクリックしてください";
        String subjectName = "";
        String studentName = "";

        List<Map<String, String>> studentRows = new ArrayList<>();

        TestScoreDAO dao = new TestScoreDAO();

        List<String> entYears = dao.getEntYears(schoolCd);
        List<String> classNums = dao.getClassNums(schoolCd);
        List<Map<String, String>> subjects = dao.getSubjects(schoolCd);

        if ("student".equals(searchType)) {
            pageTitle = "成績一覧（学生）";
            infoMsg = "";

            if (studentNo.isEmpty()) {
                errorMsg = "学生番号を入力してください";
            } else {
                studentName = dao.getStudentName(schoolCd, studentNo);

                if (studentName == null) {
                    errorMsg = "学生情報が存在しませんでした";
                } else {
                    studentRows = dao.getStudentScores(schoolCd, studentNo);
                }
            }
        }

        req.setAttribute("entYears", entYears);
        req.setAttribute("classNums", classNums);
        req.setAttribute("subjects", subjects);

        req.setAttribute("entYear", entYear);
        req.setAttribute("classNum", classNum);
        req.setAttribute("subjectCd", subjectCd);
        req.setAttribute("studentNo", studentNo);

        req.setAttribute("pageTitle", pageTitle);
        req.setAttribute("errorMsg", errorMsg);
        req.setAttribute("infoMsg", infoMsg);
        req.setAttribute("subjectName", subjectName);
        req.setAttribute("studentName", studentName);
        req.setAttribute("studentRows", studentRows);

        return "/scoremanager/main/test_list.jsp";
    }

    private String nv(String value) {
        return value == null ? "" : value.trim();
    }
}