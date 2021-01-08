package FCM;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;

import org.json.simple.JSONObject;

/* 
 * FCMConnecter ( FCM서버에 Notification 정보를 보내는 클래스 )
 * 1 - 생성자 ( Device Token을 입력받는다. )
 * 2 - pushFCMNotification ( Notification 정보를 실제로 FCM서버에 보낸다. )
 * 3 - connFinish ( 네트워크 연결을 끝낸다. )
 */

public class FCMConnecter {
	// 구글 인증 서버키
	private final String AUTH_KEY_FCM = "AAAA4yZWiL8:APA91bHUD5dsDjuw-i4VlBxg3y3FXka8yrX1gJX1SHfl4osbHNtaQKOnlxubx6oJBChsj-6D_XVygPlEmvbph926TweusJjeT-UiGqE4Fq2QK8PhJ-5ycJLsshVDBXxyf6DgfdwStuML";
	private final String API_URL_FCM = "https://fcm.googleapis.com/fcm/send";
	// 기기별 앱 토큰
	private String userDeviceIdKey;
	private HttpURLConnection conn;
	private OutputStreamWriter wr;
	private BufferedReader br;
	private URL url;

	// 1 - 생성자 ( Device Token을 입력받는다. )
	public FCMConnecter(String token) {
		this.userDeviceIdKey = token;

	}

	/**
	 * 구글서버로 푸시 request pushFCMNotification
	 * 
	 * @throws Exception
	 */

	// 2 - pushFCMNotification ( Notification 정보를 실제로 FCM서버에 보낸다. )
	@SuppressWarnings("unchecked")
	public void pushFCMNotification(String msgBody) throws Exception {

		url = new URL(API_URL_FCM);
		conn = (HttpURLConnection) url.openConnection();
		conn.setUseCaches(false);
		conn.setDoInput(true);
		conn.setDoOutput(true);
		conn.setRequestMethod("POST");
		conn.setRequestProperty("Authorization", "key=" + AUTH_KEY_FCM);
		conn.setRequestProperty("Content-Type", "application/json");

		JSONObject json = new JSONObject();
		JSONObject info = new JSONObject();
		// JSONObject dataJson = new JSONObject();

		info.put("title", "HairManager");
		info.put("body", msgBody); // Notification body
		info.put("sound", "default");

		json.put("notification", info);

		// 디바이스전송 (앱단에서 생성된 토큰키)
		json.put("to", userDeviceIdKey); // deviceID
		// json.addProperty("to", "/topics/" + topicsKey);

		System.out.println("FCM서버로 보내는 JSON 데이터 : " + json.toString());
		try {
			wr = new OutputStreamWriter(conn.getOutputStream(), "UTF-8");
			wr.write(json.toString());
			wr.flush();

		} catch (Exception e) {
			connFinish();
			throw new Exception("OutputStreamException : " + e);
		}

		if (conn.getResponseCode() != HttpURLConnection.HTTP_OK) {
			// 400, 401, 500 등
			connFinish();
			throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
		} else {
			br = new BufferedReader(new InputStreamReader((conn.getInputStream())));

			String output;
			System.out.println("Output from Server .... \n");
			while ((output = br.readLine()) != null) {
				System.out.println(output);
			}
			// 200 + error 는 재전송 등등의 로직
		}
		// }
	}

	// 3 - connFinish ( 네트워크 연결을 끝낸다. )
	private void connFinish() {
		if (br != null) {
			try {
				br.close();
				br = null;
			} catch (IOException e) {
			}
		}
		if (wr != null) {
			try {
				wr.close();
				wr = null;
			} catch (IOException e) {
			}

		}
		if (conn != null) {
			conn.disconnect();
			conn = null;
		}
	}

}
