from flask import Flask, jsonify, request, render_template
from datetime import datetime, timedelta
import requests
import pandas as pd
from flask_cors import CORS
import csv
from draw_map import  BORDER_LINES, drawKorea, drawKoreaMinus
<<<<<<< HEAD
from time import sleep
=======
>>>>>>> 7789264a3b2c780595c58da50664e82e7906d3d7

app = Flask(__name__)
CORS(app)

# # 서버 시작 전에 실행될 함수
# @app.before_first_request
# def before_first_request():

#     # 기본 URL 및 API 키 설정
#     base_url = "http://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty"
#     with open('static/keys/에어코리아api2.txt') as file:
#         service_key = file.read()  # 발급받은 에어코리아 API 키 입력

#     # 예제 데이터프레임 생성
#     main = pd.read_csv('static/data/카토그램_최종.csv', encoding='utf-8')

#     # 결과를 저장할 리스트
#     results_list = []

#     # 요청을 나누어 보내기
#     chunk_size = 50
#     max_retries = 3

#     for i in range(0, len(main), chunk_size):
#         chunk = main.iloc[i:i+chunk_size]
        
#         # 각 측정소에 대한 데이터 수집
#         for index, row in chunk.iterrows():
#             retry_count = 0

#             while retry_count < max_retries:
#                 try:
#                     params = {
#                         'serviceKey': service_key,
#                         'returnType': 'JSON',
#                         'numOfRows': 24,
#                         'pageNo': 1,
#                         'stationName': row['측정소명'],
#                         'dataTerm': 'DAILY',
#                         'ver': "1.4"
#                     }

#                     res = requests.get(url=base_url, params=params)

#                     # 응답 데이터 정리
#                     response = res.json()['response']['body']
                    
#                     # 데이터가 존재하면 처리
#                     if 'items' in response and response['items']:
#                         data = response['items']
                        
#                         # 데이터를 날짜와 시간에 대한 기준으로 정렬
#                         sorted_data = sorted(data, key=lambda x: x['dataTime'], reverse=True)

#                         # 최신 데이터 선택
#                         latest_data = None

#                         for data in sorted_data:
#                             pm10_value = data.get('pm10Value')
#                             if pm10_value and pm10_value != '-':
#                                 latest_data = data
#                                 break

#                         # 최신 데이터가 없으면 첫 번째 데이터 선택
#                         if not latest_data and sorted_data:
#                             latest_data = sorted_data[0]

#                         result = {
#                             '날짜': latest_data['dataTime'],
#                             '이름': latest_data['stationName'],
#                             '측정망 정보': latest_data['mangName'],
#                             '아황산가스 농도': latest_data['so2Value'],
#                             '일산화탄소 농도': latest_data['coValue'],
#                             '오존 농도': latest_data['o3Value'],
#                             '이산화질소 농도': latest_data['no2Value'],
#                             '미세먼지(PM10) 농도': latest_data.get('pm10Value', 0),
#                             '초미세먼지(PM2.5) 농도': latest_data.get('pm25Value', 0)
#                         }

#                         results_list.append(result)
#                         break  # 성공한 경우 while 루프 종료
#                     else:
#                         results_list.append({})
#                         break  # 성공했지만 데이터가 비어있는 경우 while 루프 종료

#                 except requests.exceptions.RequestException as e:
#                     print(f"Request failed: {e}")
#                     retry_count += 1
#                     print(f"Retrying... (Attempt {retry_count}/{max_retries})")

#                     if retry_count == max_retries:
#                         print(f"Max retries reached. Skipping request for {row['측정소명']}")
#                         break  # 최대 재시도 횟수에 도달하면 while 루프 종료

#     # 결과 리스트의 길이를 250개로 맞추기
#     results_list.extend([{}] * (len(main) - len(results_list)))

#     # '미세먼지' 데이터를 숫자로 변환하고, 빈 데이터는 0으로 변경
#     main['미세먼지'] = pd.to_numeric([entry.get('미세먼지(PM10) 농도', 0) for entry in results_list], errors='coerce')
#     main['미세먼지'] = main['미세먼지'].fillna(0)

