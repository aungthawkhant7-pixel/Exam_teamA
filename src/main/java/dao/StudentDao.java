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

    public Student get(String no, String schoolCd) throws Exception {
        String sql = "SELECT * FROM STUDENT WHERE NO=? AND SCHOOL_CD=?";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, no);
            st.setString(2, schoolCd);

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return postFilter(rs);
                }
            }
        }
        return null;
    }

    public List<Student> filter(String schoolCd, String entYear, String classNum, boolean isAttendOnly) throws Exception {
        List<Student> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM STUDENT WHERE SCHOOL_CD=?");
        List<Object> params = new ArrayList<>();
        params.add(schoolCd);

        if (entYear != null && !entYear.isEmpty()) {
            sql.append(" AND ENT_YEAR=?");
            params.add(Integer.parseInt(entYear));
        }

        if (classNum != null && !classNum.isEmpty()) {
            sql.append(" AND CLASS_NUM=?");
            params.add(classNum);
        }

        if (isAttendOnly) {
            sql.append(" AND IS_ATTEND=?");
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

    public boolean insert(Student student) throws Exception {
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
    }

    public boolean update(Student student, String originalNo) throws Exception {
        String sql = "UPDATE STUDENT SET NO=?, NAME=?, ENT_YEAR=?, CLASS_NUM=?, IS_ATTEND=? WHERE NO=? AND SCHOOL_CD=?";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, student.getNo());
            st.setString(2, student.getName());
            st.setInt(3, student.getEntYear());
            st.setString(4, student.getClassNum());
            st.setBoolean(5, student.isAttend());
            st.setString(6, originalNo);
            st.setString(7, student.getSchoolCd());

            return st.executeUpdate() > 0;
        }
    }

    public boolean delete(String no, String schoolCd) throws Exception {
        try (Connection con = getConnection()) {
            try (PreparedStatement st1 = con.prepareStatement(
                    "DELETE FROM TEST_SCORE WHERE STUDENT_NO=? AND SCHOOL_CD=?")) {
                st1.setString(1, no);
                st1.setString(2, schoolCd);
                st1.executeUpdate();
            }

            try (PreparedStatement st2 = con.prepareStatement(
                    "DELETE FROM STUDENT WHERE NO=? AND SCHOOL_CD=?")) {
                st2.setString(1, no);
                st2.setString(2, schoolCd);
                return st2.executeUpdate() > 0;
            }
        }
    }
}