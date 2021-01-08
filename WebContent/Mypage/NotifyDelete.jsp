<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="Mypage.*, java.util.*"%>

<%
	request.setCharacterEncoding("utf-8");
String json = request.getParameter("json"); // 앱에서 JSON 파일 가져오기

System.out.println("앱에서온 삭제 데이터 :" + json);

NotifyDeleteDAO ndd = new NotifyDeleteDAO();
List<NotifyDTO> notifyList = ndd.JsonParser(json);

if (notifyList.size() != 0) {
	ndd.DeletetNotifyData(notifyList);
	ndd.UpdateDiaryNotifyCheck(notifyList);
} else {
	System.out.println("앱에서온 삭제 데이터가 없습니다. or 오류가 발생했습니다.");
}
%>