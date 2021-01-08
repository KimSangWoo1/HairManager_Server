<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR" import="Mypage.* , java.util.* , Common.*"%>


<%
	request.setCharacterEncoding("UTF-8"); // Set Chracter 
	//GET ���� ��
	if(request.getMethod().equals("GET")){
	   try{
			System.out.println("ȸ�� ��� ���� ��ȸ GET!!");
			
			System.out.println("���� : " + request.getServerName());
			System.out.println("��Ʈ��ȣ : " + request.getServerPort());
			System.out.println("��û��� : " + request.getMethod());
			System.out.println("�������� : " + request.getProtocol());
			System.out.println("URL : " + request.getRequestURL());
			System.out.println("URI : " + request.getRequestURI());
			//Get �Ķ���� �ޱ�
			int userNO = Integer.parseInt(request.getParameter("userNO"));
			//�̻��� ���� ���� �� ���� �ڵ� ������
			if(userNO==0){
				String result = API_ResponseCode.API_SY_0002();
				System.out.println("Get PARAMETER ���� NULL!!");
				out.println(result); 
			}
			//�Ķ���� �������� ���
			else{
				UserHairInformationDTO dto= new UserHairInformationDTO();
				HairSettingDAO dao = new HairSettingDAO();
				//���� ��� ���� ��������
				dto = dao.UserHairDB(userNO);
				//��� ���� �˻�
				if(dto!=null){
					String json =JDataParser.Response_MyPage_003(dto);
					System.out.println(json);
					out.println(json);	
				}
				//DB ���� ���� ���
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
	//POST�� ���
	else if(request.getMethod().equals("POST")){
	    try{
	        System.out.println("ȸ�� ��� ���� ������Ʈ POST!!");
	        
	        System.out.println("���� : " + request.getServerName());
	        System.out.println("��Ʈ��ȣ : " + request.getServerPort());
	        System.out.println("��û��� : " + request.getMethod());
	        System.out.println("�������� : " + request.getProtocol());
	        System.out.println("URL : " + request.getRequestURL());
	        System.out.println("URI : " + request.getRequestURI());
	        
	        String json = request.getParameter("json");
	        //�Ķ���� ���� ����
	        if(json!=null){
	            UserHairInformationDTO dto= new UserHairInformationDTO();	
		        //JSON �Ľ� �� DTO�� ����
	            dto = JDataParser.Request_MyPage_002(json);
		        
		        //DB���� �� ����
		        HairSettingDAO dao = new HairSettingDAO();
		        String code = dao.UserHairUpdate(dto);
		        
		        //�ڵ忡 ���� ��� �� JSON ���� 
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
<title>ȸ�� ��� ����</title>
</head>
<body>

</body>
</html>