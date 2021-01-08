package Calendar;

public class DiaryDTO {
	
	//diary
	int userNO;
	int diaryID;
	String diaryDate;
	String diaryTitle;
	String diaryContent;
	boolean notifyCheck;
	
	//Notify
	int notifyID;
	String notifyDate;
	String notifyTime;
	boolean notifySwitch;

	//Photo
	String photoOne;
	String photoTwo;
	String photoThree;
	String photoFour;
	
	//Error Check;
	boolean error;
	
	public DiaryDTO() {
		this.error = false;
	}
	
	public int getUserNO() {
		return userNO;
	}
	public void setUserNO(int userNO) {
		this.userNO = userNO;
	}
	public int getDiaryID() {
		return diaryID;
	}
	public void setDiaryID(int diaryID) {
		this.diaryID = diaryID;
	}
	public String getDiaryDate() {
		return diaryDate;
	}
	public void setDiaryDate(String diaryDate) {
		this.diaryDate = diaryDate;
	}
	public String getDiaryTitle() {
		return diaryTitle;
	}
	public void setDiaryTitle(String diaryTitle) {
		this.diaryTitle = diaryTitle;
	}
	public String getDiaryContent() {
		return diaryContent;
	}
	public void setDiaryContent(String diaryContent) {
		this.diaryContent = diaryContent;
	}
	public boolean isNotifyCheck() {
		return notifyCheck;
	}
	public void setNotifyCheck(boolean notifyCheck) {
		this.notifyCheck = notifyCheck;
	}
	public void setNotifyCheck(String notifyCheck) {
		if(notifyCheck.equals("true")) {
			this.notifyCheck = true;
		}else {
			this.notifyCheck = false;
		}
	}
	
	
	//notify

	
	public int getNotifyID() {
		return notifyID;
	}
	public void setNotifyID(int notifyID) {
		this.notifyID = notifyID;
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
	public boolean isNotifySwitch() {
		return notifySwitch;
	}
	public void setNotifySwitch(boolean notifySwitch) {
		this.notifySwitch = notifySwitch;
	}
	public void setNotifySwitch(String notifySwitch) {
		if(notifySwitch.equals("true")) {
			this.notifySwitch = true;
		}else {
			this.notifySwitch = false;
		}
	}
	
	//Photo

	public String getPhotoOne() {
		return photoOne;
	}
	public void setPhotoOne(String photoOne) {
		this.photoOne = photoOne;
	}
	public String getPhotoTwo() {
		return photoTwo;
	}
	public void setPhotoTwo(String photoTwo) {
		this.photoTwo = photoTwo;
	}
	public String getPhotoThree() {
		return photoThree;
	}
	public void setPhotoThree(String photoThree) {
		this.photoThree = photoThree;
	}
	public String getPhotoFour() {
		return photoFour;
	}
	public void setPhotoFour(String photoFour) {
		this.photoFour = photoFour;
	}
	
	// Error DTO		
	public boolean isError() {
		return error;
	}
	public void setError(boolean error) {
		this.error = error;
	}
		
}
