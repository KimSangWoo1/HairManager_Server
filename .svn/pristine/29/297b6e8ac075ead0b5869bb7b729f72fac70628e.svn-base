package login;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import Common.CommonData;

/* 
 * FindPasswordDAO
 * 1 - Open ( DB 연결 ) 
 * 2 - Close ( DB 연결 종료 )
 * 3 - JsonParser ( 어플에서 온 데 이터 UserDTO형식으로 변환 )
 * 4 - MakeJson ( 어플로 보낼 데이터 Json형식으로 변환 )
 * 5 - SelectUserNO ( 데이터(App)로 DB에서 UserNO를 조회한다. )
 * 6 - CheckPassword ( UserNO( SelectUserNO )로 DB에 Password가 있는지 조회한다. )
 * 7 - MakeTempPassword ( 16자리 임시 비밀번호 생성 )
 * 8 - InsertTempPassword ( 임시비밀번호와 임시비밀번호가 생성된 시간 DB에 저장 )
 */

public class FindPasswordDAO {

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

			user.setUser_email(jsonObject.get("user_email").toString());
			user.setUser_name(jsonObject.get("user_name").toString());
			user.setUser_phoneNO(jsonObject.get("user_phoneNO").toString());

		} catch (Exception e) {
		}
		return user;
	}

	// 4 - MakeJson ( 어플로 보낼 데이터 Json형식으로 변환 ) [수정]
	public String MakeJson(String check, int userNO) {
		String result = null;

		HashMap<String, String> myHashMap = new HashMap<String, String>();

		if ("LO_0004".equals(check)) { // userNO가 존재하지 않거나 패스워드가 존재하지 않을 경우
			myHashMap.put("temppassword", "x");
			myHashMap.put("tempkey", "x");
			myHashMap.put("code", "LO_0004");
		} else { // userNO조회에 성공하고 패스워드가 존재할 경우
			PasswordDTO pd = this.MakeTempPassword(); // 임시패스워드 생성

			if ("".equals(pd.getTemppassword())) { // 임시 패스워드 생성에 실패했을 경우
				myHashMap.put("temppassword", "x");
				myHashMap.put("tempkey", "x");
				myHashMap.put("code", "LO_0004");
			} else { // 임시 패스워드 생성에 성공했을 경우
				this.InsertTempPassword(pd, userNO);
				myHashMap.put("temppassword", pd.getTemppassword());
				myHashMap.put("tempkey", pd.getTempkey());
				myHashMap.put("code", "SY_2000");
			}
		}
		JSONObject object = new JSONObject(myHashMap); // head오브젝트와 body오브젝트를 담을 JSON오브젝트

		result = object.toString();

		return result;
	}

	// 5 - SelectUserNO ( 데이터(App)로 DB에서 UserNO를 조회한다. )
	public int SelectUserNO(UserDTO user) {
		Open();
		int result = -1;
		try {
			String sql = "SELECT user_NO FROM TBL_USER WHERE user_email= ? AND user_NM = ? AND phone_NO = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user.getUser_email());
			pstmt.setString(2, user.getUser_name());
			pstmt.setString(3, user.getUser_phoneNO());

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
			e.printStackTrace();
		} finally {
			Close();
		}
		return result;
	}

	// 6 - CheckPassword ( UserNO( SelectUserNO )로 DB에 Password가 있는지 조회한다. )
	public String CheckPassword(int userNO) {
		Open();
		String returns = null;
		try {
			String sql = "SELECT password FROM TBL_USER_PRIVATE WHERE user_NO = ?";// 조회
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, userNO);

			rs = pstmt.executeQuery();
			if (rs.next()) {
				// 패스워드가 데이터베이스에 존재할 경우
				returns = "OK";

			} else {
				returns = "LO_0004";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			Close();
		}
		return returns;
	}

	// 7 - MakeTempPassword ( 16자리 임시 비밀번호 생성 )
	public PasswordDTO MakeTempPassword() {
		PasswordDTO pd = new PasswordDTO();
		
		char pwNumberCollection[] = new char[] { '1', '2', '3', '4', '5', '6', '7', '8', '9', '0'};
		char pwBigCollection[] = new char[] { 'A', 'B', 'C', 'D', 'E','F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
		char pwSmallCollection[] = new char[] {	'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u','v', 'w', 'x', 'y', 'z'};
		char pwSymbolCollection[] = new char[] {'!', '@', '#', '$', '%', '^', '&', '*', '(', ')' };
		// 배열에 선언

		String randomPassword = "";

		for (int i = 0; i < 3; i++) {
			int selectRandomPw = (int) (Math.random() * (pwNumberCollection.length));// Math.rondom()은 0.0이상 1.0미만의 난수를 생성해 준다	.																// 준다.
			randomPassword += pwNumberCollection[selectRandomPw];
		}
		for (int i = 0; i < 3; i++) {
			int selectRandomPw = (int) (Math.random() * (pwBigCollection.length));// Math.rondom()은 0.0이상 1.0미만의 난수를 생성해 준다	.																// 준다.
			randomPassword += pwBigCollection[selectRandomPw];
		}
		for (int i = 0; i < 3; i++) {
			int selectRandomPw = (int) (Math.random() * (pwSmallCollection.length));// Math.rondom()은 0.0이상 1.0미만의 난수를 생성해 준다	.																// 준다.
			randomPassword += pwSmallCollection[selectRandomPw];
		}
		for (int i = 0; i < 3; i++) {
			int selectRandomPw = (int) (Math.random() * (pwSymbolCollection.length));// Math.rondom()은 0.0이상 1.0미만의 난수를 생성해 준다	.																// 준다.
			randomPassword += pwSymbolCollection[selectRandomPw];
		}
		try {
			// 임시 비밀번호 암호화
			Crypto.aesKeyGen();
			pd.setTempkey(Crypto.secretKEY);
			pd.setTemppassword(Crypto.EncryptAES256(randomPassword));

		} catch (Exception e) {
		}
		return pd;
	}

	// 8 - InsertTempPassword ( 임시비밀번호와 임시비밀번호가 생성된 시간 DB에 저장 )
	public String InsertTempPassword(PasswordDTO pd, int userNO) {
		Open();

		Date today = new Date(); // 임시 번호 생성되는 시간
		SimpleDateFormat simpledateformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		Calendar cal = Calendar.getInstance();
		cal.setTime(today);
		cal.add(Calendar.HOUR, 24); // 임시 번호 만료기한 : 생성 시간으로부터 24시간
		String temptimeout = simpledateformat.format(cal.getTime());

		String result = "";
		try {
			String sql = "UPDATE TBL_USER_PRIVATE SET tempPassword=?, tempKey = ?, tempTimeOut = ? WHERE user_NO = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, pd.getTemppassword());
			pstmt.setString(2, pd.getTempkey());
			pstmt.setString(3, temptimeout);
			pstmt.setInt(4, userNO);

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
