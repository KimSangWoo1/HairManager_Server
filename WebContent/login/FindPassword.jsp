<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="login.*, java.util.*"%>
<%
	request.setCharacterEncoding("utf-8");
String json = request.getParameter("json"); // 어플에서 json 데이터 가져오기

System.out.println("안드로이드에서 받은 파일" + json);

FindPasswordDAO fp = new FindPasswordDAO(); // fp 객체 생성

UserDTO user = fp.JsonParser(json); // json 데이터 UserDO에 값 넣기
int userNO = fp.SelectUserNO(user); // 사용자정보로 UserNO가져오기

String checkresult = fp.CheckPassword(userNO); // UserNO로 패스워드 가져오기

String result = fp.MakeJson(checkresult, userNO); // 어플로 보낼 데이터를 JSON파일로 변환 (오류여부도 확인한다.)

out.print(result);
%>