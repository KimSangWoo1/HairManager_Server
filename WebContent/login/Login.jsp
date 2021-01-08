<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="login.*, java.util.*"%>
<%
	request.setCharacterEncoding("utf-8");
String json = request.getParameter("json"); // 앱에서 JSON 파일 가져오기

System.out.println("안드로이드에서 받은 파일" + json);

LoginDAO lo = new LoginDAO();
UserDTO user = lo.JsonParser(json); // JsonParser에서 JSON파일 파싱해서 UserDO에 담기

int userNO = lo.SelectUserNO(user); // User에 있는 email값으로 user_NO 가져와서 userNO에 저장

PasswordDTO pd = lo.SelectDBPassword(userNO); // userNO로 해당 유저의 비밀번호, 비밀번호 키 임시비밀번호, 임시비밀번호 제한시간 가져오기

String code = lo.CheckLogin(user, pd, userNO);

String send = lo.MakeJson(userNO, code, pd);

out.print(send);

//임시비밀번호가 존재할 경우
%>

