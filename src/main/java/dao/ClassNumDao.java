package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.ClassNum;

public class ClassNumDao extends Dao {

    public List<ClassNum> filter(String schoolCd) throws Exception {
        List<ClassNum> list = new ArrayList<>();

        String sql =
            "SELECT c.CLASS_NUM, c.SCHOOL_CD, " +
            "(SELECT COUNT(*) FROM STUDENT s " +
            "WHERE s.CLASS_NUM = c.CLASS_NUM AND s.SCHOOL_CD = c.SCHOOL_CD) AS STUDENT_COUNT " +
            "FROM CLASS_NUM c " +
            "WHERE c.SCHOOL_CD = ? " +
            "ORDER BY c.CLASS_NUM";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, schoolCd);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    ClassNum c = new ClassNum();
                    c.setClassNum(rs.getString("CLASS_NUM"));
                    c.setSchoolCd(rs.getString("SCHOOL_CD"));
                    c.setStudentCount(rs.getInt("STUDENT_COUNT"));
                    list.add(c);
                }
            }
        }

        return list;
    }

    public boolean insert(String classNum, String schoolCd) throws Exception {
        String sql = "INSERT INTO CLASS_NUM(CLASS_NUM, SCHOOL_CD) VALUES (?, ?)";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, classNum);
            st.setString(2, schoolCd);

            return st.executeUpdate() > 0;
        }
    }

    public int countStudents(String classNum, String schoolCd) throws Exception {
        String sql = "SELECT COUNT(*) FROM STUDENT WHERE CLASS_NUM = ? AND SCHOOL_CD = ?";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, classNum);
            st.setString(2, schoolCd);

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        return 0;
    }

    public boolean delete(String classNum, String schoolCd) throws Exception {
        String sql = "DELETE FROM CLASS_NUM WHERE CLASS_NUM = ? AND SCHOOL_CD = ?";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, classNum);
            st.setString(2, schoolCd);

            return st.executeUpdate() > 0;
        }
    }
}