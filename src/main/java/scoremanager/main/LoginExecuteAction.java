package scoremanager.main;

import java.util.ArrayList;
import java.util.List;

import bean.Teacher;
import dao.TeacherDao;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tool.Action;

public class LoginExecuteAction extends Action {

	@Override
	public String execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

		String id = req.getParameter("id");
		String password = req.getParameter("password");

		TeacherDao teacherDao = new TeacherDao();
		Teacher teacher = teacherDao.login(id, password);

		if (teacher != null) {
			HttpSession session = req.getSession(true);
			teacher.setAuthenticated(true);
			session.setAttribute("user", teacher);

			return "scoremanager/main/menu.jsp";

		} else {
			List<String> errors = new ArrayList<>();
			errors.add("IDまたはパスワードが確認できませんでした");

			req.setAttribute("errors", errors);
			req.setAttribute("id", id);

			return "scoremanager/main/login.jsp";
		}
	}
}