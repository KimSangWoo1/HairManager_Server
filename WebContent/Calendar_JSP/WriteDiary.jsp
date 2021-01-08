<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR" import="Calendar.*, java.util.*"%>
<%@ page import="java.io.*" %>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="Common.*" %>

<%
	request.setCharacterEncoding("UTF-8");
	if(request.getMethod().equals("POST")){
		
		// ���� ���� �� üũ�ϱ� ���� bool����
		boolean diaryInsert = false;  //�ϱ� DB����
		boolean notifyInsert = false;  //�˸� DB����
		boolean photoInsert = false;  //���� DB����
		boolean photoFileCreate =false; //���� ���� 
		//boolean photoFileMovedError =false;  //���� �̵�
		
		//DB ������ Data Object
		WriteDiaryDAO dao = new WriteDiaryDAO();
		DiaryDTO dto = new DiaryDTO();
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
			//���� �̹��� ����� ��� ������ �Ǿ��ִ��� Ȯ��
			FileManager.FileCheck(imageDataPath);
			
			MultipartRequest multi = new MultipartRequest( // MultipartRequest �ν��Ͻ� ����(cos.jar�� ���̺귯��)
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
				System.out.println("POST PARAMETER ���� NULL!!");
				out.println(result); 
			}else{
				System.out.println(json);
				
				//���� ���� ������ �Ľ��ϱ�
				dto = JDataParser.Request_Calendar_003(json);	
				
				// �ۼ� ������ ����� ���� üũ�� �� ���� �ڵ� ������ �ƴ� ��� �ۼ�
				//�ش� ��¥ ��� ���� �޾ƿ���
			    int count = dao.CheckWirteOverDiary(dto);
				int totalDiary = dao.TotalDiary(dto);
				int totalNotify = dao.TotalNotify(dto);
				boolean titleOverSize = DataCheck.checkTitle(dto);
				boolean contentOverSize = DataCheck.checkContent(dto);
				
			    //1. �ϱ� �ۼ� ���� ���� �ʰ� API �����ڵ�
				if(titleOverSize){
			    	out.println(API_ResponseCode.API_CA_0001());
			    	System.out.println("���� ���� �ʰ� : "+totalDiary);
			    }
				 //2. �ϱ� �ۼ� ���� ���� �ʰ� API �����ڵ�
				else if(contentOverSize){
			    	out.println(API_ResponseCode.API_CA_0002());
			    	System.out.println("���� ���� �ʰ� : "+totalDiary);
			    }
				 //3. �ش� ��¥ �ϱ� ��� 3���� �Ѿ��� ��� �ϱ� �ۼ� ��� API �����ڵ�
				else if(count>=3){ 
			    	out.println(API_ResponseCode.API_CA_0003());
			    	System.out.println("�Ϸ� �ϱ� ���� ���� �ʰ�: "+count);
			    }
			    //4. ��ü �ϱ� ���� ������ 1100���� �Ѿ��� ��� API �����ڵ�
			    else if(totalDiary>=1100){
			    	out.println(API_ResponseCode.API_CA_0004());
			    	System.out.println("��ü �ϱ� ���� ���� �ʰ�: "+totalDiary);
			    }
				//5. ��ü �˸� ���� ������ 100���� �Ѿ��� ��� API �����ڵ�
			    else if(totalNotify >=100 ){
			    	if(dto.isNotifyCheck()){
			    		out.println(API_ResponseCode.API_CA_0006());
		    			System.out.println("��ü �˸� ���� ���� �ʰ�: "+totalNotify);
					}
			    }
			    //���� ����� ���� ���
			    else{
			    	dto = dao.WriteDiaryDB(dto); //���̾ �ۼ�
			    	//DB��� üũ
			    	if(dto.isError()){
			    	 	String result = API_ResponseCode.API_DB_0303();
						out.println(result);
			    	}else{
			    		diaryInsert= true; //���̾ �ۼ� �Ϸ�
						//�˸��� TRUE�� ��츸 �ۼ�
						if(dto.isNotifyCheck()){
							dto = dao.WriteNotifyDB(dto); 	
						  	//DB��� üũ
							if(dto.isError()){
					    	 	String result = API_ResponseCode.API_DB_0303();
								out.println(result);
					    	}else{
					    		notifyInsert = true;  //�˸� ���� �Ϸ�	
					    	}					
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
				//�۾� ������ �ƴϾ��� ���
				else{
					//������ ����� ���� DB�� �ֱ�
					if(files.size()!=0||files!=null){
						String filename = null;
						File file = null;
						File newFile = null;
						String imageURL = null;
					
						for(int i=1; i<=files.size();i++){
							switch(i){
								case 1:
									filename = multi.getFilesystemName("file1");
									file = new File(uploadPath+"\\"+filename);								
									newFile = new File(imageDataPath+"\\"+dto.getDiaryID()+"_"+i+".jpg"); //���� ������ ���� ����
									//���� ������ ���Ͽ� ���� ���� ���� return : ���� ���
									imageURL = FileManager.RenameMoveFile(file, newFile,"MIF_Calendar_003"); 	
									//DB�� ����� �ּҷ� ���� ����
									dto.setPhotoOne(imageURL);
									System.out.println("�����ּ� : "+dto.getPhotoOne());							
																
									break;
								case 2:
									filename = multi.getFilesystemName("file2");
									file = new File(uploadPath+"\\"+filename); 
									newFile = new File(imageDataPath+"\\"+dto.getDiaryID()+"_"+i+".jpg"); //���� ������ ���� ����
									//���� ������ ���Ͽ� ���� ���� ���� return : ���� ���
									imageURL = FileManager.RenameMoveFile(file, newFile,"MIF_Calendar_003");							
									dto.setPhotoTwo(imageURL);
									System.out.println("�����ּ� : "+dto.getPhotoTwo());										
																	
									break;
								case 3:
									filename = multi.getFilesystemName("file3");
									file = new File(uploadPath+"\\"+filename); 
									newFile = new File(imageDataPath+"\\"+dto.getDiaryID()+"_"+i+".jpg"); //���� ������ ���� ����
									//���� ������ ���Ͽ� ���� ���� ���� return : ���� ���
									imageURL = FileManager.RenameMoveFile(file, newFile,"MIF_Calendar_003");								
									dto.setPhotoThree(imageURL);
									System.out.println("�����ּ� : "+dto.getPhotoThree());											
																
									break;
								case 4:
									filename = multi.getFilesystemName("file4");
									file = new File(uploadPath+"\\"+filename); //���� ������ ���� ����								
									newFile = new File(imageDataPath+"\\"+dto.getDiaryID()+"_"+i+".jpg"); //���� ������ ���� ����
									//���� ������ ���Ͽ� ���� ���� ���� return : ���� ���
									imageURL = FileManager.RenameMoveFile(file, newFile,"MIF_Calendar_003");
									dto.setPhotoFour(imageURL);
									System.out.println("�����ּ� : "+dto.getPhotoFour());									
									break;						
							}
						}
						//���� ����
						dto = dao.WritePhotoDB(dto);
						//���� DB ���� �۾��� ���� �� ���
						if(dto.isError()){
					  	 	String result = API_ResponseCode.API_DB_0303();
							out.println(result);
						}else {
							photoInsert=true; //���� ���� �Ϸ�							
						}
			
					}else{
							System.out.println("������ �����ϴ�.");
					}
					//���� ��� �� ������
					out.println(JDataParser.Response_Calendar_003());		
				}				
			}
		 }catch(IOException e){
			  //6. ���� �����Ͱ� �ʹ� Ŭ ��� API �����ڵ�
		 	  String result = API_ResponseCode.API_CA_0005();
		 	  out.println(result);
			  e.printStackTrace();
		 }catch(Exception e){

			 //��� ���� ������ DB�� ����� ������ �����ϱ�
			 DeleteDiaryDAO deleteDAO = new DeleteDiaryDAO();

			 //���� ������ ���� ���
			 if(photoFileCreate ){
				 //���ε� ���� ����
				files = FileManager.MakeImages(multiBackup);
				FileManager.DeleteUploadImages(files);
			 }

			 //DB�� ���� ����
			 if(photoInsert){
				deleteDAO.DeletePhoto(dto.getDiaryID());
			 }
			//DB�� �˸� ����
			 if(notifyInsert){
				deleteDAO.DeleteNotify(dto.getUserNO(), dto.getDiaryID(), dto.getDiaryDate());
				 
			 }
			//DB�� �ϱ� ����
			 if(diaryInsert){
				 deleteDAO.DeleteDiary(dto);				 
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
<title>�ϱ� �ۼ��� �̹��� ���ε�</title>
</head>
<body>
OKHTTP3
</body>
</html>