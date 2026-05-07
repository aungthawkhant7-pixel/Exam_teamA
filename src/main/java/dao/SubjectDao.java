package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.Subject;

public class SubjectDao extends Dao {

    public List<Subject> filter(String schoolCd) throws Exception {
        List<Subject> list = new ArrayList<>();

        String sql = "SELECT CD, NAME, SCHOOL_CD FROM SUBJECT WHERE SCHOOL_CD = ? ORDER BY CD";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, schoolCd);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Subject subject = new Subject();
                    subject.setCd(rs.getString("CD"));
                    subject.setName(rs.getString("NAME"));
                    subject.setSchoolCd(rs.getString("SCHOOL_CD"));
                    list.add(subject);
                }
            }
        }

        return list;
    }

    public Subject get(String cd, String schoolCd) throws Exception {
        Subject subject = null;

        String sql = "SELECT CD, NAME, SCHOOL_CD FROM SUBJECT WHERE CD = ? AND SCHOOL_CD = ?";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, cd);
            st.setString(2, schoolCd);

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    subject = new Subject();
                    subject.setCd(rs.getString("CD"));
                    subject.setName(rs.getString("NAME"));
                    subject.setSchoolCd(rs.getString("SCHOOL_CD"));
                }
            }
        }

        return subject;
    }

    public boolean insert(Subject subject) throws Exception {
        String sql = "INSERT INTO SUBJECT(CD, NAME, SCHOOL_CD) VALUES (?, ?, ?)";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, subject.getCd());
            st.setString(2, subject.getName());
            st.setString(3, subject.getSchoolCd());

            return st.executeUpdate() > 0;
        }
    }

    public boolean update(Subject subject, String originalCd) throws Exception {
        String sql = "UPDATE SUBJECT SET CD = ?, NAME = ? WHERE CD = ? AND SCHOOL_CD = ?";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, subject.getCd());
            st.setString(2, subject.getName());
            st.setString(3, originalCd);
            st.setString(4, subject.getSchoolCd());

            return st.executeUpdate() > 0;
        }
    }

    public boolean delete(String cd, String schoolCd) throws Exception {
        int count = 0;

        try (Connection con = getConnection()) {
            con.setAutoCommit(false);

            try {
                try (PreparedStatement st = con.prepareStatement(
                        "DELETE FROM TEST_SCORE WHERE SUBJECT_CD = ? AND SCHOOL_CD = ?")) {
                    st.setString(1, cd);
                    st.setString(2, schoolCd);
                    st.executeUpdate();
                }

                try (PreparedStatement st = con.prepareStatement(
                        "DELETE FROM SUBJECT WHERE CD = ? AND SCHOOL_CD = ?")) {
                    st.setString(1, cd);
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