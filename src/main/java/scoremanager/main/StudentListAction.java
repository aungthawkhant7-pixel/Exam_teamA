package scoremanager.main;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import bean.ClassNum;
import bean.Student;
import bean.Teacher;
import dao.ClassNumDao;
import dao.StudentDao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
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

        String formAction = nv(req.getParameter("formAction"));
        String selectedEntYear = nv(req.getParameter("entYear"));
        String selectedClassNum = nv(req.getParameter("classNum"));
        boolean checkedAttend = "true".equals(req.getParameter("isAttend"));

        String flash = "";
        String errorMsg = "";

        String formNo = "";
        String formName = "";
        String formEntYear = "";
        String formClassNum = "";
        boolean formAttend = true;
        String originalNo = nv(req.getParameter("originalNo"));

        StudentDao studentDao = new StudentDao();
        ClassNumDao classNumDao = new ClassNumDao();

        if ("save".equals(formAction)) {
            formNo = nv(req.getParameter("no"));
            formName = nv(req.getParameter("name"));
            formEntYear = nv(req.getParameter("formEntYear"));
            formClassNum = nv(req.getParameter("formClassNum"));
            formAttend = "true".equals(req.getParameter("formAttend"));

            if (formNo.isEmpty() || formName.isEmpty() || formEntYear.isEmpty() || formClassNum.isEmpty()) {
                errorMsg = "学生番号・氏名・入学年度・クラスは必須です。";
            } else {
                Student s = new Student();
                s.setNo(formNo);
                s.setName(formName);
                s.setEntYear(Integer.parseInt(formEntYear));
                s.setClassNum(formClassNum);
                s.setAttend(formAttend);
                s.setSchoolCd(schoolCd);

                try {
                    if (originalNo.isEmpty()) {
                        studentDao.insert(s);
                        flash = "学生を登録しました。";
                        formNo = "";
                        formName = "";
                        formEntYear = "";
                        formClassNum = "";
                        formAttend = true;
                    } else {
                        studentDao.update(s, originalNo);
                        flash = "学生情報を更新しました。";
                        originalNo = "";
                        formNo = "";
                        formName = "";
                        formEntYear = "";
                        formClassNum = "";
                        formAttend = true;
                    }
                } catch (Exception e) {
                    errorMsg = "保存に失敗しました。学生番号が重複している可能性があります。";
                }
            }
        }

        if ("delete".equals(formAction)) {
            String no = nv(req.getParameter("no"));
            if (!no.isEmpty()) {
                studentDao.delete(no, schoolCd);
                flash = "学生を削除しました。";
            }
        }

        String editNo = nv(req.getParameter("editNo"));
        if (!editNo.isEmpty()) {
            Student editStudent = studentDao.get(editNo, schoolCd);
            if (editStudent != null) {
                formNo = editStudent.getNo();
                formName = editStudent.getName();
                formEntYear = String.valueOf(editStudent.getEntYear());
                formClassNum = editStudent.getClassNum();
                formAttend = editStudent.isAttend();
                originalNo = editStudent.getNo();
            }
        }

        List<Integer> entYearSet = new ArrayList<>();
        int currentYear = Calendar.getInstance().get(Calendar.YEAR);
        for (int i = currentYear - 10; i <= currentYear + 1; i++) {
            entYearSet.add(i);
        }

        List<ClassNum> classNums = classNumDao.filter(schoolCd);
        List<Student> students = studentDao.filter(schoolCd, selectedEntYear, selectedClassNum, checkedAttend);

        req.setAttribute("students", students);
        req.setAttribute("classNums", classNums);
        req.setAttribute("entYearSet", entYearSet);

        req.setAttribute("flash", flash);
        req.setAttribute("errorMsg", errorMsg);

        req.setAttribute("formNo", formNo);
        req.setAttribute("formName", formName);
        req.setAttribute("formEntYear", formEntYear);
        req.setAttribute("formClassNum", formClassNum);
        req.setAttribute("formAttend", formAttend);
        req.setAttribute("originalNo", originalNo);

        req.setAttribute("selectedEntYear", selectedEntYear);
        req.setAttribute("selectedClassNum", selectedClassNum);
        req.setAttribute("checkedAttend", checkedAttend);

        return "scoremanager/main/student_list.jsp";
    }

    private String nv(String value) {
        return value == null ? "" : value.trim();
    }
}