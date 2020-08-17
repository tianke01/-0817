package com.tidemedia.controller;


import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.alibaba.fastjson.JSONObject;
import com.tidemedia.entity.User;
import com.tidemedia.entity.UserQuery;
import com.tidemedia.service.UserService;
import com.tidemedia.utils.CryptoUtil;
import com.tidemedia.utils.Layui;

import redis.clients.jedis.Jedis;


@Controller
public class UserController {
	@Resource
	public UserService userService;	
	
//	@Autowired
//	private Jedis jedis;
	
//	@ResponseBody
//	@RequestMapping(value = "/queryAllUser")
//	public Layui queryAllUser(UserQuery userQuery) {
//		System.out.println("===用户模块-查询全部用户===");
//		userQuery.setStartlimit((userQuery.getPage()-1)*userQuery.getLimit());
//		List<User> u =null;
//		u= userService.queryAllUser(userQuery);
//		for (User user : u) {
//			user.setPassword(CryptoUtil.decode(user.getPassword()));
//		}
//		//存储缓存
//		int i = userService.querytUserCount(userQuery);	
//		return Layui.data(i, u);
//	}	
	
	@ResponseBody
	@RequestMapping(value = "/queryAllUser")
	public Layui queryAllUser(UserQuery userQuery) {
		System.out.println("===用户模块-查询全部用户===");
        System.out.println("===用户模块-查询全部用户===");
        System.out.println("===hahahaha===");
		userQuery.setStartlimit((userQuery.getPage()-1)*userQuery.getLimit());
		List<User> u= userService.queryAllUser(userQuery);
		for (User user : u) {
			user.setPassword(CryptoUtil.decode(user.getPassword()));
		}
		int i = userService.queryUserCount(userQuery);
		return Layui.data(i, u);
	}	
	
	//登录
	@RequestMapping(value = "/login")
	public String login(User user,Model model,HttpServletRequest request,HttpServletResponse response) {
		System.out.println("===登录模块-用户登录===");	
		//根据用户用户名查询用户信息
		User dbuser = userService.selectByUserName(user.getUserName());
		if(dbuser!=null) {
			if(dbuser.getIdentity()!=user.getIdentity()) {
				model.addAttribute("a", "身份有误");
				return "login";
			}
			//将密码解密
			String dbpassword = CryptoUtil.decode(dbuser.getPassword());
			if(user.getPassword().equals(dbpassword)) {
				//获取当前用户ip,并修改数据库
				String ip=getUserIP(request);
				dbuser.setIp(ip);
				userService.userUpdate(dbuser);
				dbuser.setPassword(CryptoUtil.decode(dbuser.getPassword()));
				HttpSession session = request.getSession();
				session.setAttribute("userSession", dbuser);
//				HttpSession session = request.getSession();
//				session.setAttribute(dbuser.getUserName(), dbuser);
//				// 设置Cookie可读性
//				response.addHeader("Set-Cookie", "Path=/; HttpOnly");
//				Cookie cookie = new Cookie("sessionId",dbuser.getUserName());
//				response.addCookie(cookie);
				//预留：根据用户身份跳转不同页面 1：管理员 2：普通用户
				if(dbuser.getIdentity()==true) {
					return "UserMana";
				}if(dbuser.getIdentity()==false){
					model.addAttribute("user", dbuser);
					System.out.println(dbuser);
					return "UserMana2";
				}
			}else {
				model.addAttribute("a", "密码输入错误，请重新输入");
			}
		}else {
			model.addAttribute("a", "账号不存在，请重新输入");
		}
		return "login";
	}
	
	//退出
	@RequestMapping(value="/loginOut")
	public String userLoginout(HttpServletRequest req,HttpServletResponse response) {
		System.out.println("===登录模块-用户退出===");
		req.getSession().removeAttribute("userSession");
		return "/login";
	}
	
	//跳转用户新增页面
	@RequestMapping(value = "/JumpToUserAdd")
	public String JumpToUserAdd() {
		return "UserAdd";
	}
	
	@RequestMapping(value = "/userAdd" )
	@ResponseBody
	public String userAdd(User user,HttpServletResponse response) throws IOException {
		System.out.println("===用户模块-用户新增===");		
		//判断用户名是否重复
		User dbuser = userService.selectByUserName(user.getUserName());
		if(dbuser!=null) {
            return  "2";//该用户名重复，提示用户换一个
		}
		//密码加密
		user.setPassword(CryptoUtil.encode(user.getPassword()));
		int i = userService.userAdd(user);
		if(i==0) {
			return "0";
		}else {
			System.out.println("用户新增成功");
			return "1";
		}
	}
	
