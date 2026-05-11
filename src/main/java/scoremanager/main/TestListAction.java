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

        String errorMsg = "";
        String studentName = "";
        String subjectName = "";

        List<Map<String, String>> studentRows = new ArrayList<>();
        List<Map<String, String>> subjectRows = new ArrayList<>();

        TestScoreDAO dao = new TestScoreDAO();

        List<String> entYears = dao.getEntYears(schoolCd);
        List<String> classNums = dao.getClassNums(schoolCd);
        List<Map<String, String>> subjects = dao.getSubjects(schoolCd);

        System.out.println("schoolCd = " + schoolCd);
        System.out.println("entYears = " + entYears);
        System.out.println("classNums = " + classNums);
        System.out.println("subjects = " + subjects);

        if ("student".equals(searchType)) {

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

        } else if ("subject".equals(searchType)) {

            if (entYear.isEmpty() || classNum.isEmpty() || subjectCd.isEmpty()) {
                errorMsg = "入学年度、クラス、科目を選択してください";
            } else {
                subjectName = dao.getSubjectName(schoolCd, subjectCd);
                subjectRows = dao.getSubjectScores(schoolCd, entYear, classNum, subjectCd);
            }
        }

        req.setAttribute("entYears", entYears);
        req.setAttribute("classNums", classNums);
        req.setAttribute("subjects", subjects);

        req.setAttribute("entYear", entYear);
        req.setAttribute("classNum", classNum);
        req.setAttribute("subjectCd", subjectCd);
        req.setAttribute("studentNo", studentNo);

        req.setAttribute("errorMsg", errorMsg);
        req.setAttribute("studentName", studentName);
        req.setAttribute("subjectName", subjectName);
        req.setAttribute("studentRows", studentRows);
        req.setAttribute("subjectRows", subjectRows);

        return "/scoremanager/main/test_list.jsp";
    }

    private String nv(String value) {
        return value == null ? "" : value.trim();
    }
}