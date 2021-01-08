<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="Gallery.*, java.util.*"%>

<%
	request.setCharacterEncoding("utf-8");
String json = request.getParameter("json"); // 앱에서 JSON 파일 가져오기

System.out.println("앱에서온 삭제 데이터 :" + json);

GalleryDeleteDAO gdd = new GalleryDeleteDAO();
List<String> diaryNOList = gdd.JsonParser(json); // 앱에서 온 json데이터를 파싱한다.

// 앱에서 온 데이터가 없을 경우 DB와 통신을 하지 않는다. 
// 앱에서 온 데이터가 있을 때만 DB와 연결하게 데이터를 삭제한다.
if (diaryNOList.size() != 0) { // 외래키 때문에 삭제 순서 중요함.
	gdd.DeletetPhotoData(diaryNOList); // 사진 데이터 삭제 
	gdd.DeletetDiaryData(diaryNOList); // 일기 데이터 삭제
	gdd.DeletetNotifyData(diaryNOList); // 알림 데이터 삭제.
}
%>