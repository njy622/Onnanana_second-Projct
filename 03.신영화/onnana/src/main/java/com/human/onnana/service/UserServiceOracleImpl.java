package com.human.onnana.service;

import java.util.List;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.sql.Timestamp;
import org.springframework.transaction.annotation.Transactional;

import com.human.onnana.db.UserDaoOracle;
import com.human.onnana.entity.User;

@Service
public class UserServiceOracleImpl implements UserService {

    @Autowired
    private UserDaoOracle userDao;

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
    @Transactional
    public void updateUser(String uid, Timestamp currentTimestamp) {
        // UserDaoOracle의 updateLastLoginDate 메서드 호출
        userDao.updateLastLoginDate(uid, currentTimestamp);
    }

    @Override
    public void deleteUser(String uid) {
        userDao.deleteUser(uid);
    }

    @Override
    public int login(String uid, String pwd) {
        User user = userDao.getUser(uid);
        if (user == null) // uid가 들어온게 아님
            return UID_NOT_EXIST;

        if (BCrypt.checkpw(pwd, user.getPwd())) // 입력한 pwd와 DB에 있는 PWD가 같으면
            return CORRECT_LOGIN; // 로그인 성공!
        else
            return WRONG_PASSWORD;
    }

    @Override
    public int getAttendanceCount(String uid) {
        // 여기에서 출석 횟수를 어떻게 계산할지 구현해야 합니다.
        // 예시로는 해당 유저의 스케줄 개수를 리턴하도록 구현하겠습니다.
        return userDao.getUserSchedCount(uid);
    }
    @Override
    public void updateLastLoginDate(String uid, Timestamp currentTimestamp) {
        // 구현 내용 추가
    }

}
