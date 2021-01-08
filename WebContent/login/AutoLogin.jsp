<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="login.*, java.util.*"%>
<%
	request.setCharacterEncoding("utf-8");
String json = request.getParameter("json"); // 앱에서 JSON 파일 가져오기

System.out.println("안드로이드에서 받은 파일" + json);

AutoLoginDAO alo = new AutoLoginDAO();

UserDTO user = alo.JsonParser(json); // JsonParser에서 JSON파일 파싱해서 UserDO에 담기

int userNO = alo.SelectUserNO(user); // User에 있는 email값으로 user_NO 가져와서 userNO에 저장

PasswordDTO pd = alo.SelectDBPassword(userNO); // userNO로 해당 유저의 비밀번호, 비밀번호 키 임시비밀번호, 임시비밀번호 제한시간 가져오기

String code = alo.CheckLogin(user, pd, userNO);

String send = alo.MakeJson(userNO, code, pd);

// 왜 json 보내면 json 파싱을 못하는지 이해를 못하겠다..
out.print(send);

//임시비밀번호가 존재할 경우
%>

