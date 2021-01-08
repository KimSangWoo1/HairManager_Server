package FCM;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/* 
 * FCMExecute ( FCMServiceDemon을 실제로 실행시키는 클래스 )
 * 1 - main ( ??시 ??분 00초에 FCMServiceDemon을 실행시킨다. )
 */

public class FCMExecute {

	//  1 - main ( ??시 ??분 00초에 FCMServiceDemon을 실행시킨다. )
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		while (true) {
			SimpleDateFormat format = new SimpleDateFormat("hh:mm:ss");
			SimpleDateFormat format2 = new SimpleDateFormat("ss");

			Date date = new Date();
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(date);
			
			String startTime = format.format(calendar.getTime());
			String notifyTime = format2.format(calendar.getTime());
			
			// 정확히 00초에 Device에 알람을 보내기 위한 if문
			if (notifyTime.equals("00")) {
				System.out.println("시작!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"+startTime);
				FCMServiceDemon ct = new FCMServiceDemon();
				ct.start();
				return;
			}
			else {
				System.out.println("0초에 돌리고 싶어요~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"+startTime);
			}
		}
	}
}