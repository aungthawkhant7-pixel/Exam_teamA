package scoremanager.main;

import java.util.List;

import bean.ClassNum;
import bean.Teacher;
import dao.ClassNumDao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tool.Action;

public class ClassListAction extends Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        Teacher user = (Teacher) request.getSession().getAttribute("user");

        if (user == null) {
            return "Login.action";
        }

        String schoolCd = user.getSchoolCd();

        ClassNumDao dao = new ClassNumDao();

        String formAction = request.getParameter("formAction");
        String flash = null;
        String errorMsg = null;
        String formClassNum = "";

        if ("save".equals(formAction)) {
            formClassNum = request.getParameter("classNum");

            if (formClassNum == null) {
                formClassNum = "";
            }

            formClassNum = formClassNum.trim();

            if (formClassNum.isEmpty()) {
                errorMsg = "クラスコードは必須です。";
            } else {
                try {
                    dao.insert(formClassNum, schoolCd);
                    flash = "クラスを登録しました。";
                    formClassNum = "";
                } catch (Exception e) {
                    errorMsg = "登録に失敗しました。クラスコードが重複している可能性があります。";
                }
            }
        }

        if ("delete".equals(formAction)) {
            String classNum = request.getParameter("classNum");

            if (classNum != null && !classNum.isEmpty()) {
                int count = dao.countStudents(classNum, schoolCd);

                if (count > 0) {
                    errorMsg = "このクラスには学生がいるため削除できません。";
                } else {
                    dao.delete(classNum, schoolCd);
                    flash = "クラスを削除しました。";
                }
            }
        }

        List<ClassNum> classes = dao.filter(schoolCd);

        request.setAttribute("classes", classes);
        request.setAttribute("flash", flash);
        request.setAttribute("errorMsg", errorMsg);
        request.setAttribute("formClassNum", formClassNum);

        return "scoremanager/main/class_list.jsp";
    }
}