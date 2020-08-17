<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>login</title>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
	<!-- VENDOR CSS -->
	<link rel="stylesheet" href="assets/css/bootstrap.min.css">
	<link rel="stylesheet" href="assets/vendor/font-awesome/css/font-awesome.min.css">
	<link rel="stylesheet" href="assets/vendor/linearicons/style.css">
	<!-- MAIN CSS -->
	<link rel="stylesheet" href="assets/css/main.css">
	<!-- FOR DEMO PURPOSES ONLY. You should remove this in your project -->
	<link rel="stylesheet" href="assets/css/demo.css">
	<!-- GOOGLE FONTS -->
	<link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700" rel="stylesheet">
	<!-- ICONS -->
	<link rel="apple-touch-icon" sizes="76x76" href="assets/img/apple-icon.png">
	<link rel="icon" type="image/png" sizes="96x96" href="assets/img/favicon.png">
</head>
<body>
	<div id="wrapper">
		<div class="vertical-align-wrap">
			<div class="vertical-align-middle">
				<div class="auth-box ">
					<div class="left">
						<div class="content">
							<div class="header">
								<div class="logo text-center"></div>
								<p class="lead">登入你的帐户</p>
							</div>
							<form class="form-auth-small" action="login.do" method="post">
								<div class="form-group">
									<label for="UserName" class="control-label sr-only">用户名</label>
									<input type="text" class="form-control" id="username" name="userName" placeholder="请输入用户名"  required="required">
								</div>
								<div class="form-group">
									<label for="signin-password" class="control-label sr-only">密码</label>
									<input type="password" class="form-control" id="password" name="password"  placeholder="请输入密码"  required="required">
								</div>
								<div class="form-group">
									<label class="control-label sr-only">身份</label>
									<div class="layui-input-block">
										管理员<input type="radio" name="identity" value="1" title="管理员" checked="">
										普通用户<input type="radio" name="identity" value="0" title="普通用户">
									</div>
								</div>
								<div class="form-group clearfix">
									<label class="fancy-checkbox element-left">
										<span></span>
										<span style="color: red">${a }</span>
									</label>
								</div>
								<button type="submit" class="btn btn-primary btn-lg btn-block">登录</button>
							</form>
						</div>
					</div>
					<div class="right">
						<div class="overlay"></div>
						<div class="content text">
							<h1 class="heading"></h1>
							<p></p>
						</div>
					</div>
					<div class="clearfix"></div>
				</div>
			</div>
		</div>
	</div>

</body>
</html>