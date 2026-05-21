package scoremanager.main;

import bean.Student;
import bean.Teacher;
import dao.StudentDao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tool.Action;

public class StudentCreateDoneAction extends Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        Teacher teacher = (Teacher) request.getSession().getAttribute("user");

        if (teacher == null) {
            return "../login.jsp";
        }

        String entYear = request.getParameter("entYear");
        String no = request.getParameter("no");
        String name = request.getParameter("name");
        String classNum = request.getParameter("classNum");

        request.setAttribute("entYear", entYear);
        request.setAttribute("no", no);
        request.setAttribute("name", name);
        request.setAttribute("classNum", classNum);

        boolean error = false;

        if (entYear == null || entYear.isEmpty()) {
            request.setAttribute("entYearError", "入学年度を選択してください");
            error = true;
        }

        if (no == null || no.isEmpty()) {
            error = true;
        }

        if (name == null || name.isEmpty()) {
            error = true;
        }

        StudentDao dao = new StudentDao();

        if (no != null && !no.isEmpty() && dao.exists(no)) {
            request.setAttribute("noError", "学生番号が重複しています");
            error = true;
        }

        if (error) {
            return "scoremanager/main/student_create.jsp";
        }

        Student student = new Student();
        student.setEntYear(Integer.parseInt(entYear));
        student.setNo(no);
        student.setName(name);
        student.setClassNum(classNum);
        student.setAttend(true);
        student.setSchoolCd(teacher.getSchoolCd());

        dao.save(student);

        return "scoremanager/main/student_create_done.jsp";
    }
}