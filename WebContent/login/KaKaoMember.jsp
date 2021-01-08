<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="login.*, java.util.*"%>
<%
	request.setCharacterEncoding("UTF-8");
%>
<%
	String json = request.getParameter("json"); // 어플에서 json데이터 수신

KakaoMemberDAO kmd = new KakaoMemberDAO(); //객체 생성

System.out.println("안드로이드에서 받은 파일" + json);

UserDTO user = kmd.JsonParser(json); // json데이터 파싱 user에 담기

int result = kmd.OverlapKakaoEmailCheck(user); // DB에 유저정보가 이미 있는지 확인 없다면 DB에 유저 정보 저장, 있다면 userNO가져와서 앱으로 전송

if (result == 0) {
	System.out.println("성공적으로 저장되었습니다");
	out.print(result);
} else {
	System.out.println("이미 저장된 회원입니다.");
	out.print(result);
}
%>

