<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR" import="Mypage.* , java.util.* , Common.*"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="java.io.*" %>
<%
	int userNO;      //���� ��ȣ (PK)
String imageURL;


request.setCharacterEncoding("UTF-8"); // Set Chracter 
//GET ���� ��
if(request.getMethod().equals("POST")){
	  try{
		   System.out.println("������ ���� ����!!");
		  
		   System.out.println("���� : " + request.getServerName());
		   System.out.println("��Ʈ��ȣ : " + request.getServerPort());
		   System.out.println("��û��� : " + request.getMethod());
   		   System.out.println("�������� : " + request.getProtocol());
		   System.out.println("URL : " + request.getRequestURL());
	       System.out.println("URI : " + request.getRequestURI());
		      
		  String uploadPath = request.getRealPath("upload"); 
		//�������� ���������� ����� �̹��� �����Ͱ� �ִ� ����
		  String profileImagePath = request.getRealPath("user_profile_image"); 
		  
		  //���� �̹��� ����� ��� ������ �Ǿ��ִ��� Ȯ��
		  FileManager.FileCheck(profileImagePath);
	
		  MultipartRequest multi = new MultipartRequest( // MultipartRequest �ν��Ͻ� ����(cos.jar�� ���̺귯��)
			request, 
			uploadPath, // ������ ������ ���丮 ����
			100*1024*1024 , // ÷������ �ִ� �뷮 ����(bite) / 10KB / �뷮 �ʰ� �� ���� �߻�
			"utf-8", // ���ڵ� ��� ����
			new DefaultFileRenamePolicy() // �ߺ� ���� ó��(������ ���ϸ��� ���ε�Ǹ� �ڿ� ���� ���� �ٿ� �ߺ� ȸ��)
	);
	
	String json = multi.getParameter("json");
	System.out.println(json);
	//�����ѹ� �Ľ��ؼ� ��������
	userNO = JDataParser.Request_MyPage_008(json);
	
	//File originalFile = multi.getFile("userProfilePhoto");
	String filename = multi.getFilesystemName("userProfilePhoto");
	//����� ���� �ҷ�����
	File file = new File(uploadPath+"\\"+filename);
	System.out.println("�����̸� : "+filename);
	//���� ����� ���� ��ο� ���� �����ϱ�
	File newFile = new File(profileImagePath+"\\"+userNO+".jpg");
	//���� ���� ����� ��η� �̵��ϱ�
	imageURL = FileManager.RenameMoveFile(file, newFile,"MIF_MyPage_008");		
	
	//DB�� �����ϱ�
	MyPageDAO dao = new MyPageDAO();
	String code = dao.UserProfilePhotoUpdate(imageURL,userNO);
	
	//����� ������
	String result = JDataParser.Response_MyPage_008(code);
	out.println(result);
	   }catch(IOException e){
		   //������ �ʹ� Ŭ ��� API ���� �ڵ�
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
<title>������ ���� ����</title>
</head>
<body>

</body>
</html>