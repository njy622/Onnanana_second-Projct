package com.human.onnana.service;

import java.util.List;

import com.human.onnana.entity.User;


// 인터페이스로 구현하면, 호출하는 프로그램이 Oracle, MySQL, DB2 어떤 것이든
// 코드 수정 없이 이용 가능함으로 인터페이스 이용
public interface UserService {

	// 로그인할때 나오는 경우의수를 상수로 지정 (인터페이스)로 만듦

	public static final int CORRECT_LOGIN = 0;   // 등록이 완료된경우
	public static final int WRONG_PASSWORD = 1;		// 비밀번호가 안 맞는 경우
	public static final int UID_NOT_EXIST = 2;		// uid가 중복 입력한 경우
	public static final int RECORDS_PER_PAGE = 5;	// 한페이지 당 10개 레코드를 보여줌
	
	
	
	int getUserCount();			// pagination을 위해서 사용됨
	
	User getUser(String uid);
	
	List<User> getUserList(int page);	
	
	void insertUser(User user);
	
	void updateUser(User user);

	
	void deleteUser(String uid);
	
	int login(String uid, String pwd);
	
}
