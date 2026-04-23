package tool;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("*.action")
public class FrontController extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException {

		try {
			String path = req.getServletPath();
			// 例: /LoginExecute.action

			String name = path.substring(1, path.lastIndexOf(".action"));
			// => LoginExecute

			String className = "scoremanager.main." + name + "Action";
			// => scoremanager.main.LoginExecuteAction

			Action action = (Action) Class.forName(className)
					.getDeclaredConstructor()
					.newInstance();

			String url = action.execute(req, res);

			if (url != null) {
				req.getRequestDispatcher("/" + url).forward(req, res);
			}

		} catch (Exception e) {
			throw new ServletException(e);
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException {
		doGet(req, res);
	}
}