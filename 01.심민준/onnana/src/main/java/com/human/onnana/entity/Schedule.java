package com.human.onnana.entity;

import java.time.LocalDateTime;

public class Schedule {
	private int sid;
	private String uid;
	private String sdate;
	private LocalDateTime startTime;
	private String title;
	private String place;
	private String smoke;
	
	public Schedule() { }

	public Schedule(int sid, String uid, String sdate, LocalDateTime startTime, String title, String place,
			String smoke) {
		super();
		this.sid = sid;
		this.uid = uid;
		this.sdate = sdate;
		this.startTime = startTime;
		this.title = title;
		this.place = place;
		this.smoke = smoke;
	}

	


	public Schedule(String uid, String sdate, LocalDateTime startTime, String title, String place, String smoke) {
		super();
		this.uid = uid;
		this.sdate = sdate;
		this.startTime = startTime;
		this.title = title;
		this.place = place;
		this.smoke = smoke;
	}

	public int getSid() {
		return sid;
	}

	public void setSid(int sid) {
		this.sid = sid;
	}

	public String getUid() {
		return uid;
	}

	public void setUid(String uid) {
		this.uid = uid;
	}

	public String getSdate() {
		return sdate;
	}

	public void setSdate(String sdate) {
		this.sdate = sdate;
	}

	public LocalDateTime getStartTime() {
		return startTime;
	}

	public void setStartTime(LocalDateTime startTime) {
		this.startTime = startTime;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getPlace() {
		return place;
	}

	public void setPlace(String place) {
		this.place = place;
	}

	public String getSmoke() {
		return smoke;
	}

	public void setSmoke(String smoke) {
		this.smoke = smoke;
	}

	@Override
	public String toString() {
		return "Schedule [sid=" + sid + ", uid=" + uid + ", sdate=" + sdate + ", startTime=" + startTime + ", title="
				+ title + ", place=" + place + ", smoke=" + smoke + "]";
	}



}
