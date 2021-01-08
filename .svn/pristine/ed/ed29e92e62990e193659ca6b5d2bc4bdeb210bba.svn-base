package Mypage;

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
 * NotifyDelete DAO ( DB에서 알람 데이터를 삭제하는 클래스 )
 * 1 - Open ( DB 연결 ) 
 * 2 - Close ( DB 연결 종료 )
 * 3 - JsonParser ( 어플에서 온 데이터 String형식으로 변환 )
 * 4 - DeletetNotifyData ( NotifyNO(App)로 DB에서 NotifyData 삭제 )
 * 5 - UpdateDiaryNotifyCheck ( diaryNO(App)로 TBL_DIARY의 NotifyCheck 수정 )
 */

public class NotifyDeleteDAO {
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

	// 3 - JsonParser ( 어플에서 온 데이터 String형식으로 변환 )
	public List<NotifyDTO> JsonParser(String data) {
		ArrayList<NotifyDTO> notifyList = new ArrayList<>();
		
		try {
			JSONParser jsonParser = new JSONParser();
			Object obj = jsonParser.parse(data);
			JSONArray jsonArray = (JSONArray) obj;

			for (int i = 0; i < jsonArray.size(); i++) {
				JSONObject json = (JSONObject) jsonArray.get(i);// 인덱스 번호로 접근해서 가져온
				NotifyDTO notify = new NotifyDTO();
				notify.setDiaryNO(Integer.parseInt(json.get("diaryNO").toString()));
				notify.setNotifyNO(Integer.parseInt((String) json.get("notifyNO")));
				
				notifyList.add(notify);
			}

		} catch (Exception e) {
		}
		return notifyList;
	}

	// 4 - DeletetNotifyData ( NotifyNO(App)로 DB에서 NotifyData 삭제 )
	public void DeletetNotifyData(List<NotifyDTO> notifyList) {
		Open();
		String sql = "DELETE FROM TBL_NOTIFY WHERE notify_ID = ?";
		try {
			for (NotifyDTO notify : notifyList) {
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, notify.getNotifyNO());

				pstmt.executeUpdate();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Close();
		}
	}

	// 5 - UpdateDiaryNotifyCheck ( diaryNO(App)로 TBL_DIARY의 NotifyCheck 수정 )
	public void UpdateDiaryNotifyCheck(List<NotifyDTO> notifyList) {
		Open();
		String sql = "UPDATE TBL_DIARY SET notify_check = ? WHERE diary_ID = ?";
		try {
			for (NotifyDTO notify : notifyList) {
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, 0);
				pstmt.setInt(2, notify.getDiaryNO());

				pstmt.executeUpdate();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Close();
		}
	}
}