package FCM;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import Mypage.NotifyDTO;

/* 
 * FCMServiceDemon Thread ( Notification을 위해 DB와 통신하는 클래스  )
 * 1 - 생성자
 * 2 - stopForever ( 필요할 시 Thread를 끝낸다. )
 * 3 - run ( 1분 단위로 DB와 통신하여 Notification 이벤트 발생 여부를 조회한다. )
 */

public class FCMServiceDemon extends Thread {
	boolean isRun = true;

	// 1 - 생성자
	public FCMServiceDemon() {
	}

	// 2 - stopForever ( 필요할 시 Thread를 끝낸다. )
	public void stopForever() {
		synchronized (this) {
			this.isRun = false;
		}
	}

	// 3 - run ( 1분 단위로 DB와 통신하여 Notification 이벤트 발생 여부를 조회한다. )
	public void run() {
		// 반복적으로 수행할 작업을 한다.
		while (isRun) {

			
			SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd");
			SimpleDateFormat format2 = new SimpleDateFormat("HH:mm:ss");

			Date date = new Date();
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(date);
			

			String notifyDate = format1.format(calendar.getTime());
			String notifyTime = format2.format(calendar.getTime());
			System.out.println("나 돌아가고 있어요~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"+notifyDate+notifyTime);

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
				Thread.sleep(60000); // 60초씩 쉰다.
			} catch (Exception e) {
			}
		}
	}
}
