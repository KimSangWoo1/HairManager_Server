<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="login.*, java.util.*"%>
<%
	request.setCharacterEncoding("utf-8");
//앱에서 온 json파일을 변수json에 저장한다.
String json = request.getParameter("json");

System.out.println("안드로이드에서 받은 파일" + json);

FindEmailDAO fe = new FindEmailDAO();

UserDTO user = fe.JsonParser(json); // json파일을 파싱하여 user에 넣는다.

String user_email = fe.FindEmail(user); // user데이터를 통해서 db에서 해당하는 이메일이 있는지 조회한 후 결과를 반환한다.

String result = fe.MakeJson(user_email); // 어플로 보낼 데이터를 json 형식으로 변경한다. (오류 여부를 확인한다.)

out.print(result); // 어플로 데이터 전송
%>