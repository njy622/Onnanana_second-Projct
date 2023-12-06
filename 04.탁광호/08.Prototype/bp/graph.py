from flask import Blueprint, render_template, current_app, request, redirect, url_for
import util.graph_util as gu
import util.graph_util as gu


graph_bp = Blueprint('graph_bp', __name__)

menu = {'ho':0, 'us':0, 'cr':0, 'ma':1,'cb':0, 'sc':0}



@graph_bp.route('/variables')
def variables():
    variables_graph = gu.get_variables_graph()
    return render_template('/graph/variables.html', variables_graph=variables_graph, menu=menu)

@graph_bp.route('/select-variable', methods=['GET', 'POST'])
def select_variable():
    variables = ['비염환자수', '아토피환자수', '천식환자수', '평균기온', '평균상대습도', '평균증기압', '평균최고기온',
       '평균최저기온', '평균풍속', 'AVG_PM10', 'AVG_PM2.5', 'AVG_아황산', 'AVG_이산화',
       'AVG_일산화', '차량수', 'AVG_구리', 'AVG_납', 'AVG_니켈', 'AVG_망간', 'AVG_비소',
       'AVG_철', 'AVG_카드뮴', 'AVG_크롬']
    selected_variable = '비염환자수'  # 초기 선택된 변수 설정

    if request.method == 'POST':
        selected_variable = request.form.get('variable')
        graph = gu.get_variables_graph_select(selected_variable)
    else:
        graph = None

    return render_template('/graph/variables_select.html', variables=variables, selected_variable=selected_variable, graph=graph, menu=menu)






@graph_bp.route('/station', methods=['GET','POST'])
def station():
    if request.method == 'GET':
        return render_template('/map/station_form.html' ,menu=menu)
    else:
        stations = request.form.getlist('station')
        stations = [station for station in stations if len(station.strip()) != 0]
        gu.get_station_map(current_app.root_path, stations)     # static/img/station_map.html 파일
        return render_template('/map/station_res.html', menu=menu)

@graph_bp.route('/cctv')
def cctv():
    gu.get_cctv(current_app.static_folder)      # static/img/cctv.html 파일
    return render_template('/map/cctv.html')

@graph_bp.route('/cctv_pop', methods=['GET','POST'])
def cctv_pop():
    if request.method == 'GET':
        columns = ['CCTV댓수','최근증가율','인구수','내국인','외국인','고령자','외국인 비율','고령자 비율']
        colormaps = ['RdPu','Greys', 'Purples', 'Blues', 'Greens', 'Oranges', 'Reds', 'YlOrBr', 'YlOrRd', 'OrRd', 'PuRd',  'BuPu',
                        'GnBu', 'PuBu', 'YlGnBu', 'PuBuGn', 'BuGn', 'YlGn']
        return render_template('/map/cctv_pop_form.html', columns=columns, colormaps=colormaps, menu=menu)
    else:
        column = request.form['column']
        colormap = request.form['colormap']
        gu.get_cctv_pop(current_app.static_folder, column, colormap)    # static/img/cctv_pop.html 파일
        return render_template('/map/cctv_pop_res.html', column=column, colormap=colormap, menu=menu)
    