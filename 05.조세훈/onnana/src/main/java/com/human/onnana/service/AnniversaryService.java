package com.human.onnana.service;

import java.util.List;

import com.human.onnana.entity.Anniversary;

public interface AnniversaryService {

	List<Anniversary> getDayAnnivList(String uid, String sdate);
	
	List<Anniversary> getAnnivDays(String uid, String start, String end);
	
	void insertAnniv(Anniversary anniv);
	
}
