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
	//�̹��� ������ ���� ����
	public static void FileCheck(String path) {
		File Folder = new File(path);
		// �ش� ���丮�� ������� ���丮�� �����մϴ�.
		
		if (!Folder.exists()) {
			try{
			    Folder.mkdir(); //���� �����մϴ�.
			    System.out.println("������ �����Ǿ����ϴ�.");
		    } 
		    catch(Exception e){
			    e.getStackTrace();
			}         
	    }   
		else {
			System.out.println("�̹� ������ �����Ǿ� �ֽ��ϴ�.");
        }
		
	}
	//�̹��� ���� ����Ʈ �����
	public static List<File> MakeImages(MultipartRequest multi){		
		//���� ����
		File file1 = multi.getFile("file1");
		File file2 = multi.getFile("file2");
		File file3 = multi.getFile("file3");
		File file4 = multi.getFile("file4");
			
		//���� ���ϸ� �߰��ϱ�
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
	
	//���� ���ε� ���Ͽ��� ���� ���� ������ �̵� �� �̸� ����
	public static String RenameMoveFile(File A, File B,String API) {
		String imageDBPath =null;
		try {
			if(A.exists()){
   				//���� ������ ������ �ִٸ� �����Ѵ�.
   				if(B.exists()){
   					B.delete();
   				}
   				//������ �̵��Ѵ�.
   				A.renameTo(B);	
   			}
	
			//�ϱ� �ۼ� �Ǵ� ������ ���
			if(API.equals("MIF_Calendar_003")||API.equals("MIF_Calendar_004")) {
				imageDBPath = CommonData.getImageURL()+B.getName();
			}
			//������ ���� ���� �� ���
			else if(API.equals("MIF_MyPage_008")) {
				imageDBPath = CommonData.getProfileURLL()+B.getName();

			}

			//System.out.println("������ ����� ���� �ּ�: "+B.getAbsolutePath());
			//System.out.println("DB�� ����� ���� �ּ�: "+imageDBPath);
				
		}catch(Exception e) {
			e.printStackTrace();
			
		}
			return imageDBPath;
	}
	
	//���ε忡 �ִ� ���� ���� ����
	public static void DeleteUploadImages(List<File> files) throws IOException {
		if(files.size()!=0||files!=null){
			for(File deleteFile : files){
				deleteFile.delete();
			}
		}
	}
	
	//���� �̹��� �������� ���� �����ϱ�
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
		
	//������ �ʴ� ���� �����
	public static void DeleteGarbageImage(int diaryID,int newCount, String path) {
		WriteDiaryDAO dao= new WriteDiaryDAO();		
		try {
			
		}catch(NullPointerException e) {
			e.printStackTrace();
		}catch(Exception e) {
			e.printStackTrace();
		}
		int oldCount = dao.GarbageImage(diaryID);
		
		//���� �̹��� ����ҿ��� �̹����� �����.
			File garbageFile;
			for(int i=4; i>newCount;i--) {
				switch(i) {
				case 4:
					System.out.println("4��");
					garbageFile = new File(path+"\\"+diaryID+"_"+i+".jpg");
					if(garbageFile.exists()) {
						garbageFile.delete();
						System.out.println("4������");
					}
				
					break;
				case 3:
					System.out.println("3��");
					garbageFile = new File(path+"\\"+diaryID+"_"+i+".jpg");
					if(garbageFile.exists()) {
						garbageFile.delete();
						System.out.println("3������");
					}
				
					break;
				case 2:
					System.out.println("2��");
					garbageFile = new File(path+"\\"+diaryID+"_"+i+".jpg");
					if(garbageFile.exists()) {
						garbageFile.delete();
						System.out.println("2������");
					}
				
					break;
				case 1:
					garbageFile = new File(path+"\\"+diaryID+"_"+i+".jpg");
					if(garbageFile.exists()) {
						garbageFile.delete();
						System.out.println("1������");
					}
					System.out.println("1��");
				
					break;
				default:
				
					break;
						
				}	
			}				
	}
}