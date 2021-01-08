package Mypage;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import Common.CommonData;

/* 
 * Notify DAO ( DB에서 알람 데이터를 조회하는 클래스 )
 * 1 - Open ( DB 연결 ) 
 * 2 - Close ( DB 연결 종료 )
 * 3 - JsonParser ( 어플에서 온 데이터 NotifyDTO형식으로 변환 )
 * 4 - MakeJson ( 어플로 보낼 데이터 Json형식으로 변환 )
 * 5 - SelectNotifyData ( UserNO(App)로 DB에서 NotifyData 조회 )
 * 6 - SelectDiaryTitle ( DiaryNO( SelectNotifyData에서 가져온 )로 DB에서 일기제목 조회 )
 */

public class NotifyDAO {
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

	// 3 - JsonParser ( 어플에서 온 데이터 NotifyDTO형식으로 변환 )
	public NotifyDTO JsonParser(String data) {
		NotifyDTO notify = new NotifyDTO();
		int userNO = 0;
		int pageNO = 0;
		try {
			JSONParser jsonParser = new JSONParser();
			JSONObject jsonObject = (JSONObject) jsonParser.parse(data);

			if (!"".equals(jsonObject.get("user_NO").toString())) {
				// userNO 파싱
				userNO = Integer.parseInt(jsonObject.get("user_NO").toString());
				notify.setUserNO(userNO);
			}

			if (!"".equals(jsonObject.get("user_profile").toString())) {
				// PageNO 파싱.
				pageNO = Integer.parseInt(jsonObject.get("user_profile").toString());
				notify.setPageNO(pageNO);
			}

		} catch (Exception e) {
		}
		return notify;
	}

	// 4 - MakeJson ( 어플로 보낼 데이터 Json형식으로 변환 )
	@SuppressWarnings("unchecked")
	public String MakeJson(List<NotifyDTO> Nlist) {
		String result = null;
		JSONArray array = new JSONArray();
		HashMap<String, Object> myHashMap = new HashMap<String, Object>();
		for (NotifyDTO ndo : Nlist) {
			myHashMap.put("DiaryNO", ndo.getDiaryNO());
			myHashMap.put("notifyNO", ndo.getNotifyNO());
			myHashMap.put("NTitle", ndo.getNotifyTitle());
			myHashMap.put("NDate", ndo.getNotifyDate());
			myHashMap.put("NTime", ndo.getNotifyTime());
			myHashMap.put("Nonoff", ndo.getNonoff());
			
			JSONObject object = new JSONObject(myHashMap); 
			array.add(object);
		}
		result = array.toString();
		return result.toString();
	}

	// 5 - SelectNotifyData ( UserNO(App)로 DB에서 NotifyData 조회 )
	public ArrayList<NotifyDTO> SelectNotifyData(NotifyDTO notify) {
		Open();
		String sql = "SELECT * FROM TBL_NOTIFY WHERE user_NO = ? ORDER BY diary_ID DESC LIMIT 10 OFFSET ?";
		ArrayList<NotifyDTO> datas = new ArrayList<>();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, notify.getUserNO());
			pstmt.setInt(2, notify.getPageNO() * 10);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				 rs.previous();
				while (rs.next()) {
					NotifyDTO nd = new NotifyDTO();
					nd.setDiaryNO(rs.getInt("diary_ID"));
					nd.setNotifyNO(rs.getInt("notify_ID"));
					nd.setNotifyDate(rs.getString("notify_date"));
					nd.setNotifyTime(rs.getString("notify_time"));
					nd.setNonoff(rs.getInt("notify_switch"));
					
					datas.add(nd);
				}
				rs.close();
			} else {
				System.out.println("해당 userNO에 해당하는 데이터가 없습니다. ( Default값 적용 ) ");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Close();
		}
		return datas;
	}

	// 6 - SelectDiaryTitle ( DiaryNO( SelectNotifyData에서 가져온 )로 DB에서 일기제목 조회 )
	public List<NotifyDTO> SelectDiaryTitle(List<NotifyDTO> Nlist) {
		Open();
		String sql = "SELECT diary_title FROM TBL_DIARY WHERE diary_ID= ?";
		try {
			pstmt = conn.prepareStatement(sql);
			for (NotifyDTO nd : Nlist) {
				pstmt.setInt(1, nd.getDiaryNO());
				rs = pstmt.executeQuery();

				if (rs.next()) {
					nd.setNotifyTitle(rs.getString("diary_title"));
				} else {
					System.out.println(
							"해당 일기에 제목이 저장되어 있지 않습니다. ( 정상적으로 프로그래밍이 돌아가면 사실 이런 경우는 없어야 함. 제목이 없으면 일기를 저장할 수 없으므로 )");
				}
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Close();
		}
		return Nlist;
	}
}