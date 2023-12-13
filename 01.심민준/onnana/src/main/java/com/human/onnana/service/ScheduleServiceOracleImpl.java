package com.human.onnana.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.human.onnana.db.AnniversaryDaoOracle;
import com.human.onnana.db.ScheduleDaoOracle;
import com.human.onnana.entity.Anniversary;
import com.human.onnana.entity.SchDay;
import com.human.onnana.entity.Schedule;

@Service
public class ScheduleServiceOracleImpl implements ScheduleService {
	
	@Autowired private ScheduleDaoOracle schedDao;
	@Autowired private AnniversaryDaoOracle annivDao;

	@Override
	public List<Schedule> getDaySchedList(String uid, String sdate) {
		List<Schedule> list = schedDao.getSchedList(uid, sdate, sdate);
		return list;
	}

	@Override
	public List<Schedule> getMonthSchedList(String uid, String month, int lastDay) {
		String startDay = month + "01";
		String endDay = month + lastDay;
		List<Schedule> list = schedDao.getSchedList(uid, startDay, endDay);
		return list;
	}

	@Override
	public List<Schedule> getCalendarSchedList(String uid, String startDate, String endDate) {
		List<Schedule> list = schedDao.getSchedList(uid, startDate, endDate);
		return list;
	}

	@Override
	public SchDay generateSchDay(String uid, String sdate, int date, int isOtherMonth) {
		List<Anniversary> annivList = annivDao.getAnnivList(uid, sdate, sdate);
		List<Schedule> schedList = schedDao.getSchedList(uid, sdate, sdate);
		int day = Integer.parseInt(sdate.substring(6));
		int isHoliday = 0;
		List<String> aList = new ArrayList<>();
		for (Anniversary anniv: annivList) {
			aList.add(anniv.getAname());
			if (isHoliday == 0)
				isHoliday = anniv.getIsHoliday();
		}
		SchDay schDay = new SchDay(day, date, isHoliday, isOtherMonth, sdate, aList, schedList);
		return schDay;
	}

	@Override
	public void insert(Schedule schedule) {
		schedDao.insert(schedule);
	}

	@Override
	public Schedule getSchedule(int sid) {
		Schedule sched = schedDao.getSchedule(sid);
		return sched;
	}

	@Override
	public void update(Schedule schedule) {
		schedDao.update(schedule);
	}

	@Override
	public void delete(int sid) {
		schedDao.delete(sid);
	}
	
	@Override
	public int getCount() {
		int allCount = schedDao.count();
		return allCount;
	}

	@Override
	public int getUserCount(String uid) {
		int userCount = schedDao.userCount(uid);
		return userCount;
	}
	
	
	
	@Override
	public double getCarbonCount() {
		double allCarbon = schedDao.carbonCount();
		return allCarbon;
	}
	
	@Override
	public double getCarbonUserCount(String uid) {
		double userCarbon = schedDao.carbonUserCount(uid);
		return userCarbon;
	}

}
