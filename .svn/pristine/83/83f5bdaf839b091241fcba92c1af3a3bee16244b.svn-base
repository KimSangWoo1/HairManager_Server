<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="login.*, java.util.*"%>
<%
	request.setCharacterEncoding("utf-8");
String json = request.getParameter("json"); // 앱에서 JSON 파일 가져오기

OverlapPhoneNODAO op = new OverlapPhoneNODAO();
String user_phoneNO = op.JsonParser(json); // JSON 파싱
String returns = op.OverlapPhoneNOCheck(user_phoneNO); // 핸드폰번호 중복 체크

// 중복이 아닐 경우
if (returns.equals("SY_2000")) {
	out.print("SY_2000");
} // 중복일 경우
else if (returns.equals("LO_0005")) {
	out.print("LO_0005");
} // 알 수 없는 오류
else {
	out.print("x");
}
%>