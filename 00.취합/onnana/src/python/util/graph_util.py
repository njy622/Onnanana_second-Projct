import requests, json, os, folium
import numpy as np
import pandas as pd
from urllib.parse import quote
import seaborn as sns
import matplotlib.pyplot as plt
import io
import base64
from flask import current_app
from datetime import datetime
from sklearn.preprocessing import MinMaxScaler
from keras.models import load_model
import joblib  
from joblib import dump
from datetime import datetime, timedelta
import time
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import xml.etree.ElementTree as ET
import pytz
plt.rcParams['font.family'] = 'Malgun Gothic'
plt.rcParams['axes.unicode_minus'] = False


def get_variables_graph():
    
    # 현재 애플리케이션의 정적 파일 경로를 사용하여 파일 경로 설정
    filename = os.path.join(current_app.static_folder, 'data/월별데이터합침2015-2022(콜롬명수정).csv')
    
    # 데이터 로드
    df = pd.read_csv(filename)

    # 'BAD' 문자를 포함하는 컬럼 제외
    result_df = df.loc[:, ~(df.columns.str.contains('농도') | df.columns.str.contains('차량수'))]


    # 날짜 데이터 변환
    result_df['Year'] = result_df['STD_YYYYMM'].astype(str).str[:4].astype(int)
    result_df['Month'] = result_df['STD_YYYYMM'].astype(str).str[4:].astype(int)

    # 시도 원-핫 인코딩
    sido_dummies = pd.get_dummies(result_df['SIDO'], prefix='SIDO')
    result_df = pd.concat([result_df, sido_dummies], axis=1)

    # 필요한 경우, 원래 'STD_YYYYMM' 및 'SIDO' 컬럼 제거
    result_df.drop(['STD_YYYYMM', 'SIDO'], axis=1, inplace=True)

    # 시각화용 상관관계 행렬 생성
    visualization_columns = [col for col in result_df.columns if 'Year' not in col and 'Month' not in col and not col.startswith('SIDO')]
    vis_corr_matrix = result_df[visualization_columns].corr()

    # 상관 계수 행렬 시각화
    plt.figure(figsize=(12, 10))
    sns.heatmap(vis_corr_matrix, annot=True, fmt=".2f", cmap='coolwarm')
    plt.title('전체상관관계')

    img = io.BytesIO()
    plt.savefig(img, format='png', bbox_inches='tight')
    img.seek(0)
    graph_url = base64.b64encode(img.getvalue()).decode()

    plt.close()

    return f'data:image/png;base64,{graph_url}'

def get_variables_graph_select(selected_variable):
    filename = os.path.join(current_app.static_folder, 'data/월별데이터합침2015-2022(콜롬명수정).csv')
    df = pd.read_csv(filename)


    result_df = df.loc[:, ~(df.columns.str.contains('농도') | df.columns.str.contains('STD') | df.columns.str.contains('SIDO') | df.columns.str.contains('차량수'))]

    # 상관관계 계산
    target_corr = result_df.corrwith(result_df[selected_variable]).sort_values(ascending=False)

    # 선택된 변수가 '환자수'를 포함하면 '환자수'를 포함하는 열 제거
    if '질병' in selected_variable:
        target_corr = target_corr[~target_corr.index.str.contains('질병')]

    # 선택된 변수가 target_corr 인덱스에 존재하는지 확인 후 제거
    if selected_variable in target_corr.index:
        target_corr = target_corr.drop(labels=[selected_variable])

    # 상관계수를 막대 그래프로 표시합니다.
    plt.figure(figsize=(9, 6))  # 그래프 크기 조정
    corr_result_df = target_corr.reset_index()
    corr_result_df.columns = ['변수', '상관관계 수치']
    sns.barplot(x='상관관계 수치', y='변수', data=corr_result_df, palette='Spectral')
    plt.title(f'{selected_variable}와(과) 다른 변수 간의 상관 관계')

    img = io.BytesIO()
    plt.savefig(img, format='png', bbox_inches='tight')
    img.seek(0)
    graph_url = base64.b64encode(img.getvalue()).decode()
    plt.close()

    return f'data:image/png;base64,{graph_url}'


