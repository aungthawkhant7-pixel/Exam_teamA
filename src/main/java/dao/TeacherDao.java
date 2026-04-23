package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import bean.Teacher;

public class TeacherDao extends Dao {

    public Teacher get(String id) throws Exception {
        Teacher teacher = null;

        String sql = "SELECT * FROM TEACHER WHERE ID = ?";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, id);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                teacher = new Teacher();
                teacher.setId(rs.getString("ID"));
                teacher.setName(rs.getString("NAME"));
                teacher.setSchoolCd(rs.getString("SCHOOL_CD"));
            }
        }

        return teacher;
    }

    public Teacher login(String id, String password) throws Exception {
        Teacher teacher = null;

        String sql = "SELECT * FROM TEACHER WHERE ID = ? AND PASSWORD = ?";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, id);
            st.setString(2, password);

            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                teacher = new Teacher();
                teacher.setId(rs.getString("ID"));
                teacher.setName(rs.getString("NAME"));
                teacher.setSchoolCd(rs.getString("SCHOOL_CD"));
            }
        }

        return teacher;
    }
}