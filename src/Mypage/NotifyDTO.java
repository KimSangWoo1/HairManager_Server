package Mypage;

/* 
 * Notify DTO
 */


public class NotifyDTO {
	private int userNO = 0; // ���� ������ȣ
	private int diaryNO = 0; // �ϱ� ������ȣ
	private int notifyNO = 0; // �˶� ������ȣ
	private int pageNO = -1; // ������ ������ �ѹ� ( ����¡�� �� ���ȴ�. )
	private int Nonoff = -1; // �˶� ���� ����
	private String notifyTitle = ""; // �˶� ����
	private String notifyDate = ""; // �˶� ���� ��¥
	private String notifyTime = ""; // �˶� ���� �ð�
	private String token = "";
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
	public int getNotifyNO() {
		return notifyNO;
	}
	public void setNotifyNO(int notifyNO) {
		this.notifyNO = notifyNO;
	}
	public int getPageNO() {
		return pageNO;
	}
	public void setPageNO(int pageNO) {
		this.pageNO = pageNO;
	}
	public int getNonoff() {
		return Nonoff;
	}
	public void setNonoff(int nonoff) {
		Nonoff = nonoff;
	}
	public String getNotifyTitle() {
		return notifyTitle;
	}
	public void setNotifyTitle(String notifyTitle) {
		this.notifyTitle = notifyTitle;
	}
	public String getNotifyDate() {
		return notifyDate;
	}
	public void setNotifyDate(String notifyDate) {
		this.notifyDate = notifyDate;
	}
	public String getNotifyTime() {
		return notifyTime;
	}
	public void setNotifyTime(String notifyTime) {
		this.notifyTime = notifyTime;
	}
	public String getToken() {
		return token;
	}
	public void setToken(String token) {
		this.token = token;
	}	
}
