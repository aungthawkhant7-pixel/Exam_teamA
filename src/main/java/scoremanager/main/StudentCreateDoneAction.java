package scoremanager.main;

import bean.Student;
import bean.Teacher;
import dao.StudentDao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tool.Action;

public class StudentCreateDoneAction extends Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Teacher teacher = (Teacher) session.getAttribute("user");

        String entYearStr = request.getParameter("entYear");
        String no = request.getParameter("no");
        String name = request.getParameter("name");
        String classNum = request.getParameter("classNum");

        request.setAttribute("entYear", entYearStr);
        request.setAttribute("no", no);
        request.setAttribute("name", name);
        request.setAttribute("classNum", classNum);

        boolean hasError = false;

        if (entYearStr == null || entYearStr.isEmpty()) {
            request.setAttribute("entYearError", "入学年度を選択してください");
            hasError = true;
        }

        if (no == null || no.trim().isEmpty()) {
            request.setAttribute("noError", "学生番号を入力してください");
            hasError = true;
        }

        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("nameError", "氏名を入力してください");
            hasError = true;
        }

        StudentDao dao = new StudentDao();

        if (no != null && !no.trim().isEmpty()) {
            Student oldStudent = dao.get(no);

            if (oldStudent != null) {
                request.setAttribute("noError", "学生番号が重複しています");
                hasError = true;
            }
        }

        if (hasError) {
            return "scoremanager/main/student_create.jsp";
        }

        Student student = new Student();
        student.setNo(no);
        student.setName(name);
        student.setEntYear(Integer.parseInt(entYearStr));
        student.setClassNum(classNum);
        student.setAttend(true);

        if (teacher != null) {
            student.setSchoolCd(teacher.getSchoolCd());
        } else {
            student.setSchoolCd("oom");
        }

        dao.save(student);

        return "scoremanager/main/student_create_done.jsp";
    }
}