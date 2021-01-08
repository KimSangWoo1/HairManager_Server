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
 * 1 - Open ( DB ���� ) 
 * 2 - Close ( DB ���� ���� )
 * 3 - JsonParser ( ���ÿ��� �� ������ String�������� ��ȯ )
 * 4 - OverlapEmailCheck ( DB�� ����Ͽ� �̸����ߺ� üũ )
 */

public class OverlapEmailDAO {
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

	// 3 - JsonParser ( ���ÿ��� �� ������ String�������� ��ȯ )
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

	// 4 - OverlapEmailCheck ( DB�� ����Ͽ� �̸����ߺ� üũ )
	public String OverlapEmailCheck(String user_email) {
		Open();
		String returns = "";
		try {
			String sql = "SELECT user_email FROM TBL_USER WHERE user_email = ?";// ��ȸ
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user_email);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getFetchSize() > 1) {
					System.out.println("DB�� �ߺ��� �̸����� �����մϴ�. Ȯ���ϼ���.");
				} else {
					// �̸����� �����ͺ��̽��� ������ ���
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