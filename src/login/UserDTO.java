package login;

/* 
 * User DTO
 */

public class UserDTO {

	private String user_email = ""; // �̸���(���̵�)
	private String user_password = ""; // ��й�ȣ
	private String user_name = ""; // �̸�
	private String user_phoneNO = ""; // �ڵ�����ȣ
	private String user_birthday = ""; // �������
	private String user_sex = ""; // ����
	private String user_key = ""; // ��ȣȭ Ű
	private String user_NO = ""; // ���� ������ȣ;
	private String change_password =""; // ������ ��й�ȣ
	
	public String getUser_email() {
		return user_email;
	}
	public void setUser_email(String user_email) {
		this.user_email = user_email;
	}
	public String getUser_password() {
		return user_password;
	}
	public void setUser_password(String user_password) {
		this.user_password = user_password;
	}
	public String getUser_name() {
		return user_name;
	}
	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}
	public String getUser_phoneNO() {
		return user_phoneNO;
	}
	public void setUser_phoneNO(String user_phoneNO) {
		this.user_phoneNO = user_phoneNO;
	}
	public String getUser_birthday() {
		return user_birthday;
	}
	public void setUser_birthday(String user_birthday) {
		this.user_birthday = user_birthday;
	}
	public String getUser_sex() {
		return user_sex;
	}
	public void setUser_sex(String user_sex) {
		this.user_sex = user_sex;
	}
	public String getUser_key() {
		return user_key;
	}
	public void setUser_key(String user_key) {
		this.user_key = user_key;
	}
	public String getUser_NO() {
		return user_NO;
	}
	public void setUser_NO(String user_NO) {
		this.user_NO = user_NO;
	}
	public String getChange_password() {
		return change_password;
	}
	public void setChange_password(String change_password) {
		this.change_password = change_password;
	}

	
}