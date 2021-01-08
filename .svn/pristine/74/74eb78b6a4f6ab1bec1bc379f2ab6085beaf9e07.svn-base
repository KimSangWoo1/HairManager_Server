package login;

import java.sql.Connection;

import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import Common.CommonData;

/* 
 * FindEmailDAO
 * 1 - Open ( DB 연결 ) 
 * 2 - Close ( DB 연결 종료 )
 * 3 - JsonParser ( 어플에서 온 데이터 UserDTO형식으로 변환 )
 * 4 - MakeJson ( 어플로 보낼 데이터 Json형식으로 변환 )
 * 5 - FindEmail ( Data( App )로 DB에서 Email을 조회한다. )
 */

public class FindEmailDAO {

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

			user.setUser_name(jsonObject.get("user_name").toString());
			user.setUser_phoneNO(jsonObject.get("user_phoneNO").toString());
			user.setUser_birthday(jsonObject.get("user_birthday").toString());

		} catch (Exception e) {
		}
		return user;
	}

	// 4 - MakeJson ( 어플로 보낼 데이터 Json형식으로 변환 )
	public String MakeJson(String user_email) {
		String result = null;

		HashMap<String, Object> myHashMap = new HashMap<String, Object>();

		if ("LO_0003".equals(user_email)) { // 이메일이 db에 존재하지 않을 경우
			myHashMap.put("user_email", "x");
			myHashMap.put("code", "LO_0003");
		} else { // DB에 이메일이 존재할 경우
			myHashMap.put("user_email", user_email);
			myHashMap.put("code", "SY_2000");
		}

		JSONObject object = new JSONObject(myHashMap); // head오브젝트와 body오브젝트를 담을 JSON오브젝트

		result = object.toString();

		return result;
	}

	// 5 - FindEmail ( Data( App )로 DB에서 Email을 조회한다. )
	public String FindEmail(UserDTO user) {
		Open();
		String returns = null;
		try {
			// 이름,폰번호,생년월일로 해당하는 이메일 있는지 조회
			String sql = "SELECT user_email FROM TBL_USER WHERE user_NM= ? AND phone_NO= ? AND user_birthday= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user.getUser_name());
			pstmt.setString(2, user.getUser_phoneNO());
			pstmt.setString(3, user.getUser_birthday());
			rs = pstmt.executeQuery();
			if (rs.next()) {
				// DB에 같은 정보가 2개 이상 존재할 경우
				if (rs.getFetchSize() > 1) {
					System.out.println("DB에 중복된 정보가 존재합니다. 확인하세요.");
				} else {
					// 이메일이 이미 데이터베이스에 존재할 경우 해당 이메일 반환
					returns = rs.getString("user_email");
				}
			} else {
				// 아닐경우 오류코드 반환
				returns = "LO_0003";
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			Close();
		}
		return returns;
	}
}
