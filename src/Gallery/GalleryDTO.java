package Gallery;

/* 
 * Gallery DTO
 */

public class GalleryDTO {
	int userNO = 0; // 유저 고유번호
	int diaryNO = 0; // 일기 고유번호
	int pageNO = -1; // 갤러리 페이지 넘버 ( 페이징할 때 사용된다. )
	String GPhoto = ""; // 일기 대표사진
	String GTitle = ""; // 일기 제목
	String GDate = ""; // 일기 저장 날짜
	public int getUserNO() {
		return userNO;
	}
	public void setUserNO(int userNO) {
		this.userNO = userNO;
	}
	public int getDiaryNO() {
		return diaryNO;
	}
	public void setDiaryNO(int diaryNO) {
		this.diaryNO = diaryNO;
	}
	public int getPageNO() {
		return pageNO;
	}
	public void setPageNO(int pageNO) {
		this.pageNO = pageNO;
	}
	public String getGPhoto() {
		return GPhoto;
	}
	public void setGPhoto(String gPhoto) {
		GPhoto = gPhoto;
	}
	public String getGTitle() {
		return GTitle;
	}
	public void setGTitle(String gTitle) {
		GTitle = gTitle;
	}
	public String getGDate() {
		return GDate;
	}
	public void setGDate(String gDate) {
		GDate = gDate;
	}
	

}
