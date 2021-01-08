<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="Gallery.*, java.util.*"%>

<%
	request.setCharacterEncoding("utf-8");
String json = request.getParameter("json"); // 앱에서 JSON 파일 가져오기

System.out.println("앱에서온 데이터 :" + json);

// 갤럴리 객체 생성
GalleryDAO gd = new GalleryDAO();
// json 데이터 갤러리 객체에 담기
Gallery.GalleryDTO user = gd.JsonParser(json);

// 일반적인 페이지별로 데이터를 조회 하는 경우 ( -1은 default값으로 검색 데이터를 조회할 때만 나온다. )
if (user.getPageNO() != -1) {
	// 앱에서 보내온 userNO를 토대로 DB에서 일기 고유번호 , 일기 제목 , 일기가 저장된 날짜를 가지고 온다.
	List<Gallery.GalleryDTO> Glist = gd.SelectDiaryData(user);
	// 위에서 갖고온 일기 고유번호를 가지고 해당 일기의 대표사진을 가져온다.
	List<Gallery.GalleryDTO> Glist2 = gd.SelectPhoto(Glist);
	// 일기 대표사진, 일기 제목, 일기 저장 날짜를 Json 형식으로 변환한다.
	String result = gd.MakeJson(Glist2);
	// 어플로 보낸다.
	out.print(result);
// 사용자가 검색한 날짜에 저장된 일기 데이터만을 조회하는 경우
} else {
	// 앱에서 보내온 userNO, 날짜를 토대로 DB에서 일기 고유번호 , 일기 제목을 가지고 온다.
	List<Gallery.GalleryDTO> Glist = gd.SelectSearchData(user);
	// 위에서 갖고온 일기 고유번호를 가지고 해당 일기의 대표사진을 가져온다.
	List<Gallery.GalleryDTO> Glist2 = gd.SelectPhoto(Glist);
	// 일기 대표사진, 일기 제목, 일기 저장 날짜를 Json 형식으로 변환한다.
	String result = gd.MakeJson(Glist2);
	// 어플로 보낸다.
	out.print(result);
}
%>