package Common;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import Calendar.DiaryDTO;
import Mypage.UserHairInformationDTO;
import Mypage.UserProfileDTO;

public class JDataParser {
	
	//�� �ϱ� ���� ���� ���� json �� 
		public static String Response_Calendar_002(DiaryDTO dto) {
			
			//API MIF-Calnedar-002  Response JSON ������ֱ� 
			JSONObject json = new JSONObject(); // All data ..������ ���� ��ü Json �׸�
			
			try {
				JSONArray jsonPhotoListArray = new JSONArray(); //photoList (Key) ..��������Ʈ Json 
				JSONArray jsonNotifyListArray = new JSONArray(); //NotifyList (Key) ..�˸�����Ʈ Json 
				JSONObject jsonData = new JSONObject(); // data (Key) ..Response ������ ���� �׸� [diary List ���Ե�]
				
				json.put("code","SY_2000");
				json.put("message","SUCCESS");
			
				//���̾ �ϱ� JSON�� �ֱ�
				JSONObject jsonDiary = new JSONObject();
				jsonData.put("diaryDate",dto.getDiaryDate());
				jsonData.put("diaryTitle",dto.getDiaryTitle());
				jsonData.put("diaryContent",dto.getDiaryContent());						
				jsonData.put("notifyCheck",dto.isNotifyCheck());
				
				//���̾ ���� JSON�� �ֱ�
				JSONObject jsonPhoto = new JSONObject();
				jsonPhoto.put("photoOne",dto.getPhotoOne());
				jsonPhoto.put("photoTwo",dto.getPhotoTwo());
				jsonPhoto.put("photoThree",dto.getPhotoThree());
				jsonPhoto.put("photoFour",dto.getPhotoFour());
				//jsonPhotoListArray.add(jsonPhoto);
				
				//���̾ �˸� JSON�� �ֱ�
				JSONObject jsonNotify = new JSONObject();
				jsonNotify.put("notifyID",dto.getNotifyID());
				jsonNotify.put("notifySwitch",dto.isNotifySwitch());
				jsonNotify.put("notifyDate",dto.getNotifyDate());
				jsonNotify.put("notifyTime",dto.getNotifyTime());
				//jsonNotifyListArray.add(jsonNotify);
			
				jsonData.put("photoList",jsonPhoto); //���̾ �迭 �ֱ�
				jsonData.put("notify",jsonNotify);// ��ü ������ ���� �ֱ�
				json.put("data",jsonData); //�� data �� �־��ֱ�
					
			}catch(NumberFormatException e){
				System.out.println("�� �ϱ� ���� ��ȸ ����");
			}catch(Exception e){
				e.printStackTrace();
			}
			return json.toString();
		}
		
