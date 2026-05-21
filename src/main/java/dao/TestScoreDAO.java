package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TestScoreDAO extends Dao {

    public List<String> getEntYears(String schoolCd) throws Exception {
        List<String> list = new ArrayList<>();

        String sql = "SELECT DISTINCT ENT_YEAR FROM STUDENT "
                   + "WHERE TRIM(SCHOOL_CD)=TRIM(?) "
                   + "ORDER BY ENT_YEAR DESC";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, schoolCd);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getString("ENT_YEAR"));
                }
            }
        }
        return list;
    }

    public List<String> getClassNums(String schoolCd) throws Exception {
        List<String> list = new ArrayList<>();

        String sql = "SELECT DISTINCT CLASS_NUM FROM STUDENT "
                   + "WHERE TRIM(SCHOOL_CD)=TRIM(?) "
                   + "ORDER BY CLASS_NUM";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, schoolCd);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getString("CLASS_NUM"));
                }
            }
        }
        return list;
    }

    public List<Map<String, String>> getSubjects(String schoolCd) throws Exception {
        List<Map<String, String>> list = new ArrayList<>();

        String sql = "SELECT CD, NAME FROM SUBJECT "
                   + "WHERE TRIM(SCHOOL_CD)=TRIM(?) "
                   + "ORDER BY CD";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, schoolCd);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> m = new HashMap<>();
                    m.put("cd", rs.getString("CD"));
                    m.put("name", rs.getString("NAME"));
                    list.add(m);
                }
            }
        }
        return list;
    }

    public String getSubjectName(String schoolCd, String subjectCd) throws Exception {
        String sql = "SELECT NAME FROM SUBJECT "
                   + "WHERE TRIM(SCHOOL_CD)=TRIM(?) "
                   + "AND TRIM(CD)=TRIM(?)";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, schoolCd);
            st.setString(2, subjectCd);

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("NAME");
                }
            }
        }
        return "";
    }

    public String getStudentName(String schoolCd, String studentNo) throws Exception {
        String sql = "SELECT NAME FROM STUDENT "
                   + "WHERE TRIM(SCHOOL_CD)=TRIM(?) "
                   + "AND TRIM(NO)=TRIM(?)";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, schoolCd);
            st.setString(2, studentNo);

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("NAME");
                }
            }
        }
        return null;
    }

    public List<Map<String, String>> getStudentScores(String schoolCd, String studentNo) throws Exception {
        List<Map<String, String>> list = new ArrayList<>();

        String sql =
            "SELECT SU.NAME AS SUBJECT_NAME, TS.SUBJECT_CD, TS.TEST_NO, TS.POINT "
          + "FROM TEST_SCORE TS "
          + "LEFT JOIN SUBJECT SU "
          + "ON TRIM(TS.SUBJECT_CD)=TRIM(SU.CD) "
          + "AND TRIM(TS.SCHOOL_CD)=TRIM(SU.SCHOOL_CD) "
          + "WHERE TRIM(TS.SCHOOL_CD)=TRIM(?) "
          + "AND TRIM(TS.STUDENT_NO)=TRIM(?) "
          + "ORDER BY TS.SUBJECT_CD, TS.TEST_NO";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, schoolCd);
            st.setString(2, studentNo);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> row = new HashMap<>();
                    row.put("subjectName", rs.getString("SUBJECT_NAME"));
                    row.put("subjectCd", rs.getString("SUBJECT_CD"));
                    row.put("testNo", rs.getString("TEST_NO"));
                    row.put("point", rs.getString("POINT"));
                    list.add(row);
                }
            }
        }
        return list;
    }

    public List<Map<String, String>> getSubjectScores(
            String schoolCd, String entYear, String classNum, String subjectCd) throws Exception {

        List<Map<String, String>> list = new ArrayList<>();

        String sql =
            "SELECT "
          + "ST.ENT_YEAR, "
          + "ST.CLASS_NUM, "
          + "ST.NO AS STUDENT_NO, "
          + "ST.NAME AS STUDENT_NAME, "
          + "MAX(CASE WHEN TS.TEST_NO = 1 THEN TS.POINT END) AS POINT1, "
          + "MAX(CASE WHEN TS.TEST_NO = 2 THEN TS.POINT END) AS POINT2 "
          + "FROM TEST_SCORE TS "
          + "INNER JOIN STUDENT ST "
          + "ON TRIM(TS.STUDENT_NO)=TRIM(ST.NO) "
          + "AND TRIM(TS.SCHOOL_CD)=TRIM(ST.SCHOOL_CD) "
          + "WHERE TRIM(TS.SCHOOL_CD)=TRIM(?) "
          + "AND TRIM(ST.ENT_YEAR)=TRIM(?) "
          + "AND TRIM(ST.CLASS_NUM)=TRIM(?) "
          + "AND TRIM(TS.SUBJECT_CD)=TRIM(?) "
          + "GROUP BY ST.ENT_YEAR, ST.CLASS_NUM, ST.NO, ST.NAME "
          + "ORDER BY ST.NO";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, schoolCd);
            st.setString(2, entYear);
            st.setString(3, classNum);
            st.setString(4, subjectCd);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> row = new HashMap<>();
                    row.put("entYear", rs.getString("ENT_YEAR"));
                    row.put("classNum", rs.getString("CLASS_NUM"));
                    row.put("studentNo", rs.getString("STUDENT_NO"));
                    row.put("studentName", rs.getString("STUDENT_NAME"));
                    row.put("point1", rs.getString("POINT1"));
                    row.put("point2", rs.getString("POINT2"));
                    list.add(row);
                }
            }
        }
        return list;
    }
}