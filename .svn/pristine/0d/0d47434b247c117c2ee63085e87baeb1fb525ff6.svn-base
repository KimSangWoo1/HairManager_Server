<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR" import="Calendar.*, java.util.*"%>
<%@ page import="org.json.simple.*" %>
<%@ page import="java.io.*" %>
<%@ page import="org.json.simple.parser.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="Common.*" %>
<%
	
	//다이어리
	int userNO;
	int diaryID;
	String diaryDate;
	String diaryTitle;
	String diaryContent;
	boolean notifyCheck;
	//포토
	String photoOne;
	String photoTwo;
	String photoThree;
	String photoFour;
	//알림
	int notifyID;
	String notifyDate;
	String notifyTime;

	request.setCharacterEncoding("UTF-8"); // Set Chracter 
	//GET 들어올 때
	if(request.getMethod().equals("GET")){
		try{
			System.out.println("Android Detail Diary GET!!");		
			System.out.println("서버 : " + request.getServerName());
			System.out.println("포트번호 : " + request.getServerPort());
			System.out.println("요청방식 : " + request.getMethod());
			System.out.println("프로토콜 : " + request.getProtocol());
			System.out.println("URL : " + request.getRequestURL());
			System.out.println("URI : " + request.getRequestURI());
			
			//Get 파라메터 변수 받기
			int _userNO = Integer.parseInt(request.getParameter("userNO"));
			int _diaryID = Integer.parseInt(request.getParameter("diaryID"));
			String _diaryDate = request.getParameter("date");
			
			//이상한 정보 받을 시 에러 코드 보내기
			if(_userNO==0||_diaryID==0||_diaryDate==null) {
				String result = API_ResponseCode.API_SY_0002();
				System.out.println("Get PARAMETER 오류 NULL!!");
				out.println(result); 
			}
			//정상 정보 받을 시 코드 진행
			else {			
				//일기 상세 DAO, DTO ,응답 처리		
				DetailDiaryDAO dao= new DetailDiaryDAO();					
				DiaryDTO dto = dao.DetailDiary(_userNO, _diaryID, _diaryDate);	
				//DB에서 정상적으로 데이터 가져왔을 경우
				if(dto!=null){
					String json = JDataParser.Response_Calendar_002(dto);
					System.out.println(json.toString());
					out.println(json.toString()); //결과 보내기	  
				}
				//DB_0303 DB 오류 있을 시
				else{
					 String result = API_ResponseCode.API_DB_0303();
					 out.println(result);
				}							
			}

		}catch(NumberFormatException e){
			System.out.println("상세 일기 정보 조회 오류");
			//500 Error
		    String result = API_ResponseCode.API_HTTP_500();
		    out.println(result);
		}catch(Exception e){
			e.printStackTrace();
			//500 Error
		    String result = API_ResponseCode.API_HTTP_500();
		    out.println(result);
		}
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>상세 일기 정보</title>
</head>
<body>

</body>
</html>