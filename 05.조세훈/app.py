# 필요한 모듈 임포트
from flask import Flask, render_template
import pandas as pd
import json
import requests, time
from bs4 import BeautifulSoup
from selenium import webdriver
from datetime import datetime, timedelta
from selenium.webdriver.common.by import By
from flask_cors import CORS



# Flask 웹 애플리케이션을 생성합니다.
app = Flask(__name__)
CORS(app)  # 모든 경로에 대해 CORS 허용

def crawl_and_save_to_csv():
    data1 = []
    data2 = []
    url = 'https://www.kr-weathernews.com/mv3/html/lifeindex.html?region='
    header = {'User-Agent' : 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36'}
    res = requests.get(url, headers=header) 
    chrome_options = webdriver.ChromeOptions()
    chrome_options.add_argument('--headless')
    chrome_options.add_argument('--disable-gpu')

    driver = webdriver.Chrome(options=chrome_options)
    driver.get(url)
    soup = BeautifulSoup(driver.page_source, 'html.parser')
    trs = soup.select('#slidePage1 > #pointList > li')

    try:
        for tr in trs:
            img = tr.select_one('img')['src']
            item = tr.select_one('h1').get_text().strip().replace('.', '')
            index = tr.select_one('h2').get_text().strip()
            ment = tr.select_one('p').get_text().strip()

            # 그래프 크롤링
            progress_element = tr.select_one('progress')
            graph_value = progress_element['value']
            graph_max = progress_element['max']

            url = 'https://www.kr-weathernews.com/mv3/html/lifeindex.html?region='
            res = requests.get(url)
            soup = BeautifulSoup(res.text, 'html.parser')

            data1.append({ '이미지': img, '생활지수': item, '지수': index, '안내멘트': ment,'그래프 값': graph_value, '그래프 최댓값': graph_max})


        # 계절별 지수를 찾아서 클릭
        driver.find_element(By.XPATH, '//*[@id="2"]').click()
        time.sleep(1)
        soup = BeautifulSoup(driver.page_source, 'html.parser')
        trs2 = soup.select('#slidePage2 > #pointList > li')
        for tr2 in trs2:
            img = tr2.select_one('img')['src']
            item = tr2.select_one('h1').get_text().strip().replace('.', '')
            index = tr2.select_one('h2').get_text().strip()
            ment = tr2.select_one('p').get_text().strip()

            # 그래프 크롤링
            progress_element = tr2.select_one('progress')
            graph_value = progress_element['value']
            graph_max = progress_element['max']

            url = 'https://www.kr-weathernews.com/mv3/html/lifeindex.html?region='
            res = requests.get(url)
            soup = BeautifulSoup(res.text, 'html.parser')

            data2.append({ '이미지': img, '생활지수': item, '지수': index, '안내멘트': ment,'그래프 값': graph_value, '그래프 최댓값': graph_max})
    finally:
        driver.quit()
        data = data1 + data2
        df = pd.DataFrame(data)
        df.to_csv('data/kweather.csv', index=False)

# Flask 애플리케이션이 시작될 때 바로 크롤링을 실행합니다.
crawl_and_save_to_csv()


# 웹 브라우저에서 '/test' 경로로 접속했을 때 실행되는 함수를 정의합니다.
@app.route('/test')

def display_data():
    # CSV 파일에서 데이터프레임을 읽어옵니다.
    file_path = 'data/kweather.csv'
    df = pd.read_csv(file_path)

    # 이미지의 상대 경로에 절대 URL을 추가하여 이미지 경로를 완성합니다.
    base_url = 'https://www.kr-weathernews.com/mv3'
    df['이미지'] = df['이미지'].apply(lambda x: f"{base_url}/{x.lstrip('../')}")

    # 간단한 HTML 코드를 생성합니다.
    html_table = "<table class='table table-striped'><thead><tr>"
    # 각 열의 이름을 테이블의 헤더로 추가합니다.
    html_table += "".join(f"<th>{col}</th>" for col in df.columns) + "</tr></thead><tbody>"

    # 데이터프레임을 순회하며 행 단위로 HTML 코드를 생성하여 추가합니다.
    for _, row in df.iterrows():
        html_table += "<tr>" + "".join(f"<td>{row[col]}</td>" for col in df.columns) + "</tr>"

    # HTML 코드 생성이 완료되었습니다.
    html_table += "</tbody></table>"

    # 데이터프레임을 JSON 형식으로 변환하여 data.json 파일에 저장합니다.
    json_data = df.to_dict(orient='records')
    # with open('static/js/kweather.json', 'w') as json_file:
    #     json.dump(json_data, json_file, indent=2)

    # # HTML 템플릿을 렌더링하고, 생성된 HTML 코드를 클라이언트에게 반환합니다.
    # return render_template('index.html', html_table=html_table)
    return json.dumps(json_data)

# 스크립트가 직접 실행되었을 때만 Flask 애플리케이션을 실행합니다.
if __name__ == '__main__':
    app.run(debug=True)
