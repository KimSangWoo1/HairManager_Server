package FCM;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/* 
 * FCMExecute ( FCMServiceDemon�� ������ �����Ű�� Ŭ���� )
 * 1 - main ( ??�� ??�� 00�ʿ� FCMServiceDemon�� �����Ų��. )
 */

public class FCMExecute {

	//  1 - main ( ??�� ??�� 00�ʿ� FCMServiceDemon�� �����Ų��. )
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
			
			// ��Ȯ�� 00�ʿ� Device�� �˶��� ������ ���� if��
			if (notifyTime.equals("00")) {
				System.out.println("����!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"+startTime);
				FCMServiceDemon ct = new FCMServiceDemon();
				ct.start();
				return;
			}
			else {
				System.out.println("0�ʿ� ������ �;��~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"+startTime);
			}
		}
	}
}