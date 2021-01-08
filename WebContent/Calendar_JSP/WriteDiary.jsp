<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR" import="Calendar.*, java.util.*"%>
<%@ page import="java.io.*" %>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="Common.*" %>

<%
	request.setCharacterEncoding("UTF-8");
	if(request.getMethod().equals("POST")){
		
		// 오류 있을 시 체크하기 위한 bool변수
		boolean diaryInsert = false;  //일기 DB저장
		boolean notifyInsert = false;  //알림 DB저장
		boolean photoInsert = false;  //파일 DB저장
		boolean photoFileCreate =false; //파일 생성 
		//boolean photoFileMovedError =false;  //파일 이동
		
		//DB 접근할 Data Object
		WriteDiaryDAO dao = new WriteDiaryDAO();
		DiaryDTO dto = new DiaryDTO();
		List<File> files = new ArrayList<>(); //사진 파일들
		MultipartRequest multiBackup= null;
		try{
			System.out.println("Write Diary POST!!");
			
			System.out.println("서버 : " + request.getServerName());
			System.out.println("포트번호 : " + request.getServerPort());
			System.out.println("요청방식 : " + request.getMethod());
			System.out.println("프로토콜 : " + request.getProtocol());
			System.out.println("URL : " + request.getRequestURL());
			System.out.println("URI : " + request.getRequestURI());
			
			//앱에서 서버로 이미지 전송시 임시 저장소 폴더
			String uploadPath = request.getRealPath("upload"); 
			//서버에서 실질적으로 저장될 이미지 데이터가 있는 폴더
			String imageDataPath = request.getRealPath("hm_image_data"); 
			//실제 이미지 저장소 경로 생성이 되어있는지 확인
			FileManager.FileCheck(imageDataPath);
			
			MultipartRequest multi = new MultipartRequest( // MultipartRequest 인스턴스 생성(cos.jar의 라이브러리)
					request, 
					uploadPath, // 파일을 저장할 디렉토리 지정
					100 * 1024*1024, // 첨부파일 최대 용량 설정(bite) / 100MB / 용량 초과 시 예외 발생
					"utf-8", // 인코딩 방식 지정
					new DefaultFileRenamePolicy() // 중복 파일 처리(동일한 파일명이 업로드되면 뒤에 숫자 등을 붙여 중복 회피)
			);
			//오류 있을 시 multiBackup 사용
			multiBackup=multi;		
			photoFileCreate = true; //사진 저장 완료
			//****************************사진저장이 완료 **********************************
			
			//파라메터 받기
			String json = multi.getParameter("json");
			if(json==null){
				String result = API_ResponseCode.API_SY_0002();
				System.out.println("POST PARAMETER 오류 NULL!!");
				out.println(result); 
			}else{
				System.out.println(json);
				
				//전달 받은 데이터 파싱하기
				dto = JDataParser.Request_Calendar_003(json);	
				
				// 작성 실패할 경우의 수를 체크한 뒤 응답 코드 보내기 아닐 경우 작성
				//해당 날짜 기록 갯수 받아오기
			    int count = dao.CheckWirteOverDiary(dto);
				int totalDiary = dao.TotalDiary(dto);
				int totalNotify = dao.TotalNotify(dto);
				boolean titleOverSize = DataCheck.checkTitle(dto);
				boolean contentOverSize = DataCheck.checkContent(dto);
				
			    //1. 일기 작성 제목 길이 초과 API 응답코드
				if(titleOverSize){
			    	out.println(API_ResponseCode.API_CA_0001());
			    	System.out.println("제목 길이 초과 : "+totalDiary);
			    }
				 //2. 일기 작성 제목 길이 초과 API 응답코드
				else if(contentOverSize){
			    	out.println(API_ResponseCode.API_CA_0002());
			    	System.out.println("내용 길이 초과 : "+totalDiary);
			    }
				 //3. 해당 날짜 일기 기록 3개가 넘었을 경우 일기 작성 취소 API 응답코드
				else if(count>=3){ 
			    	out.println(API_ResponseCode.API_CA_0003());
			    	System.out.println("하루 일기 저장 갯수 초과: "+count);
			    }
			    //4. 전체 일기 저장 갯수가 1100개를 넘었을 경우 API 응답코드
			    else if(totalDiary>=1100){
			    	out.println(API_ResponseCode.API_CA_0004());
			    	System.out.println("전체 일기 저장 갯수 초과: "+totalDiary);
			    }
				//5. 전체 알림 저장 갯수가 100개를 넘었을 경우 API 응답코드
			    else if(totalNotify >=100 ){
			    	if(dto.isNotifyCheck()){
			    		out.println(API_ResponseCode.API_CA_0006());
		    			System.out.println("전체 알림 저장 갯수 초과: "+totalNotify);
					}
			    }
			    //실패 요건이 없을 경우
			    else{
			    	dto = dao.WriteDiaryDB(dto); //다이어리 작성
			    	//DB결과 체크
			    	if(dto.isError()){
			    	 	String result = API_ResponseCode.API_DB_0303();
						out.println(result);
			    	}else{
			    		diaryInsert= true; //다이어리 작성 완료
						//알림이 TRUE일 경우만 작성
						if(dto.isNotifyCheck()){
							dto = dao.WriteNotifyDB(dto); 	
						  	//DB결과 체크
							if(dto.isError()){
					    	 	String result = API_ResponseCode.API_DB_0303();
								out.println(result);
					    	}else{
					    		notifyInsert = true;  //알림 저장 완료	
					    	}					
						}	
			    	}		    	
			    }
			    
				//****************************다이어리 , 알림 저장이 완료 **********************************	
				//이미지 리스트 생성 
				files = FileManager.MakeImages(multi);
				
				//위에서 작업 오류 였을 시 서버에 저장된 사진 삭제
				if(dto.isError() ||titleOverSize||count>=3||contentOverSize||totalDiary>=1100||totalNotify >=100){
					FileManager.DeleteUploadImages(files);
					if(dto.isError()){
						String result = API_ResponseCode.API_DB_0303();
						out.println(result);
					}					
					return; //jsp 종료
				}
				//작업 오류가 아니었을 경우
				else{
					//서버에 저장된 파일 DB에 넣기
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
									newFile = new File(imageDataPath+"\\"+dto.getDiaryID()+"_"+i+".jpg"); //새로 저장할 파일 생성
									//새로 저장할 피일에 기존 파일 대입 return : 서버 경로
									imageURL = FileManager.RenameMoveFile(file, newFile,"MIF_Calendar_003"); 	
									//DB에 저장될 주소로 사진 저장
									dto.setPhotoOne(imageURL);
									System.out.println("절대주소 : "+dto.getPhotoOne());							
																
									break;
								case 2:
									filename = multi.getFilesystemName("file2");
									file = new File(uploadPath+"\\"+filename); 
									newFile = new File(imageDataPath+"\\"+dto.getDiaryID()+"_"+i+".jpg"); //새로 저장할 파일 생성
									//새로 저장할 피일에 기존 파일 대입 return : 서버 경로
									imageURL = FileManager.RenameMoveFile(file, newFile,"MIF_Calendar_003");							
									dto.setPhotoTwo(imageURL);
									System.out.println("절대주소 : "+dto.getPhotoTwo());										
																	
									break;
								case 3:
									filename = multi.getFilesystemName("file3");
									file = new File(uploadPath+"\\"+filename); 
									newFile = new File(imageDataPath+"\\"+dto.getDiaryID()+"_"+i+".jpg"); //새로 저장할 파일 생성
									//새로 저장할 피일에 기존 파일 대입 return : 서버 경로
									imageURL = FileManager.RenameMoveFile(file, newFile,"MIF_Calendar_003");								
									dto.setPhotoThree(imageURL);
									System.out.println("절대주소 : "+dto.getPhotoThree());											
																
									break;
								case 4:
									filename = multi.getFilesystemName("file4");
									file = new File(uploadPath+"\\"+filename); //새로 저장할 파일 생성								
									newFile = new File(imageDataPath+"\\"+dto.getDiaryID()+"_"+i+".jpg"); //새로 저장할 파일 생성
									//새로 저장할 피일에 기존 파일 대입 return : 서버 경로
									imageURL = FileManager.RenameMoveFile(file, newFile,"MIF_Calendar_003");
									dto.setPhotoFour(imageURL);
									System.out.println("절대주소 : "+dto.getPhotoFour());									
									break;						
							}
						}
						//사진 저장
						dto = dao.WritePhotoDB(dto);
						//사진 DB 저장 작업시 오류 일 경우
						if(dto.isError()){
					  	 	String result = API_ResponseCode.API_DB_0303();
							out.println(result);
						}else {
							photoInsert=true; //사진 저장 완료							
						}
			
					}else{
							System.out.println("사진이 없습니다.");
					}
					//정상 결과 값 보내기
					out.println(JDataParser.Response_Calendar_003());		
				}				
			}
		 }catch(IOException e){
			  //6. 사진 데이터가 너무 클 경우 API 응답코드
		 	  String result = API_ResponseCode.API_CA_0005();
		 	  out.println(result);
			  e.printStackTrace();
		 }catch(Exception e){

			 //결과 도중 서버와 DB에 저장된 데이터 삭제하기
			 DeleteDiaryDAO deleteDAO = new DeleteDiaryDAO();

			 //파일 생성만 했을 경우
			 if(photoFileCreate ){
				 //업로드 파일 삭제
				files = FileManager.MakeImages(multiBackup);
				FileManager.DeleteUploadImages(files);
			 }

			 //DB에 사진 삭제
			 if(photoInsert){
				deleteDAO.DeletePhoto(dto.getDiaryID());
			 }
			//DB에 알림 삭제
			 if(notifyInsert){
				deleteDAO.DeleteNotify(dto.getUserNO(), dto.getDiaryID(), dto.getDiaryDate());
				 
			 }
			//DB에 일기 삭제
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
<title>일기 작성과 이미지 업로드</title>
</head>
<body>
OKHTTP3
</body>
</html>