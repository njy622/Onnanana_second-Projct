package com.human.finedust.service;

import java.util.List;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.human.finedust.db.UserDaoOracle;
import com.human.finedust.entity.User;


@Service
public class UserServiceOracleImpl implements UserService {
	@Autowired private UserDaoOracle userDao;	// UserDaoOracle은 오라클로 만들었으므로 만약 MySQL로 만들면 다시 이름을 MySQL로 바꾸면 됨
	
	@Override
	public int getUserCount() {
		int count = userDao.getUserCount();
		return count;
	}

	@Override
	public User getUser(String uid) {
		User user = userDao.getUser(uid);
		return user;
	}

	@Override
	public List<User> getUserList(int page) {
		int offset = (page - 1) * RECORDS_PER_PAGE;
		int limit = page * RECORDS_PER_PAGE;
		List<User> list = userDao.getUserList(offset, limit);
		return list;
	}

	@Override
	public void insertUser(User user) {
		userDao.insertUser(user);
	}

	@Override
	public void updateUser(User user) {
		userDao.updateUser(user);	
	}

	@Override
	public void deleteUser(String uid) {
		userDao.deleteUser(uid);
	}

	@Override
	public int login(String uid, String pwd) {
		User user = userDao.getUser(uid);
		if (user == null)
			return UID_NOT_EXIST;
		if (BCrypt.checkpw(pwd, user.getPwd()))			// user.getPwd() 데이터에 있는 pwd 정보를 가져와 일치하는 체크
			return CORRECT_LOGIN;
		else 
		return WRONG_PASSWORD;
	}

}