	@RequestMapping(value = "/JtUsersUpdate")
	public String JumpToUserUpdate() {
		System.out.println("===跳转到用户修改页面===");	
		return "UserUpdate";
	}
	
	@RequestMapping(value = "/userUpdate" )
	@ResponseBody
	public String userUpdate(User user,HttpServletRequest request) {
		System.out.println("===用户模块-用户修改===");
		//密码加密
		user.setPassword(CryptoUtil.encode(user.getPassword()));
		System.out.println(user);
		int i = userService.userUpdate(user);
		if(i==0) {
			return "0";
		}else {
			HttpSession session = request.getSession();
			user.setPassword(CryptoUtil.decode(user.getPassword()));
			session.setAttribute("userSession", user);
			System.out.println("修改成功");
			return "1";
		}
	}
	
	@RequestMapping(value = "/UpdatePwd" )
	@ResponseBody
	public String userUpdatePWD(User user,HttpServletRequest request) {
		System.out.println("===用户模块-修改密码===");
		user.setPassword(CryptoUtil.encode(user.getPassword()));
		int i = userService.userUpdate(user);
		if(i==0) {
			return "0";
		}else {
			HttpSession session = request.getSession();
			user.setPassword(CryptoUtil.decode(user.getPassword()));
			session.setAttribute("userSession", user);
			System.out.println("用户"+user.getUserName()+"密码修改成功");
			return "1";
		}
	}
	
	@RequestMapping(value = "/dlUsers")
	@ResponseBody
	public String dlBills(@RequestParam("ids") String ids ){
		System.out.println("===用户模块-用户批量删除===");
		String[] str = ids.split(",");
		Long[] ids2 = new Long[str.length];
		for (int i = 0; i < str.length; i++) {
			ids2[i] =  Long.parseLong(str[i]);
		}
		userService.deleteUserById(ids2);
		return "true";
	}
	
	public static String getUserIP(HttpServletRequest request)
	{
		String ip = request.getHeader("X-Forwarded-For");
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
		ip = request.getHeader("Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
		ip = request.getHeader("WL-Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
		ip = request.getHeader("HTTP_CLIENT_IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
		ip = request.getHeader("HTTP_X_FORWARDED_FOR");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
		ip = request.getRemoteAddr();
		}
		if("0:0:0:0:0:0:0:1".equals(ip)){
			return "127.0.0.1";
		}
		return ip;
	}
	
	//上传头像
	@ResponseBody
    @RequestMapping("/upload")
	public Map<String, Object> upload(MultipartFile file,HttpServletRequest request){
		System.out.println("===上传头像===");
		String prefix="";
        String dateStr="";
        //保存上传
        OutputStream out = null;
        InputStream fileInput=null;
		try {
			if(file!=null) {
				String originalName = file.getOriginalFilename();
                prefix=originalName.substring(originalName.lastIndexOf(".")+1);
                Date date = new Date();
                String uuid = UUID.randomUUID()+"";
                SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
                dateStr = simpleDateFormat.format(date);
                String filepath ="F:\\ideaWork\\new\\yhgl\\src\\main\\webapp\\images\\"+dateStr+"\\"+uuid+"."+prefix;
                File files=new File(filepath);
                //打印查看上传路径
                System.out.println(filepath);
                if(!files.getParentFile().exists()){
                    files.getParentFile().mkdirs();
                }
                file.transferTo(files);
                Map<String,Object> map2=new HashMap<>();
                Map<String,Object> map=new HashMap<>();
                map.put("code",0);
                map.put("msg","");
                map.put("data",map2);
                map2.put("src","images/"+ dateStr+"/"+uuid+"." + prefix);
                return map;
			}
		} catch (Exception e) {
			
		}finally{
            try {
                if(out!=null){
                    out.close();
                }
                if(fileInput!=null){
                    fileInput.close();
                }
            } catch (IOException e) {
            }
		}
		Map<String,Object> map=new HashMap<>();
        map.put("code",1);
        map.put("msg","");
        return map;
	}
	
	
}


