<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<!DOCTYPE html>
<html>

	<head>
		<title>用户修改</title>
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
		<!-- MAIN CONTENT -->
		<div class="main-content">
			<div class="container-fluid">
				<!-- OVERVIEW -->
				
				<div class="panel panel-headline">
					<form class="layui-form" action="userUpdate.do" id="changeForm"> 
						<div class="layui-form-item">
						</div>
						<!--用户id 隐藏-->
						<%String userId =request.getParameter("userId");%>
						<div class="layui-form-item" style="display:none;">
							<div class="layui-inline">
								<label class="layui-form-label">id</label>
								<div class="layui-input-block">
									<input type="number" name="userId" value="<%=userId%>"  autocomplete="off" class="layui-input">
								</div>
							</div>
						</div>
						<%String password =request.getParameter("password");%>
						<div class="layui-form-item">
							<div class="layui-inline">
								<label class="layui-form-label">密码框</label>
								<div class="layui-input-block">
									<input type="text" name="password" value="<%=password%>" placeholder="请输入密码" lay-verify="required|pass" lay-reqtext="密码是必填项，不能为空！" autocomplete="off" class="layui-input">
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
				
				<!-- END OVERVIEW -->

			</div>
		</div>
		<!-- END MAIN CONTENT -->
		<!-- END WRAPPER -->
		<!-- Javascript -->
		<script src="assets/vendor/jquery/jquery.min.js"></script>
		<script src="assets/vendor/bootstrap/js/bootstrap.min.js"></script>
		<script src="assets/vendor/jquery-slimscroll/jquery.slimscroll.min.js"></script>
		<script src="assets/vendor/jquery.easy-pie-chart/jquery.easypiechart.min.js"></script>
		<script src="assets/vendor/chartist/js/chartist.min.js"></script>
		<script src="assets/scripts/klorofil-common.js"></script>
		<script src="layui/layui.js" charset="utf-8"></script>
		<script>
			layui.use(['form', 'layedit', 'laydate'], function() {
				var form = layui.form,
					layer = layui.layer,
					layedit = layui.layedit,
					laydate = layui.laydate;

				//日期
				laydate.render({
					elem: '#date'
				});
				laydate.render({
					elem: '#date1'
				});

								//创建一个编辑器
								var editIndex = layedit.build('LAY_demo_editor');

				//自定义验证规则
				form.verify({
					userrname: function(value) {
						if(value.length < 2) {
							return '真实姓名至少得2个字符';
						}
					},
					pass: [
						/^[\S]{6,12}$/, '密码必须6到12位，且不能出现空格'
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
		                	'password':data.field.password,
		                },
		                success : function(msg) {
							if (msg == '1') {
								layer.msg("编辑成功", {
									icon : 6
								});
								setTimeout(function(){
									parent.a();
								},1200);						
							} else{
								layer.msg("编辑失败", {
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