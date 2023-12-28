package com.human.onnana.service;

import java.util.List;

import com.human.onnana.entity.SchDay;
import com.human.onnana.entity.Schedule;

public interface ScheduleService {

	List<Schedule> getDaySchedList(String uid, String sdate);
	
	List<Schedule> getMonthSchedList(String uid, String month, int lastDay);
	
	List<Schedule> getCalendarSchedList(String uid, String startDate, String endDate);
	
	SchDay generateSchDay(String uid, String sdate, int date, int isOtherMonth);
	
	void insert(Schedule schedule);
	
	Schedule getSchedule(int sid);
	
	void update(Schedule schedule);
	
	void delete(int sid);
	
	int getCount();

	int getUserCount(String uid);
	
	
	Double getCarbonCount();
	
	Double getCarbonUserCount(String uid);
	
	double getUserCarbonReductionTotal(int sid);
	
	int getAttendanceCount(String uid);
	
	double UserdaycarbonSum(String uid, String sdate);

	double UserAlldaycarbonSum(String sdate);

	
}
