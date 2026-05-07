package scoremanager.main;

import bean.Student;
import dao.StudentDao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tool.Action;

public class StudentUpdateExecuteAction extends Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        request.setCharacterEncoding("UTF-8");

        String no = request.getParameter("no");
        String name = request.getParameter("name");
        String entYearStr = request.getParameter("entYear");
        String classNum = request.getParameter("classNum");
        boolean isAttend = "true".equals(request.getParameter("isAttend"));

        int entYear = Integer.parseInt(entYearStr);

        Student student = new Student();
        student.setNo(no);
        student.setName(name);
        student.setEntYear(entYear);
        student.setClassNum(classNum);
        student.setAttend(isAttend);

        StudentDao dao = new StudentDao();
        dao.update(student);

        return "scoremanager/main/student_update_done.jsp";
    }
}