def get_disease_graph(column1, column2, agg_func, agg_func_name_korean):
    # 데이터 파일 경로 설정 및 데이터 로드
    filename = os.path.join(current_app.static_folder, 'data/월별데이터합침2015-2022(콜롬명수정).csv')
    df = pd.read_csv(filename)

    # 필요한 컬럼만 필터링
    result_df = df.loc[:, (df.columns.str.contains('농도') | df.columns.str.contains('질병'))]

    # 선택된 컬럼에 따른 집계(최소값 또는 최대값)
    agg_result = result_df.groupby(column1)[column2].agg(agg_func).reset_index()

    # 막대 그래프 그리기
    plt.figure(figsize=(8, 6))
    
    # 'Y'와 'N' 값에 따라 색상을 지정합니다.
    colors = ["green" if x == "좋음" else "red" for x in agg_result[column1]]
    sns.barplot(x=column1, y=column2, data=agg_result, palette=colors)

    # 그래프 제목 설정
    title = f'{column1}에 따른 {column2}의 {agg_func_name_korean}값 비교'
    plt.title(title)

     # 집계 함수 확인
    print("사용된 집계 함수:", agg_func.__name__)

    img = io.BytesIO()
    plt.savefig(img, format='png', bbox_inches='tight')
    img.seek(0)
    graph_url = base64.b64encode(img.getvalue()).decode()
    plt.close()

    return f'data:image/png;base64,{graph_url}'



def get_corona_graph(sido, variable):
    filename = os.path.join(current_app.static_folder, 'data/코로나시각화.csv')
    df = pd.read_csv(filename)

    # 선택한 시도에 대한 데이터 필터링 및 날짜 변환
    filtered_df = df[df['SIDO'] == sido]
    filtered_df['STD_YYYYMM'] = pd.to_datetime(filtered_df['STD_YYYYMM'], format='%Y%m')

    # 코로나19 기간 설정
    pre_covid_start = datetime(2010, 1, 1)
    pre_covid_end = datetime(2019, 12, 31)
    covid_start = datetime(2020, 1, 1)
    covid_end = datetime(2021, 12, 31)

    # 데이터 프레임 필터링
    pre_covid_df = filtered_df[(filtered_df['STD_YYYYMM'] >= pre_covid_start) & (filtered_df['STD_YYYYMM'] <= pre_covid_end)]
    covid_df = filtered_df[(filtered_df['STD_YYYYMM'] >= covid_start) & (filtered_df['STD_YYYYMM'] <= covid_end)]

    # 각 기간의 평균 계산
    pre_covid_avg = pre_covid_df[variable].mean()
    covid_avg = covid_df[variable].mean()

    if pre_covid_avg != 0:
        select_corona_percent_change = int(((covid_avg - pre_covid_avg) / pre_covid_avg) * 100)
    else:
        select_corona_percent_change = 0  # 이전 기간의 평균이 0인 경우, 변화율을 0으로 설정

    

    # 증감률에 따라 "증가" 또는 "감소" 결정
    change_type = "증가" if select_corona_percent_change >= 0 else "감소"
    


    # 시각화
    plt.figure(figsize=(10, 6))
    sns.lineplot(x='STD_YYYYMM', y=variable, data=pre_covid_df, marker='o', label='코로나19 이전')
    sns.lineplot(x='STD_YYYYMM', y=variable, data=covid_df, marker='o', label='코로나19 기간')

    # 평균선 추가
    plt.axhline(pre_covid_avg, color='blue', linestyle='--', label='코로나19 이전 평균')
    plt.axhline(covid_avg, color='orange', linestyle='--', label='코로나19 기간 평균')

    plt.title(f'-{sido} {variable} 코로나19 기간에 {abs(select_corona_percent_change)}% {change_type}-')
    plt.xlabel('년월')
    plt.ylabel(variable)
    plt.xticks(rotation=45)
    plt.legend()
    plt.grid(True)

    # 이미지로 변환 및 Base64 인코딩
    img = io.BytesIO()
    plt.savefig(img, format='png', bbox_inches='tight')
    img.seek(0)
    graph_url = base64.b64encode(img.getvalue()).decode()
    plt.close()

    return f'data:image/png;base64,{graph_url}', select_corona_percent_change

