package com.tidemedia.service;

import java.util.List;


import com.tidemedia.entity.User;
import com.tidemedia.entity.UserQuery;

public interface UserService {
	//根据用户名查询用户信息
	public User selectByUserName(String userName);
	//用户新增
	public int userAdd(User user); 
	//查询所有用户
	public List<User> queryAllUser(UserQuery userQuery);
	//按id查询单个用户
	public User queryUserById(User user);
	//删除用户
	public int deleteUserById(Long[] ids);
	//用户修改
	public int userUpdate(User user);
	//查询用户数量
	public Integer queryUserCount(UserQuery userQuery);
}
