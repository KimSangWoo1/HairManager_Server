<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="Mypage.*, java.util.*"%>

<%
	request.setCharacterEncoding("utf-8");
String json = request.getParameter("json"); // 앱에서 JSON 파일 가져오기

System.out.println("앱에서온 데이터 :" + json);

//알람 객체 생성
NotifyDAO nd = new NotifyDAO();
//json 데이터 알람 객체에 담기
NotifyDTO notify = nd.JsonParser(json);

//앱에서 보내온 userNO를 토대로 DB에서 알람 데이터를 가지고 온다.
List<NotifyDTO> Nlist = nd.SelectNotifyData(notify);
//위에서 갖고온 일기 고유번호를 가지고 해당 일기의 제목을 가져온다.
List<NotifyDTO> Nlist2 = nd.SelectDiaryTitle(Nlist);
//데이터를 Json 형식으로 변환한다.
String result = nd.MakeJson(Nlist2);
//어플로 보낸다.
out.print(result);
%>