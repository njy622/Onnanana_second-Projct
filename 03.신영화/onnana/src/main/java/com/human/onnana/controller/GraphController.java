package com.human.onnana.controller;

import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import java.util.Map;
import java.util.HashMap;




@Controller
@RequestMapping("/graph")
public class GraphController {
	
	
	
	
	@GetMapping("/analysis")
	public String analysisForm(Model model) {
		model.addAttribute("menu", "analy"); // 아이콘 불들어옴

		return "graph/analysis";
	}
	
	
	private String extractImageData(String jsonResponse) {
	    JSONObject jsonObject = new JSONObject(jsonResponse);
	    return jsonObject.getString("image");
	}

	@GetMapping("/variables")
	public String variablesForm(Model model) {
	    RestTemplate restTemplate = new RestTemplate();
	    String pythonServiceUrl = "http://localhost:5000/graph/generate-graph";

	    ResponseEntity<String> response = restTemplate.getForEntity(pythonServiceUrl, String.class);

	    // 응답으로부터 이미지 데이터 추출
	    String imageData = extractImageData(response.getBody());

	    // 모델에 이미지 데이터 추가
	    model.addAttribute("imageData", imageData);
		model.addAttribute("menu", "analy"); // 아이콘 불들어옴

	    // user/variables.jsp 뷰 반환
	    return "graph/variables";
	}
	
	@GetMapping("/select-variable")
	public String showSelectVariablePage(Model model, HttpSession session) {
	    // 세션에서 선택된 변수 가져오기
	    String selectedVariable = (String) session.getAttribute("selectedVariable");

	    // 선택된 변수가 없으면 기본값 설정
	    if (selectedVariable == null) {
	        selectedVariable = "비염환자(질병)"; // 기본값 예시
	    }
	    
		List<String> variables = Arrays.asList(
	        "비염환자(질병)", "아토피환자(질병)", "천식환자(질병)", "평균기온(기후)",
	        "상대습도(기후)", "증기압(기후)", "최고기온(기후)", "최저기온(기후)", "풍속(기후)", "미세먼지",
	        "초미세먼지", "아황산가스", "이산화질소", "일산화탄소", "구리(중금속)", "납(중금속)",
	        "니켈(중금속)", "망간(중금속)", "비소(중금속)", "철(중금속)", "카드뮴(중금속)", "크롬(중금속)"
	    );
	    model.addAttribute("variables", variables);
	 // Spring 컨트롤러에서
	    model.addAttribute("selectedVariable", selectedVariable);
		model.addAttribute("menu", "analy"); // 아이콘 불들어옴

	    return "graph/variables_select"; // JSP 파일 이름
	}
	
	@PostMapping("/select-variable")
	public String handleVariableSelection(@RequestParam("variable") String selectedVariable, Model model, HttpSession session) {
	    
	    // 선택된 변수를 세션에 저장
	    session.setAttribute("selectedVariable", selectedVariable);
	    
		List<String> variables = Arrays.asList(
		        "비염환자(질병)", "아토피환자(질병)", "천식환자(질병)", "평균기온(기후)",
		        "상대습도(기후)", "증기압(기후)", "최고기온(기후)", "최저기온(기후)", "풍속(기후)", "미세먼지",
		        "초미세먼지", "아황산가스", "이산화질소", "일산화탄소", "구리(중금속)", "납(중금속)",
		        "니켈(중금속)", "망간(중금속)", "비소(중금속)", "철(중금속)", "카드뮴(중금속)", "크롬(중금속)"
		    );
		
		RestTemplate restTemplate = new RestTemplate();
	    String flaskUrl = "http://localhost:5000/graph/get-correlation-graph"; 

	    HttpHeaders headers = new HttpHeaders();
	    headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

	    MultiValueMap<String, String> map = new LinkedMultiValueMap<>();
	    map.add("variable", selectedVariable);

	    HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(map, headers);

	    ResponseEntity<String> response = restTemplate.postForEntity(flaskUrl, request, String.class);

	    String imageData = extractImageData(response.getBody());
	    // 모델에 변수 목록과 선택된 변수, 그래프 데이터 추가
	    model.addAttribute("variables", variables);
	    model.addAttribute("selectedVariable", selectedVariable);
	    model.addAttribute("graph", imageData);
	    
	    
	    System.out.println("POST - Selected variables: " + variables);
        System.out.println("POST - Selected selectedVariable: " + selectedVariable);
		model.addAttribute("menu", "analy"); // 아이콘 불들어옴

	    
	    return "graph/variables_select"; 
	}
	


