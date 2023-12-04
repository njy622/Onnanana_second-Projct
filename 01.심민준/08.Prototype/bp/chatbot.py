from flask import Blueprint, render_template, request, current_app
import json, os
'''import openai
'''
import pandas as pd
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity
from urllib.parse import unquote
'''import util.chatbot_util as cu
'''
import requests, base64
from PIL import Image, ImageDraw, ImageFont
import matplotlib.pyplot as plt
from draw_map import  BORDER_LINES, drawKorea, drawKoreaMinus

chatbot_bp = Blueprint('chatbot_bp', __name__)

menu = {'ho':0, 'us':0, 'cr':0, 'ma':0, 'cb':1, 'sc':0}

@chatbot_bp.before_app_first_request
def before_app_first_request():
    global model, wdf
    model = SentenceTransformer('jhgan/ko-sroberta-multitask')
    filename = os.path.join(current_app.static_folder, 'data/wellness_dataset.csv')
    wdf = pd.read_csv(filename)
    wdf.embedding = wdf.embedding.apply(json.loads)
    print('Wellness initialization is done.')

@chatbot_bp.route('/counsel', methods=['GET','POST'])
def counsel():
    if request.method == 'GET':
        return render_template('chatbot/counsel.html', menu=menu)
    else:
        user_input = request.form['userInput']
        embedding = model.encode(user_input)
        wdf['유사도'] = wdf.embedding.map(lambda x: cosine_similarity([embedding],[x]).squeeze())
        answer = wdf.loc[wdf.유사도.idxmax()]
        result = {
            'category':answer.구분, 'user':user_input, 'chatbot':answer.챗봇, 'similarity':answer.유사도
        }
        return json.dumps(result)
    
@chatbot_bp.route('/air')  
def get_air_quality():
    
    # 기본 URL 및 API 키 설정
    base_url = "http://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty"
    with open('static/keys/에어코리아api2.txt') as file:
        service_key = file.read()  # 발급받은 에어코리아 API 키 입력

    # 예제 데이터프레임 생성
    main = pd.read_csv('static/data/카토그램_최종.csv', encoding='utf-8')

    # 결과를 저장할 리스트
    results_list = []

    # 요청을 나누어 보내기
    chunk_size = 50
    max_retries = 3

    for i in range(0, len(main), chunk_size):
        chunk = main.iloc[i:i+chunk_size]
        
        # 각 측정소에 대한 데이터 수집
        for index, row in chunk.iterrows():
            retry_count = 0

            while retry_count < max_retries:
                try:
                    params = {
                        'serviceKey': service_key,
                        'returnType': 'JSON',
                        'numOfRows': 24,
                        'pageNo': 1,
                        'stationName': row['측정소명'],
                        'dataTerm': 'DAILY',
                        'ver': "1.4"
                    }

                    res = requests.get(url=base_url, params=params)

                    # 응답 데이터 정리
                    response = res.json()['response']['body']
                    
                    # 데이터가 존재하면 처리
                    if 'items' in response and response['items']:
                        data = response['items']
                        
                        # 데이터를 날짜와 시간에 대한 기준으로 정렬
                        sorted_data = sorted(data, key=lambda x: x['dataTime'], reverse=True)

                        # 최신 데이터 선택
                        latest_data = None

                        for data in sorted_data:
                            pm10_value = data.get('pm10Value')
                            if pm10_value and pm10_value != '-':
                                latest_data = data
                                break

                        # 최신 데이터가 없으면 첫 번째 데이터 선택
                        if not latest_data and sorted_data:
                            latest_data = sorted_data[0]

                        result = {
                            '날짜': latest_data['dataTime'],
                            '이름': latest_data['stationName'],
                            '측정망 정보': latest_data['mangName'],
                            '아황산가스 농도': latest_data['so2Value'],
                            '일산화탄소 농도': latest_data['coValue'],
                            '오존 농도': latest_data['o3Value'],
                            '이산화질소 농도': latest_data['no2Value'],
                            '미세먼지(PM10) 농도': latest_data.get('pm10Value', 0),
                            '초미세먼지(PM2.5) 농도': latest_data.get('pm25Value', 0)
                        }

                        results_list.append(result)
                        break  # 성공한 경우 while 루프 종료
                    else:
                        results_list.append({})
                        break  # 성공했지만 데이터가 비어있는 경우 while 루프 종료

                except requests.exceptions.RequestException as e:
                    print(f"Request failed: {e}")
                    retry_count += 1
                    print(f"Retrying... (Attempt {retry_count}/{max_retries})")

                    if retry_count == max_retries:
                        print(f"Max retries reached. Skipping request for {row['측정소명']}")
                        break  # 최대 재시도 횟수에 도달하면 while 루프 종료

    # 결과 리스트의 길이를 250개로 맞추기
    results_list.extend([{}] * (len(main) - len(results_list)))

    # '미세먼지' 데이터를 숫자로 변환하고, 빈 데이터는 0으로 변경
    main['미세먼지'] = pd.to_numeric([entry.get('미세먼지(PM10) 농도', 0) for entry in results_list], errors='coerce')
    main['미세먼지'] = main['미세먼지'].fillna(0)

    
    return drawKorea('미세먼지', main, 'Blues', save_filename='static/img/카토그램.png')
    

    
