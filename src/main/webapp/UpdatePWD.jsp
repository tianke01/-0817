<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<!DOCTYPE html>
<html>
<head>
		<title>货票新增</title>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
		<!-- VENDOR CSS -->
		<link rel="stylesheet" href="assets/vendor/bootstrap/css/bootstrap.min.css">
		<link rel="stylesheet" href="assets/vendor/font-awesome/css/font-awesome.min.css">
		<link rel="stylesheet" href="assets/vendor/linearicons/style.css">
		<link rel="stylesheet" href="assets/vendor/chartist/css/chartist-custom.css">
		<!-- MAIN CSS -->
		<link rel="stylesheet" href="assets/css/main.css">
		<!-- FOR DEMO PURPOSES ONLY. You should remove this in your project -->
		<link rel="stylesheet" href="assets/css/demo.css">
		<!-- GOOGLE FONTS -->
		<link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700" rel="stylesheet">
		<!-- ICONS -->
		<link rel="apple-touch-icon" sizes="76x76" href="assets/img/apple-icon.png">
		<link rel="icon" type="image/png" sizes="96x96" href="assets/img/favicon.png">
		<!--layui—css-->
		<link rel="stylesheet" href="layui/css/layui.css" media="all">
	</head>
<body>
<div class="layui-col-md12">
		<div class="layui-card">			
			<div class="layui-card-body" pad15="">

				<form class="layui-form" action="">
					<div class="layui-form-item" style="display:none;" >
						<label class="layui-form-label">ID</label>
						<div class="layui-input-inline">
							<input name="userId" class="layui-input" type="number" value="${userSession.userId}">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">当前密码</label>
						<div class="layui-input-inline">
							<input name="oldPassword" lay-verify="required|oldPwd"
								lay-vertype="tips" class="layui-input" type="password">
						</div>
					</div>

					<div class="layui-form-item">
						<label class="layui-form-label">新密码</label>
						<div class="layui-input-inline">
							<input name="password" lay-verify="required|pass"
								lay-vertype="tips" id="LAY_password" class="layui-input"
								type="password">
						</div>
						<div class="layui-form-mid layui-word-aux">6到12个字符</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">确认新密码</label>
						<div class="layui-input-inline">
							<input name="repassword"
								lay-verify="required|repass" lay-vertype="tips"
								class="layui-input" type="password">
						</div>
					</div>
					<div class="layui-form-item">
						<div class="layui-input-block">
							<button class="layui-btn" lay-submit="" lay-filter="pwdup">确认修改</button>
						</div>
					</div>
				</form>

			</div>
		</div>
	</div>
<script src="assets/vendor/jquery/jquery.min.js"></script>
<script src="assets/vendor/bootstrap/js/bootstrap.min.js"></script>
<script src="assets/vendor/jquery-slimscroll/jquery.slimscroll.min.js"></script>
<script src="assets/vendor/jquery.easy-pie-chart/jquery.easypiechart.min.js"></script>
<script src="assets/vendor/chartist/js/chartist.min.js"></script>
<script src="assets/scripts/klorofil-common.js"></script>
<script src="layui/layui.js" charset="utf-8"></script>
<script>
layui.use(['form', 'layedit'] ,function(){
	  var $ = layui.jquery
	  ,form = layui.form
	  ,layer = layui.layer
	  ,layedit = layui.layedit; 
	  
	  form.render();
	  //自定义验证规则
	  form.verify({
		 oldPwd : function(value, item){  
			 var message=''; 			 
			 var oldpassword = ${userSession.password};
				 if(oldpassword!=value){
					 message = '旧密码输入错误，请重新输入！'
				 }
			  return message;
			 }
	  
	    ,pass: [/(.+){6,12}$/, '密码必须6到12位'] 
	    ,repass: function(value){
	    	var passwordValue = $('input[name=password]').val();
	    	if(value != passwordValue){
	    	return '两次输入的密码不一致!';
	    	}
	    	} 
	  });
	  
	  //监听提交
	  form.on('submit(pwdup)', function(data){
	    /* layer.alert(JSON.stringify(data.field), {
	      title: '最终的提交信息'
	    }) */
	    $.ajax({          
				  url: "UpdatePwd.do",       
				  type: "post",                
				  async: false,                   
				  data: data.field,                  
				  dataType: "json",       
				  success: function (msg) {  
					  if (msg == '1') {
							layer.msg("修改成功，即将退出登录！", {
								icon : 6
							});
							setTimeout(function(){
								parent.b();
							},1200);						
						} else{
							layer.msg("修改失败", {
								icon : 5
							});
						}
					}   
				});  
	    return false;
	  });
	   
	});
</script>
</body>
</html>