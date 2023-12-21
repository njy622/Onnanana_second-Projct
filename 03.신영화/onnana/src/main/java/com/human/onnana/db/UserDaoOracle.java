package com.human.onnana.db;

import java.sql.Timestamp;
import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.human.onnana.entity.User;

@Mapper
public interface UserDaoOracle {
	
   @Select("select count(uname) from users where isDeleted=0")
   public int getUserCount();

	
   @Select("select * from users where \"uid\"=#{uid}")
   public User getUser(String uid);
   
   // #{uid} --> user.getUid()
   @Insert("insert into users values (#{uid}, #{pwd}, #{uname},#{email}, default, default)")
   public void insertUser(User user);

   @Select("select * from (select rownum rnum, a. * from"
         + "    (select * from users where isDeleted=0) a"
         + "    where rownum <= #{limit}) where rnum > #{offset}")
   public List<User> getUserList(int offset, int limit);
   
 
   @Update("update users set isDeleted=1 where \"uid\"=#{uid}")
   void deleteUser(String uid);		// 인터페이스이기 때문에 public 생략가능
   
	// UserDaoOracle 클래스에서 수정
	@Update("UPDATE users SET last_login_date=#{currentTimestamp} WHERE uid=#{uid}")
	void updateLastLoginDate(@Param("uid") String uid, @Param("currentTimestamp") Timestamp currentTimestamp);

	 @Select("SELECT COUNT(sid) FROM schedule WHERE uid=#{uid}")
	    int getUserSchedCount(String uid);
	
	
}