#     # '미세먼지' 처리 이후에 그래프 그리기
#     drawKorea('미세먼지', main, 'Blues', save_filename='../onnana/src/main/resources/static/img/카토그램.png')

def get_weather(nx, ny):
    base_url = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst"
    with open('static/keys/기상청api.txt') as file:
        service_key = file.read()

    # 웹 요청할 base_date, base_time 계산
    now = datetime.now()

    if now.minute <= 40:
        if now.hour == 0:
            base_date = (now - timedelta(days=1)).strftime('%Y%m%d')
            base_time = '2300'
        else:
            base_date = now.strftime('%Y%m%d')
            base_time = (now - timedelta(hours=1)).strftime('%H00')
    else:
        base_date = base_date = now.strftime('%Y%m%d') 
        base_time = now.strftime('%H00')
<<<<<<< HEAD

    params = {
        'serviceKey': service_key,
        'numOfRows': 10,
        'pageNo': 1,
        'dataType': 'JSON',
        'base_date': base_date,
        'base_time': base_time,
        'nx': nx,
        'ny': ny,
    }

    res = requests.get(url=base_url, params=params)

    data = res.json()
    data = data['response']['body']['items']['item']

    categorys = {
        'T1H': '기온',
        'RN1': '1시간 강수량',
        'UUU': '동서바람성분',
        'VVV': '남북바람성분',
        'REH': '습도',
        'PTY': '강수형태',
        'VEC': '풍향',
        'WSD': '풍속',
    }

    results = {}
    for d in data:
        category = categorys[d['category']]
        value = d['obsrValue']

        if category == '기온':
            value = f"{value}°C"
        elif category == '1시간 강수량':
            value = f"{value}mm"
        elif category in ['동서바람성분', '남북바람성분', '풍속']:
            value = f"{value}m/s"
        elif category == '습도':
            value = f"{value}%"
        elif category == '풍향':
            value = int(value)
            if 0 <= value <= 45:
                value = "북동"
            elif 46 <= value <= 90:
                value = "동"
            elif 91 <= value <= 135:
                value = "남동"
            elif 136 <= value <= 180:
                value = "남"
            elif 181 <= value <= 225:
                value = "남서"
            elif 226 <= value <= 270:
                value = "서"
            elif 271 <= value <= 315:
                value = "북서"
            elif 316 <= value <= 360:
                value = "북"

        results[category] = value

    return results

def get_air_quality(station_name):
    with open('static/keys/에어코리아api2.txt') as file:
        air_service_key = file.read()
    air_base_url = "http://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty"

    params = {
        'serviceKey': air_service_key,
        'returnType': 'JSON',
        'numOfRows': 24,
        'pageNo': 1,
        'stationName': station_name,
        'dataTerm': 'DAILY',
        'ver': "1.4"
    }

    res = requests.get(url=air_base_url, params=params)

    data = res.json()
    data = data['response']['body']['items']

    sorted_data = sorted(data, key=lambda x: x['dataTime'], reverse=True)
    latest_data = sorted_data[0]

    results = {
        '날짜': latest_data['dataTime'],
        '이름': latest_data['stationName'],
        '측정망 정보': latest_data['mangName'],
        '아황산가스 농도': latest_data['so2Value'] + "ppm",
        '일산화탄소 농도': latest_data['coValue'] + "ppm",
        '오존 농도': latest_data['o3Value'] + "ppm",
        '이산화질소 농도': latest_data['no2Value'] + "ppm",
        '미세먼지(PM10) 농도': latest_data['pm10Value'] + "ug/m³",
        '초미세먼지(PM2.5) 농도': latest_data['pm25Value'] + "ug/m³"
    }

    return results


