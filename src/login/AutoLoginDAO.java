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
 * AutoLogin DAO
 * 1 - Open ( DB ���� ) 
 * 2 - Close ( DB ���� ���� )
 * 3 - JsonParser ( ���ÿ��� �� ������ UserDTO�������� ��ȯ )
 * 4 - MakeJson ( ���÷� ���� ������ Json�������� ��ȯ )
 * 5 - SelectUserNO ( Email������(App)�� DB���� UserNO�� ��ȸ�Ѵ�. )
 * 6 - SelectDBPassword ( userNO( SelectUserNO���� ������ )�� Password, Password Key, TempPassword, TempKey, TempTimeout�� �����´�. )
 * 7 - CheckLogin ( ��й�ȣ( App ) ��й�ȣ( DB ) �ΰ��� ��ȣȭ���� ���Ѵ�. )
 * 8 - CheckTempPassword ( �ӽú�й�ȣ ��밡�ɽð� üũ )
 */

public class AutoLoginDAO {
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

			user.setUser_email(jsonObject.get("user_email").toString());
			user.setUser_password(jsonObject.get("user_password").toString());

		} catch (Exception e) {
		}
		return user;
	}

	// 4 - MakeJson ( ���÷� ���� ������ Json�������� ��ȯ )
	public String MakeJson(int user_NO, String code, PasswordDTO pd) {
		String result = null;

		HashMap<String, Object> myHashMap = new HashMap<String, Object>();

		// SelectUserNO���� UserNO�����͸� SELECT���� ���� ���
		if (user_NO == -1) {
			myHashMap.put("user_NO", user_NO);
			myHashMap.put("code", "LO_0001");
		} else {
			myHashMap.put("user_NO", user_NO);
			myHashMap.put("code", code);
		}
		JSONObject object = new JSONObject(myHashMap); // head������Ʈ�� body������Ʈ�� ���� JSON������Ʈ

		result = object.toString();

		return result;
	}

	// 5 - SelectUserNO ( Email������(App)�� DB���� UserNO�� ��ȸ�Ѵ�. )
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
					System.out.println("DB�� �ߺ��� userNO�� �����մϴ�. Ȯ���ϼ���.");
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

	// 6 - SelectDBPassword ( userNO( SelectUserNO���� ������ )�� Password, Password Key,
	// TempPassword, TempKey, TempTimeout�� �����´�. )
	public PasswordDTO SelectDBPassword(int user_NO) {
		Open();
		// �н����� , �ӽ� �н����� , �ӽ� �н����� ����ð� �� ������ �ִ� ��ü
		PasswordDTO pd = new PasswordDTO();
		try {
			String sql = "SELECT password,passwordKey,tempPassword,tempKey,tempTimeOut FROM TBL_USER_PRIVATE WHERE user_NO = ?";// ��ȸ
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, user_NO);
			rs = pstmt.executeQuery();
			// �н�������� ������ ������ ���
			if (rs.next()) {
				pd.setUser_password(rs.getString("password"));
				pd.setUser_key(rs.getString("passwordKey"));
				// �ӽú�й�ȣ�� ���� ���
				if ("".equals(rs.getString("tempPassword"))) {
					pd.setTemppassword("x");
					pd.setTempkey("x");
					pd.setTemptimeout("x");
					// �ӽú�й�ȣ�� �����ϴ� ���
				} else {
					pd.setTemppassword(rs.getString("tempPassword"));
					pd.setTempkey(rs.getString("tempKey"));
					pd.setTemptimeout(rs.getString("tempTimeOut"));
				}
			} else {
				pd.setUser_password("x");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			Close();
		}
		return pd;
	}

	// 7 - CheckLogin ( ��й�ȣ( App ) ��й�ȣ( DB ) �ΰ��� ��ȣȭ���� ���Ѵ�. )
	public String CheckLogin(UserDTO user, PasswordDTO pd, int userNO) {
		String result = "";

		// �ӽ� ��й�ȣ�� �������� ���� ���
		if ("x".equals(pd.getTemppassword())) {
			String Apassword = user.getUser_password(); // ���ÿ��� �� ���� �н�����
			String Dpassword = pd.getUser_password(); // SelectDBPassword���� ������ �н�����
			try {
				Crypto.secretKEY = pd.getUser_key(); // ���ÿ��� ���� �н����� Ű
				String decApassword = Crypto.DecryptAES256(Apassword);
				System.out.println("�ۿ��� ������ �н����� ��ȣȭ:" + decApassword);
				Crypto.secretKEY = pd.getUser_key(); // DB���� ������ �н����� Ű
				String decDpassword = Crypto.DecryptAES256(Dpassword);
				System.out.println("db���� ������ �н����� ��ȣȭ:" + decDpassword);

				if (decDpassword.equals(decApassword)) {
					result = "SY_2000";
				} else {
					result = "LO_0001";
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			// �ӽú�й�ȣ�� ��밡������ �ƴ��� üũ (���ѽð� �Ѿ����� �ȳѾ����� üũ)
			Boolean useOrnot = this.CheckTempPassword(userNO);

			// �ӽú�й�ȣ�� ��밡���� ���
			if (useOrnot == true) {
				String Apassword = user.getUser_password();
				String Dpassword = pd.getTemppassword(); // SelectDBPassword���� ������ �ӽú�й�ȣ

				try {
					Crypto.secretKEY = pd.getTempkey();
					String decApassword = Crypto.DecryptAES256(Apassword);
					System.out.println("�ۿ��� ������ �н����� ��ȣȭ:" + decApassword);
					Crypto.secretKEY = pd.getTempkey();
					String decDpassword = Crypto.DecryptAES256(Dpassword);
					System.out.println("db���� ������ �н����� ��ȣȭ:" + decDpassword);

					if (decDpassword.equals(decApassword)) {
						result = "LO_2000";
					} else {
						result = "LO_0007";
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				// �ӽú�й�ȣ�� ���Ұ��� ���
			} else {
				result = "LO_0006";
			}
		}

		return result;
	}

	// 8 - CheckTempPassword ( �ӽú�й�ȣ ��밡�ɽð� üũ )
	public boolean CheckTempPassword(int userNO) {
		Open();

		int result = -1;
		boolean useOrnot = false;

		Date date = new Date(); // �α����� �õ��ϴ� �ð�
		SimpleDateFormat simpledateformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String logintime = simpledateformat.format(date); // String������ ��ȯ

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