package FCM;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import Common.CommonData;

/* 
 * InputFCMToken DAO ( DB에서 일기 데이터 , 검색 데이터를 조회하는 클래스 )
 * 1 - Open ( DB 연결 ) 
 * 2 - Close ( DB 연결 종료 )
 * 3 - JsonParser ( 어플에서 온 데이터 TokenDTO형식으로 변환 )
 * 4 - UpdateFCMToken ( Token Data(App)를 DB에 저장한다. )
 * 5 - SelectFCMToken ( UserNO(App)로 DB에서 Token Data를 조회한다. )
 */

public class InputFCMTokenDAO {
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

	// 3 - JsonParser ( 어플에서 온 데이터 TokenDTO형식으로 변환 )
	public TokenDTO JsonParser(String data) {
		TokenDTO token = new TokenDTO();
		try {
			JSONParser jsonParser = new JSONParser();
			JSONObject jsonObject = (JSONObject) jsonParser.parse(data);

			token.setUserNO(Integer.parseInt(jsonObject.get("user_NO").toString()));
			token.setToken(jsonObject.get("user_key").toString()); // Device 토큰 값;

		} catch (Exception e) {
		}
		return token;
	}

	// 4 - UpdateFCMToken ( Token Data(App)를 DB에 저장한다. )
	public void UpdateFCMToken(TokenDTO token) {
		Open();
		String sql = "UPDATE TBL_USER SET fcm_token = ? WHERE user_NO = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, token.getToken());
			pstmt.setInt(2, token.getUserNO());

			pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Close();
		}
	}

	// 5 - SelectFCMToken ( UserNO(App)로 DB에서 Token Data를 조회한다. )
	public String SelectFCMToken(TokenDTO token) {
		Open();
		String fcm_token = "";
		String sql = "SELECT fcm_token FROM TBL_USER WHERE user_NO = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, token.getUserNO());

			rs = pstmt.executeQuery();

			if (rs.next()) {
				fcm_token = rs.getString("fcm_token");
			} else {
				System.out.println("알 수 없는 오류입니다.( DB에 토큰이 없습니다. )");
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Close();
		}
		return fcm_token;
	}
}