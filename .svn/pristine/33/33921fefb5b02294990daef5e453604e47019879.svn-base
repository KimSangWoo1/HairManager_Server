package Common;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.oreilly.servlet.MultipartRequest;

import Calendar.CalendarDAO;
import Calendar.DiaryDTO;
import Calendar.WriteDiaryDAO;

public class FileManager {
	//이미지 저장할 폴더 생성
	public static void FileCheck(String path) {
		File Folder = new File(path);
		// 해당 디렉토리가 없을경우 디렉토리를 생성합니다.
		
		if (!Folder.exists()) {
			try{
			    Folder.mkdir(); //폴더 생성합니다.
			    System.out.println("폴더가 생성되었습니다.");
		    } 
		    catch(Exception e){
			    e.getStackTrace();
			}         
	    }   
		else {
			System.out.println("이미 폴더가 생성되어 있습니다.");
        }
		
	}
	//이미지 파일 리스트 만들기
	public static List<File> MakeImages(MultipartRequest multi){		
		//파일 생성
		File file1 = multi.getFile("file1");
		File file2 = multi.getFile("file2");
		File file3 = multi.getFile("file3");
		File file4 = multi.getFile("file4");
			
		//정상 파일만 추가하기
		List<File> files = new ArrayList<>();
		if(file1!=null){
			files.add(file1);
		}if(file2!=null){	
			files.add(file2);
		}if(file3!=null){
			files.add(file3);
		}if(file4!=null){
			files.add(file4);
		}		
		return files;
		
	}
	
	//사진 업로드 파일에서 실제 저장 폴더로 이동 및 이름 변경
	public static String RenameMoveFile(File A, File B,String API) {
		String imageDBPath =null;
		try {
			if(A.exists()){
   				//만약 기존에 파일이 있다면 삭제한다.
   				if(B.exists()){
   					B.delete();
   				}
   				//파일을 이동한다.
   				A.renameTo(B);	
   			}
	
			//일기 작성 또는 수정할 경우
			if(API.equals("MIF_Calendar_003")||API.equals("MIF_Calendar_004")) {
				imageDBPath = CommonData.getImageURL()+B.getName();
			}
			//프로필 사진 수정 할 경우
			else if(API.equals("MIF_MyPage_008")) {
				imageDBPath = CommonData.getProfileURLL()+B.getName();

			}

			//System.out.println("서버에 저장된 사진 주소: "+B.getAbsolutePath());
			//System.out.println("DB에 저장될 사진 주소: "+imageDBPath);
				
		}catch(Exception e) {
			e.printStackTrace();
			
		}
			return imageDBPath;
	}
	
	//업로드에 있는 파일 사진 삭제
	public static void DeleteUploadImages(List<File> files) throws IOException {
		if(files.size()!=0||files!=null){
			for(File deleteFile : files){
				deleteFile.delete();
			}
		}
	}
	
	//서버 이미지 폴더에서 사진 삭제하기
	public static void DeleteAll(DiaryDTO dto) {
		String photoOnePath = dto.getPhotoOne();
		String photoTwoPath = dto.getPhotoTwo();
		String photoThreePath = dto.getPhotoThree();
		String photoFourPath = dto.getPhotoFour();
		
		String photoOneFileName=null;
		String photoTwoFileName=null;
		String photoThreeFileName=null;
		String photoFourFileName=null;
		
		if(photoOnePath!=null) {
			photoOneFileName = dto.getDiaryID()+"1.jpg";
			File photoOneFile = new File(CommonData.getAbsolutePath()+"\\photoOneFileName");
			photoOneFile.delete();
		}
		if(photoTwoPath!=null) {
			photoTwoFileName = dto.getDiaryID()+"2.jpg";
			File photoTwoFile = new File(CommonData.getAbsolutePath()+"\\photoOneFileName");	
			photoTwoFile.delete();
		}
		if(photoThreePath!=null) {
			photoThreeFileName = dto.getDiaryID()+"3.jpg";
			File photoThreeFile = new File(CommonData.getAbsolutePath()+"\\photoOneFileName");	
			photoThreeFile.delete();
		}
		if(photoFourPath!=null) {
			photoFourFileName = dto.getDiaryID()+"4.jpg";
			File photoFourFile = new File(CommonData.getAbsolutePath()+"\\photoOneFileName");	
			photoFourFile.delete();
		}
		
	}
		
	//사용되지 않는 사진 지우기
	public static void DeleteGarbageImage(int diaryID,int newCount, String path) {
		WriteDiaryDAO dao= new WriteDiaryDAO();		
		try {
			
		}catch(NullPointerException e) {
			e.printStackTrace();
		}catch(Exception e) {
			e.printStackTrace();
		}
		int oldCount = dao.GarbageImage(diaryID);
		
		//기존 이미지 저장소에서 이미지를 지운다.
			File garbageFile;
			for(int i=4; i>newCount;i--) {
				switch(i) {
				case 4:
					System.out.println("4번");
					garbageFile = new File(path+"\\"+diaryID+"_"+i+".jpg");
					if(garbageFile.exists()) {
						garbageFile.delete();
						System.out.println("4번삭제");
					}
				
					break;
				case 3:
					System.out.println("3번");
					garbageFile = new File(path+"\\"+diaryID+"_"+i+".jpg");
					if(garbageFile.exists()) {
						garbageFile.delete();
						System.out.println("3번삭제");
					}
				
					break;
				case 2:
					System.out.println("2번");
					garbageFile = new File(path+"\\"+diaryID+"_"+i+".jpg");
					if(garbageFile.exists()) {
						garbageFile.delete();
						System.out.println("2번삭제");
					}
				
					break;
				case 1:
					garbageFile = new File(path+"\\"+diaryID+"_"+i+".jpg");
					if(garbageFile.exists()) {
						garbageFile.delete();
						System.out.println("1번삭제");
					}
					System.out.println("1번");
				
					break;
				default:
				
					break;
						
				}	
			}				
	}
}