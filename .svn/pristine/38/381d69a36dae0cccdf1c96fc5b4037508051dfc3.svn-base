package login;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import Common.CommonData;

/* 
 * Login DAO
 * 1 - Open ( DB 연결 ) 
 * 2 - Close ( DB 연결 종료 )
 * 3 - JsonParser ( 어플에서 온 데이터 UserDTO형식으로 변환 )
 * 4 - MakeJson ( 어플로 보낼 데이터 Json형식으로 변환 )
 * 5 - SelectUserNO ( Email데이터(App)로 DB에서 UserNO를 조회한다. )
 * 6 - SelectDBPassword ( userNO( SelectUserNO에서 가져온 )로 Password, Password Key, TempPassword, TempKey, TempTimeout을 가져온다. )
 * 7 - CheckLogin ( 비밀번호( App ) 비밀번호( DB ) 두개를 복호화한후 비교한다. )
 * 8 - CheckTempPassword ( 임시비밀번호 사용가능시간 체크 )
 */

public class LoginDAO {
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
			user.setUser_key(jsonObject.get("user_key").toString());

		} catch (Exception e) {
		}
		return user;
	}

	// 4 - MakeJson ( 어플로 보낼 데이터 Json형식으로 변환 )
	public String MakeJson(int user_NO, String code, PasswordDTO pd) {
		String result = null;

		HashMap<String, Object> myHashMap = new HashMap<String, Object>();

		// SelectUserNO에서 UserNO데이터를 SELECT하지 못한 경우
		if (user_NO == -1) {
			myHashMap.put("user_NO", user_NO);
			myHashMap.put("code", "LO_0001");
			myHashMap.put("db_password", "x");
		} else if ("SY_2000".equals(code)) {
			myHashMap.put("user_NO", user_NO);
			myHashMap.put("code", code);
			myHashMap.put("db_password", pd.getUser_password());
		} else {
			myHashMap.put("user_NO", user_NO);
			myHashMap.put("code", code);
			myHashMap.put("db_password", pd.getTemppassword());
		}
		JSONObject object = new JSONObject(myHashMap); // head오브젝트와 body오브젝트를 담을 JSON오브젝트

		result = object.toString();

		return result;
	}

	// 5 - SelectUserNO ( Email데이터(App)로 DB에서 UserNO를 조회한다. )
	public int SelectUserNO(UserDTO user) {
		Open();
		String sql = "SELECT user_NO FROM TBL_USER WHERE user_email= ?";
		int user_NO = -1;
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user.getUser_email());

			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getFetchSize() > 1) {
					System.out.println("DB에 중복된 userNO가 존재합니다. 확인하세요.");
				} else {
					user_NO = rs.getInt("user_NO");
				}
			} else {
				user_NO = -1;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Close();
		}
		return user_NO;
	}

	// 6 - SelectDBPassword ( userNO( SelectUserNO에서 가져온 )로 Password, Password Key, TempPassword, TempKey, TempTimeout을 가져온다. )
	public PasswordDTO SelectDBPassword(int user_NO) {
		Open();
		// 패스워드 , 임시 패스워드 , 임시 패스워드 만료시간 을 담을수 있는 객체
		PasswordDTO pd = new PasswordDTO();
		try {
			String sql = "SELECT password,passwordKey,tempPassword,tempKey,tempTimeOut FROM TBL_USER_PRIVATE WHERE user_NO = ?";// 조회
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, user_NO);
			rs = pstmt.executeQuery();
			// 패스워드관련 정보가 존재할 경우
			if (rs.next()) {
				pd.setUser_password(rs.getString("password"));
				pd.setUser_key(rs.getString("passwordKey"));
				// 임시비밀번호가 없는 경우
				if ("".equals(rs.getString("tempPassword"))) {
					pd.setTemppassword("x");
					pd.setTempkey("x");
					pd.setTemptimeout("x");
					// 임시비밀번호가 존재하는 경우
				} else {
					pd.setTemppassword(rs.getString("tempPassword"));
					pd.setTempkey(rs.getString("tempKey"));
					pd.setTemptimeout(rs.getString("tempTimeOut"));
				}
			} else {
				// 카카오로 회원가입했을 경우 패스워드가 존재 하지 않을 수 있다, 혹은 회원가입을 하지 않았거나.
				pd.setUser_password("x");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			Close();
		}
		return pd;
	}

	// 7 - CheckLogin ( 비밀번호( App ) 비밀번호( DB ) 두개를 복호화한후 비교한다. )
	public String CheckLogin(UserDTO user, PasswordDTO pd, int userNO) {
		String result = "";
		// DB에 패스워드가 존재하지 않을 경우
		if ("x".equals(pd.getUser_password())) {
			result = "LO_0001";
		} else {
			// 임시 비밀번호가 존재하지 않을 경우
			if ("x".equals(pd.getTemppassword())) {
				String Apassword = user.getUser_password(); // 어플에서 온 유저 패스워드
				String Dpassword = pd.getUser_password(); // SelectDBPassword에서 가져온 패스워드
				try {
					Crypto.secretKEY = user.getUser_key(); // 어플에서 보낸 패스워드 키
					String decApassword = Crypto.DecryptAES256(Apassword);
					System.out.println("앱에서 갖고온 패스워드 복호화:" + decApassword);
					Crypto.secretKEY = pd.getUser_key(); // DB에서 가져온 패스워드 키
					String decDpassword = Crypto.DecryptAES256(Dpassword);
					System.out.println("db에서 갖고온 패스워드 복호화:" + decDpassword);

					if (decDpassword.equals(decApassword)) {
						result = "SY_2000";
					} else {
						result = "LO_0001";
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else {
				// 임시비밀번호가 사용가능한지 아닌지 체크 (제한시간 넘었는지 안넘었는지 체크)
				Boolean useOrnot = this.CheckTempPassword(userNO);

				// 임시비밀번호가 사용가능할 경우
				if (useOrnot == true) {
					String Apassword = user.getUser_password();
					String Dpassword = pd.getTemppassword(); // SelectDBPassword에서 가져온 임시비밀번호

					try {
						Crypto.secretKEY = user.getUser_key();
						String decApassword = Crypto.DecryptAES256(Apassword);
						System.out.println("앱에서 갖고온 패스워드 복호화:" + decApassword);
						Crypto.secretKEY = pd.getTempkey();
						String decDpassword = Crypto.DecryptAES256(Dpassword);
						System.out.println("db에서 갖고온 패스워드 복호화:" + decDpassword);

						if (decDpassword.equals(decApassword)) {
							result = "LO_2000";
						} else {
							result = "LO_0007";
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
					// 임시비밀번호가 사용불가할 경우
				} else {
					result = "LO_0006";
				}
			}
		}
		return result;
	}

	// 8 - CheckTempPassword ( 임시비밀번호 사용가능시간 체크 )
	public boolean CheckTempPassword(int userNO) {
		Open();

		int result = -1;
		boolean useOrnot = false;

		Date date = new Date(); // 로그인을 시도하는 시간
		SimpleDateFormat simpledateformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String logintime = simpledateformat.format(date); // String형으로 변환

		try {
			String sql = "SELECT TIMESTAMPDIFF(SECOND, ? , (SELECT tempTimeOut FROM TBL_USER_PRIVATE WHERE user_NO = ? )) AS diff";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, logintime);
			pstmt.setInt(2, userNO);

			rs = pstmt.executeQuery();
			if (rs.next()) {
				result = rs.getInt("diff");
			} else {
				result = -1;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Close();
		}

		if (result != -1) {
			if (result > 0)
				useOrnot = true;
			else
				useOrnot = false;
		}

		return useOrnot;
	}

}