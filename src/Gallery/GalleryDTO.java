package Gallery;

/* 
 * Gallery DTO
 */

public class GalleryDTO {
	int userNO = 0; // ���� ������ȣ
	int diaryNO = 0; // �ϱ� ������ȣ
	int pageNO = -1; // ������ ������ �ѹ� ( ����¡�� �� ���ȴ�. )
	String GPhoto = ""; // �ϱ� ��ǥ����
	String GTitle = ""; // �ϱ� ����
	String GDate = ""; // �ϱ� ���� ��¥
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