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

            // URL取得
            // 例: /scoremanager/main/TestList.action
            String path = req.getServletPath();

            // Action名取得
            // => TestList
            String name = path.substring(
                    path.lastIndexOf("/") + 1,
                    path.lastIndexOf(".action"));

            // クラス名作成
            // => scoremanager.main.TestListAction
            String className = "scoremanager.main." + name + "Action";

            // Action生成
            Action action = (Action) Class.forName(className)
                    .getDeclaredConstructor()
                    .newInstance();

            // execute実行
            String url = action.execute(req, res);

            // JSPへ遷移
            if (url != null) {
                req.getRequestDispatcher(url).forward(req, res);
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