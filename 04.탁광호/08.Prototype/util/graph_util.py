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
    print("사용된 집계 함수:", agg_func)

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


def predict_pm10_pm25(selected_variable):

    # 먼저 대기오염 데이터를 업데이트합니다.
    fetch_air_quality_data()


    filename = os.path.join(current_app.static_folder, 'data/12-23대기오염nan처리.csv')    
    df = pd.read_csv(filename)

    n_input = 30
    n_features_pm10 = 5
    n_features_pm25 = 5

    features_pm10 = df[['이산화질소', '오존', '일산화탄소', '아황산', '초미세']]
    features_pm25 = df[['이산화질소', '오존', '일산화탄소', '아황산', '미세']]

    scaler_filename_pm10 = os.path.join(current_app.static_folder, 'model/scaler_pm10.joblib')
    scaler_features_pm10 = joblib.load(scaler_filename_pm10)
    features_scaled_pm10 = scaler_features_pm10.transform(features_pm10)

    scaler_filename_pm25 = os.path.join(current_app.static_folder, 'model/scaler_pm25.joblib')
    scaler_features_pm25 = joblib.load(scaler_filename_pm25)
    features_scaled_pm25 = scaler_features_pm25.transform(features_pm25)

    scaler_target_pm10 = joblib.load(os.path.join(current_app.static_folder, 'model/scaler_pm10_target.joblib'))
    scaler_target_pm25 = joblib.load(os.path.join(current_app.static_folder, 'model/scaler_pm25_target.joblib'))

    if selected_variable == '미세먼지':
        model_filename = os.path.join(current_app.static_folder, 'model/pm10_model.h5')
        model_pm10 = load_model(model_filename)
        predicted_pm10 = predict(features_scaled_pm10, model_pm10, scaler_target_pm10, n_input, n_features_pm10)
        return f"예상되는 미세먼지는 {predicted_pm10}입니다."
    elif selected_variable == '초미세먼지':
        model_filename = os.path.join(current_app.static_folder, 'model/pm25_model.h5')
        model_pm25 = load_model(model_filename)
        predicted_pm25 = predict(features_scaled_pm25, model_pm25, scaler_target_pm25, n_input, n_features_pm25)
        return f"예상되는 초미세먼지는 {predicted_pm25}입니다."



 




def fetch_air_quality_data():
    
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

    # 시작 날짜와 종료 날짜가 다를 경우에만 데이터 처리
    if start_date < end_date:
        all_data_df1 = pd.DataFrame()

        for attempt in range(3):  # 최대 3번 재시도
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
        df.to_csv('1211.대기오염미래예측/data/12-23대기오염nan처리.csv', index=False)

    else:
        print("데이터가 이미 최신 상태입니다.")

