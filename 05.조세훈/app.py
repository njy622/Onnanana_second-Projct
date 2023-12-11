# 필요한 모듈 임포트
from flask import Flask, render_template
import pandas as pd
import json

# Flask 웹 애플리케이션을 생성합니다.
app = Flask(__name__)

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
