package com.tidemedia.service.impl;

import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tidemedia.dao.UserDao;
import com.tidemedia.entity.User;
import com.tidemedia.entity.UserQuery;
import com.tidemedia.service.UserService;
@Service
public class UserServiceImpl implements UserService{
	@Autowired
	private UserDao userDao;

	@Override
	public User selectByUserName(String userName) {
		// TODO Auto-generated method stub
		return userDao.selectByUserName(userName);
	}

	@Override
	public int userAdd(User user) {
		// TODO Auto-generated method stub
		return userDao.userAdd(user);
	}

	@Override
	public List<User> queryAllUser(UserQuery userQuery) {
		// TODO Auto-generated method stub
		return userDao.queryAllUser(userQuery);
	}

	@Override
	public User queryUserById(User user) {
		// TODO Auto-generated method stub
		return userDao.queryUserById(user);
	}

	@Override
	public int deleteUserById(Long[] ids) {
		// TODO Auto-generated method stub
		return userDao.deleteUserById(ids);
	}

	@Override
	public int userUpdate(User user) {
		// TODO Auto-generated method stub
		return userDao.userUpdate(user);
	}


	@Override
	public Integer queryUserCount(UserQuery userQuery) {
		// TODO Auto-generated method stub
		return userDao.queryUserCount(userQuery);
	}

}
