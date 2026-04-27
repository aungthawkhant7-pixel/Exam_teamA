package dao;

import java.sql.*;
import java.util.*;
import bean.Student;

public class StudentDao extends Dao {

    private Student postFilter(ResultSet rs) throws Exception {
        Student s = new Student();
        s.setNo(rs.getString("NO"));
        s.setName(rs.getString("NAME"));
        s.setEntYear(rs.getInt("ENT_YEAR"));
        s.setClassNum(rs.getString("CLASS_NUM"));
        s.setAttend(rs.getBoolean("IS_ATTEND"));
        s.setSchoolCd(rs.getString("SCHOOL_CD"));
        return s;
    }

    public List<Student> filter(String entYear, String classNum, String schoolCd, boolean isAttend) throws Exception {
        List<Student> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM STUDENT WHERE SCHOOL_CD = ?");
        params.add(schoolCd);

        if (entYear != null && !entYear.isEmpty()) {
            sql.append(" AND ENT_YEAR = ?");
            params.add(Integer.parseInt(entYear));
        }

        if (classNum != null && !classNum.isEmpty()) {
            sql.append(" AND CLASS_NUM = ?");
            params.add(classNum);
        }

        if (isAttend) {
            sql.append(" AND IS_ATTEND = ?");
            params.add(true);
        }

        sql.append(" ORDER BY ENT_YEAR DESC, NO");

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(postFilter(rs));
                }
            }
        }

        return list;
    }

    public Student get(String no, String schoolCd) throws Exception {
        Student s = null;

        String sql = "SELECT * FROM STUDENT WHERE NO = ? AND SCHOOL_CD = ?";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, no);
            st.setString(2, schoolCd);

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    s = postFilter(rs);
                }
            }
        }

        return s;
    }

    public boolean insert(Student s) throws Exception {
        String sql = "INSERT INTO STUDENT(NO, NAME, ENT_YEAR, CLASS_NUM, IS_ATTEND, SCHOOL_CD) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, s.getNo());
            st.setString(2, s.getName());
            st.setInt(3, s.getEntYear());
            st.setString(4, s.getClassNum());
            st.setBoolean(5, s.isAttend());
            st.setString(6, s.getSchoolCd());

            return st.executeUpdate() > 0;
        }
    }

    public boolean update(Student s, String originalNo) throws Exception {
        String sql = "UPDATE STUDENT SET NO = ?, NAME = ?, ENT_YEAR = ?, CLASS_NUM = ?, IS_ATTEND = ? WHERE NO = ? AND SCHOOL_CD = ?";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, s.getNo());
            st.setString(2, s.getName());
            st.setInt(3, s.getEntYear());
            st.setString(4, s.getClassNum());
            st.setBoolean(5, s.isAttend());
            st.setString(6, originalNo);
            st.setString(7, s.getSchoolCd());

            return st.executeUpdate() > 0;
        }
    }

    public boolean delete(String no, String schoolCd) throws Exception {
        int count = 0;

        try (Connection con = getConnection()) {
            con.setAutoCommit(false);

            try {
                try (PreparedStatement st = con.prepareStatement(
                        "DELETE FROM TEST_SCORE WHERE STUDENT_NO = ? AND SCHOOL_CD = ?")) {
                    st.setString(1, no);
                    st.setString(2, schoolCd);
                    st.executeUpdate();
                }

                try (PreparedStatement st = con.prepareStatement(
                        "DELETE FROM STUDENT WHERE NO = ? AND SCHOOL_CD = ?")) {
                    st.setString(1, no);
                    st.setString(2, schoolCd);
                    count = st.executeUpdate();
                }

                con.commit();

            } catch (Exception e) {
                con.rollback();
                throw e;
            }
        }

        return count > 0;
    }
}