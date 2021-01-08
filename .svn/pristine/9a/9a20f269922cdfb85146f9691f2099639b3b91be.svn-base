package Common;

import Calendar.DiaryDTO;

public class DataCheck {
	 // 제목 길이가 DB 데이터 크기보다 클경우 오류 방지 하기 위해
	  public static boolean checkTitle(DiaryDTO dto) {
		  	boolean result =false;
	        int size = dto.getDiaryTitle().getBytes().length;
	        //최대 33자 - 한글기준
	        if (size > 100) {
	            return true;
	        } 
	  
	        return result;
	    }
	// 내용 길이가 DB 데이터 크기보다 클경우 오류 방지 하기 위해
	  public static boolean checkContent(DiaryDTO dto) {
		  	boolean result =false;
	        int size = dto.getDiaryContent().getBytes().length;
	        //최대 5,592,405자 - 한글기준
	        if (size > 16777215) {
	            return true;
	        } 
	  
	        return result;
	    }
	    // String 값이 비었는지 검사해준다.
	    public static boolean checkNPE(String str) {
	        return str == null || str.trim().isEmpty();
	    }
}
