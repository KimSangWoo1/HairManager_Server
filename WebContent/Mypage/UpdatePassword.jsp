<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="Mypage.*,login.*, java.util.*"%>
<%
	request.setCharacterEncoding("utf-8");
String json = request.getParameter("json"); // 어플에서 json 데이터 가져오기

System.out.println("안드로이드에서 받은 파일" + json);

UpdatePasswordDAO upd = new UpdatePasswordDAO(); // 객체 생성

UserDTO user = upd.JsonParser(json); // json 데이터 파싱

PasswordDTO password = upd.SelectPasswordData(user); // userNO로 DB에서 일반패스워드, 키 , 임시 패스워드 , 키를 가져온다.

String code = upd.CheckPassowrd(password, user); // 앱에서 온 데이터와 DB에서 온 데이터를 비교하여 코드를 반환한다.

// 일치한다면 DB를 업데이트하고 SY_2000을 앱으로 보낸다.
if (code.equals("SY_2000")) {
	String result = upd.UpdatePassword(user);
	System.out.println("업데이트 결과 값 : " + result);
	out.print(code);
	System.out.println(code);
	// 일치하지 않으면 DB를 업데이트하지 않고 경우에 따른 실패코드를 앱으로 보낸다.
} else {
	out.print(code);
	System.out.println(code);
}
%>