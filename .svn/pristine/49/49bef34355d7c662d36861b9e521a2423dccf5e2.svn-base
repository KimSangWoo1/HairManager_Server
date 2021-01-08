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
 * SignUpDAO
 * 1 - Open ( DB 연결 ) 
 * 2 - Close ( DB 연결 종료 )
 * 3 - JsonParser ( 어플에서 온 데이터 UserDTO형식으로 변환 )
 * 4 - InsertUser ( TBL_USER테이블에 이메일, 이름, 성별, 핸드폰번호, 생년월일 저장 )
 * 5 - SelectUserNO ( Email데이터(App)로 DB에서 UserNO 조회 )
 * 6 - InsertUserPrivate ( userNO( SelectUserNO에서 가져온 )로 DB에 비밀번호, 키 저장 )
 * 7 - InsertUserHair  ( userNO( SelectUserNO에서 가져온 )로 TBL_HAIR에 기본값 저장 [차후 업데이트를 위해서] )
 */


public class SignUpDAO {
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

			user.setUser_email(jsonObject.get("user_email").toString());
			user.setUser_password(jsonObject.get("user_password").toString());
			user.setUser_name(jsonObject.get("user_name").toString());
			user.setUser_phoneNO(jsonObject.get("user_phoneNO").toString());
			user.setUser_birthday(jsonObject.get("user_birthday").toString());
			user.setUser_sex(jsonObject.get("user_sex").toString());
			user.setUser_key(jsonObject.get("user_key").toString().trim());

		} catch (Exception e) {
		}
		return user;
	}

	// 4 - InsertUser ( TBL_USER테이블에 이메일, 이름, 성별, 핸드폰번호, 생년월일 저장 )
	public String InsertUser(UserDTO user) {
		Open();
		String result = "e";
		try {
			String sql = "INSERT INTO TBL_USER(user_email,user_NM,user_sex,phone_NO,user_birthday) VALUES(?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user.getUser_email());
			pstmt.setString(2, user.getUser_name());
			pstmt.setString(3, user.getUser_sex());
			pstmt.setString(4, user.getUser_phoneNO());
			pstmt.setString(5, user.getUser_birthday());

			// 4단계 실행
			pstmt.executeUpdate();
			result = "OK";
		} catch (SQLException e) {
			e.printStackTrace();
			result = "FAIL";
		} finally {
			Close();
		}
		return result;
	}

	// 5 - SelectUserNO ( Email데이터(App)로 DB에서 UserNO 조회 )
	public int SelectUserNO(UserDTO user) {
		Open();

		int result = -1;
		try {
			String sql = "SELECT user_NO FROM TBL_USER WHERE user_email= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user.getUser_email());

			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getFetchSize() > 1) {
					System.out.println("DB에 중복된 userNO가 존재합니다. 확인하세요.");
				} else {
					result = rs.getInt("user_NO");
				}
			} else {
				result = -1;
			}
		} catch (SQLException e) {

		} finally {
			Close();
		}
		return result;
	}

	// 6 - InsertUserPrivate ( userNO( SelectUserNO에서 가져온 )로 DB에 비밀번호, 키 저장 )
	public String InsertUserPrivate(UserDTO user, int userNO) {
		Open();
		String result = "e";
		try {
			String sql = "INSERT INTO TBL_USER_PRIVATE(user_NO,password,passwordKey) VALUES(?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, userNO);
			pstmt.setString(2, user.getUser_password());
			pstmt.setString(3, user.getUser_key());

			pstmt.executeUpdate();
			result = "OK";
		} catch (SQLException e) {
			e.printStackTrace();
			result = "FAIL";
		} finally {
			Close();
		}
		return result;
	}

	// 7 - InsertUserHair  ( userNO( SelectUserNO에서 가져온 )로 TBL_HAIR에 기본값 저장 [차후 업데이트를 위해서] )
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
