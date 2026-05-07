package scoremanager.main;

import bean.Student;
import bean.Teacher;
import dao.StudentDao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tool.Action;

public class StudentUpdateAction extends Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        Teacher teacher = (Teacher) request.getSession().getAttribute("user");

        if (teacher == null) {
            return "../login.jsp";
        }

        String no = request.getParameter("no");

        StudentDao dao = new StudentDao();

        Student student = dao.get(no);

        request.setAttribute("student", student);

        return "scoremanager/main/student_update.jsp";
    }
}