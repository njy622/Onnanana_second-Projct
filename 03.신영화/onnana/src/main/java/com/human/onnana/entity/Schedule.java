package com.human.onnana.entity;

import java.time.LocalDateTime;

public class Schedule {
	private int sid;
	private String uid;
	private String sdate;
	private LocalDateTime startTime;
	private String title;
	private String title2;
	private String place;
	private String startplace;
	private String endplace;
	private String smoke;
	private String smoke2;
	private String waypoint1;
	private String waypoint3;
	private String waypoint2;
	
	
	
	public Schedule() {}

	public Schedule(String uid, String sdate, LocalDateTime startTime) {
		this.uid = uid;
		this.sdate = sdate;
		this.startTime = startTime;
	}
	
	public Schedule(int sid, String uid, String sdate, LocalDateTime startTime) {
		this.sid = sid;
        this.uid = uid;
        this.sdate = sdate;
        this.startTime = startTime;
    }

	public Schedule(int sid, String uid, String sdate, LocalDateTime startTime, String title, String title2,
			String place, String startplace, String endplace, String smoke, String smoke2, String waypoint1,
			String waypoint3, String waypoint2) {
		super();
		this.sid = sid;
		this.uid = uid;
		this.sdate = sdate;
		this.startTime = startTime;
		this.title = title;
		this.title2 = title2;
		this.place = place;
		this.startplace = startplace;
		this.endplace = endplace;
		this.smoke = smoke;
		this.smoke2 = smoke2;
		this.waypoint1 = waypoint1;
		this.waypoint3 = waypoint3;
		this.waypoint2 = waypoint2;
	}



	public Schedule(String uid, String sdate, LocalDateTime startTime, String title, String title2, String place,
			String startplace, String endplace, String smoke, String smoke2, String waypoint1, String waypoint3,
			String waypoint2) {
		super();
		this.uid = uid;
		this.sdate = sdate;
		this.startTime = startTime;
		this.title = title;
		this.title2 = title2;
		this.place = place;
		this.startplace = startplace;
		this.endplace = endplace;
		this.smoke = smoke;
		this.smoke2 = smoke2;
		this.waypoint1 = waypoint1;
		this.waypoint3 = waypoint3;
		this.waypoint2 = waypoint2;
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



	public String getTitle2() {
		return title2;
	}



	public void setTitle2(String title2) {
		this.title2 = title2;
	}



	public String getPlace() {
		return place;
	}



	public void setPlace(String place) {
		this.place = place;
	}



	public String getStartplace() {
		return startplace;
	}



	public void setStartplace(String startplace) {
		this.startplace = startplace;
	}



	public String getEndplace() {
		return endplace;
	}



	public void setEndplace(String endplace) {
		this.endplace = endplace;
	}



	public String getSmoke() {
		return smoke;
	}



	public void setSmoke(String smoke) {
		this.smoke = smoke;
	}



	public String getSmoke2() {
		return smoke2;
	}



	public void setSmoke2(String smoke2) {
		this.smoke2 = smoke2;
	}



	public String getWaypoint1() {
		return waypoint1;
	}



	public void setWaypoint1(String waypoint1) {
		this.waypoint1 = waypoint1;
	}



	public String getWaypoint3() {
		return waypoint3;
	}



	public void setWaypoint3(String waypoint3) {
		this.waypoint3 = waypoint3;
	}



	public String getWaypoint2() {
		return waypoint2;
	}



	public void setWaypoint2(String waypoint2) {
		this.waypoint2 = waypoint2;
	}



	@Override
	public String toString() {
		return "Schedule [sid=" + sid + ", uid=" + uid + ", sdate=" + sdate + ", startTime=" + startTime + ", title="
				+ title + ", title2=" + title2 + ", place=" + place + ", startplace=" + startplace + ", endplace="
				+ endplace + ", smoke=" + smoke + ", smoke2=" + smoke2 + ", waypoint1=" + waypoint1 + ", waypoint3="
				+ waypoint3 + ", waypoint2=" + waypoint2 + "]";
	}



}