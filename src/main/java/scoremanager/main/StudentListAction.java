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
import tool.Action;

public class StudentListAction extends Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        Teacher user = (Teacher) request.getSession().getAttribute("user");

        if (user == null) {
            return "Login.action";
        }

        String schoolCd = user.getSchoolCd();

        String formAction = request.getParameter("formAction");
        String originalNo = request.getParameter("originalNo");
        String editNo = request.getParameter("editNo");

        if (originalNo == null) originalNo = "";

        String selectedEntYear = request.getParameter("entYear");
        String selectedClassNum = request.getParameter("classNum");
        String isAttendStr = request.getParameter("isAttend");

        if (selectedEntYear == null) selectedEntYear = "";
        if (selectedClassNum == null) selectedClassNum = "";

        boolean checkedAttend = "true".equals(isAttendStr);

        String flash = null;
        String errorMsg = null;

        StudentDao studentDao = new StudentDao();
        ClassNumDao classNumDao = new ClassNumDao();

        Student formStudent = new Student();
        formStudent.setNo("");
        formStudent.setName("");
        formStudent.setEntYear(0);
        formStudent.setClassNum("");
        formStudent.setAttend(true);
        formStudent.setSchoolCd(schoolCd);

        if ("save".equals(formAction)) {
            String no = request.getParameter("no");
            String name = request.getParameter("name");
            String formEntYear = request.getParameter("formEntYear");
            String formClassNum = request.getParameter("formClassNum");
            String formAttendStr = request.getParameter("formAttend");

            if (no == null) no = "";
            if (name == null) name = "";
            if (formEntYear == null) formEntYear = "";
            if (formClassNum == null) formClassNum = "";

            no = no.trim();
            name = name.trim();
            formEntYear = formEntYear.trim();
            formClassNum = formClassNum.trim();

            formStudent.setNo(no);
            formStudent.setName(name);
            formStudent.setClassNum(formClassNum);
            formStudent.setAttend("true".equals(formAttendStr));
            formStudent.setSchoolCd(schoolCd);

            if (no.isEmpty() || name.isEmpty() || formEntYear.isEmpty() || formClassNum.isEmpty()) {
                errorMsg = "学生番号・氏名・入学年度・クラスは必須です。";
            } else {
                formStudent.setEntYear(Integer.parseInt(formEntYear));

                try {
                    if (originalNo.isEmpty()) {
                        studentDao.insert(formStudent);
                        flash = "学生を登録しました。";
                    } else {
                        studentDao.update(formStudent, originalNo);
                        flash = "学生情報を更新しました。";
                    }

                    originalNo = "";
                    formStudent = new Student();
                    formStudent.setNo("");
                    formStudent.setName("");
                    formStudent.setEntYear(0);
                    formStudent.setClassNum("");
                    formStudent.setAttend(true);
                    formStudent.setSchoolCd(schoolCd);

                } catch (Exception e) {
                    errorMsg = originalNo.isEmpty()
                            ? "登録に失敗しました。学生番号が重複している可能性があります。"
                            : "更新に失敗しました。学生番号が重複している可能性があります。";
                }
            }
        }

        if ("delete".equals(formAction)) {
            String no = request.getParameter("no");

            if (no != null && !no.isEmpty()) {
                studentDao.delete(no, schoolCd);
                flash = "学生を削除しました。";
            }
        }

        if (editNo != null && !editNo.isEmpty()) {
            Student editStudent = studentDao.get(editNo, schoolCd);

            if (editStudent != null) {
                formStudent = editStudent;
                originalNo = editStudent.getNo();
            }
        }

        List<Integer> entYearSet = new ArrayList<>();
        int currentYear = Calendar.getInstance().get(Calendar.YEAR);

        for (int i = currentYear - 10; i <= currentYear + 1; i++) {
            entYearSet.add(i);
        }

        List<ClassNum> classNums = classNumDao.filter(schoolCd);
        List<Student> students = studentDao.filter(selectedEntYear, selectedClassNum, schoolCd, checkedAttend);

        request.setAttribute("students", students);
        request.setAttribute("classNums", classNums);
        request.setAttribute("entYearSet", entYearSet);

        request.setAttribute("flash", flash);
        request.setAttribute("errorMsg", errorMsg);

        request.setAttribute("formNo", formStudent.getNo());
        request.setAttribute("formName", formStudent.getName());
        request.setAttribute("formEntYear", formStudent.getEntYear() == 0 ? "" : String.valueOf(formStudent.getEntYear()));
        request.setAttribute("formClassNum", formStudent.getClassNum());
        request.setAttribute("formAttend", formStudent.isAttend());

        request.setAttribute("originalNo", originalNo);
        request.setAttribute("selectedEntYear", selectedEntYear);
        request.setAttribute("selectedClassNum", selectedClassNum);
        request.setAttribute("checkedAttend", checkedAttend);

        return "scoremanager/main/student_list.jsp";
    }
}