<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR" import="Mypage.* , java.util.* , Common.*"%>

<%
int userNO;      //유저 번호 (PK)
String userEmail;
String userProfile;

request.setCharacterEncoding("UTF-8"); // Set Chracter 
//GET 들어올 때
if(request.getMethod().equals("GET")){
   try{
      System.out.println("회원 기본 정보 GET!!");
      
      System.out.println("서버 : " + request.getServerName());
      System.out.println("포트번호 : " + request.getServerPort());
      System.out.println("요청방식 : " + request.getMethod());
      System.out.println("프로토콜 : " + request.getProtocol());
      System.out.println("URL : " + request.getRequestURL());
      System.out.println("URI : " + request.getRequestURI());
     
      //Get Parmater 받기
      userNO = Integer.parseInt(request.getParameter("userNO"));
      if(userNO==0){
			String result = API_ResponseCode.API_SY_0002();
			System.out.println("Get PARAMETER 오류 NULL!!");
			out.println(result); 
      }else{
          // 변수 생성
          MyPageDAO dao = new MyPageDAO();
          UserProfileDTO dto = new UserProfileDTO();
          //회원 프로필 정보 가져오기
          dto = dao.MyPageInformation(userNO);
          if(dto!=null){
             //회원 프로필 정보 JSON 포맷 만들기
             String json = JDataParser.Response_MyPage_001(dto);            
             System.out.println(json);
             out.println(json);    
          }
          //DB 오류 일 경우 DB_0303
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
      
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
</head>
<body>

</body>
</html>