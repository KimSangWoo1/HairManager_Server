<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="Calendar.*, java.util.*"%>
<%@ page import="java.io.*" %>
<%@ page import="Common.*" %>

<%
request.setCharacterEncoding("UTF-8");

if(request.getMethod().equals("POST")){
	try{
		System.out.println("���� : " + request.getServerName());
		System.out.println("��Ʈ��ȣ : " + request.getServerPort());
		System.out.println("��û��� : " + request.getMethod());
		System.out.println("�������� : " + request.getProtocol());
		System.out.println("URL : " + request.getRequestURL());
		System.out.println("URI : " + request.getRequestURI());
		//Parameter �ޱ�
		String json = request.getParameter("json");
		
		//�ʿ� ���� ����
		String code;
		String responseJson;
		
		if(!DataCheck.checkNPE(json)){
			//�ϱ� DAO ,DTO ����
			DiaryDTO dto = new DiaryDTO();
			DeleteDiaryDAO dao = new DeleteDiaryDAO();
			DetailDiaryDAO detailDAO = new DetailDiaryDAO();
			
			dto = JDataParser.Request_Calendar_005(json);
			dto = detailDAO.DetailDiaryPhoto(dto,2);
			//���� ���� �������� ���� ���� �ϱ�
			FileManager.DeleteAll(dto);
			//�ϱ� ���� �ϱ�(�ϱ�,�˸�,����)	
			code = dao.DeleteAll(dto);
			
			//�ϱ� ���� ��� �� ��������
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