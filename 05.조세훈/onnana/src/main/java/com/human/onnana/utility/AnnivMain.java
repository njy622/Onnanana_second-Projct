package com.human.onnana.utility;

import java.util.List;

import com.human.onnana.entity.Anniversary;

public class AnnivMain {

	public static void main(String[] args) {
		SchedUtil su = new SchedUtil();
		for (int year = 2023; year <= 2025; year++) {
			List<Anniversary> holiList = su.getAnnivList("공휴일", year);
			List<Anniversary> solarList = su.getAnnivList("24절기", year);
			System.out.printf("%d: 공휴일: %d, 24절기: %d%n", year, holiList.size(), solarList.size());
			System.out.println(holiList.get(0)); 
			System.out.println(holiList.get(holiList.size()-1));
			System.out.println(solarList.get(0)); 
			System.out.println(solarList.get(solarList.size()-1));
		}
	}

}
