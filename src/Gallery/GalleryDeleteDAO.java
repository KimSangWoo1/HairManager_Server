package Gallery;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import Common.CommonData;

/* 
 * GalleryDeleteDAO ( DB���� �ϱ� �����͸� �����ϴ� Ŭ����. )
 * 1 - Open ( DB ���� ) 
 * 2 - Close ( DB ���� ���� )
 * 3 - JsonParser ( ���ÿ��� �� ������ GalleryDTO�������� ��ȯ )
 * 4 - DeletetDiaryData ( diaryNO( App )�� DB���� �ϱ� Data ���� )
 * 5 - DeletetPhotoData ( diaryNO( App )�� DB���� ���� Data ���� )
 * 6 - DeletetNotifyData ( diaryNO( App )�� DB���� �˶� Data ���� )
 */

// DB���� �ϱ� �����͸� �����ϴ� Ŭ����. (��������)
public class GalleryDeleteDAO {
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

	// 3 - JsonParser ( ���ÿ��� �� ������ GalleryDTO�������� ��ȯ )
	public List<String> JsonParser(String data) {
		ArrayList<String> diaryNOList = new ArrayList<>();
		try {
			JSONParser jsonParser = new JSONParser();
			Object obj = jsonParser.parse(data);
			JSONArray jsonArray = (JSONArray) obj;

			for (int i = 0; i < jsonArray.size(); i++) {
				JSONObject json = (JSONObject) jsonArray.get(i);// �ε��� ��ȣ�� �����ؼ� ������
				// ������ ������ Ȯ�ο�
				diaryNOList.add((String) json.get("diaryNO"));
			}

		} catch (Exception e) {
		}
		return diaryNOList;
	}

	// 4 - DeletetDiaryData ( diaryNO( App )�� DB���� �ϱ� Data ���� )
	public void DeletetDiaryData(List<String> diaryNOList) {
		Open();
		String sql = "DELETE FROM TBL_DIARY WHERE diary_ID = ?";
		try {
			for (String diaryNO : diaryNOList) {
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, Integer.parseInt(diaryNO));

				pstmt.executeUpdate();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Close();
		}
	}

	// 5 - DeletetPhotoData ( diaryNO( App )�� DB���� ���� Data ���� )
	public void DeletetPhotoData(List<String> diaryNOList) {
		Open();
		String sql = "DELETE FROM TBL_PHOTO WHERE diary_ID = ?";
		try {
			for (String diaryNO : diaryNOList) {
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, Integer.parseInt(diaryNO));

				pstmt.executeUpdate();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Close();
		}
	}

	// 6 - DeletetNotifyData ( diaryNO( App )�� DB���� �˶� Data ���� )
	public void DeletetNotifyData(List<String> diaryNOList) {
		Open();
		String sql = "DELETE FROM TBL_NOTIFY WHERE diary_ID = ?";
		try {
			for (String diaryNO : diaryNOList) {
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, Integer.parseInt(diaryNO));

				pstmt.executeUpdate();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Close();
		}
	}
}