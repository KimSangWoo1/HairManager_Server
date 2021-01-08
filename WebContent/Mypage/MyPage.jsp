<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR" import="Mypage.* , java.util.* , Common.*"%>

<%
int userNO;      //���� ��ȣ (PK)
String userEmail;
String userProfile;

request.setCharacterEncoding("UTF-8"); // Set Chracter 
//GET ���� ��
if(request.getMethod().equals("GET")){
   try{
      System.out.println("ȸ�� �⺻ ���� GET!!");
      
      System.out.println("���� : " + request.getServerName());
      System.out.println("��Ʈ��ȣ : " + request.getServerPort());
      System.out.println("��û��� : " + request.getMethod());
      System.out.println("�������� : " + request.getProtocol());
      System.out.println("URL : " + request.getRequestURL());
      System.out.println("URI : " + request.getRequestURI());
     
      //Get Parmater �ޱ�
      userNO = Integer.parseInt(request.getParameter("userNO"));
      if(userNO==0){
			String result = API_ResponseCode.API_SY_0002();
			System.out.println("Get PARAMETER ���� NULL!!");
			out.println(result); 
      }else{
          // ���� ����
          MyPageDAO dao = new MyPageDAO();
          UserProfileDTO dto = new UserProfileDTO();
          //ȸ�� ������ ���� ��������
          dto = dao.MyPageInformation(userNO);
          if(dto!=null){
             //ȸ�� ������ ���� JSON ���� �����
             String json = JDataParser.Response_MyPage_001(dto);            
             System.out.println(json);
             out.println(json);    
          }
          //DB ���� �� ��� DB_0303
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
<title>����������</title>
</head>
<body>

</body>
</html>