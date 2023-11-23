package com.human.finedust.db;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.human.finedust.entity.User;

@Mapper
public interface UserDaoOracle {
	
	@Select("select count (uname) from users where isDeleted=0")
	public int getUserCount();

	@Select("select * from users where \"uid\"=#{uid}") // MyBatis로 사용해서 이 한줄로 끝나는 것! 아니면 일일히 써야한다 (예전 demo에서 BookDao처럼 길게 안써도됨!)
	public User getUser(String uid); // User 위치 패키지가 달라서 import 해줘야함 (select문을 받아서 User 에서 객체를 찾음)

	// #{uid} --> user.getUid()메소드를 불러옴
	@Insert("insert into users values (#{uid}, #{pwd}, #{uname}, #{email}, default, default)")
	public void insertUser(User user);

	@Select("select * from (select rownum rnum, a.* from"
			+ "    (select * from users where isDeleted=0) a"
			+ "    where rownum <= #{limit}) where rnum >#{offset}")
	public List<User> getUserList(int offset, int limit);
	
	@Update("update users set pwd=#{pwd}, uname=#{uname}, email=#{email} where \"uid\"=#{uid}")
	void updateUser(User user);			// 인터페이스이기 때문에 public 생략 가능
	
	@Update("update users set isdeleted=1 where \"uid\"=#{uid}")
	void  deleteUser(String uid);		// 인터페이스이기 때문에 public 생략 가능
	
}
