package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import bean.School;

public class SchoolDao extends Dao {

    public School get(String cd) throws Exception {
        School school = null;

        String sql = "SELECT * FROM SCHOOL WHERE CD = ?";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, cd);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                school = new School();
                school.setCd(rs.getString("CD"));
                school.setName(rs.getString("NAME"));
            }
        }

        return school;
    }
}