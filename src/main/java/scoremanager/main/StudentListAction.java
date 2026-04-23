package scoremanager.main;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import bean.ClassNum;
import bean.Student;
import bean.Teacher;
import dao.ClassNumDao;
import dao.StudentDao;
import tool.Action;

public class StudentListAction extends Action {

    @Override
    public String execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
        HttpSession session = req.getSession();
        Teacher teacher = (Teacher) session.getAttribute("user");

        if (teacher == null) {
            return "scoremanager/main/login.jsp";
        }

        String schoolCd = teacher.getSchoolCd();
        String entYearStr = req.getParameter("entYear");
        String classNum = req.getParameter("classNum");
        String isAttendStr = req.getParameter("isAttend");

        List<Integer> entYearSet = new ArrayList<>();
        int currentYear = Calendar.getInstance().get(Calendar.YEAR);
        for (int i = currentYear - 10; i <= currentYear + 1; i++) {
            entYearSet.add(i);
        }

        ClassNumDao classNumDao = new ClassNumDao();
        List<ClassNum> classNumSet = classNumDao.filter(schoolCd);

        StudentDao studentDao = new StudentDao();
        List<Student> students;

        if (entYearStr == null || entYearStr.isEmpty()) {
            students = studentDao.filter(schoolCd);
        } else {
            int entYear = Integer.parseInt(entYearStr);
            boolean isAttend = "true".equals(isAttendStr);

            if (classNum != null && !classNum.isEmpty()) {
                students = studentDao.filter(schoolCd, entYear, classNum, isAttend);
            } else {
                students = studentDao.filter(schoolCd, entYear, isAttend);
            }
        }

        req.setAttribute("students", students);
        req.setAttribute("entYearSet", entYearSet);
        req.setAttribute("classNumSet", classNumSet);
        req.setAttribute("selectedEntYear", entYearStr);
        req.setAttribute("selectedClassNum", classNum);
        req.setAttribute("checkedAttend", "true".equals(isAttendStr));

        return "scoremanager/main/student_list.jsp";
    }
}
