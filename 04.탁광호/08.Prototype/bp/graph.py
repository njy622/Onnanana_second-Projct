from flask import Blueprint, render_template, current_app, request, redirect, url_for
import util.graph_util as gu
import util.graph_util as gu
import numpy as np


graph_bp = Blueprint('graph_bp', __name__)

menu = {'ho':0, 'us':0, 'cr':0, 'ma':1,'cb':0, 'sc':0}



@graph_bp.route('/variables')
def variables():
    variables_graph = gu.get_variables_graph()
    return render_template('/graph/variables.html', variables_graph=variables_graph, menu=menu)

@graph_bp.route('/select-variable', methods=['GET', 'POST'])
def select_variable():
    variables = ['비염환자(질병)', '아토피환자(질병)', '천식환자(질병)', '평균기온(기후)',
       '상대습도(기후)', '증기압(기후)', '최고기온(기후)', '최저기온(기후)', '풍속(기후)', '미세먼지',
       '초미세먼지', '아황산가스', '이산화질소', '일산화탄소', '구리(중금속)', '납(중금속)',
       '니켈(중금속)', '망간(중금속)', '비소(중금속)', '철(중금속)', '카드뮴(중금속)', '크롬(중금속)']
    selected_variable = '비염환자(질병)'  # 초기 선택된 변수 설정

    if request.method == 'POST':
        selected_variable = request.form.get('variable')
        graph = gu.get_variables_graph_select(selected_variable)
    else:
        graph = None

    return render_template('/graph/variables_select.html', variables=variables, selected_variable=selected_variable, graph=graph, menu=menu)

@graph_bp.route('/disease-graph', methods=['GET', 'POST'])
def disease_graph():
    # 사용자가 선택할 수 있는 변수 목록
    variables1 = [
        '미세먼지(농도)', '미세먼지(농도80)', '초미세먼지(농도)', '초미세먼지(농도35)', 
        '아황산가스(농도0.05)', '아황산가스(농도)', '이산화질소(농도0.06)', '이산화질소(농도0.03)', 
        '이산화질소(농도)', '일산화탄소(농도9)', '일산화탄소(농도)', '구리(농도)', '납(농도0.5)', 
        '납(농도)', '니켈(농도)', '망간(농도)', '비소(농도)', '철(농도)', '카드뮴(농도)', '크롬(농도)'
    ]
    variables2 = ['비염환자(질병)', '아토피환자(질병)', '천식환자(질병)']

    # 집계 함수 이름을 한글로 매핑
    aggregation_functions_korean = {'min': '최소', 'max': '최대', 'mean': '평균'}
    # 집계 함수 이름을 영어로 매핑하는 딕셔너리 생성
    aggregation_functions_english = {v: k for k, v in aggregation_functions_korean.items()}
    aggregation_functions = list(aggregation_functions_korean.values())

    # 기본값 설정
    selected_variable1 = '이산화질소(농도0.03)'
    selected_variable2 = '천식환자(질병)'
    selected_agg_func = 'min'
    selected_agg_func_korean = aggregation_functions_korean[selected_agg_func]

    if request.method == 'POST':
        selected_variable1 = request.form.get('variable1')
        selected_variable2 = request.form.get('variable2')
        selected_agg_func_korean = request.form.get('agg_func')
        
        # 한글 집계 함수 이름을 영어로 매핑
        selected_agg_func = aggregation_functions_english.get(selected_agg_func_korean, 'min')

        # 선택된 함수에 따른 그래프 생성
        agg_func = {
            'min': np.min,
            'max': np.max,
            'mean': np.mean
        }.get(selected_agg_func, np.min)

        graph = gu.get_disease_graph(selected_variable1, selected_variable2, agg_func, selected_agg_func_korean)
    else:
        graph = None
        selected_agg_func_korean = aggregation_functions_korean[selected_agg_func]



    return render_template('/graph/disease_graph.html', 
                           variables1=variables1, 
                           variables2=variables2, 
                           aggregation_functions=aggregation_functions, 
                           selected_variable1=selected_variable1, 
                           selected_variable2=selected_variable2, 
                           selected_agg_func=selected_agg_func, 
                           selected_agg_func_korean=selected_agg_func_korean, 
                           graph=graph, 
                           menu=menu)

@graph_bp.route('/corona-graph', methods=['GET', 'POST'])
def corona_graph():
    # 시도와 변수 목록을 제공합니다.
    sidos = [
    '서울특별시', '부산광역시', '대구광역시', '인천광역시',
    '광주광역시', '대전광역시', '울산광역시', '세종특별자치시',
    '경기도', '충청북도', '충청남도', '전라북도',
    '전라남도', '경상북도', '경상남도']

    variables = ['비염환자(질병)', '아토피환자(질병)', '천식환자(질병)', '평균기온(기후)',
       '상대습도(기후)', '증기압(기후)', '최고기온(기후)', '최저기온(기후)', '풍속(기후)', '미세먼지',
       '초미세먼지', '아황산가스', '이산화질소', '일산화탄소', '구리(중금속)', '납(중금속)',
       '니켈(중금속)', '망간(중금속)', '비소(중금속)', '철(중금속)', '카드뮴(중금속)', '크롬(중금속)']  # 예시

    # 기본값 설정
    selected_sido = '서울특별시'
    selected_variable = '미세먼지'

    # 유사한 증감폭 메시지 변수 초기화
    similar_impact_message = None

    if request.method == 'POST':
        selected_sido = request.form.get('sido')
        selected_variable = request.form.get('variable')

        # 선택된 시도와 변수에 따른 그래프 생성 및 코로나 증감폭 계산
        graph_url, percent_change = gu.get_corona_graph(selected_sido, selected_variable)

        # 유사한 증감폭 찾기
        similar_impact_message = gu.find_similar_covid_impact(selected_sido, selected_variable, percent_change)
    else:
        graph_url = None

    return render_template('/graph/corona_graph.html', sidos=sidos, variables=variables, selected_sido=selected_sido, selected_variable=selected_variable, graph=graph_url, similar_impact=similar_impact_message, menu=menu)



@graph_bp.route('/future-prediction', methods=['GET', 'POST'])
def predict_pm():
    variables = ['미세먼지', '초미세먼지']
    selected_variable = '미세먼지'

    prediction = None
    if request.method == 'POST':
        selected_variable = request.form.get('variable')
        prediction = gu.predict_pm10_pm25(selected_variable)


    return render_template('/graph/future_prediction.html', variables=variables, selected_variable=selected_variable, prediction=prediction, menu=menu)
