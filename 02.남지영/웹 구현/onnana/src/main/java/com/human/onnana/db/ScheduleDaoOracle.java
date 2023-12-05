
package com.human.onnana.db;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.human.onnana.entity.Schedule;

@Mapper
public interface ScheduleDaoOracle {

	@Select("SELECT * FROM schedule"
			+ "  WHERE \"uid\"=#{uid} and sdate >= #{startDate} and sdate <= #{endDate}"
			+ "  ORDER BY startTime")
	List<Schedule> getSchedList(String uid, String startDate, String endDate);
	
	@Insert("INSERT INTO schedule VALUES"
			+ " (DEFAULT, #{uid}, #{sdate}, #{startTime}, #{title}, #{place}, #{smoke})")
	void insert(Schedule schedule);
	
	@Select("select * from schedule where sid=#{sid}")
	Schedule getSchedule(int sid);
	
	@Update("update schedule set \"uid\"=#{uid}, sdate=#{sdate}, startTime=#{startTime}, title=#{title},"
			+ " place=#{place}, smoke=#{smoke} where sid=#{sid}")
	void update(Schedule schedule);
	
	@Delete("delete from schedule where sid=#{sid}")
	void delete(int sid);
	
	@Select("SELECT * FROM schedule"
			+ "  WHERE  \"uid\"=#{uid} and sdate >= #{startDate}"
			+ "  ORDER BY startTime LIMIT 15 OFFSET #{offset}")
	List<Schedule> getSchedListByPage(String uid, String startDate, int offset);
	
	@Select("SELECT COUNT(sid) FROM schedule"
			+ "  WHERE \"uid\"=#{uid} and sdate >= #{startDate}"
			+ "  ORDER BY startTime")
	int getSchedCount(String uid, String startDate);

	// 유저 전체 캘린더 작성 카운트
	@Select("select count(*) from schedule")
	int count();
	
	// 한 유저 캘린더 작성 카운트
	@Select("SELECT COUNT(*)FROM schedule WHERE \"uid\" = #{uid}")
	int userCount(String uid);
	
	// 유저 전체 캘린더 작성 카운트
	@Select("SELECT  SUM(TO_NUMBER(REGEXP_SUBSTR(title, '\\d+(\\.\\d+)?'))) AS total_sum FROM schedule")
	double carbonCount();
	
	// 유저 전체 캘린더 작성 카운트
	@Select("SELECT  SUM(TO_NUMBER(REGEXP_SUBSTR(title, '\\d+(\\.\\d+)?'))) AS total_sum FROM schedule where \"uid\"= #{uid}")
	double carbonUserCount(String uid);
	
	
	
	
	
	
	
}
