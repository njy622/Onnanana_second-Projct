from flask import Blueprint, session, redirect, flash


user_bp = Blueprint('user_bp', __name__)

menu = {'ho':0, 'us':1, 'cr':0, 'ma':0, 'sc':0}


@user_bp.route('/login')
def login():
    # admin, 관리자로 로그인했다고 가정
    flash('관리자님 환영합니다.')
    session['uid'] = 'admin'
    session['uname'] = '관리자'
    return redirect('/')

@user_bp.route('/logout')
def logout():
    session.pop('uid', None)        # 세션을 날려서 로그아웃
    session.pop('uname', None)
    #session.pop('qiote', None)      # login 기능을 제대로 구현한 후 처리예정
    #session.pop('addr', None)
    return redirect('/')