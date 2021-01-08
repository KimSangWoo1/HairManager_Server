package Calendar;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLDataException;
import java.sql.SQLException;
import java.sql.SQLSyntaxErrorException;
import java.util.ArrayList;
import java.util.List;


import Common.CommonData;

public class CalendarDAO {
	
	final private String jdbc_class = CommonData.getJdbc_Class();
	final private String jdbc_url= CommonData.getJdbc_Url();
	final private String DB_ID = CommonData.getDB_ID();
	final private String DB_PW = CommonData.getDB_PW();
	
	Connection conn; 
	PreparedStatement pstmt; 

	public void Open() {
		try {
			Class.forName(jdbc_class);
			conn=DriverManager.getConnection(jdbc_url,DB_ID,DB_PW);
			System.out.println("DB Connection Success");
		}catch(Exception e) {
			e.printStackTrace();
		}				
	}

	public void Close() {
		try {
			pstmt.close();
			conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}	
	
	//캘린더 정보 받아오기
	public List<CalendarDTO> SelectMonth(int _no, String _month)
	{
		Open(); 
		//예시 : SELECT * from TBL_DIARY  WHERE user_NO='1' AND diary_DT LIKE MONTH('2020-10-%');
		String sql= "SELECT user_NO, diary_DT, diary_ID, diary_title FROM TBL_DIARY WHERE user_NO=? AND diary_DT LIKE ?";
		ArrayList<CalendarDTO> datas = new ArrayList<>();
		try {
			pstmt= conn.prepareStatement(sql);
			pstmt.setInt(1,_no);
			pstmt.setString(2,_month);
			System.out.println("캘린더 날짜"+_month);
			ResultSet rs= pstmt.executeQuery();
			
			while(rs.next()) {
				CalendarDTO dto = new CalendarDTO();
				dto.setUserNO(rs.getInt("user_NO"));
				dto.setDiaryNO(rs.getInt("diary_ID"));
				dto.setDiaryDate(rs.getString("diary_DT"));
				dto.setTitle(rs.getString("diary_title"));
				datas.add(dto);
			}
			rs.close();
		} catch (SQLException e) {
			datas=null;
			e.printStackTrace();
		}finally {
			Close();
		}
		return datas;
	}

}

