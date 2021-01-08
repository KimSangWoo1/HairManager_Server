<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR" import="Calendar.*, java.util.*"%>
<%@ page import="org.json.simple.*" %>
<%@ page import="java.io.*" %>
<%@ page import="Common.*" %>
<%@ page import="org.json.simple.parser.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%

   request.setCharacterEncoding("UTF-8"); // Set Chracter 
   //GET 들어올 때
   if(request.getMethod().equals("GET")){
      try{
         System.out.println("캘린더 정보!!");
       
         System.out.println("서버 : " + request.getServerName());
         System.out.println("포트번호 : " + request.getServerPort());
         System.out.println("요청방식 : " + request.getMethod());
         System.out.println("프로토콜 : " + request.getProtocol());
         System.out.println("URL : " + request.getRequestURL());
         System.out.println("URI : " + request.getRequestURI());
         
         CalendarDAO dao= new CalendarDAO();   
         //API MIF-Calnedar-001
         JSONObject json = new JSONObject(); // All data ..데이터 보낼 전체 Json 그릇
         JSONArray jsonDiaryListArray = new JSONArray(); //diary list (Key) ..다이어리 별 Json 데이터 그릇
         JSONObject jsonData = new JSONObject(); // data (Key) ..Response 데이터 담을 그릇 [diary List 포함됨]
		
         //코드 Class에서 가져오기 --수정 필요
         json.put("code","SY_2000");
         json.put("message","SUCCESS");
         
         //Get 파라메터 변수 받기
         int _userNO = Integer.parseInt(request.getParameter("userNO")); 
         String _diaryMonth = request.getParameter("month"); 
         //Parameter 오류
         if(_userNO==0||_diaryMonth==null){
        		String result = API_ResponseCode.API_SY_0002();
				System.out.println("Get PARAMETER 오류 NULL!!");
				out.println(result); 
         }
         //정상 진행
         else{
        	    //마리아DB Date형 쿼리하기 위해 String 변환    
        	 String[] array = _diaryMonth.split("-");
             String Year= array[0];
             String Month=array[1];
             String Day= array[2];
            
             String qureyMonth=Year+"-"+Month+"-"+"%"; // 끝에 % 을 붙임          
             List<CalendarDTO> datas=dao.SelectMonth(_userNO,qureyMonth);
             
             if(datas!=null){
          	   for(CalendarDTO dto: datas){
                     JSONObject jsonDiary = new JSONObject();
                     jsonDiary.put("diaryDate",dto.getDiaryDate());
                     jsonDiary.put("diaryNO",dto.getDiaryNO());
                     jsonDiary.put("title",dto.getTitle());            
                     jsonDiaryListArray.add(jsonDiary); //다이어리 배열로 한개씩 넣기                  
                  }   
                  
                  jsonData.put("diaryList",jsonDiaryListArray); //다이어리 배열 넣기
                  jsonData.put("total",datas.size());// 전체 데이터 길이 넣기
                  json.put("data",jsonData); //총 data 값 넣어주기
                  System.out.println("값 : "+json.toString());
                  out.println(json.toString());              
           
             }
             //DB 오류일 경우
             else{
          	   String result = API_ResponseCode.API_DB_0303();
			   out.println(result);
             }
         }       
         }catch(NumberFormatException e){
        	//500 Error
 		    String result = API_ResponseCode.API_HTTP_500();
 		    out.println(result);
            System.out.println("캘린더 정보 조회 오류");
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
<title>캘린더 달력 정보 반환</title>
</head>
<body>
HELLO
</body>
</html>