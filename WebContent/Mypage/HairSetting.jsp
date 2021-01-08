<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR" import="Mypage.* , java.util.* , Common.*"%>


<%
	request.setCharacterEncoding("UTF-8"); // Set Chracter 
	//GET 들어올 때
	if(request.getMethod().equals("GET")){
	   try{
			System.out.println("회원 헤어 정보 조회 GET!!");
			
			System.out.println("서버 : " + request.getServerName());
			System.out.println("포트번호 : " + request.getServerPort());
			System.out.println("요청방식 : " + request.getMethod());
			System.out.println("프로토콜 : " + request.getProtocol());
			System.out.println("URL : " + request.getRequestURL());
			System.out.println("URI : " + request.getRequestURI());
			//Get 파라메터 받기
			int userNO = Integer.parseInt(request.getParameter("userNO"));
			//이상한 정보 받을 시 에러 코드 보내기
			if(userNO==0){
				String result = API_ResponseCode.API_SY_0002();
				System.out.println("Get PARAMETER 오류 NULL!!");
				out.println(result); 
			}
			//파라메터 정상적일 경우
			else{
				UserHairInformationDTO dto= new UserHairInformationDTO();
				HairSettingDAO dao = new HairSettingDAO();
				//유저 헤어 정보 가져오기
				dto = dao.UserHairDB(userNO);
				//헤어 정보 검사
				if(dto!=null){
					String json =JDataParser.Response_MyPage_003(dto);
					System.out.println(json);
					out.println(json);	
				}
				//DB 오류 였을 경우
				else{
					String result = API_ResponseCode.API_DB_0303();
					out.println(result);
				}
			}		
	   }catch(Exception e){
			//500 Error
			String result = API_ResponseCode.API_HTTP_500();
			out.println(result);
			e.printStackTrace();
	   }
	     
	}
	//POST일 경우
	else if(request.getMethod().equals("POST")){
	    try{
	        System.out.println("회원 헤어 정보 업데이트 POST!!");
	        
	        System.out.println("서버 : " + request.getServerName());
	        System.out.println("포트번호 : " + request.getServerPort());
	        System.out.println("요청방식 : " + request.getMethod());
	        System.out.println("프로토콜 : " + request.getProtocol());
	        System.out.println("URL : " + request.getRequestURL());
	        System.out.println("URI : " + request.getRequestURI());
	        
	        String json = request.getParameter("json");
	        //파라매터 오류 예방
	        if(json!=null){
	            UserHairInformationDTO dto= new UserHairInformationDTO();	
		        //JSON 파싱 후 DTO에 저장
	            dto = JDataParser.Request_MyPage_002(json);
		        
		        //DB접속 및 쿼리
		        HairSettingDAO dao = new HairSettingDAO();
		        String code = dao.UserHairUpdate(dto);
		        
		        //코드에 따른 결과 값 JSON 포맷 
		        String resultJson = JDataParser.Response_MyPage_002(code);
		        System.out.println(json);
		        out.println(resultJson);        	
	        }

	     }catch(Exception e){
			 //500 Error
			 String result = API_ResponseCode.API_HTTP_500();
			 out.println(result);
	  	   	 e.printStackTrace();
	     }
	}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>회원 헤어 정보</title>
</head>
<body>

</body>
</html>