@app.route('/get_weather', methods=['GET'])
def get_weather_route():
    # 클라이언트로부터 받은 요청 파라미터에서 nx와 ny를 추출
    nx = request.args.get('nx')
    ny = request.args.get('ny')

    if nx is not None and ny is not None:
        # 기상 정보를 가져오는 함수 호출
        weather_result = get_weather(nx, ny)

        # 결과를 JSON으로 반환
        return jsonify(weather_result)
    else:
        return jsonify({'error': 'Invalid request parameters'})


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
=======

    params = {
        'serviceKey': service_key,
        'numOfRows': 10,
        'pageNo': 1,
        'dataType': 'JSON',
        'base_date': base_date,
        'base_time': base_time,
        'nx': nx,
        'ny': ny,
    }

    res = requests.get(url=base_url, params=params)

    data = res.json()
    data = data['response']['body']['items']['item']

    categorys = {
        'T1H': '기온',
        'RN1': '1시간 강수량',
        'UUU': '동서바람성분',
        'VVV': '남북바람성분',
        'REH': '습도',
        'PTY': '강수형태',
        'VEC': '풍향',
        'WSD': '풍속',
    }

    results = {}
    for d in data:
        category = categorys[d['category']]
        value = d['obsrValue']

        if category == '기온':
            value = f"{value}°C"
        elif category == '1시간 강수량':
            value = f"{value}mm"
        elif category in ['동서바람성분', '남북바람성분', '풍속']:
            value = f"{value}m/s"
        elif category == '습도':
            value = f"{value}%"
        elif category == '풍향':
            value = int(value)
            if 0 <= value <= 45:
                value = "북동"
            elif 46 <= value <= 90:
                value = "동"
            elif 91 <= value <= 135:
                value = "남동"
            elif 136 <= value <= 180:
                value = "남"
            elif 181 <= value <= 225:
                value = "남서"
            elif 226 <= value <= 270:
                value = "서"
            elif 271 <= value <= 315:
                value = "북서"
            elif 316 <= value <= 360:
                value = "북"

        results[category] = value

    return results

def get_air_quality(station_Name):
    
    # 측정소별 실시간 측정정보 조회 (매시 15분 내외 업데이트)
    base_url = "http://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty"
    with open('static/keys/에어코리아api3.txt') as file:
        service_key = file.read()       # 발급받은 에어코리아 API 키 입력
        
    # 웹 요청시 같이 전달될 데이터 = 요청 메시지
    params = {
        'serviceKey' : service_key,
        'returnType' : 'JSON',
        'numOfRows' : 24,
        'pageNo' : 1,
        'stationName' : station_Name, # 시도 이름
        'dataTerm' : 'DAILY',
        'ver' : "1.4" # 오퍼레이션 버전
    }

    res = requests.get(url=base_url , params=params)

    # 응답 데이터 정리
    data = res.json() # json.loads(res.text)와 같은 기능
    data = data['response']['body']['items']
    
    # 데이터를 날짜와 시간에 대한 기준으로 정렬
    sorted_data = sorted(data, key=lambda x: x['dataTime'], reverse=True)

    # 최신 데이터 선택
    latest_data = sorted_data[0]
    
    # 최종 데이터 생성
    results = {
        '날짜': latest_data['dataTime'],
        '이름': latest_data['stationName'],
        '측정망 정보': latest_data['mangName'],
        '아황산가스 농도': latest_data['so2Value'] + "ppm",
        '일산화탄소 농도': latest_data['coValue'] + "ppm",
        '오존 농도': latest_data['o3Value'] + "ppm",
        '이산화질소 농도': latest_data['no2Value'] + "ppm",
        '미세먼지(PM10) 농도': latest_data['pm10Value'] + "ug/m³",
        '초미세먼지(PM2.5) 농도': latest_data['pm25Value'] + "ug/m³"
    }

    # pprint(results)
    return results


@app.route('/get_weather', methods=['GET'])
def get_weather_route():
    # 클라이언트로부터 받은 요청 파라미터에서 nx와 ny를 추출
    nx = request.args.get('nx')
    ny = request.args.get('ny')

    if nx is not None and ny is not None:
        # 기상 정보를 가져오는 함수 호출
        weather_result = get_weather(nx, ny)

        # 결과를 JSON으로 반환
        return jsonify(weather_result)
    else:
        return jsonify({'error': 'Invalid request parameters'})

@app.route('/get_air_quality' , methods=['GET'])
def get_air_quality_route():
    
    name = request.args.get('name')
    
    if name is not None:
        air_result = get_air_quality(name)
        
        return jsonify(air_result)
    else:
        return jsonify({'error': 'Invalid request parameters'})
    

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
>>>>>>> 7789264a3b2c780595c58da50664e82e7906d3d7
