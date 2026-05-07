package scoremanager.main;

import java.util.List;

import bean.Subject;
import bean.Teacher;
import dao.SubjectDao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tool.Action;

public class SubjectListAction extends Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        Teacher user = (Teacher) request.getSession().getAttribute("user");

        if (user == null) {
            return "Login.action";
        }

        String schoolCd = user.getSchoolCd();

        String formAction = request.getParameter("formAction");
        String originalCd = request.getParameter("originalCd");
        String editCd = request.getParameter("editCd");

        if (originalCd == null) {
            originalCd = "";
        }

        SubjectDao dao = new SubjectDao();

        String flash = null;
        String errorMsg = null;

        Subject formSubject = new Subject();
        formSubject.setCd("");
        formSubject.setName("");
        formSubject.setSchoolCd(schoolCd);

        if ("save".equals(formAction)) {
            String cd = request.getParameter("cd");
            String name = request.getParameter("name");

            if (cd == null) cd = "";
            if (name == null) name = "";

            cd = cd.trim();
            name = name.trim();

            formSubject.setCd(cd);
            formSubject.setName(name);

            if (cd.isEmpty() || name.isEmpty()) {
                errorMsg = "科目コードと科目名は必須です。";
            } else {
                try {
                    if (originalCd.isEmpty()) {
                        dao.insert(formSubject);
                        flash = "科目を登録しました。";
                        formSubject.setCd("");
                        formSubject.setName("");
                    } else {
                        dao.update(formSubject, originalCd);
                        flash = "科目を更新しました。";
                        originalCd = "";
                        formSubject.setCd("");
                        formSubject.setName("");
                    }
                } catch (Exception e) {
                    errorMsg = originalCd.isEmpty()
                            ? "登録に失敗しました。科目コードが重複している可能性があります。"
                            : "更新に失敗しました。科目コードが重複している可能性があります。";
                }
            }
        }

        if ("delete".equals(formAction)) {
            String cd = request.getParameter("cd");

            if (cd != null && !cd.isEmpty()) {
                dao.delete(cd, schoolCd);
                flash = "科目を削除しました。";
            }
        }

        if (editCd != null && !editCd.isEmpty()) {
            Subject subject = dao.get(editCd, schoolCd);

            if (subject != null) {
                formSubject = subject;
                originalCd = subject.getCd();
            }
        }

        List<Subject> subjects = dao.filter(schoolCd);

        request.setAttribute("subjects", subjects);
        request.setAttribute("subject", formSubject);
        request.setAttribute("originalCd", originalCd);
        request.setAttribute("flash", flash);
        request.setAttribute("errorMsg", errorMsg);

        return "scoremanager/main/subject_list.jsp";
    }
}