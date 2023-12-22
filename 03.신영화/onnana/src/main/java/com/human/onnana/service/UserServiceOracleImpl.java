package com.human.onnana.service;

import java.sql.Timestamp;
import java.util.List;

import javax.sql.DataSource;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.human.onnana.db.UserDaoOracle;
import com.human.onnana.entity.User;

@Service
public class UserServiceOracleImpl implements UserService{
	
	@Autowired private UserDaoOracle userDao;    
// 오라클 버전으로 이용하고 있기때문에 오라클 표기한것 다른 DB사용하면 그걸로 이름 바꿔도됨

	@Autowired
    private JdbcTemplate jdbcTemplate;  // JdbcTemplate 추가
	
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
		userDao.updataUser(user);
	}

	@Override
	public void deleteUser(String uid) {
		userDao.deleteUser(uid);
	}

	@Override
	public int login(String uid, String pwd) {
		User user = userDao.getUser(uid);
		if (user == null)			//uid가 들어온게 아님
			return UID_NOT_EXIST;   
		
		if (BCrypt.checkpw(pwd, user.getPwd()))  // 입력한 pwd와 DB에 있는 PWD가 같으면
			return CORRECT_LOGIN;		// 로그인 성공!
		else
			return WRONG_PASSWORD; 
	}

	@Override
	public String idsearch(String uname, String email) {
		return userDao.idsearch(uname,email);
	}

	@Override
	public String userinfosame(String uname, String uid, String email) {
		return userDao.userinfosame(uname,uid, email);
	}


	@Override
    @Transactional
    public void updateUser(String uid, Timestamp currentTimestamp) {
        // UserDaoOracle의 updateLastLoginDate 메서드 호출
        userDao.updateLastLoginDate(uid, currentTimestamp);
    }

	 @Override
	    public void updateLastLoginDate(String uid, Timestamp currentTimestamp) {
	        // 구현 내용 추가
	    }


	 @Override
	    @Transactional
	    public void updateAttendanceCount(String uid) {
	        // 출석 횟수를 1 증가시키는 쿼리
	        String updateQuery = "UPDATE USERS SET ATTENDANCE_COUNT = ATTENDANCE_COUNT + 1 WHERE UID = ?";
	        
	        // JdbcTemplate을 사용하여 쿼리 실행
	        jdbcTemplate.update(updateQuery, uid);
	    }
	 
	 
	 @Override
	    public int getAttendanceCount(String uid) {
	        String sql = "SELECT ATTENDANCE_COUNT FROM USERS WHERE UID = ?";
	        try {
	            int attendanceCount = jdbcTemplate.queryForObject(sql, Integer.class, uid);
	            return attendanceCount;
	        } catch (DataAccessException e) {
	            e.printStackTrace();
	            return 0;
	        }
	    }
}
