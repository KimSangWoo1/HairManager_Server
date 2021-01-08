<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="Calendar.*, java.util.*"%>
<%@ page import="java.io.*" %>
<%@ page import="Common.*" %>

<%
request.setCharacterEncoding("UTF-8");

if(request.getMethod().equals("POST")){
	try{
		System.out.println("서버 : " + request.getServerName());
		System.out.println("포트번호 : " + request.getServerPort());
		System.out.println("요청방식 : " + request.getMethod());
		System.out.println("프로토콜 : " + request.getProtocol());
		System.out.println("URL : " + request.getRequestURL());
		System.out.println("URI : " + request.getRequestURI());
		//Parameter 받기
		String json = request.getParameter("json");
		
		//필요 변수 생성
		String code;
		String responseJson;
		
		if(!DataCheck.checkNPE(json)){
			//일기 DAO ,DTO 변수
			DiaryDTO dto = new DiaryDTO();
			DeleteDiaryDAO dao = new DeleteDiaryDAO();
			DetailDiaryDAO detailDAO = new DetailDiaryDAO();
			
			dto = JDataParser.Request_Calendar_005(json);
			dto = detailDAO.DetailDiaryPhoto(dto,2);
			//서버 로컬 폴더에서 사진 삭제 하기
			FileManager.DeleteAll(dto);
			//일기 삭제 하기(일기,알림,사진)	
			code = dao.DeleteAll(dto);
			
			//일기 삭제 결과 값 가져오기
			responseJson = "";//JDataParser.Response_Calendar_005(code);
			out.println(responseJson);					
		}
	
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
<title>Insert title here</title>
</head>
<body>

</body>
</html>