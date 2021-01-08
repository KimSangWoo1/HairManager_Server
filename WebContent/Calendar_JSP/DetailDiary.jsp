<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR" import="Calendar.*, java.util.*"%>
<%@ page import="org.json.simple.*" %>
<%@ page import="java.io.*" %>
<%@ page import="org.json.simple.parser.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="Common.*" %>
<%
	
	//���̾
	int userNO;
	int diaryID;
	String diaryDate;
	String diaryTitle;
	String diaryContent;
	boolean notifyCheck;
	//����
	String photoOne;
	String photoTwo;
	String photoThree;
	String photoFour;
	//�˸�
	int notifyID;
	String notifyDate;
	String notifyTime;

	request.setCharacterEncoding("UTF-8"); // Set Chracter 
	//GET ���� ��
	if(request.getMethod().equals("GET")){
		try{
			System.out.println("Android Detail Diary GET!!");		
			System.out.println("���� : " + request.getServerName());
			System.out.println("��Ʈ��ȣ : " + request.getServerPort());
			System.out.println("��û��� : " + request.getMethod());
			System.out.println("�������� : " + request.getProtocol());
			System.out.println("URL : " + request.getRequestURL());
			System.out.println("URI : " + request.getRequestURI());
			
			//Get �Ķ���� ���� �ޱ�
			int _userNO = Integer.parseInt(request.getParameter("userNO"));
			int _diaryID = Integer.parseInt(request.getParameter("diaryID"));
			String _diaryDate = request.getParameter("date");
			
			//�̻��� ���� ���� �� ���� �ڵ� ������
			if(_userNO==0||_diaryID==0||_diaryDate==null) {
				String result = API_ResponseCode.API_SY_0002();
				System.out.println("Get PARAMETER ���� NULL!!");
				out.println(result); 
			}
			//���� ���� ���� �� �ڵ� ����
			else {			
				//�ϱ� �� DAO, DTO ,���� ó��		
				DetailDiaryDAO dao= new DetailDiaryDAO();					
				DiaryDTO dto = dao.DetailDiary(_userNO, _diaryID, _diaryDate);	
				//DB���� ���������� ������ �������� ���
				if(dto!=null){
					String json = JDataParser.Response_Calendar_002(dto);
					System.out.println(json.toString());
					out.println(json.toString()); //��� ������	  
				}
				//DB_0303 DB ���� ���� ��
				else{
					 String result = API_ResponseCode.API_DB_0303();
					 out.println(result);
				}							
			}

		}catch(NumberFormatException e){
			System.out.println("�� �ϱ� ���� ��ȸ ����");
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
<title>�� �ϱ� ����</title>
</head>
<body>

</body>
</html>