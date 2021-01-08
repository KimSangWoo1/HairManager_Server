package Mypage;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import Common.CommonData;
import login.Crypto;
import login.PasswordDTO;
import login.UserDTO;

/* 
 * UpdatePassword DAO ( 패스워드 변경 )
 * 1 - Open ( DB 연결 ) 
 * 2 - Close ( DB 연결 종료 )
 * 3 - JsonParser ( 어플에서 온 데 이터 UserDTO형식으로 변환 )
 * 4 - SelectPasswordData ( UserNO(App)로 DB에서 Password, Key, TempPassword, TempKey 조회 )
 * 5 - CheckPassowrd (비밀번호( App ) 비밀번호( DB ) 두개를 복호화한후 비교한다. )
 * 6 - UpdatePassword ( 변경할 비밀번호( App )를 DB에 Insert한다. )
 */

public class UpdatePasswordDAO {

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

	// 3 - JsonParser ( 어플에서 온 데 이터 UserDTO형식으로 변환 )
	public UserDTO JsonParser(String data) {

		UserDTO user = new UserDTO();
		try {
			JSONParser jsonParser = new JSONParser();
			JSONObject jsonObject = (JSONObject) jsonParser.parse(data);

			user.setUser_NO(jsonObject.get("user_NO").toString());
			user.setUser_password(jsonObject.get("user_password").toString());
			user.setChange_password(jsonObject.get("change_password").toString());
			user.setUser_key(jsonObject.get("key").toString());

		} catch (Exception e) {
		}
		return user;
	}

	// 4 - SelectPasswordData ( UserNO(App)로 DB에서 Password, Key, TempPassword, TempKey 조회 )
	public PasswordDTO SelectPasswordData(UserDTO user) {
		Open();

		PasswordDTO pd = new PasswordDTO();
		try {
			String sql = "SELECT * FROM TBL_USER_PRIVATE WHERE user_NO = ?";// 조회
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, Integer.parseInt(user.getUser_NO()));

			rs = pstmt.executeQuery();
			if (rs.next()) {
				// 패스워드가 데이터베이스에 존재할 경우
				pd.setUser_password(rs.getString("password"));
				pd.setUser_key(rs.getString("passwordKey"));
				pd.setTemppassword(rs.getString("tempPassword"));
				pd.setTempkey(rs.getString("tempKey"));
			} else {
				// PasswordDO에 default값 있음.
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			Close();
		}
		return pd;
	}

	// 5 - CheckPassowrd (비밀번호( App ) 비밀번호( DB ) 두개를 복호화한후 비교한다. )
	public String CheckPassowrd(PasswordDTO password, UserDTO user) {

		String returns = "";
		// 일반패스워드도 임시패스워드도 빈칸일 경우
		if (password.getTemppassword().equals("") && password.getUser_password().equals("")) {
			returns = "MP_0004"; // 카카오로 로그인한 후 비밀번호찾기를 했을 때
		} else { // 임시비밀번호가 없을 경우 ( 일반 비밀번호랑 비교 )
			if (password.getTemppassword().equals("")) {
				try {
					Crypto.secretKEY = user.getUser_key();
					String Apassword = Crypto.DecryptAES256(user.getUser_password());
					System.out.println("앱에서 보낸 패스워드 복호화 : " + Apassword);
					String Cpassword = Crypto.DecryptAES256(user.getChange_password());
					System.out.println("앱에서 보낸 변경할 패스워드 복호화 : " + Cpassword);
					Crypto.secretKEY = password.getUser_key();
					String Dpassword = Crypto.DecryptAES256(password.getUser_password());
					System.out.println("DB에 있는 일반 패스워드 복호화 : " + Dpassword);

					if (Apassword.equals(Dpassword)) {
						returns = "SY_2000";
					} else {
						returns = "MP_0002";
					}
				} catch (Exception e) {

				}
			} // 임시비밀번호가 있을 경우 ( 임시 비밀번호랑 비교 )
			else {
				try {
					Crypto.secretKEY = user.getUser_key();
					String Apassword = Crypto.DecryptAES256(user.getUser_password());
					System.out.println("앱에서 보낸 패스워드 복호화 : " + Apassword);
					Crypto.secretKEY = password.getTempkey();
					String Dpassword = Crypto.DecryptAES256(password.getTemppassword());
					System.out.println("DB에 있는 임시 패스워드 복호화 : " + Dpassword);
					if (Apassword.equals(Dpassword)) {
						returns = "SY_2000";
					} else {
						returns = "MP_0003";
					}
				} catch (Exception e) {

				}
			}
		}
		return returns;
	}

	// 6 - UpdatePassword ( 변경할 비밀번호( App )를 DB에 Insert한다. )
	public String UpdatePassword(UserDTO user) {
		Open();
		String result = "";
		try {
			String sql = "UPDATE TBL_USER_PRIVATE SET password = ?, passwordKey = ?, tempPassword = ?, tempKey = ?, tempTimeOut = ? WHERE user_NO = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user.getChange_password());
			pstmt.setString(2, user.getUser_key());
			pstmt.setString(3, "");
			pstmt.setString(4, "");
			pstmt.setString(5, null);
			pstmt.setInt(6, Integer.parseInt(user.getUser_NO()));

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
}
