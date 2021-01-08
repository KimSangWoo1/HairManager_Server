package Common;

public class CommonData {
	static final private String jdbc_class="org.mariadb.jdbc.Driver";
	static final private String jdbc_url="jdbc:mariadb://121.169.194.198:3306/hairmanager"; 
	static final private String id="planty"; 
	static final private String password="Planty2020"; 
	
	//합성하기 위한 예비용 안쓰는 변수 
	static final private String port=":8080";
	static final private String http="http://";
	static final private String imagePath="/HairManager/hm_image_data/";
	//~~~ 까지 안씀
	
	//이거 상당히 중요한 변수 리눅스로 서버 변경하면 리눅스 absolutePath로 변경해야함.
	static final private String absolutePath ="C:\\Users\\ksw\\eclipse-workspace\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\HairManager\\hm_image_data";
	static final private String imageURL="http://"+NetworkManager.getNetworKIP()+":8080/HairManager/hm_image_data/";
	static final private String profileURL="http://"+NetworkManager.getNetworKIP()+":8080/HairManager/user_profile_image/";
	
	public static String getImageURL() {
		return imageURL;
	}
	public static String getProfileURLL() {
		return profileURL;
	}
	public static String getJdbc_Class() {	
		return jdbc_class;
	}
	public static String getJdbc_Url() {	
		return jdbc_url;
	}
	public static String getDB_ID() {	
		return id;
	}
	public static String getDB_PW() {	
		return password;
	}
	
	public static String getPort() {
		return port;
	}
	public static String getHttp() {
		return http;
	}
	public static String getImagepath() {
		return imagePath;
	}
	public static String getAbsolutePath() {
		return absolutePath;
	}
	
}
