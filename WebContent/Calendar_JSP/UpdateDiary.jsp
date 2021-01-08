<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR" import="Calendar.*, java.util.*"%>
<%@ page import="org.json.simple.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="Common.*" %>

<%
	request.setCharacterEncoding("UTF-8");

	if(request.getMethod().equals("POST")){		
		// ���� ���� �� üũ�ϱ� ���� bool����
		boolean diaryUpdate = false;  //�ϱ� DB����
		boolean notifyUpdate = false;  //�˸� DB����
		boolean photoUpdate = false;  //���� DB����
		boolean photoFileCreate =false; //���� ���� 
		//boolean photoFileMovedError =false;  //���� �̵�
		
		//DB ������ Data Object
		WriteDiaryDAO dao = new WriteDiaryDAO();
		DiaryDTO dto = new DiaryDTO();
		DiaryDTO backupDTO = new DiaryDTO(); //����� DTO
		List<File> files = new ArrayList<>(); //���� ���ϵ�
		MultipartRequest multiBackup= null;
		
		try{
		System.out.println("Write Diary POST!!");
	
		System.out.println("���� : " + request.getServerName());
		System.out.println("��Ʈ��ȣ : " + request.getServerPort());
		System.out.println("��û��� : " + request.getMethod());
		System.out.println("�������� : " + request.getProtocol());
		System.out.println("URL : " + request.getRequestURL());
		System.out.println("URI : " + request.getRequestURI());
			
		//�ۿ��� ������ �̹��� ���۽� �ӽ� ����� ����
		String uploadPath = request.getRealPath("upload"); 
		//�������� ���������� ����� �̹��� �����Ͱ� �ִ� ����
		String imageDataPath = request.getRealPath("hm_image_data"); 
		//���� �̹��� ����� ��� ������ �Ǿ��ִ��� Ȯ�� - ������ ����
		FileManager.FileCheck(imageDataPath);
		
		// MultipartRequest �ν��Ͻ� ����(cos.jar�� ���̺귯��)
		MultipartRequest multi = new MultipartRequest( 
				request, 
				uploadPath, // ������ ������ ���丮 ����
				100 * 1024*1024, // ÷������ �ִ� �뷮 ����(bite) / 100MB / �뷮 �ʰ� �� ���� �߻�
				"utf-8", // ���ڵ� ��� ����
				new DefaultFileRenamePolicy() // �ߺ� ���� ó��(������ ���ϸ��� ���ε�Ǹ� �ڿ� ���� ���� �ٿ� �ߺ� ȸ��)
		);
		
		//���� ���� �� multiBackup ���
		multiBackup=multi;		
		photoFileCreate = true; //���� ���� �Ϸ�
		//****************************���������� �Ϸ� **********************************
		
		//�Ķ���� �ޱ�
		String json = multi.getParameter("json");
		if(json==null){
			String result = API_ResponseCode.API_SY_0002();
			System.out.println("Get PARAMETER ���� NULL!!");
			out.println(result); 
		}else{
			
		
			System.out.println(json);				
			//���޹��� ������ �Ľ��Ͽ� dto�� �ֱ�
			dto = JDataParser.Request_Calendar_004(json);
			
			//��� �غ�
			DetailDiaryDAO backupDAO = new DetailDiaryDAO();
			backupDTO =  backupDAO.DetailDiary(dto.getUserNO(),dto.getDiaryID() , dto.getDiaryDate());
			
			int count = dao.CheckWirteOverDiary(dto);//�ش� ��¥ ��� ���� �޾ƿ���
			int totalDiary = dao.TotalDiary(dto); //�ϱ� �� ���� �޾ƿ���
			int totalNotify = dao.TotalNotify(dto); //�˸� �� ���� �޾ƿ���
			boolean dateIndiary = dao.DateInDiary(dto); //���� ��¥ �ϱ����� üũ
			boolean titleOverSize = DataCheck.checkTitle(dto); //���� ���� �ʰ� ���� üũ
			boolean contentOverSize = DataCheck.checkContent(dto); //���� ���� �ʰ� ���� üũ
				
			 //1. �ϱ� ���� ���� ���� �ʰ� API �����ڵ�
			if(titleOverSize){
		    	out.println(API_ResponseCode.API_CA_0001());
		    	System.out.println("���� ���� �ʰ� : "+totalDiary);
			}
			 //2. �ϱ� ���� ���� ���� �ʰ� API �����ڵ�
			else if(contentOverSize){
		    	out.println(API_ResponseCode.API_CA_0002());
		    	System.out.println("���� ���� �ʰ� : "+totalDiary);
		    }
			 //3.�ٸ� ��¥���� �ۼ��� �ϱⰡ  �̹� 3���� �ִ� ��¥�� ������ ��� �ϱ� �ۼ� ��� API �����ڵ�
			else if(count>=3 && !dateIndiary){ 
		    	out.println(API_ResponseCode.API_CA_0003());
		    	System.out.println("�Ϸ� �ϱ� ���� �ʰ�: "+count);
		    }    
			//4. ��ü �˸� ���� ������ 100���� �Ѿ��� ��� API �����ڵ�
			else if(totalNotify >=100 ){
			    	if(dto.isNotifyCheck()){
			    		out.println(API_ResponseCode.API_CA_0006());
		    			System.out.println("��ü �˸� ���� ���� �ʰ�: "+totalNotify);
					}
		    }
		    //���� ����� ���� ���
		    else{
		    	//�ϱ� �����ϱ�
		    	dto = dao.UpdateDiaryDB(dto); 		
		    	//�˸� �������� üũ�ϱ�
		    	if(dto.isError()){
	    		   String result = API_ResponseCode.API_DB_0303();
				   out.println(result);
		    	}else{
		    		diaryUpdate= true; //���̾ �ۼ� �Ϸ�
		    		
		    		if(dto.isNotifyCheck()){
		    			// 1. �˸� ON -> ON
		    			if(dto.getNotifyID()!=0){
		    				dto = dao.UpdateNotifyDiary(dto);
			    			System.out.println("�˸� ON -> �˸� ON"  +" "+dto.getNotifyID());
		    			}
		    			// 2. �˸� OFF -> ON
		    			else{
		    				//���� �˸� ���̺� ������ �ִ��� Ȯ��
			    			dto= dao.FindNotifyID(dto);
			    			//�˸� ���̺��� �����Ͱ� ���� ��� ����
			    			if(dto.getNotifyID()!=0){
			    				dto = dao.UpdateNotifyDiary(dto);
			    			}
			    			//���� �˸� ���̺��� �����Ͱ� ���� ��� ����
			    			else{
			    				dto = dao.WriteNotifyDB(dto);  				
			    			}
			    			System.out.println("�˸� OFF -> �˸� ON"  +" "+dto.getNotifyID());
		    			}		    			
		    		}else{
		    			// ?? -> OFF �� TBL_Notify���� notify_switch �� �����Ѵ� (��¥ �ð��� ������ �ʿ�� ����)
		    			dto= dao.FindNotifyID(dto);
		    			dto = dao.UpdateNotifySwitch(dto);
		    			System.out.println("�˸� ??? -> �˸� OFF"  +" "+dto.getNotifyID());
		  
		    		}		
		    		//�˸� DB �Դ� �����ϱ� �ѹ� �� �˻� 
		    	   	if(dto.isError()){
		    		   String result = API_ResponseCode.API_DB_0303();
					   out.println(result);
		    		}else{
		    			//�˸� ���� �Ϸ�	
		    			notifyUpdate = true;  
		    		}
		   	 	}	
		    }
			
			//****************************���̾ , �˸� ������ �Ϸ� **********************************	
			//�̹��� ����Ʈ ���� 
			files = FileManager.MakeImages(multi);
			
			//������ �۾� ���� ���� �� ������ ����� ���� ����
			if(dto.isError() ||titleOverSize||count>=3||contentOverSize||totalDiary>=1100||totalNotify >=100){
				FileManager.DeleteUploadImages(files);
				if(dto.isError()){
					String result = API_ResponseCode.API_DB_0303();
					out.println(result);
				}					
				return; //jsp ����
			}
			//DB�۾� ������ �ƴϾ��� ���
			else{
				int imageCount=0; //������ ī��Ʈ  ex) 4�� -> 1���� ������ ��� ������� ������ ����.
				if(files.size()!=0){
					if(files!=null){
						String filename = null;
						File file = null;
						File newFile = null;
						String imageURL = null;
					
						for(int i=1; i<=files.size();i++){
							switch(i){
								case 1:
									filename = multi.getFilesystemName("file1");
									file = new File(uploadPath+"\\"+filename);
									newFile = new File(imageDataPath+"\\"+dto.getDiaryID()+"_"+i+".jpg");
									//���� �̵�
									imageURL = FileManager.RenameMoveFile(file, newFile,"MIF_Calendar_004");		
									//���� ũ�� üũ
									File filesize = multi.getFile("file1");
									System.out.println("���� ũ�� : " + filesize.length());							
									//���� DTO�� �ֱ�
									dto.setPhotoOne(imageURL);
									System.out.println("�����ּ� : "+dto.getPhotoOne());		
									imageCount++;
									System.out.println("file1");
									break;
								case 2:
									filename = multi.getFilesystemName("file2");
									file = new File(uploadPath+"\\"+filename);
									newFile = new File(imageDataPath+"\\"+dto.getDiaryID()+"_"+i+".jpg");
									//���� �̵�
									imageURL = FileManager.RenameMoveFile(file, newFile,"MIF_Calendar_004");								
									//���� DTO�� �ֱ�
									dto.setPhotoTwo(imageURL);
									System.out.println("�����ּ� : "+dto.getPhotoTwo());			
									imageCount++;
									System.out.println("file2");
									break;
								case 3:
									filename = multi.getFilesystemName("file3");
									file = new File(uploadPath+"\\"+filename);			
									newFile = new File(imageDataPath+"\\"+dto.getDiaryID()+"_"+i+".jpg");
									//���� �̵�
									imageURL = FileManager.RenameMoveFile(file, newFile,"MIF_Calendar_004");						
									//���� DTO�� �ֱ�
									dto.setPhotoThree(imageURL);
									System.out.println("�����ּ� : "+dto.getPhotoThree());		
									imageCount++;
									System.out.println("file3 ");
									break;
								case 4:
									filename = multi.getFilesystemName("file4");
									file = new File(uploadPath+"\\"+filename);
									//���� �̵�
									newFile = new File(imageDataPath+"\\"+dto.getDiaryID()+"_"+i+".jpg");
									imageURL = FileManager.RenameMoveFile(file, newFile,"MIF_Calendar_004");								
									//���� DTO�� �ֱ�
									dto.setPhotoFour(imageURL);
									System.out.println("�����ּ� : "+dto.getPhotoFour());	
									imageCount++;
									System.out.println("file4 ");
									break;						
							}
						}											
					}		
				}
				//Ȥ�� �� ������ ���� ��� �̹��� ī���� üũ 
				else{
					if(dto.getPhotoOne()!=null){
						imageCount++;
					}
					if(dto.getPhotoTwo()!=null){
						imageCount++;
					}
					if(dto.getPhotoThree()!=null){
						imageCount++;
					}
					if(dto.getPhotoFour()!=null){
						imageCount++;
					}
					System.out.println("������ �����ϴ�.");
				}	
				//�ʿ���� ���� �����
				FileManager.DeleteGarbageImage(dto.getDiaryID(), imageCount, imageDataPath);
				//�ϱ� ���� ������Ʈ				
				dto = dao.UpdatePhotoDiary(dto);
				if(dto.isError()){
					String result = API_ResponseCode.API_DB_0303();
					out.println(result);
				}else{
					photoUpdate=true;	//���� ���� �Ϸ�
				}
				//���� ��� �� ������
				out.println(JDataParser.Response_Calendar_004());		
			}
		}
			
		}catch(IOException e){
		   	 //5. ���� �����Ͱ� �ʹ� Ŭ ��� API �����ڵ�
			 String result = API_ResponseCode.API_CA_0005();
			 out.println(result);
		  	 e.printStackTrace();
		}catch(Exception e){
			 //��� ���� ������ DB�� ����� ������ �����ϱ�
			// DeleteDiaryDAO deleteDAO = new DeleteDiaryDAO();

			 //���� ������ ���� ��� (�̹��� ���� ������ �ǰ� �ǻ�� ���� ���� ������ �ű�� ���� �ִ� upload ������ �ִ� �������� ����)
			 if(photoFileCreate){
				 //���ε� ���� ����
				files = FileManager.MakeImages(multiBackup);
				FileManager.DeleteUploadImages(files);
			 }
			 //���� ���Ϸ� ��� (���� ����� ��ǻ� ���� �ȵ� ���� �̹����� �̹� ��ü�Ǿ��ų� �����Ǿ��� ������ ���� ������ ��� ������ �־���� �۾��� �ؾ��� �״��� ������ ������ ��������� �̹����� �������� ������ ������ ��� ������ ������ �����ؾ���)
			 if(photoUpdate || notifyUpdate||diaryUpdate){
				dao.BackUpDiary(backupDTO);
			 }
			
			//500 Error
			 String result = API_ResponseCode.API_HTTP_500();
			 out.println(result);
	 	 	 e.printStackTrace();
		}
	}
%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>�ϱ� ����</title>
</head>
<body>

</body>
</html>