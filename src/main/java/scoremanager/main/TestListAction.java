package scoremanager.main;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import bean.Teacher;
import dao.TestScoreDAO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tool.Action;

/**
* 成績参照アクション
*
* searchType = "subject" : 科目情報検索（入学年度・クラス・科目コードで絞り込み）
* searchType = "student" : 学生情報検索（学生番号で絞り込み）
* searchType が空        : 初期表示（検索なし）
*/
public class TestListAction extends Action {

   private static final String SEARCH_TYPE_SUBJECT = "subject";
   private static final String SEARCH_TYPE_STUDENT = "student";

   @Override
   public String execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

       // ── セッションチェック ───────────────────────────────
       Teacher user = (Teacher) req.getSession().getAttribute("user");
       if (user == null) {
           return "/login.jsp";
       }
       String schoolCd = user.getSchoolCd();

       // ── リクエストパラメータ取得 ─────────────────────────
       String entYear    = nv(req.getParameter("entYear"));
       String classNum   = nv(req.getParameter("classNum"));
       String subjectCd  = nv(req.getParameter("subjectCd"));
       String studentNo  = nv(req.getParameter("studentNo"));
       String searchType = nv(req.getParameter("searchType"));

       // ── DAO・共通マスタ取得 ──────────────────────────────
       TestScoreDAO dao = new TestScoreDAO();

       List<String>              entYearSet  = dao.getEntYears(schoolCd);
       List<String>              classNumSet = dao.getClassNums(schoolCd);
       List<Map<String, String>> subjectSet  = dao.getSubjects(schoolCd);

       // ── 検索結果 ─────────────────────────────────────────
       String errorMsg    = "";
       String studentName = "";
       List<Map<String, String>> studentRows = new ArrayList<>();
       List<Map<String, String>> subjectRows = new ArrayList<>();

       switch (searchType) {

           case SEARCH_TYPE_STUDENT:
               if (studentNo.isEmpty()) {
                   errorMsg = "学生番号を入力してください";
               } else {
                   studentName = dao.getStudentName(schoolCd, studentNo);
                   if (studentName == null) {
                       errorMsg = "学生情報が存在しませんでした";
                       studentName = "";
                   } else {
                       studentRows = dao.getStudentScores(schoolCd, studentNo);
                       if (studentRows.isEmpty()) {
                           errorMsg = "成績情報が存在しませんでした";
                       }
                   }
               }
               break;

           case SEARCH_TYPE_SUBJECT:
               if (entYear.isEmpty() || classNum.isEmpty() || subjectCd.isEmpty()) {
                   errorMsg = "入学年度・クラス・科目をすべて選択してください";
               } else {
                   subjectRows = dao.getSubjectScores(schoolCd, entYear, classNum, subjectCd);
                   if (subjectRows.isEmpty()) {
                       errorMsg = "成績情報が存在しませんでした";
                   }
               }
               break;

           default:
               // 初期表示 — 検索なし、エラーなし
               break;
       }

       // ── リクエストスコープにセット ───────────────────────
       // マスタ
       req.setAttribute("entYearSet",  entYearSet);
       req.setAttribute("classNumSet", classNumSet);
       req.setAttribute("subjectSet",  subjectSet);

       // 入力値（再表示用）
       req.setAttribute("entYear",    entYear);
       req.setAttribute("classNum",   classNum);
       req.setAttribute("subjectCd",  subjectCd);
       req.setAttribute("studentNo",  studentNo);
       req.setAttribute("searchType", searchType);

       // 検索結果・メッセージ
       req.setAttribute("errorMsg",    errorMsg);
       req.setAttribute("studentName", studentName);
       req.setAttribute("studentRows", studentRows);
       req.setAttribute("subjectRows", subjectRows);

       return "/scoremanager/main/test_list.jsp";
   }

   /** null を空文字に変換してトリム */
   private static String nv(String value) {
       return value == null ? "" : value.trim();
   }
}