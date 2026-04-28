package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

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

    public Student get(String no) throws Exception {
        Student student = null;

        String sql = "SELECT * FROM STUDENT WHERE NO = ?";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, no);

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    student = postFilter(rs);
                }
            }
        }

        return student;
    }

    public List<Student> filter(String schoolCd, Integer entYear, String classNum, boolean isAttend) throws Exception {
        List<Student> list = new ArrayList<>();

        String sql = "SELECT * FROM STUDENT WHERE SCHOOL_CD = ?";

        if (entYear != null) {
            sql += " AND ENT_YEAR = ?";
        }

        if (classNum != null && !classNum.isEmpty()) {
            sql += " AND CLASS_NUM = ?";
        }

        if (isAttend) {
            sql += " AND IS_ATTEND = TRUE";
        }

        sql += " ORDER BY ENT_YEAR DESC, NO";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            int index = 1;
            st.setString(index++, schoolCd);

            if (entYear != null) {
                st.setInt(index++, entYear);
            }

            if (classNum != null && !classNum.isEmpty()) {
                st.setString(index++, classNum);
            }

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(postFilter(rs));
                }
            }
        }

        return list;
    }

    public List<Integer> filterEntYear(String schoolCd) throws Exception {
        List<Integer> list = new ArrayList<>();

        String sql = "SELECT DISTINCT ENT_YEAR FROM STUDENT WHERE SCHOOL_CD = ? ORDER BY ENT_YEAR DESC";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, schoolCd);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getInt("ENT_YEAR"));
                }
            }
        }

        return list;
    }

    public List<String> filterClassNum(String schoolCd) throws Exception {
        List<String> list = new ArrayList<>();

        String sql = "SELECT DISTINCT CLASS_NUM FROM STUDENT WHERE SCHOOL_CD = ? ORDER BY CLASS_NUM";

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

    public boolean update(Student student) throws Exception {
        String sql = "UPDATE STUDENT SET NAME = ?, ENT_YEAR = ?, CLASS_NUM = ?, IS_ATTEND = ? WHERE NO = ?";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, student.getName());
            st.setInt(2, student.getEntYear());
            st.setString(3, student.getClassNum());
            st.setBoolean(4, student.isAttend());
            st.setString(5, student.getNo());

            int count = st.executeUpdate();

            return count > 0;
        }
    }

    public boolean save(Student student) throws Exception {
        String sql = "INSERT INTO STUDENT(NO, NAME, ENT_YEAR, CLASS_NUM, IS_ATTEND, SCHOOL_CD) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, student.getNo());
            st.setString(2, student.getName());
            st.setInt(3, student.getEntYear());
            st.setString(4, student.getClassNum());
            st.setBoolean(5, student.isAttend());
            st.setString(6, student.getSchoolCd());

            int count = st.executeUpdate();

            return count > 0;
        }
    }
}