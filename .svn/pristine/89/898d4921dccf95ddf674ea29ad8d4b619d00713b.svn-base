package login;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import Common.CommonData;

/* 
 * OverlapEmailDAO
 * 1 - Open ( DB 연결 ) 
 * 2 - Close ( DB 연결 종료 )
 * 3 - JsonParser ( 어플에서 온 데이터 String형식으로 변환 )
 * 4 - OverlapEmailCheck ( DB와 통신하여 이메일중복 체크 )
 */

public class OverlapEmailDAO {
	final private String jdbc_class = CommonData.getJdbc_Class();
	final private String jdbc_url = CommonData.getJdbc_Url();
	final private String DB_ID = CommonData.getDB_ID();
	final private String DB_PW = CommonData.getDB_PW();

	Connection conn;
	PreparedStatement pstmt;
	ResultSet rs = null;

	// 1 - Open ( DB 연결 ) 
	public void Open() {
		try {
			Class.forName(jdbc_class);
			conn = DriverManager.getConnection(jdbc_url, DB_ID, DB_PW);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 2 - Close ( DB 연결 종료 )
	public void Close() {
		try {
			pstmt.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	// 3 - JsonParser ( 어플에서 온 데이터 String형식으로 변환 )
	public String JsonParser(String data) {

		String user_email = null;
		try {
			JSONParser jsonParser = new JSONParser();
			JSONObject jsonObject = (JSONObject) jsonParser.parse(data);

			user_email = jsonObject.get("user_email").toString();

		} catch (Exception e) {
		}
		return user_email;
	}

	// 4 - OverlapEmailCheck ( DB와 통신하여 이메일중복 체크 )
	public String OverlapEmailCheck(String user_email) {
		Open();
		String returns = "";
		try {
			String sql = "SELECT user_email FROM TBL_USER WHERE user_email = ?";// 조회
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user_email);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getFetchSize() > 1) {
					System.out.println("DB에 중복된 이메일이 존재합니다. 확인하세요.");
				} else {
					// 이메일이 데이터베이스에 존재할 경우
					returns = "LO_0002";
				}
			} else {
				returns = "SY_2000";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			Close();
		}
		return returns;
	}
}