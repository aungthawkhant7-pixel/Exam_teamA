package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.ClassNum;

public class ClassNumDao extends Dao {

    public ClassNum get(String classNum, String schoolCd) throws Exception {
        ClassNum cn = null;

        String sql = "SELECT * FROM CLASS_NUM WHERE CLASS_NUM = ? AND SCHOOL_CD = ?";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, classNum);
            st.setString(2, schoolCd);

            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                cn = new ClassNum();
                cn.setClassNum(rs.getString("CLASS_NUM"));
                cn.setSchoolCd(rs.getString("SCHOOL_CD"));
            }
        }

        return cn;
    }

    public List<ClassNum> filter(String schoolCd) throws Exception {
        List<ClassNum> list = new ArrayList<>();

        String sql = "SELECT * FROM CLASS_NUM WHERE SCHOOL_CD = ? ORDER BY CLASS_NUM";

        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, schoolCd);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                ClassNum cn = new ClassNum();
                cn.setClassNum(rs.getString("CLASS_NUM"));
                cn.setSchoolCd(rs.getString("SCHOOL_CD"));
                list.add(cn);
            }
        }

        return list;
    }
}