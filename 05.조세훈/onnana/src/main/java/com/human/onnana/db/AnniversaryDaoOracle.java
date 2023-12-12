package com.human.onnana.db;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.human.onnana.entity.Anniversary;

@Mapper
public interface AnniversaryDaoOracle {

	@Select("SELECT * FROM anniversary WHERE aid=#{aid}")
	Anniversary getAnniv(int aid);
	
	@Select("SELECT * FROM anniversary"
			+ "  WHERE (\"uid\"=#{uid} OR \"uid\"='admin') AND adate >= #{start} AND adate <= #{end}"
			+ "  ORDER BY adate")
	List<Anniversary> getAnnivList(String uid, String start, String end);
	
	@Insert("INSERT INTO anniversary VALUES"
			+ "  (default, #{uid}, #{aname}, #{adate}, #{isHoliday})")
	void insertAnniv(Anniversary anniversary);
	
}
