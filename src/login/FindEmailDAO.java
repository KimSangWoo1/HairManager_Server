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
 * 1 - Open ( DB ���� ) 
 * 2 - Close ( DB ���� ���� )
 * 3 - JsonParser ( ���ÿ��� �� ������ UserDTO�������� ��ȯ )
 * 4 - MakeJson ( ���÷� ���� ������ Json�������� ��ȯ )
 * 5 - FindEmail ( Data( App )�� DB���� Email�� ��ȸ�Ѵ�. )
 */

public class FindEmailDAO {

	final private String jdbc_class = CommonData.getJdbc_Class();
	final private String jdbc_url = CommonData.getJdbc_Url();
	final private String DB_ID = CommonData.getDB_ID();
	final private String DB_PW = CommonData.getDB_PW();

	Connection conn;
	PreparedStatement pstmt;
	ResultSet rs = null;

	// 1 - Open ( DB ���� ) 
	public void Open() {
		try {
			Class.forName(jdbc_class);
			conn = DriverManager.getConnection(jdbc_url, DB_ID, DB_PW);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 2 - Close ( DB ���� ���� )
	public void Close() {
		try {
			pstmt.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	// 3 - JsonParser ( ���ÿ��� �� ������ UserDTO�������� ��ȯ )
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

	// 4 - MakeJson ( ���÷� ���� ������ Json�������� ��ȯ )
	public String MakeJson(String user_email) {
		String result = null;

		HashMap<String, Object> myHashMap = new HashMap<String, Object>();

		if ("LO_0003".equals(user_email)) { // �̸����� db�� �������� ���� ���
			myHashMap.put("user_email", "x");
			myHashMap.put("code", "LO_0003");
		} else { // DB�� �̸����� ������ ���
			myHashMap.put("user_email", user_email);
			myHashMap.put("code", "SY_2000");
		}

		JSONObject object = new JSONObject(myHashMap); // head������Ʈ�� body������Ʈ�� ���� JSON������Ʈ

		result = object.toString();

		return result;
	}

	// 5 - FindEmail ( Data( App )�� DB���� Email�� ��ȸ�Ѵ�. )
	public String FindEmail(UserDTO user) {
		Open();
		String returns = null;
		try {
			// �̸�,����ȣ,������Ϸ� �ش��ϴ� �̸��� �ִ��� ��ȸ
			String sql = "SELECT user_email FROM TBL_USER WHERE user_NM= ? AND phone_NO= ? AND user_birthday= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user.getUser_name());
			pstmt.setString(2, user.getUser_phoneNO());
			pstmt.setString(3, user.getUser_birthday());
			rs = pstmt.executeQuery();
			if (rs.next()) {
				// DB�� ���� ������ 2�� �̻� ������ ���
				if (rs.getFetchSize() > 1) {
					System.out.println("DB�� �ߺ��� ������ �����մϴ�. Ȯ���ϼ���.");
				} else {
					// �̸����� �̹� �����ͺ��̽��� ������ ��� �ش� �̸��� ��ȯ
					returns = rs.getString("user_email");
				}
			} else {
				// �ƴҰ�� �����ڵ� ��ȯ
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
