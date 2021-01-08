<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="login.*, java.util.*"%>

<%
	request.setCharacterEncoding("utf-8");
String json = request.getParameter("json"); // 앱에서 JSON 파일 가져오기

OverlapEmailDAO oe = new OverlapEmailDAO();
String user_email = oe.JsonParser(json); // JSON데이터 파싱
String returns = oe.OverlapEmailCheck(user_email); // 이메일중복 확인.

// DB에 해당 이메일이 없을 경우
if (returns.equals("SY_2000")) {
	out.print("SY_2000");
} // DB에 해당 이메일이 존재할 경우
else if (returns.equals("LO_0002")) {
	out.print("LO_0002");
} // 알수 없는 오류일 경우
else {
	out.print("x");
}
%>