    private static final List<String> VARIABLES1 = Arrays.asList(
            "미세먼지(농도)", "미세먼지(농도80)", "초미세먼지(농도)", "초미세먼지(농도35)",
            "아황산가스(농도0.05)", "아황산가스(농도)", "이산화질소(농도0.06)", "이산화질소(농도0.03)",
            "이산화질소(농도)", "일산화탄소(농도9)", "일산화탄소(농도)", "구리(농도)", "납(농도0.5)",
            "납(농도)", "니켈(농도)", "망간(농도)", "비소(농도)", "철(농도)", "카드뮴(농도)", "크롬(농도)"
    );
    private static final List<String> VARIABLES2 = Arrays.asList("비염환자(질병)", "아토피환자(질병)", "천식환자(질병)");
    private static final Map<String, String> AGG_FUNC_KOREAN_TO_ENGLISH = new HashMap<>();

    static {
        AGG_FUNC_KOREAN_TO_ENGLISH.put("최소", "min");
        AGG_FUNC_KOREAN_TO_ENGLISH.put("최대", "max");
        AGG_FUNC_KOREAN_TO_ENGLISH.put("평균", "mean");
    }
    
   
    @GetMapping("/disease-graph")
    public String showDiseaseGraphForm(Model model, HttpSession session) {
        // 기본값 설정
        if (session.getAttribute("selectedVariable1") == null) {
            session.setAttribute("selectedVariable1", "이산화질소(농도0.03)");
        }
        if (session.getAttribute("selectedVariable2") == null) {
            session.setAttribute("selectedVariable2", "천식환자(질병)");
        }
        if (session.getAttribute("selectedAggFuncKorean") == null) {
            session.setAttribute("selectedAggFuncKorean", "최소");
        }

        model.addAttribute("variables1", VARIABLES1);
        model.addAttribute("variables2", VARIABLES2);
        model.addAttribute("aggregationFunctions", AGG_FUNC_KOREAN_TO_ENGLISH.keySet());

        // 기존 세션 값을 모델에 추가
        model.addAttribute("selectedVariable1", session.getAttribute("selectedVariable1"));
        model.addAttribute("selectedVariable2", session.getAttribute("selectedVariable2"));
        model.addAttribute("selectedAggFuncKorean", session.getAttribute("selectedAggFuncKorean"));
		model.addAttribute("menu", "analy"); // 아이콘 불들어옴


        return "graph/disease_graph";
    }


    @PostMapping("/disease-graph")
    public String processDiseaseGraphForm(
            @RequestParam("variable1") String selectedVariable1,
            @RequestParam("variable2") String selectedVariable2,
            @RequestParam("agg_func_korean") String selectedAggFuncKorean,
            Model model, HttpSession session) {

        // 사용자 선택을 세션에 저장
        session.setAttribute("selectedVariable1", selectedVariable1);
        session.setAttribute("selectedVariable2", selectedVariable2);
        session.setAttribute("selectedAggFuncKorean", selectedAggFuncKorean);
        
        System.out.println("POST - Session Variable 1: " + session.getAttribute("selectedVariable1"));
        System.out.println("POST - Session Variable 2: " + session.getAttribute("selectedVariable2"));
        System.out.println("POST - Session Aggregation Function Korean: " + session.getAttribute("selectedAggFuncKorean"));

        
        String selectedAggFuncEnglish = AGG_FUNC_KOREAN_TO_ENGLISH.getOrDefault(selectedAggFuncKorean, "mean");

        // Flask 서버로 요청을 보내는 로직
        RestTemplate restTemplate = new RestTemplate();
        String flaskUrl = "http://localhost:5000/graph/disease-graph-api";

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> map = new LinkedMultiValueMap<>();
        map.add("variable1", selectedVariable1);
        map.add("variable2", selectedVariable2);
        map.add("agg_func", selectedAggFuncEnglish);
        map.add("agg_func_korean", selectedAggFuncKorean);
        
        // 콘솔에 입력받은 값들을 출력
        System.out.println("POST - Selected Variable 1: " + selectedVariable1);
        System.out.println("POST - Selected Variable 2: " + selectedVariable2);
        System.out.println("POST - Selected Aggregation Function Korean: " + selectedAggFuncKorean);
        System.out.println("POST - Mapped Aggregation Function English: " + selectedAggFuncEnglish);

        
        
        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(map, headers);
        ResponseEntity<String> response = restTemplate.postForEntity(flaskUrl, request, String.class);

        String imageData = extractImageData(response.getBody());
        
        model.addAttribute("variables1", VARIABLES1);
        model.addAttribute("variables2", VARIABLES2);
        model.addAttribute("aggregationFunctions", AGG_FUNC_KOREAN_TO_ENGLISH.keySet());
        model.addAttribute("selectedVariable1", session.getAttribute("selectedVariable1"));
        model.addAttribute("selectedVariable2", session.getAttribute("selectedVariable2"));
        model.addAttribute("selectedAggFuncKorean", session.getAttribute("selectedAggFuncKorean"));


        model.addAttribute("graph", imageData);
		model.addAttribute("menu", "analy"); // 아이콘 불들어옴


        return "graph/disease_graph";
    }

