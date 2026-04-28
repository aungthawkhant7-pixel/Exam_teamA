package scoremanager.main;

import java.util.List;

import bean.Student;
import bean.Teacher;
import dao.StudentDao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tool.Action;

public class StudentListAction extends Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // session user
        Teacher teacher = (Teacher) request.getSession().getAttribute("user");

        if (teacher == null) {
            return "../login.jsp"; // login page
        }

        // school code
        String schoolCd = teacher.getSchoolCd();

        // parameters
        String entYearStr = request.getParameter("entYear");
        String classNum = request.getParameter("classNum");
        boolean isAttend = "true".equals(request.getParameter("isAttend"));

        // convert
        Integer entYear = null;
        if (entYearStr != null && !entYearStr.isEmpty()) {
            entYear = Integer.parseInt(entYearStr);
        }

        // DAO
        StudentDao dao = new StudentDao();

        List<Student> students = dao.filter(schoolCd, entYear, classNum, isAttend);
        List<Integer> entYearSet = dao.filterEntYear(schoolCd);
        List<String> classNumSet = dao.filterClassNum(schoolCd);

        // set JSP data
        request.setAttribute("students", students);
        request.setAttribute("entYearSet", entYearSet);
        request.setAttribute("classNumSet", classNumSet);

        request.setAttribute("entYear", entYear);
        request.setAttribute("classNum", classNum);
        request.setAttribute("isAttend", isAttend);

        // ✅ IMPORTANT: correct JSP path
        return "scoremanager/main/student_list.jsp";
    }
}