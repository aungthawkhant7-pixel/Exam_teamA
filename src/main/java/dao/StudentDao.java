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

    public List<Student> filter(String schoolCd) throws Exception {
        List<Student> list = new ArrayList<>();

        String sql = "SELECT * FROM STUDENT WHERE SCHOOL_CD = ? ORDER BY NO";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, schoolCd);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                list.add(postFilter(rs));
            }
        }

        return list;
    }

    public List<Student> filter(String schoolCd, int entYear, boolean isAttend) throws Exception {
        List<Student> list = new ArrayList<>();

        String sql = "SELECT * FROM STUDENT WHERE SCHOOL_CD = ? AND ENT_YEAR = ? AND IS_ATTEND = ? ORDER BY NO";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, schoolCd);
            st.setInt(2, entYear);
            st.setBoolean(3, isAttend);

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(postFilter(rs));
            }
        }

        return list;
    }

    public List<Student> filter(String schoolCd, int entYear, String classNum, boolean isAttend) throws Exception {
        List<Student> list = new ArrayList<>();

        String sql = "SELECT * FROM STUDENT WHERE SCHOOL_CD = ? AND ENT_YEAR = ? AND CLASS_NUM = ? AND IS_ATTEND = ? ORDER BY NO";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, schoolCd);
            st.setInt(2, entYear);
            st.setString(3, classNum);
            st.setBoolean(4, isAttend);

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(postFilter(rs));
            }
        }

        return list;
    }

    public Student get(String no) throws Exception {
        Student student = null;

        String sql = "SELECT * FROM STUDENT WHERE NO = ?";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, no);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                student = postFilter(rs);
            }
        }

        return student;
    }

    public boolean save(Student student) throws Exception {
        Student old = get(student.getNo());

        if (old == null) {
            String sql = "INSERT INTO STUDENT(NO, NAME, ENT_YEAR, CLASS_NUM, IS_ATTEND, SCHOOL_CD) VALUES(?, ?, ?, ?, ?, ?)";

            try (Connection con = getConnection();
                 PreparedStatement st = con.prepareStatement(sql)) {

                st.setString(1, student.getNo());
                st.setString(2, student.getName());
                st.setInt(3, student.getEntYear());
                st.setString(4, student.getClassNum());
                st.setBoolean(5, student.isAttend());
                st.setString(6, student.getSchoolCd());

                return st.executeUpdate() > 0;
            }
        } else {
            String sql = "UPDATE STUDENT SET NAME=?, ENT_YEAR=?, CLASS_NUM=?, IS_ATTEND=?, SCHOOL_CD=? WHERE NO=?";

            try (Connection con = getConnection();
                 PreparedStatement st = con.prepareStatement(sql)) {

                st.setString(1, student.getName());
                st.setInt(2, student.getEntYear());
                st.setString(3, student.getClassNum());
                st.setBoolean(4, student.isAttend());
                st.setString(5, student.getSchoolCd());
                st.setString(6, student.getNo());

                return st.executeUpdate() > 0;
            }
        }
    }
}