def find_similar_covid_impact(sido, variable, select_corona_percent_change):

    filename = os.path.join(current_app.static_folder, 'data/코로나시각화.csv')
    df = pd.read_csv(filename)
    # 코로나 증감폭 컬럼만 필터링
    covid_impact_columns = [col for col in df.columns if '코로나증감폭' in col and variable not in col]
    
    # 가장 유사한 증감폭 찾기
    closest_value = None
    closest_column = None
    
    min_diff = float('inf')

    for col in covid_impact_columns:
        # 선택된 시도에 대한 데이터 필터링
        filtered_df = df[df['SIDO'] == sido]
        
        # 증감폭 차이 계산
        diff = abs(filtered_df[col] - select_corona_percent_change).min()

        # 조건을 만족하는 행이 있는지 확인
        matching_rows = filtered_df[abs(filtered_df[col] - select_corona_percent_change) == diff]
        
        if not matching_rows.empty and diff < min_diff:
            min_diff = diff
            closest_value = matching_rows[col].iloc[0]
            closest_column = col
            

    # 결과 포매팅
    if closest_column:
        similar_variable = closest_column.split('_코로나증감폭')[0]
        change_type = "증가" if closest_value >= 0 else "감소"
        similar_impact_message = f"- {sido}의 {similar_variable} {abs(closest_value)}% {change_type}와 가장 유사 -"
        return similar_impact_message
    else:
        return "유사한 증감폭을 찾을 수 없습니다."
    

def predict(features_scaled, model, scaler_target, n_input, n_features):
    x_input = features_scaled[-n_input:]
    x_input = x_input.reshape((1, n_input, n_features))
    predicted = model.predict(x_input, verbose=0)

    predicted_reshaped = predicted.reshape(-1, 1)
    predicted_inverse = scaler_target.inverse_transform(predicted_reshaped)
    return int(predicted_inverse[0][0])  # round 대신 int 사용


# 예측을 위한 함수
def predict_pm10_pm25():
    # 먼저 대기오염 데이터를 업데이트합니다.
    fetch_air_quality_api_data()

    # 데이터 파일 로드
    filename = os.path.join(current_app.static_folder, 'data/12-23대기오염nan처리.csv')    
    df = pd.read_csv(filename)

    # 예측에 필요한 입력값 설정
    n_input = 30
    n_features_pm10 = 5
    n_features_pm25 = 5

    features_pm10 = df[['이산화질소', '오존', '일산화탄소', '아황산', '초미세']]
    features_pm25 = df[['이산화질소', '오존', '일산화탄소', '아황산', '미세']]

    # 스케일러 로드
    scaler_filename_pm10 = os.path.join(current_app.static_folder, 'model/scaler_pm10.joblib')
    scaler_features_pm10 = joblib.load(scaler_filename_pm10)
    features_scaled_pm10 = scaler_features_pm10.transform(features_pm10)

    scaler_filename_pm25 = os.path.join(current_app.static_folder, 'model/scaler_pm25.joblib')
    scaler_features_pm25 = joblib.load(scaler_filename_pm25)
    features_scaled_pm25 = scaler_features_pm25.transform(features_pm25)

    # 타겟 스케일러 로드
    scaler_target_pm10 = joblib.load(os.path.join(current_app.static_folder, 'model/scaler_pm10_target.joblib'))
    scaler_target_pm25 = joblib.load(os.path.join(current_app.static_folder, 'model/scaler_pm25_target.joblib'))

    # 모델 로드 및 예측
    model_filename_pm10 = os.path.join(current_app.static_folder, 'model/pm10_model.h5')
    model_pm10 = load_model(model_filename_pm10)
    predicted_pm10 = predict(features_scaled_pm10, model_pm10, scaler_target_pm10, n_input, n_features_pm10)

    model_filename_pm25 = os.path.join(current_app.static_folder, 'model/pm25_model.h5')
    model_pm25 = load_model(model_filename_pm25)
    predicted_pm25 = predict(features_scaled_pm25, model_pm25, scaler_target_pm25, n_input, n_features_pm25)

    # 등급 결정 함수
    def determine_grade_pm10(value):
        if value <= 30:
            return '좋음'
        elif value <= 80:
            return '보통'
        elif value <= 150:
            return '나쁨'
        else:
            return '매우나쁨'

    def determine_grade_pm25(value):
        if value <= 15:
            return '좋음'
        elif value <= 35:
            return '보통'
        elif value <= 75:
            return '나쁨'
        else:
            return '매우나쁨'

    grade_pm10 = determine_grade_pm10(predicted_pm10)
    grade_pm25 = determine_grade_pm25(predicted_pm25)

    # 세 개의 문자열 변수 반환
    prediction_summary = f"내일 예상되는 미세먼지와 초미세먼지는 {predicted_pm10}, {predicted_pm25} 수치를 예상합니다."
    grade_pm10_str = grade_pm10
    grade_pm25_str = grade_pm25

    return prediction_summary, grade_pm10_str, grade_pm25_str



 




