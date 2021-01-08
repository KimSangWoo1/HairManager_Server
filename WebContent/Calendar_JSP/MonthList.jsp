<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR" import="Calendar.*, java.util.*"%>
<%@ page import="org.json.simple.*" %>
<%@ page import="java.io.*" %>
<%@ page import="Common.*" %>
<%@ page import="org.json.simple.parser.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%

   request.setCharacterEncoding("UTF-8"); // Set Chracter 
   //GET ���� ��
   if(request.getMethod().equals("GET")){
      try{
         System.out.println("Ķ���� ����!!");
       
         System.out.println("���� : " + request.getServerName());
         System.out.println("��Ʈ��ȣ : " + request.getServerPort());
         System.out.println("��û��� : " + request.getMethod());
         System.out.println("�������� : " + request.getProtocol());
         System.out.println("URL : " + request.getRequestURL());
         System.out.println("URI : " + request.getRequestURI());
         
         CalendarDAO dao= new CalendarDAO();   
         //API MIF-Calnedar-001
         JSONObject json = new JSONObject(); // All data ..������ ���� ��ü Json �׸�
         JSONArray jsonDiaryListArray = new JSONArray(); //diary list (Key) ..���̾ �� Json ������ �׸�
         JSONObject jsonData = new JSONObject(); // data (Key) ..Response ������ ���� �׸� [diary List ���Ե�]
		
         //�ڵ� Class���� �������� --���� �ʿ�
         json.put("code","SY_2000");
         json.put("message","SUCCESS");
         
         //Get �Ķ���� ���� �ޱ�
         int _userNO = Integer.parseInt(request.getParameter("userNO")); 
         String _diaryMonth = request.getParameter("month"); 
         //Parameter ����
         if(_userNO==0||_diaryMonth==null){
        		String result = API_ResponseCode.API_SY_0002();
				System.out.println("Get PARAMETER ���� NULL!!");
				out.println(result); 
         }
         //���� ����
         else{
        	    //������DB Date�� �����ϱ� ���� String ��ȯ    
        	 String[] array = _diaryMonth.split("-");
             String Year= array[0];
             String Month=array[1];
             String Day= array[2];
            
             String qureyMonth=Year+"-"+Month+"-"+"%"; // ���� % �� ����          
             List<CalendarDTO> datas=dao.SelectMonth(_userNO,qureyMonth);
             
             if(datas!=null){
          	   for(CalendarDTO dto: datas){
                     JSONObject jsonDiary = new JSONObject();
                     jsonDiary.put("diaryDate",dto.getDiaryDate());
                     jsonDiary.put("diaryNO",dto.getDiaryNO());
                     jsonDiary.put("title",dto.getTitle());            
                     jsonDiaryListArray.add(jsonDiary); //���̾ �迭�� �Ѱ��� �ֱ�                  
                  }   
                  
                  jsonData.put("diaryList",jsonDiaryListArray); //���̾ �迭 �ֱ�
                  jsonData.put("total",datas.size());// ��ü ������ ���� �ֱ�
                  json.put("data",jsonData); //�� data �� �־��ֱ�
                  System.out.println("�� : "+json.toString());
                  out.println(json.toString());              
           
             }
             //DB ������ ���
             else{
          	   String result = API_ResponseCode.API_DB_0303();
			   out.println(result);
             }
         }       
         }catch(NumberFormatException e){
        	//500 Error
 		    String result = API_ResponseCode.API_HTTP_500();
 		    out.println(result);
            System.out.println("Ķ���� ���� ��ȸ ����");
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
<title>Ķ���� �޷� ���� ��ȯ</title>
</head>
<body>
HELLO
</body>
</html>