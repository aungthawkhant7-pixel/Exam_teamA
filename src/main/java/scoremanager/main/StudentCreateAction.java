package scoremanager.main;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tool.Action;

public class StudentCreateAction extends Action {

    @Override
    public String execute(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        return "scoremanager/main/student_create.jsp";
    }
}