package com.human.onnana.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.human.onnana.db.AnniversaryDaoOracle;
import com.human.onnana.entity.Anniversary;

@Service
public class AnniversaryServiceOracleImpl implements AnniversaryService {
	
	@Autowired private AnniversaryDaoOracle annivDao;

	@Override
	public List<Anniversary> getDayAnnivList(String uid, String sdate) {
		List<Anniversary> list = annivDao.getAnnivList(uid, sdate, sdate);
		return list;
	}

	@Override
	public List<Anniversary> getAnnivDays(String uid, String start, String end) {
		List<Anniversary> list = annivDao.getAnnivList(uid, start, end);
		return list;
	}

	@Override
	public void insertAnniv(Anniversary anniv) {
		annivDao.insertAnniv(anniv);
	}

}
