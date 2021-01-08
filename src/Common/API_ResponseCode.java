package Common;

import org.json.simple.JSONObject;

public class API_ResponseCode {
	
	//Client에서 보낸 파라매터가 올바르지 않을 경우 API 응답
	public static String API_SY_0002() {
		JSONObject json = new JSONObject();		
		
		json.put("code", "SY_0002");
		json.put("message", "FAIL");
		return json.toString();
	}
	
	//DB 작업중 오류 생길 경우 API 응답
	public static String API_DB_0303() {
		JSONObject json = new JSONObject();		
		
		json.put("code", "DB_0303");
		json.put("message", "FAIL");
		return json.toString();
	}
	
	//일기 작성 제목 길이 초과 API 응답 
	public static String API_CA_0001() {
		JSONObject json = new JSONObject();
		//Calendar a Day Diary Three Over Code;
			json.put("code", "CA_0001");
			json.put("message", "Fail");

		return json.toString();
	}

	//일기 작성 내용 길이 초과 API 응답 
	public static String API_CA_0002() {
		JSONObject json = new JSONObject();
		//Calendar a Day Diary Three Over Code;
			json.put("code", "CA_0002");
			json.put("message", "FAIL");

		return json.toString();
	}
	
	//일기 작성 하루 일기 3개 초과 API 응답 
	public static String API_CA_0003() {
		JSONObject json = new JSONObject();
		//Calendar a Day Diary Three Over Code;
			json.put("code", "CA_0003");
			json.put("message", "FAIL");

		return json.toString();
	}
	
	//일기 작성 전체 일기 1100개 초과 API 응답 
	public static String API_CA_0004() {
		JSONObject json = new JSONObject();
		//Calendar Total Diary 1100 Over Code;
			json.put("code", "CA_0004");
			json.put("message", "FAIL");
	
		return json.toString();
	}
	
	//사진 데이터가 너무 커서 한번에 보내지지 않음 API 응답 코드
	public static String API_CA_0005() {
		JSONObject json = new JSONObject();		
		
		json.put("code", "CA_0005");
		json.put("message", "FAIL");
		return json.toString();
	}
	
	//알림 최대 저장 개수 100개 초과 API 응답 코드 
	public static String API_CA_0006() {
		JSONObject json = new JSONObject();		
		
		json.put("code", "CA_0006");
		json.put("message", "FAIL");
		return json.toString();
	}
	
	//사진 이미지가 너무 클경우 API 응답 코드 MP_0001
	public static String API_MP_0001() {
		JSONObject json = new JSONObject();		
		
		json.put("code", "MP_0001");
		json.put("message", "FAIL");
		return json.toString();
	}
	
	//서버 스크립트 오류 API 응답 코드
	public static String API_HTTP_500() {
		JSONObject json = new JSONObject();		
		
		json.put("code", "HTTP_500");
		json.put("message", "FAIL");
		return json.toString();
	}	
}
