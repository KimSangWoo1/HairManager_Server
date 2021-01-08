<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR" import="Mypage.* , java.util.* , Common.*"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="java.io.*" %>
<%
	int userNO;      //유저 번호 (PK)
String imageURL;


request.setCharacterEncoding("UTF-8"); // Set Chracter 
//GET 들어올 때
if(request.getMethod().equals("POST")){
	  try{
		   System.out.println("프로필 사진 수정!!");
		  
		   System.out.println("서버 : " + request.getServerName());
		   System.out.println("포트번호 : " + request.getServerPort());
		   System.out.println("요청방식 : " + request.getMethod());
   		   System.out.println("프로토콜 : " + request.getProtocol());
		   System.out.println("URL : " + request.getRequestURL());
	       System.out.println("URI : " + request.getRequestURI());
		      
		  String uploadPath = request.getRealPath("upload"); 
		//서버에서 실질적으로 저장될 이미지 데이터가 있는 폴더
		  String profileImagePath = request.getRealPath("user_profile_image"); 
		  
		  //실제 이미지 저장소 경로 생성이 되어있는지 확인
		  FileManager.FileCheck(profileImagePath);
	
		  MultipartRequest multi = new MultipartRequest( // MultipartRequest 인스턴스 생성(cos.jar의 라이브러리)
			request, 
			uploadPath, // 파일을 저장할 디렉토리 지정
			100*1024*1024 , // 첨부파일 최대 용량 설정(bite) / 10KB / 용량 초과 시 예외 발생
			"utf-8", // 인코딩 방식 지정
			new DefaultFileRenamePolicy() // 중복 파일 처리(동일한 파일명이 업로드되면 뒤에 숫자 등을 붙여 중복 회피)
	);
	
	String json = multi.getParameter("json");
	System.out.println(json);
	//유저넘버 파싱해서 가져오기
	userNO = JDataParser.Request_MyPage_008(json);
	
	//File originalFile = multi.getFile("userProfilePhoto");
	String filename = multi.getFilesystemName("userProfilePhoto");
	//저장된 파일 불러오기
	File file = new File(uploadPath+"\\"+filename);
	System.out.println("파일이름 : "+filename);
	//새로 저장될 파일 경로에 파일 지정하기
	File newFile = new File(profileImagePath+"\\"+userNO+".jpg");
	//기존 파일 저장될 경로로 이동하기
	imageURL = FileManager.RenameMoveFile(file, newFile,"MIF_MyPage_008");		
	
	//DB에 저장하기
	MyPageDAO dao = new MyPageDAO();
	String code = dao.UserProfilePhotoUpdate(imageURL,userNO);
	
	//결과값 보내기
	String result = JDataParser.Response_MyPage_008(code);
	out.println(result);
	   }catch(IOException e){
		   //사진이 너무 클 경우 API 응답 코드
		   String result = API_ResponseCode.API_MP_0001();
		   out.println(result);
		   e.printStackTrace();
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
<title>프로필 사진 수정</title>
</head>
<body>

</body>
</html>