package Common;

import java.net.InetAddress;
//���� ������ IP �ּҸ� �޾ƿ´�
public class NetworkManager {
	public static String getNetworKIP() {
		String ip ="";
		try {
		InetAddress local; 
 		local = InetAddress.getLocalHost();
 		ip = local.getHostAddress(); 
 		System.out.println("local ip : "+ip); 
 	}catch (Exception e1){
			e1.printStackTrace(); 
		}
 	return ip;
	}
	
	/*
	public static String getNetworKPath() {
		String ip =getNetworKIP();
		String newURL = CommonData.getHttp()+NetworkManager.getNetworKIP()+CommonData.getPort()+CommonData.getImagepath();
		return newURL;
	}
	*/
}