	//�ϱ� �ۼ��� json �Ľ�
	public static DiaryDTO Request_Calendar_003(String data) {
		
		JSONParser jsonParser = new JSONParser();
		JSONObject jsonObject;
		DiaryDTO dto = new DiaryDTO();
		
		try {
			jsonObject = (JSONObject) jsonParser.parse(data);
			
			dto.setUserNO(Integer.parseInt(jsonObject.get("userNO").toString()));
			dto.setDiaryDate(jsonObject.get("diaryDate").toString());
			dto.setDiaryTitle(jsonObject.get("diaryTitle").toString());
			dto.setDiaryContent(jsonObject.get("diaryContent").toString());
			dto.setNotifyCheck(jsonObject.get("notifyCheck").toString());

			boolean notifyCheck = dto.isNotifyCheck();
		
			if(notifyCheck) {
				JSONObject notifyJsonObject = (JSONObject) jsonObject.get("notify");
				dto.setNotifySwitch(notifyJsonObject.get("notifySwitch").toString());
				dto.setNotifyDate(notifyJsonObject.get("notifyDate").toString());
				dto.setNotifyTime(notifyJsonObject.get("notifyTime").toString());				
			}
			
		} catch (ParseException e) {
			e.printStackTrace();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return dto;
	}
	
	//�ϱ� �ۼ� ���� 
	public static String Response_Calendar_003() {
		JSONObject json = new JSONObject();
		//Calendar a Day Diary Three Over Code;
			json.put("code", "SY_2000");
			json.put("message", "SUCCESS");

		return json.toString();
	}
	
	//�ϱ� ������ json �Ľ�
	public static DiaryDTO Request_Calendar_004(String data) {
		
		JSONParser jsonParser = new JSONParser();
		JSONObject jsonObject;
		DiaryDTO dto = new DiaryDTO();
		
		try {
			jsonObject = (JSONObject) jsonParser.parse(data);
			
			dto.setUserNO(Integer.parseInt(jsonObject.get("userNO").toString()));
			dto.setDiaryID(Integer.parseInt(jsonObject.get("diaryID").toString()));
			dto.setDiaryDate(jsonObject.get("diaryDate").toString());
			dto.setDiaryTitle(jsonObject.get("diaryTitle").toString());
			dto.setDiaryContent(jsonObject.get("diaryContent").toString());
			dto.setNotifyCheck(jsonObject.get("notifyCheck").toString());
			
			boolean notifyCheck = dto.isNotifyCheck();
			JSONObject notifyJsonObject = (JSONObject) jsonObject.get("notify");
			
			if(notifyCheck) {
				dto.setNotifyID(Integer.parseInt(notifyJsonObject.get("notifyID").toString()));;
				dto.setNotifySwitch(notifyJsonObject.get("notifySwitch").toString());
				dto.setNotifyDate(notifyJsonObject.get("notifyDate").toString());
				dto.setNotifyTime(notifyJsonObject.get("notifyTime").toString());		
			}
			
			JSONObject photoJsonObject = (JSONObject) jsonObject.get("photoList");

			String photoOne  =photoJsonObject.get("photoOne").toString();	
			String photoTwo =photoJsonObject.get("photoTwo").toString();
			String photoThree =photoJsonObject.get("photoThree").toString();
			String photoFour =photoJsonObject.get("photoFour").toString();
			
			if(photoOne!=null ||!photoOne.trim().isEmpty()) {
				dto.setPhotoOne(photoJsonObject.get("photoOne").toString());
			}
			if(photoTwo!=null ||!photoTwo.trim().isEmpty()) {
				dto.setPhotoTwo(photoJsonObject.get("photoTwo").toString());
			}
			if(photoThree!=null ||!photoThree.trim().isEmpty()) {
				dto.setPhotoThree(photoJsonObject.get("photoThree").toString());
			}
			if(photoFour!=null ||!photoFour.trim().isEmpty()) {
				dto.setPhotoFour(photoJsonObject.get("photoFour").toString());
			}
			
		}catch(NullPointerException e) {
			e.printStackTrace();
		}
		catch (ParseException e) {
			e.printStackTrace();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return dto;
	}
	
	//�ϱ� ���� ���� ���� json �� 
	public static String Response_Calendar_004() {
		JSONObject json = new JSONObject();
		json.put("code", "SY_2000");
		json.put("message", "SUCCESS");
		return json.toString();
	}
	
	//�ϱ� ������ json �Ľ�
	public static DiaryDTO Request_Calendar_005(String json) {
		
		JSONParser jsonParser = new JSONParser();
		JSONObject jsonObject;
		DiaryDTO dto = new DiaryDTO();
		
		try {
			jsonObject = (JSONObject) jsonParser.parse(json);
			dto.setUserNO(Integer.parseInt(jsonObject.get("userNO").toString()));
			dto.setDiaryDate(jsonObject.get("diaryDate").toString());
			dto.setDiaryID(Integer.parseInt(jsonObject.get("diaryID").toString()));
			
		}catch(Exception e) {
			e.printStackTrace();
		}
	
		return dto;
	}
	
	//�ϱ� ���� ���� ���� json �� 
	public static String Response_Calendar_005(String code) {
		JSONObject json = new JSONObject();
		
		if(code.equals("DB_0303")) {
			json.put("code", code);
			json.put("message", "SUCCESS");
		}else
		{
			json.put("code", "SY_2000");
			json.put("message", "SUCCESS");	
		}
		return json.toString();
	}
	
	//���������� ȸ�� ������ ���� 
	public static String Response_MyPage_001(UserProfileDTO dto) {
		String userName = dto.getUserName();
		String userEmail = dto.getUserEamil();
		String userProfilePhoto = dto.getUserProfilePhoto();
		
		JSONObject json = new JSONObject();
		json.put("code", "SY_2000");
		json.put("message", "SUCCESS");
		
		JSONObject dataJson = new JSONObject();
		dataJson.put("userName", userName);
		dataJson.put("userEmail", userEmail);
		dataJson.put("userProfilePhoto", userProfilePhoto);
		
		json.put("data", dataJson);
		return json.toString();
	}
	
	public static int Request_MyPage_008(String data) {
		
		int userNO=0;
		JSONParser jsonParser = new JSONParser();
		JSONObject jsonObject;	
		try {
			jsonObject = (JSONObject) jsonParser.parse(data);
			userNO = Integer.parseInt(jsonObject.get("userNO").toString());
			
		}catch(Exception e){
			e.printStackTrace();
		}	
		return userNO;
	}
	
	public static UserHairInformationDTO Request_MyPage_002(String data) {
		JSONParser jsonParser = new JSONParser();
		JSONObject jsonObject;
		UserHairInformationDTO dto = new UserHairInformationDTO();
		
		try {
			jsonObject = (JSONObject) jsonParser.parse(data);
			dto.setUserNO(Integer.parseInt(jsonObject.get("userNO").toString()));
			dto.setThinning(Integer.parseInt(jsonObject.get("thinning").toString()));
			dto.setQuality(Integer.parseInt(jsonObject.get("quality").toString()));
			dto.setShape(Integer.parseInt(jsonObject.get("shape").toString()));
			dto.setHairColor(jsonObject.get("hairColor").toString());
			
		}catch(NullPointerException e) {
			e.printStackTrace();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	
		return dto;
	}
	
	public static String Response_MyPage_002(String code) {
		JSONObject json = new JSONObject();
		
		if(!code.equals("DB_0303")) {
			json.put("code", "SY_2000");
			json.put("message", "SUCCESS");
		}else {
			json.put("code", code);
			json.put("message", "FAIL");	
		}
		
		
		return json.toString();
	}
	//ȸ�� ������� ����
	public static String Response_MyPage_003(UserHairInformationDTO dto) {
		JSONObject json = new JSONObject();
		
		int thinning = dto.getThinning();
		int quality = dto.getQuality();
		int shape = dto.getShape();
		String hairColor = dto.getHairColor();
		
		try {
			if(hairColor!=null||!hairColor.trim().isEmpty()) {
				json.put("code", "SY_2000");
				json.put("message", "SUCCESS");
				
				JSONObject dataJson = new JSONObject();
				dataJson.put("thinning", thinning);
				dataJson.put("quality", quality);
				dataJson.put("shape", shape);
				dataJson.put("hairColor", hairColor);
				
				json.put("data", dataJson);
			}else {
				json.put("code", "DB_0303");
				json.put("message", "Fail");
				return json.toString();
			}
		
		}catch(NullPointerException e) {
			e.printStackTrace();
		}catch(Exception e) {
			e.printStackTrace();
		}
	
		return json.toString();
	}
	
	//ȸ�� ������ ���� ���� ����
	public static String Response_MyPage_008(String code) {
	JSONObject json = new JSONObject();
		
		if(!code.equals("DB_0303")) {
			json.put("code", "SY_2000");
			json.put("message", "SUCCESS");
		}else {
			json.put("code", code);
			json.put("message", "FAIL");	
		}
	
		return json.toString();
	}
	
}