    private static final List<String> Sidos = Arrays.asList(
            "서울특별시", "부산광역시", "대구광역시", "인천광역시",
            "광주광역시", "대전광역시", "울산광역시", "세종특별자치시",
            "경기도", "충청북도", "충청남도", "전라북도",
            "전라남도", "경상북도", "경상남도"
        );

    private static final List<String> Variables = Arrays.asList(
        "비염환자(질병)", "아토피환자(질병)", "천식환자(질병)", "평균기온(기후)",
        "상대습도(기후)", "증기압(기후)", "최고기온(기후)", "최저기온(기후)", "풍속(기후)", "미세먼지",
        "초미세먼지", "아황산가스", "이산화질소", "일산화탄소", "구리(중금속)", "납(중금속)",
        "니켈(중금속)", "망간(중금속)", "비소(중금속)", "철(중금속)", "카드뮴(중금속)", "크롬(중금속)"
    );

    @GetMapping("/corona-graph")
    public String showCoronaGraphForm(Model model, HttpSession session) {
        
    	if (session.getAttribute("selectedSido") == null) {
            session.setAttribute("selectedSido", "서울특별시");
        }
        if (session.getAttribute("selectedVariable") == null) {
            session.setAttribute("selectedVariable", "미세먼지");
        }


        // similarImpact 세션 속성 초기화
        session.removeAttribute("similarImpact");

        
        model.addAttribute("sidos", Sidos);
        model.addAttribute("variables", Variables);
        model.addAttribute("selectedSido", session.getAttribute("selectedSido"));
        model.addAttribute("selectedVariable", session.getAttribute("selectedVariable"));

        
        
        return "graph/corona_graph";
    }

    @PostMapping("/corona-graph")
    public String processCoronaGraphForm(
            @RequestParam("sido") String selectedSido,
            @RequestParam("variable") String selectedVariable,
            Model model , HttpSession session) {

        // 선택된 변수 출력
        System.out.println("Selected Sido: " + selectedSido);
        System.out.println("Selected Variable: " + selectedVariable);

        RestTemplate restTemplate = new RestTemplate();
        String url = "http://localhost:5000/graph/corona-graph-api"; // Flask 서버 URL

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> map = new LinkedMultiValueMap<>();
        map.add("sido", selectedSido);
        map.add("variable", selectedVariable);

        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(map, headers);

        // POST 요청 및 응답 처리
        try {
            ResponseEntity<String> response = restTemplate.postForEntity(url, request, String.class);
            String imageData = extractImageData(response.getBody());

            // 여기서 similar impact 메시지 추출 및 세션에 저장
            String similarImpact = extractSimilarImpact(response.getBody());
            session.setAttribute("similarImpact", similarImpact);

            model.addAttribute("sidos", Sidos);
            model.addAttribute("variables", Variables);
            model.addAttribute("selectedSido", selectedSido);
            model.addAttribute("selectedVariable", selectedVariable);
            model.addAttribute("graph", imageData);
            model.addAttribute("similarImpact", similarImpact);
        } catch (Exception e) {
            System.out.println("Error during POST request: " + e.getMessage());
            // 에러 핸들링 로직
        }
		model.addAttribute("menu", "analy"); // 아이콘 불들어옴


        return "graph/corona_graph";
    }
	
    private String extractSimilarImpact(String responseBody) {
        try {
            JSONObject json = new JSONObject(responseBody);
            return json.optString("similar_impact", "유사한 증감폭 정보 없음");
        } catch (Exception e) {
            System.out.println("JSON 파싱 중 오류 발생: " + e.getMessage());
            return "유사한 증감폭 정보 추출 실패";
        }
    }


	
	

}
