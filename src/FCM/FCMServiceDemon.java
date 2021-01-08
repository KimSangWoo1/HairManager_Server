package FCM;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import Mypage.NotifyDTO;

/* 
 * FCMServiceDemon Thread ( Notification�� ���� DB�� ����ϴ� Ŭ����  )
 * 1 - ������
 * 2 - stopForever ( �ʿ��� �� Thread�� ������. )
 * 3 - run ( 1�� ������ DB�� ����Ͽ� Notification �̺�Ʈ �߻� ���θ� ��ȸ�Ѵ�. )
 */

public class FCMServiceDemon extends Thread {
	boolean isRun = true;

	// 1 - ������
	public FCMServiceDemon() {
	}

	// 2 - stopForever ( �ʿ��� �� Thread�� ������. )
	public void stopForever() {
		synchronized (this) {
			this.isRun = false;
		}
	}

	// 3 - run ( 1�� ������ DB�� ����Ͽ� Notification �̺�Ʈ �߻� ���θ� ��ȸ�Ѵ�. )
	public void run() {
		// �ݺ������� ������ �۾��� �Ѵ�.
		while (isRun) {

			
			SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd");
			SimpleDateFormat format2 = new SimpleDateFormat("HH:mm:ss");

			Date date = new Date();
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(date);
			

			String notifyDate = format1.format(calendar.getTime());
			String notifyTime = format2.format(calendar.getTime());
			System.out.println("�� ���ư��� �־��~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"+notifyDate+notifyTime);

			NotifyDTO notify = new NotifyDTO();
		
			notify.setNotifyDate(notifyDate);
			notify.setNotifyTime(notifyTime);
			
			SelectFCMDataDAO SFD = new SelectFCMDataDAO();
			
			List<NotifyDTO> notifyList1 = SFD.SelectNotifyData(notify);
			SFD.UpdatetNotifyOnOff(notifyList1);
			List<NotifyDTO> notifyList2 = SFD.SelectDiaryTitle(notifyList1);
			List<NotifyDTO> notifyList3 = SFD.SelectFCMToken(notifyList2);
			
			for(NotifyDTO nd : notifyList3) {
				System.out.println(nd.getToken()+nd.getNotifyTitle());
				try {
					FCMConnecter fpt = new FCMConnecter(nd.getToken());
					fpt.pushFCMNotification(nd.getNotifyTitle());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			try {
				Thread.sleep(60000); // 60�ʾ� ����.
			} catch (Exception e) {
			}
		}
	}
}
