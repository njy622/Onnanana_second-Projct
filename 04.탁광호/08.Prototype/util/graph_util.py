import requests, json, os, folium
import numpy as np
import pandas as pd
from urllib.parse import quote
import seaborn as sns
import matplotlib.pyplot as plt
import io
import base64
from flask import current_app
plt.rcParams['font.family'] = 'Malgun Gothic'
plt.rcParams['axes.unicode_minus'] = False

def get_variables_graph():
    
    # 현재 애플리케이션의 정적 파일 경로를 사용하여 파일 경로 설정
    filename = os.path.join(current_app.static_folder, 'data/월별데이터합침2015-2022.csv')
    
    # 데이터 로드
    df = pd.read_csv(filename)

    # 'BAD' 문자를 포함하는 컬럼 제외
    result_df = df.loc[:, ~df.columns.str.contains('BAD')]

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
    plt.title('선택된 변수 간 상관 관계')

    img = io.BytesIO()
    plt.savefig(img, format='png', bbox_inches='tight')
    img.seek(0)
    graph_url = base64.b64encode(img.getvalue()).decode()

    plt.close()

    return f'data:image/png;base64,{graph_url}'

def get_variables_graph_select(selected_variable):
    filename = os.path.join(current_app.static_folder, 'data/월별데이터합침2015-2022.csv')
    df = pd.read_csv(filename)


    result_df = df.loc[:, ~(df.columns.str.contains('BAD') | df.columns.str.contains('STD') | df.columns.str.contains('SIDO'))]

    # 선택된 변수와 다른 모든 변수 간의 상관관계 계산
    target_corr = result_df.corrwith(result_df[selected_variable]).sort_values(ascending=False)

    # 선택된 변수 제거
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



def get_station_map(root_path, stations):
    # 도로명 주소 구하기
    # filename = '../04.지도시각화/keys/도로명주소apiKey.txt'
    filename = os.path.join(root_path, 'static/keys/도로명주소apiKey.txt')
    with open(filename) as file:
        road_key = file.read()

    base_url = 'https://www.juso.go.kr/addrlink/addrLinkApi.do'
    params1 = f'confmKey={road_key}&currentPage=1&countPerPage=10'
    road_addr_list = []
    for station in stations:
        params2 = f'keyword={quote(station)}&resultType=json'
        url = f'{base_url}?{params1}&{params2}'
        result = requests.get(url)
        if result.status_code == 200:
            res = json.loads(result.text)
            road_addr_list.append(res['results']['juso'][0]['roadAddr'])
        else:
            print(result.status_code)
    df = pd.DataFrame({'이름': stations, '주소': road_addr_list})

    # 위도, 경도 좌표 구하기
    filename = os.path.join(root_path, 'static/keys/카카오apiKey.txt')
    with open(filename) as file:
        kakao_key = file.read()
    base_url = 'https://dapi.kakao.com/v2/local/search/address.json'
    header = {'Authorization': f'KakaoAK {kakao_key}'}

    lat_list, lng_list = [], []
    for i in df.index:
        url = f'{base_url}?query={quote(df["주소"][i])}'
        result = requests.get(url, headers=header).json()
        lat_list.append(float(result['documents'][0]['y']))
        lng_list.append(float(result['documents'][0]['x']))
    df['위도'] = lat_list
    df['경도'] = lng_list

    # map 그리기
    map = folium.Map(location=[df.위도.mean(), df.경도.mean()], zoom_start=14)  # Center position
    for i in df.index:
        folium.Marker(
            location=[df.위도[i], df.경도[i]],       
            tooltip=df.이름[i],
            popup=folium.Popup(df.주소[i], max_width=200)
        ).add_to(map)   
    filename = os.path.join(root_path, 'static/img/station_map.html')
    map.save(filename)

def get_text_location(geo_str):
    gu_dict = {}
    for gu in geo_str['features']:
        for coord in gu['geometry']['coordinates']:
            geo = np.array(coord)
            gu_dict[gu['id']] = [np.mean(geo[:,1]), np.mean(geo[:,0])]
    return gu_dict

def get_cctv(static_path):
    filename = f'{static_path}/data/서울시 구별 CCTV 인구 현황.csv'
    df = pd.read_csv(filename, index_col='구별')
    geo_data = json.load(open(f'{static_path}/data/seoul_geo_simple.json', encoding='utf-8'))

    map = folium.Map([37.55, 126.98], zoom_start=11, tiles='Stamen Toner')
    folium.Choropleth(
        geo_data=geo_data,      # GEO 지도 데이터
        data=df.CCTV댓수,       # 단계구분도로 보여줄 데이터
        columns=[df.index, df.CCTV댓수],        # 데이터프레임에서 추출할 항목
        fill_color='RdPu',      # Colormap
        key_on='feature.id'     # 지도에서 조인할 항목
    ).add_to(map)
    gu_dict = get_text_location(geo_data)
    for gu_name in df.index:
        folium.map.Marker(
            location=gu_dict[gu_name],
            icon = folium.DivIcon(icon_size=(80,20), icon_anchor=(20,0),
                        html=f'<span style="font-size: 10pt">{gu_name}</span>')
    ).add_to(map)
    map.save(f'{static_path}/img/cctv.html')

def get_cctv_pop(static_path, column, colormap):
    filename = f'{static_path}/data/서울시 구별 CCTV 인구 현황.csv'
    df = pd.read_csv(filename, index_col='구별')
    geo_data = json.load(open(f'{static_path}/data/seoul_geo_simple.json', encoding='utf-8'))

    map = folium.Map([37.55, 126.98], zoom_start=11, tiles='Stamen Toner')
    folium.Choropleth(
        geo_data=geo_data,      # GEO 지도 데이터
        data=df[column],        # 단계구분도로 보여줄 데이터
        columns=[df.index, df[column]],     # 데이터프레임에서 추출할 항목
        fill_color=colormap,    # Colormap
        key_on='feature.id'     # 지도에서 조인할 항목
    ).add_to(map)
    gu_dict = get_text_location(geo_data)
    for gu_name in df.index:
        folium.map.Marker(
            location=gu_dict[gu_name],
            icon = folium.DivIcon(icon_size=(80,20), icon_anchor=(20,0),
                        html=f'<span style="font-size: 10pt">{gu_name}</span>')
    ).add_to(map)
    map.save(f'{static_path}/img/cctv_pop.html')

def get_coord(static_path, place):
    filename = os.path.join(static_path, 'keys/도로명주소apiKey.txt')
    with open(filename) as file:
        road_key = file.read()
    base_url = 'https://www.juso.go.kr/addrlink/addrLinkApi.do'
    params1 = f'confmKey={road_key}&currentPage=1&countPerPage=10'
    params2 = f'keyword={quote(place)}&resultType=json'
    url = f'{base_url}?{params1}&{params2}'
    result = requests.get(url).json()
    road_addr = result['results']['juso'][0]['roadAddr']

    filename = os.path.join(static_path, 'keys/카카오apiKey.txt')
    with open(filename) as file:
        kakao_key = file.read()
    base_url = 'https://dapi.kakao.com/v2/local/search/address.json'
    header = {'Authorization': f'KakaoAK {kakao_key}'}
    url = f'{base_url}?query={quote(road_addr)}'
    result = requests.get(url, headers=header).json()
    lat = float(result['documents'][0]['y'])
    lng = float(result['documents'][0]['x'])
    return lat, lng
