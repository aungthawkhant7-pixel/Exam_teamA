package scoremanager.main;

import bean.Teacher;
import dao.TeacherDao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tool.Action;

public class LoginAction extends Action {

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String id = request.getParameter("id");
        String password = request.getParameter("password");

        TeacherDao teacherDao = new TeacherDao();
        Teacher teacher = teacherDao.login(id, password);

        if (teacher != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", teacher);
            return "/menu.jsp";
        } else {
            request.setAttribute("error", "ログインに失敗しました。");
            return "/login.jsp";
        }
    }
}