@chatbot_bp.route('/counsel_rest')
def consel_rest():
    user_input = unquote(request.args.get('userInput'))
    embedding = model.encode(user_input)
    wdf['유사도'] = wdf.embedding.map(lambda x: cosine_similarity([embedding],[x]).squeeze())
    answer = wdf.loc[wdf.유사도.idxmax()]
    result = {
        'category':answer.구분, 'user':user_input, 'chatbot':answer.챗봇, 'similarity':answer.유사도
    }
    print(user_input)
    print(result['chatbot'])
    return json.dumps(result)

@chatbot_bp.route('/legal', methods=['GET','POST'])
def legal():
    if request.method == 'GET':
        return render_template('chatbot/legal.html', menu=menu)
    else:
        user_input = request.form['userInput']
        res_dict = cu.get_legal_answer(current_app.static_folder, user_input)
        res_dict['user'] = user_input
        return json.dumps(res_dict)

@chatbot_bp.route('/bard', methods=['GET','POST'])
def bard():
    if request.method == 'GET':
        return render_template('chatbot/bard.html', menu=menu)
    else:
        with open(os.path.join(current_app.static_folder, 'keys/bardApiKey.txt')) as file:
            os.environ['_BARD_API_KEY'] = file.read()
        user_input = request.form['userInput']
        response = bardapi.core.Bard().get_answer(user_input)
        result = {'user':user_input, 'chatbot':response['content']}
        return json.dumps(result)

@chatbot_bp.route('/genImg', methods=['GET','POST'])
def gen_img():
    if request.method == 'GET':
        return render_template('chatbot/genImg.html', menu=menu)
    else:
        with open(os.path.join(current_app.static_folder, 'keys/openAiApiKey.txt')) as file:
            openai.api_key = file.read()
        user_input = request.form['userInput'] 
        size = request.form['size']

        gpt_prompt = [
            {'role': 'system', 
             'content': 'Imagine the detail appearance of the input. Response it shortly around 20 English words.'},
            {'role': 'user', 'content': user_input}      
        ]
        gpt_response = openai.ChatCompletion.create(
            model='gpt-3.5-turbo', messages=gpt_prompt
        )
        prompt = gpt_response['choices'][0]['message']['content']
        dalle_response = openai.Image.create(
            prompt=prompt, size=size         # '1024x1024', '512x512', '256x256'
        )
        img_url = dalle_response['data'][0]['url']
        result = {'img_url':img_url, 'translated_text': prompt}
        return json.dumps(result)
    
@chatbot_bp.route('/ocr', methods=['GET','POST'])
def ocr():
    if request.method == 'GET':
        return render_template('chatbot/ocr.html', menu=menu)
    else:
        color = request.form['color']
        showText = request.form['showText']
        size = request.form['size']
        file_image = request.files['image']
        filename = os.path.join(current_app.static_folder, f'upload/{file_image.filename}')
        file_image.save(filename)

        text, mtime = cu.proc_ocr(current_app.static_folder, filename, color, showText, size)
        result = {'text':text, 'mtime':mtime}
        return json.dumps(result)

@chatbot_bp.route('/yolo', methods=['GET','POST'])
def yolo():
    if request.method == 'GET':
        return render_template('chatbot/yolo_form.html', menu=menu)
    else:
        file_image = request.files['image']
        img_file = os.path.join(current_app.static_folder, f'upload/{file_image.filename}')
        file_image.save(img_file)
        img_type = img_file.split('.')[-1]
        if img_type == 'jfif':
            img_type = 'jpg'

        with open(os.path.join(current_app.static_folder, 'keys/etriAiKey.txt')) as f:
            accessKey = f.read()
        with open(img_file, 'rb') as f:
            img_content = base64.b64encode(f.read()).decode("utf8")
        openApiURL = "http://aiopen.etri.re.kr:8000/ObjectDetect"
        headers={"Content-Type": "application/json; charset=UTF-8","Authorization": accessKey}
        requestJson = { "argument": { "type": img_type, "file": img_content } }
        result = requests.post(
            openApiURL, headers=headers, data=json.dumps(requestJson)).json()
        obj_list = result['return_object']['data']

        img = Image.open(img_file)
        draw = ImageDraw.Draw(img)
        size = img.width + img.height
        font_size = 16 if size < 1600 else 32 if size < 3200 else 48
        line_width = 1 if size < 1600 else 2 if size < 3200 else 3
        font = ImageFont.truetype('malgun.ttf', font_size)
        for obj in obj_list:
            name = obj['class']
            x, y = int(obj['x']), int(obj['y'])
            w, h = int(obj['width']), int(obj['height'])
            draw.rectangle(((x,y),(x+w,y+h)), outline=(255,0,0), width=line_width)
            draw.text((x+10, y+10), name, font=font, fill=(255,0,0))

        savefile = os.path.join(current_app.static_folder, 'result/yolo.png')
        plt.imshow(img)
        plt.axis('off')
        plt.savefig(savefile, format='png')
        mtime = os.stat(savefile).st_mtime

        return render_template('chatbot/yolo_res.html', menu=menu, mtime=mtime)