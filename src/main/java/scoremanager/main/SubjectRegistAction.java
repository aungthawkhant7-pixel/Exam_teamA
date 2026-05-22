package scoremanager.main;

import bean.Subject;
import bean.Teacher;
import dao.SubjectDao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tool.Action;

public class SubjectRegistAction extends Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        Teacher user = (Teacher) request.getSession().getAttribute("user");

        if (user == null) {
            return "Login.action";
        }

        String schoolCd = user.getSchoolCd();
        SubjectDao dao = new SubjectDao();

        String formAction = request.getParameter("formAction");

        if ("save".equals(formAction)) {

            String cd = request.getParameter("cd");
            String name = request.getParameter("name");
            String originalCd = request.getParameter("originalCd");

            if (cd == null) cd = "";
            if (name == null) name = "";
            if (originalCd == null) originalCd = "";

            cd = cd.trim();
            name = name.trim();
            originalCd = originalCd.trim();

            Subject subject = new Subject();
            subject.setCd(cd);
            subject.setName(name);
            subject.setSchoolCd(schoolCd);

            try {
                if (originalCd.isEmpty()) {

                    Subject exists = dao.get(cd, schoolCd);
                    if (exists != null) {
                        request.setAttribute("errorMsg", "科目コードが重複している可能性があります。");
                        request.setAttribute("subject", subject);
                        request.setAttribute("originalCd", originalCd);
                        return "scoremanager/main/subject_regist.jsp";
                    }

                    dao.insert(subject);

                } else {
                    dao.update(subject, originalCd);
                }

                response.sendRedirect(request.getContextPath() + "/SubjectList.action");
                return null;

            } catch (Exception e) {
                e.printStackTrace();

                request.setAttribute("errorMsg", "登録に失敗しました。原因：" + e.getMessage());
                request.setAttribute("subject", subject);
                request.setAttribute("originalCd", originalCd);

                return "scoremanager/main/subject_regist.jsp";
            }
        }

        String editCd = request.getParameter("editCd");

        if (editCd != null && !editCd.isEmpty()) {
            Subject subject = dao.get(editCd, schoolCd);
            request.setAttribute("subject", subject);
            request.setAttribute("originalCd", editCd);
        }

        return "scoremanager/main/subject_regist.jsp";
    }
}