def fetch_air_quality_api_data():
    
    filename = os.path.join(current_app.static_folder, 'data/12-23대기오염nan처리.csv')   
    df = pd.read_csv(filename)

    api_key_file = os.path.join(current_app.static_folder, 'keys/api.txt')

    # API 키 로드
    with open(api_key_file, 'r') as file:
        road_key = file.read().strip()

    # 구 이름 목록
    gu_names = [
        "강남구", "강남대로", "강동구", "강변북로", "강북구", "강서구", "공항대로",
        "관악구", "광진구", "구로구", "금천구", "노원구", "도봉구", "도산대로",
        "동대문구", "동작구", "동작대로", "마포구", "서대문구", "서초구", "성동구",
        "성북구", "송파구", "신촌로", "양천구", "영등포구", "영등포로", "용산구",
        "은평구", "정릉로", "종로", "종로구", "중구", "중랑구", "천호대로",
        "청계천로", "한강대로", "홍릉로", "화랑로"
    ]

    start_point = df['측정일시'].tail(1).values
    start_point_datetime = datetime.strptime(str(start_point[0]), "%Y%m%d")
    start_date = start_point_datetime + timedelta(days=1)
    end_date = datetime.now()

        # 서울 시간대 설정
    seoul_timezone = pytz.timezone('Asia/Seoul')

    # 서버의 현재 시간을 서울 시간대로 변환
    current_time_in_seoul = datetime.now().astimezone(seoul_timezone)

    # 현재 시간의 시간 부분만 추출
    current_hour = current_time_in_seoul.hour


    # 시작 날짜와 종료 날짜가 다를 경우에만 데이터 처리
    if start_date < end_date:
        if current_hour >= 10:
            all_data_df1 = pd.DataFrame()        
            for attempt in range(3):  # 최대 3번 재시도
                print(f"시도 {attempt+1}")
                try:
                    for single_date in (start_date + timedelta(n) for n in range((end_date - start_date).days + 1)):
                        date_str = single_date.strftime("%Y%m%d")
                        for gu_name in gu_names:
                            url = f"http://openAPI.seoul.go.kr:8088/{road_key}/xml/DailyAverageAirQuality/1/5/{date_str}/{gu_name}"
                            result = requests.get(url, timeout=20)
                            if result.status_code == 200:
                                xml_data = result.text
                                root = ET.fromstring(xml_data)
                                rows = []
                                for row in root.findall('.//row'):
                                    rows.append({
                                        "측정일시": row.find('MSRDT_DE').text if row.find('MSRDT_DE') is not None else None,
                                        "측정소명": row.find('MSRSTE_NM').text if row.find('MSRSTE_NM') is not None else None,
                                        "이산화질소": row.find('NO2').text if row.find('NO2') is not None else None,
                                        "오존": row.find('O3').text if row.find('O3') is not None else None,
                                        "일산화탄소": row.find('CO').text if row.find('CO') is not None else None,
                                        "아황산": row.find('SO2').text if row.find('SO2') is not None else None,
                                        "미세": row.find('PM10').text if row.find('PM10') is not None else None,
                                        "초미세": row.find('PM25').text if row.find('PM25') is not None else None
                                    })
                                df2 = pd.DataFrame(rows)
                                all_data_df1 = pd.concat([all_data_df1, df2], ignore_index=True)
                            else:
                                print(f"에러: {gu_name} - {date_str} - 상태 코드: {result.status_code}")
                except requests.exceptions.RequestException:
                    time.sleep(5)  # 5초 대기 후 재시도

            all_data_df1.replace({None: np.nan}, inplace=True)
            combined_df = all_data_df1.dropna()
            combined_df = combined_df.drop(columns=['측정소명'])

            for col in combined_df.columns:
                if col == '측정일시':
                    combined_df[col] = combined_df[col].astype(np.int64)
                else:
                    combined_df[col] = combined_df[col].astype(float)

            combined_df = combined_df.groupby('측정일시', as_index=False).mean()
            combined_df['이산화질소'] = combined_df['이산화질소'].round(3)
            combined_df['오존'] = combined_df['오존'].round(3)
            combined_df['일산화탄소'] = combined_df['일산화탄소'].round(1)
            combined_df['아황산'] = combined_df['아황산'].round(3)
            combined_df['미세'] = combined_df['미세'].round(0)
            combined_df['초미세'] = combined_df['초미세'].round(0)

            df = pd.concat([df, combined_df], ignore_index=True)
            save_path = os.path.join(current_app.static_folder, 'data')
        
            # 디렉토리 존재 여부 확인 및 생성
            if not os.path.exists(save_path):
                os.makedirs(save_path)
            # 수정된 경로로 파일 저장
            file_path = os.path.join(save_path, '12-23대기오염nan처리.csv')
            df.to_csv(file_path, index=False)
        else:
            print("현재 시간이 오전 10시가 아닙니다. 데이터 크롤링을 건너뜁니다.")
    else:
        print("데이터가 이미 최신 상태입니다.")

