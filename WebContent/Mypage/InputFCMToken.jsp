<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="FCM.*,java.util.*" import="login.*"%>

<%
	request.setCharacterEncoding("utf-8");
String json = request.getParameter("json"); // 앱에서 JSON 파일 가져오기

System.out.println("앱에서온 데이터 :" + json);

InputFCMTokenDAO fpd = new InputFCMTokenDAO();
TokenDTO token = fpd.JsonParser(json);

// 앱에서 디바이스 토큰 값이 왔을 경우
if (!"".equals(token.getToken())) {
	System.out.println("토큰 값이 변경되었습니다.");
	fpd.UpdateFCMToken(token);
} else {
	System.out.println("토큰 값이 안왔습니다.");
}
%>