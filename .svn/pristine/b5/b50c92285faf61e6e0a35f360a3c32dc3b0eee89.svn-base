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
 * KakaoMemberDAO ( 카카오로 로그인 할 경우 카카오데이터 DB에 저장 )
 * 1 - Open ( DB 연결 ) 
 * 2 - Close ( DB 연결 종료 )
 * 3 - JsonParser ( 어플에서 온 데이터 UserDTO형식으로 변환 )
 * 4 - OverlapKakaoEmailCheck ( 카카오로그인정보가 DB에 존재할 경우 카카오자동로그인 때 DB와 연결하지 않는다. 존재할 경우 userNO를 가져온다. )
 * 5 - InsertKakaoUser ( 카카오 유저정보 DB에 저장 )
 * 6 - InsertUserHair ( userNO( OverlapKakaoEmailCheck에서 가져온 )로 TBL_HAIR에 기본값 저장 [차후 업데이트를 위해서] )
 */

public class KakaoMemberDAO {

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

	// 3 - JsonParser ( 어플에서 온 데이터 UserDTO형식으로 변환 )
	public UserDTO JsonParser(String data) {
		UserDTO user = new UserDTO();
		try {
			JSONParser jsonParser = new JSONParser();
			JSONObject jsonObject = (JSONObject) jsonParser.parse(data);

			// 이메일
			user.setUser_email(jsonObject.get("user_email").toString());
			// 이름
			user.setUser_name(jsonObject.get("user_name").toString());
			// 프로필사진
			user.setUser_password(jsonObject.get("user_profile").toString());
			// 성별
			String usersex = jsonObject.get("user_sex").toString();
			if ("MALE".equals(usersex)) {
				user.setUser_sex("M");
			} else {
				user.setUser_sex("F");
			}
		} catch (Exception e) {
		}
		return user;
	}

	// 4 - OverlapKakaoEmailCheck ( 카카오로그인정보가 DB에 존재할 경우 카카오자동로그인 때 DB와 연결하지 않는다. 존재할 경우 userNO를 가져온다. )
	public int OverlapKakaoEmailCheck(UserDTO user) {
		Open();
		int returns = 0;
		try {
			String sql = "SELECT user_email,user_NO FROM TBL_USER WHERE user_email = ?";// 조회
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user.getUser_email());
			rs = pstmt.executeQuery();
			if (rs.next()) {
				// 이메일이 이미 데이터베이스에 존재할 경우
				returns = rs.getInt("user_NO");
			} else {
				this.InsertKakaoUser(user); // DB에 저장된 정보가 없다면 User정보를 DB에 저장한다.
				this.InsertUserHair(Integer.parseInt(user.getUser_NO())); // DB에 저장된 정보가 없다면 TBL_HAIR에 기본값 저장
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			Close();
		}
		return returns;
	}

	// 5 - InsertKakaoUser ( 카카오 유저정보 DB에 저장 )
	public void InsertKakaoUser(UserDTO user) {
		Open();
		try {
			String sql = "INSERT INTO TBL_USER(user_email,user_NM,user_sex,user_profile) VALUES(?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user.getUser_email());
			pstmt.setString(2, user.getUser_name());
			pstmt.setString(3, user.getUser_sex());
			pstmt.setString(4, user.getUser_password()); // 암호화된 프로필사진 url주소

			pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Close();
		}
	}

	// 6 - InsertUserHair ( userNO( OverlapKakaoEmailCheck에서 가져온 )로 TBL_HAIR에 기본값 저장 [차후 업데이트를 위해서] )
	public void InsertUserHair(int userNO) {
		Open();
		try {
			String sql = "INSERT INTO TBL_HAIR(user_NO) VALUES(?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, userNO);

			pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Close();
		}
	}
}
