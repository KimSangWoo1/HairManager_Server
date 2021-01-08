package FCM;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Common.CommonData;
import Mypage.NotifyDTO;

/* 
 * SelectFCMData DAO ( FCMServiceDemon에서 쓰는 DAO )
 * 1 - Open ( DB 연결 ) 
 * 2 - Close ( DB 연결 종료 )
 * 3 - SelectNotifyData ( 현재 Date,Time으로 DB에서 UserNO, DiaryID, NotifyID 조회 )
 * 4 - SelectDiaryTitle ( DiaryID( SelectNotifyData )로 DB에서 DiaryTitle 조회 )
 * 5 - UpdatetNotifyOnOff ( NotifyID( SelectNotifyData )로 DB에서 Notify ON/OFF 업데이트 )
 * 6 - SelectFCMToken ( UserNO( SelectDiaryTitle )로 DB에서 FCMToken 조회 )
 */

public class SelectFCMDataDAO {
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

	// 3 - SelectNotifyData ( 현재 Date,Time으로 DB에서 UserNO, DiaryID, NotifyID 조회 )
	public ArrayList<NotifyDTO> SelectNotifyData(NotifyDTO notify) {
		Open();
		ArrayList<NotifyDTO> datas = new ArrayList<>();
		String sql = "SELECT * FROM TBL_NOTIFY WHERE notify_date = ? AND notify_time = ? AND notify_switch = 1;";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, notify.getNotifyDate());
			pstmt.setString(2, notify.getNotifyTime());
			rs = pstmt.executeQuery();
			if (rs.next()) {
				rs.previous();
				while (rs.next()) {
					NotifyDTO nd = new NotifyDTO();
					nd.setUserNO(rs.getInt("user_NO"));
					nd.setDiaryNO(rs.getInt("diary_ID"));
					nd.setNotifyNO(rs.getInt("notify_ID"));

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

	// 4 - SelectDiaryTitle ( DiaryID( SelectNotifyData )로 DB에서 DiaryTitle 조회 )
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

	// 5 - UpdatetNotifyOnOff ( NotifyID( SelectNotifyData )로 DB에서 Notify ON/OFF 업데이트 )
	public void UpdatetNotifyOnOff(List<NotifyDTO> notifyNOList) {
		Open();
		String sql = "UPDATE TBL_NOTIFY SET notify_switch = 0 WHERE notify_ID = ?";
		try {
			for (NotifyDTO notify : notifyNOList) {
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

	// 6 - SelectFCMToken ( UserNO( SelectDiaryTitle )로 DB에서 FCMToken 조회 )
	public List<NotifyDTO> SelectFCMToken(List<NotifyDTO> Nlist) {
		Open();
		String sql = "SELECT fcm_token FROM TBL_USER WHERE user_NO = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			for (NotifyDTO nd : Nlist) {
				pstmt.setInt(1, nd.getUserNO());

				rs = pstmt.executeQuery();

				if (rs.next()) {
					nd.setToken(rs.getString("fcm_token"));
				} else {
					System.out.println("알 수 없는 오류입니다.( DB에 토큰이 없습니다. )");
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
