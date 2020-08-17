package com.tidemedia.entity;

import org.springframework.stereotype.Component;

@Component
public class UserQuery {
	private Long userId;//用户id
	private String nickName;//昵称
	private String userName;//用户名/账号
	private String hobby;//爱好
	private Boolean sex;//性别 1:男 0:女
	private Long phone;//电话  	
	private String password;//密码
	private Boolean identity;//身份 1:管理员 0:普通用户
	private String imgUrl;//头像URL
	private String ip;//用户最后登录Ip
	//协助分页
	public Integer page;//第几页
	public Integer limit;//每页几行数据
	public Integer startlimit;//从第几号开始查
	public UserQuery(Long userId, String nickName, String userName, String hobby, Boolean sex, Long phone,
			String password, Boolean identity, String imgUrl, String ip, Integer page, Integer limit,
			Integer startlimit) {
		super();
		this.userId = userId;
		this.nickName = nickName;
		this.userName = userName;
		this.hobby = hobby;
		this.sex = sex;
		this.phone = phone;
		this.password = password;
		this.identity = identity;
		this.imgUrl = imgUrl;
		this.ip = ip;
		this.page = page;
		this.limit = limit;
		this.startlimit = startlimit;
	}
	public UserQuery() {
		super();
	}
	public Long getUserId() {
		return userId;
	}
	public void setUserId(Long userId) {
		this.userId = userId;
	}
	public String getNickName() {
		return nickName;
	}
	public void setNickName(String nickName) {
		this.nickName = nickName;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getHobby() {
		return hobby;
	}
	public void setHobby(String hobby) {
		this.hobby = hobby;
	}
	public Boolean getSex() {
		return sex;
	}
	public void setSex(Boolean sex) {
		this.sex = sex;
	}
	public Long getPhone() {
		return phone;
	}
	public void setPhone(Long phone) {
		this.phone = phone;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public Boolean getIdentity() {
		return identity;
	}
	public void setIdentity(Boolean identity) {
		this.identity = identity;
	}
	public String getImgUrl() {
		return imgUrl;
	}
	public void setImgUrl(String imgUrl) {
		this.imgUrl = imgUrl;
	}
	public String getIp() {
		return ip;
	}
	public void setIp(String ip) {
		this.ip = ip;
	}
	public Integer getPage() {
		return page;
	}
	public void setPage(Integer page) {
		this.page = page;
	}
	public Integer getLimit() {
		return limit;
	}
	public void setLimit(Integer limit) {
		this.limit = limit;
	}
	public Integer getStartlimit() {
		return startlimit;
	}
	public void setStartlimit(Integer startlimit) {
		this.startlimit = startlimit;
	}
	@Override
	public String toString() {
		return "UserQuery [userId=" + userId + ", nickName=" + nickName + ", userName=" + userName + ", hobby=" + hobby
				+ ", sex=" + sex + ", phone=" + phone + ", password=" + password + ", identity=" + identity
				+ ", imgUrl=" + imgUrl + ", ip=" + ip + ", page=" + page + ", limit=" + limit + ", startlimit="
				+ startlimit + "]";
	}
}