def fetch_air_quality_data():
    # 현재 날짜 구하기
    now_date = datetime.now().date()

    # 데이터 프레임 불러오기
    filename = os.path.join(current_app.static_folder, 'data/크롤링미세먼지.csv')
    print(filename)
    if os.path.exists(filename):
        df22 = pd.read_csv(filename)
        if now_date in pd.to_datetime(df22['오늘날짜']).dt.date.values:
            # 오늘 날짜의 데이터가 이미 있으면 해당 데이터를 반환
            latest_data = df22[df22['오늘날짜'] == str(now_date)].iloc[-1]
            return latest_data['내일미세10'], latest_data['내일미세25'], latest_data['오늘미세10'], latest_data['오늘미세25']
    else:
        df22 = pd.DataFrame(columns=['오늘날짜', '내일미세10', '내일미세25', '오늘미세10', '오늘미세25'])

    print(df22.columns)
    # 크롤링 시작
    # 헤드리스 모드 설정
    chrome_options1 = Options()
    chrome_options1.add_argument('--headless')

    # 웹드라이버 초기화 및 웹사이트 접속
    driver1 = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=chrome_options1)
    url1 = 'https://www.airkorea.or.kr/web/dustForecast?pMENU_NO=113'
    driver1.get(url1)
    print('미세먼지크롤링시작')

    try:
        # 원하는 요소 찾기 및 기다리기
        element = WebDriverWait(driver1, 10).until(
            EC.presence_of_element_located((By.XPATH, '//*[@id="lnb"]/div[2]/div/div[4]/div[2]/div/table/tbody/tr[2]/td[1]'))
        )
        element2 = WebDriverWait(driver1, 10).until(
            EC.presence_of_element_located((By.XPATH, '//*[@id="lnb"]/div[2]/div/div[4]/div[2]/div/table/tbody/tr[3]/td[1]'))
        )
        element3 = WebDriverWait(driver1, 10).until(
            EC.presence_of_element_located((By.XPATH, '//*[@id="lnb"]/div[2]/div/div[3]/div[2]/div/table/tbody/tr[2]/td[1]'))
        )
        element4 = WebDriverWait(driver1, 10).until(
            EC.presence_of_element_located((By.XPATH, '//*[@id="lnb"]/div[2]/div/div[3]/div[2]/div/table/tbody/tr[3]/td[1]'))
        )
        print('미세먼지크롤링긁기시작')
        # 요소의 텍스트 추출
        tomorrow_cw_pm10 = element.text
        tomorrow_cw_pm25 = element2.text
        today_cw_pm10 = element3.text
        today_cw_pm25 = element4.text
        print(today_cw_pm25)

    finally:
        driver1.quit()

    # 새로운 데이터 행 생성 및 데이터 프레임에 추가
    new_row = {
        '오늘날짜': str(now_date),
        '내일미세10': tomorrow_cw_pm10,
        '내일미세25': tomorrow_cw_pm25,
        '오늘미세10': today_cw_pm10,
        '오늘미세25': today_cw_pm25
    }

    # 딕셔너리를 데이터프레임으로 변환 (행 방향으로)
    new_row_df = pd.DataFrame([new_row])

    # 기존 데이터프레임과 새로운 데이터프레임을 연결
    df22 = pd.concat([df22, new_row_df], ignore_index=True)
    print(new_row)
    print(df22)

    try:
        df22.to_csv(filename, index=False)
        print('미세먼지크롤링데이터저장')
    except Exception as e:
        print('데이터 저장 중 오류 발생:', e)

    return tomorrow_cw_pm10, tomorrow_cw_pm25, today_cw_pm10, today_cw_pm25