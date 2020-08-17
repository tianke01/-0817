<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>

<head>
<title>用户管理</title>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
<!-- VENDOR CSS -->
<link rel="stylesheet"
	href="assets/vendor/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet"
	href="assets/vendor/font-awesome/css/font-awesome.min.css">
<link rel="stylesheet" href="assets/vendor/linearicons/style.css">
<link rel="stylesheet"
	href="assets/vendor/chartist/css/chartist-custom.css">
<!-- MAIN CSS -->
<link rel="stylesheet" href="assets/css/main.css">
<!-- GOOGLE FONTS -->
<link
	href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700"
	rel="stylesheet">
<!-- ICONS -->
<link rel="apple-touch-icon" sizes="76x76"
	href="assets/img/apple-icon.png">
<link rel="icon" type="image/png" sizes="96x96"
	href="assets/img/favicon.png">
<!--  layui-css  -->
<link rel="stylesheet" href="layui/css/layui.css" media="all">
</head>

<body>
	<!-- WRAPPER -->
	<div id="wrapper">
		<!-- NAVBAR -->
		<nav class="navbar navbar-default navbar-fixed-top">
			<div class="container-fluid">
				<div id="navbar-menu">
					<ul class="nav navbar-nav navbar-right">
						<li class="dropdown"><a href="#" class="dropdown-toggle"
							data-toggle="dropdown"> <span>${userSession.userName}</span>
								<i class="icon-submenu lnr lnr-chevron-down"></i></a>
							<ul class="dropdown-menu">
								<li><a href="loginOut.do"><i class="lnr lnr-exit"></i>
										<span>退出登录</span></a></li>
							</ul>
						</li>
					</ul>
				</div>
			</div>
		</nav>
		<!-- END NAVBAR -->
		<!-- MAIN -->
		<div class="main" style="width: 100%">
			<!-- MAIN CONTENT -->
			<div class="main-content">
				<div class="container-fluid">
						<!-- OVERVIEW -->
						<div class="panel panel-headline" style="text-align: center; ">
							<form class="layui-form" action="userUpdate.do" id="changeForm"> 
								<div class="layui-form-item">
								</div>
								<!--用户id 隐藏-->
								<div class="layui-form-item" style="display:none;">
									<div class="layui-inline">
										<label class="layui-form-label">id</label>
										<div class="layui-input-block">
											<input type="number" name="userId" value="${user.userId }"  autocomplete="off" class="layui-input">
										</div>
									</div>
								</div>
								<!--用户名-->
								<div class="layui-form-item">
									<div class="layui-inline">
										<label class="layui-form-label">昵称</label>
										<div class="layui-input-block">
											<input type="text" name="nickName" value="${user.nickName }" lay-verify="required" lay-reqtext="昵称是必填项，不能为空！" placeholder="请输入昵称" autocomplete="off" class="layui-input">
										</div>
									</div>
								</div>
								<div class="layui-form-item">
									<div class="layui-inline">
										<label class="layui-form-label">用户名</label>
										<div class="layui-input-block">
											<input type="text" name="userName" value="${user.userName }" lay-verify="required" lay-reqtext="用户名是必填项，不能为空！" placeholder="请输入用户名" autocomplete="off" class="layui-input">
										</div>
									</div>
								</div>
								<div class="layui-form-item">
									<div class="layui-inline">
										<label class="layui-form-label">爱好</label>
										<div class="layui-input-block">
											<input type="text" name="hobby" value="${user.hobby }" lay-verify="required" lay-reqtext="爱好是必填项，不能为空！" placeholder="请输入爱好" autocomplete="off" class="layui-input">
										</div>
									</div>
								</div>
								<div class="layui-form-item">
									<div class="layui-inline">
										<label class="layui-form-label">密码框</label>
										<div class="layui-input-block">
											<input type="text" name="password" value="${user.password }" placeholder="请输入密码" lay-verify="required|pass" lay-reqtext="密码是必填项，不能为空！" autocomplete="off" class="layui-input">
										</div>
									</div>
								</div>
								<div class="layui-form-item">
									<div class="layui-inline">
										<label class="layui-form-label">性别</label>
										<div class="layui-input-block">
											<input type="radio" name="sex" value="1" title="男"   ${user.sex==true ? "checked='checked'" : ""}>
											<input type="radio" name="sex" value="0" title="女"  ${user.sex==false ? "checked='checked'" : ""}>
										</div>
									</div>
								</div>
								<div class="layui-form-item">
									<div class="layui-inline">
										<label class="layui-form-label">手机号码</label>
										<div class="layui-input-block">
											<input type="tel" name="phone" value="${user.phone }" lay-verify="required|phone" lay-reqtext="手机号码是必填项，不能为空！" placeholder="请输入手机号码" autocomplete="off" class="layui-input">
										</div>
									</div>
								</div>
								<div class="layui-form-item">
									<div class="layui-inline">
										<label class="layui-form-label">身份</label>
										<div class="layui-input-block">
											<input type="radio" name="identity" value="1" title="管理员"   ${user.identity==true ? "checked='checked'" : ""}>
											<input type="radio" name="identity" value="0" title="普通用户"  ${user.identity==false ? "checked='checked'" : ""}>
										</div>
									</div>	
								</div>
								<input type="hidden" name="imgUrl" class="image" src="${user.imgUrl }">
								<div class="layui-form-item">
									<div class="layui-inline">
										<label class="layui-form-label">头像</label>
										<div class="layui-input-block">
											<div class="layui-upload">
												<button type="button" class="layui-btn" id="img">上传头像</button>
												<div class="layui-upload-list">
													<img class="layui-upload-img" id="demo1" src="${user.imgUrl }" width="100" height="100">
													<p id="demoText"></p>
												</div>
											</div>
										</div>
									</div>
								</div>
								<div class="layui-form-item">
									<div class="layui-input-block">
										<button  class="layui-btn" lay-submit="" lay-filter="demo1">立即提交</button>
										<button type="reset" class="layui-btn layui-btn-primary">重置</button>
									</div>
								</div>
							</form>		
						</div>
						
				</div>
			</div>
			<!-- END OVERVIEW -->

		</div>
		<!-- END MAIN -->
		
		
	</div>
	<!-- END WRAPPER -->
	<!-- Javascript -->
	<script src="assets/vendor/jquery/jquery.min.js"></script>
	<script src="assets/vendor/bootstrap/js/bootstrap.min.js"></script>
	<script
		src="assets/vendor/jquery-slimscroll/jquery.slimscroll.min.js"></script>
	<script
		src="assets/vendor/jquery.easy-pie-chart/jquery.easypiechart.min.js"></script>
	<script src="assets/vendor/chartist/js/chartist.min.js"></script>
	<script src="assets/scripts/klorofil-common.js"></script>
	<!--layui js-->
	<script src="layui/layui.js" charset="utf-8"></script>
	<script>
		layui.use(['form', 'layedit', 'laydate', 'upload'], function() {
			var form = layui.form,
				layer = layui.layer,
				layedit = layui.layedit,
				laydate = layui.laydate,
				$ = layui.jquery,
				upload = layui.upload;
			//普通图片上传
			var uploadInst = upload.render({
				elem: '#img',
				url: 'upload.do',
				accept:'images',
				before: function(obj) {
					//预读本地文件示例，不支持ie8
					obj.preview(function(index, file, result) {
						$('#demo1').attr('src', result); //图片链接（base64）
					});
				},
				done: function(res) {
					//如果上传失败
					if(res.code > 0) {
						return layer.msg('上传失败');
					}
					//上传成功
					//上传成功
	                var demoText = $('#demoText');
	                demoText.html('<span style="color: #4cae4c;">上传成功</span>');
	
	                var fileupload = $(".image");
	                fileupload.attr("value",res.data.src);
	                console.log(fileupload.attr("value"));
				},
				error: function() {
					//演示失败状态，并实现重传
					var demoText = $('#demoText');
					demoText.html('<span style="color: #FF5722;">上传失败</span> <a class="layui-btn layui-btn-xs demo-reload">重试</a>');
					demoText.find('.demo-reload').on('click', function() {
						uploadInst.upload();
					});
				}
			});
			//日期
			laydate.render({
				elem: '#date'
			});
			laydate.render({
				elem: '#date1'
			});

				

				//自定义验证规则
				form.verify({
					title: function(value) {
						if(value.length < 5) {
							return '标题至少得5个字符啊';
						}
					},
					chepai: [
						/^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4}[A-Z0-9挂学警港澳]{1}$/, '仅允许以汉字开头，后面可录入六个字符，由大写英文字母和阿拉伯数字组成。如：粤B12345'
					],
					content: function(value) {
						layedit.sync(editIndex);
					}
				});

				//监听指定开关
				form.on('switch(switchTest)', function(data) {
					layer.msg('开关checked：' + (this.checked ? 'true' : 'false'), {
						offset: '6px'
					});
					layer.tips('温馨提示：请注意开关状态的文字可以随意定义，而不仅仅是ON|OFF', data.othis)
				});

				//监听提交
				form.on('submit(demo1)', function (data) {
		            $.ajax({
		                url: "userUpdate.do",
		                type : "post",
		                dataType: "json",
		                data:{	
		                	'userId':data.field.userId,
		                	'nickName':data.field.nickName,
		                	'userName':data.field.userName,
		                	'hobby':data.field.hobby,
		                	'sex':data.field.sex,
		                	'phone':data.field.phone,
		                	'password':data.field.password,
		                	'identity':data.field.identity,  
		                	'imgUrl':data.field.imgUrl
		                },
		                success : function(msg) {
							if (msg == '1') {
								layer.msg("修改成功", {
									icon : 6
								});
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