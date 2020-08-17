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
								<li><a href="#" id="UpdatePWD"><i class="lnr lnr-cog"></i>
										<span>修改密码</span></a></li>
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
					<div class="panel panel-headline">						
						<div class="layui-card-header">
					        <h2 style="display: inline;font-size: 16px">用户信息</h2>
					        <span class="layui-breadcrumb pull-right" style="visibility: visible;">						        
					          <a>用户管理</a><span>/</span>
					          <a><cite>用户信息</cite></a>
					        </span>
					    </div>																	
						<!--cardBody--> 
			            <script type="text/html" id="toolbarDemo">
							  <div class="layui-btn-container">
								  <button class="layui-btn" lay-event="getCheckLength">获取选中数目</button> 
  								  <button class="layui-btn layui-btn-danger" lay-event="getCheckData"><i class="layui-icon"></i>批量删除</button>  								  
								  <button class="layui-btn layui-btn-warm" lay-event="userAdd"><i class="layui-icon"></i>新增</button> 				  					  
  							  </div>
						</script>
						<table class="layui-hide" id="userList" lay-filter="userList"></table>
						<script type="text/html" id="barDemo">					  
							  <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
						</script>
						
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
		layui.use('table', function() {
			var table = layui.table;
			table.render({
				elem : '#userList',
				url : 'queryAllUser.do',
				toolbar : '#toolbarDemo', //开启头部工具栏，并为其绑定左侧模板	
				defaultToolbar : [ 'filter', 'exports', 'print', { //自定义头部工具栏右侧图标。如无需自定义，去除该参数即可
					title : '提示',
					layEvent : 'LAYTABLE_TIPS',
					icon : 'layui-icon-tips',
				} ],
				title : '用户信息表',
				height : 500,
				cols : [ [ {
					type: 'checkbox', 
					align: "center"
				}, {
					field : 'userId',
					title : 'ID',
					width : 80,
					unresize : true,
					sort : true
				}, {
			        field: 'imgUrl',
		            title: '头像',
		            width: 120,
		            templet:"#imgtmp"			
				}, {
					field : 'nickName',
					title : '昵称',
					width : 100			
				}, {
					field : 'userName',
					title : '用户名',
					width : 100
				}, {
					field : 'hobby',
					title : '爱好',
					width : 100
				}, {
					field : 'sex',
					title : '性别',
					width : 100,
					templet : function(data) {
						var str = data.sex;
						if (str == 1) {
							return "男";
						}else{
							return "女";
						}
					}
				}, {
					field : 'phone',
					title : '联系电话',
					width : 180		
				}, {
					field : 'password',
					title : '密码',
					width : 180
				}, {
					field : 'identity',
					title : '身份',
					width : 160,
					templet : function(data) {
						var str = data.identity;
						if (str == 1) {
							return "管理员";
						}else{
							return "普通用户";
						}
					}
				}, {
					field : 'ip',
					title : '最后登录Ip',
					width : 160
				}, {
					title : '操作',
					toolbar : '#barDemo',
					width : 80
				} ] ],
				page : true,
				id : 'userTable'
			});
			table.on('toolbar(userList)', function(obj){
			    var checkStatus = table.checkStatus(obj.config.id);
			    switch(obj.event){//批量删除
			      case 'getCheckData':
			        var data = checkStatus.data;
			        if(data==""){
						layer.msg('请至少选择一个！');
						return;
					}			       
			        var ids="";
					if(data.length>0){
						for(var i=0;i<data.length;i++){
							if(i==data.length-1){
								ids+=data[i].userId;
							}else{
								ids+=data[i].userId+",";
							}
						}
					}
					layer.confirm('确认要删除['+ids+']吗？',
							function(index){
						$.ajax({
							url : "dlUsers.do",
							type : "POST",
							data : {
								ids : ids
							},
							success : function(msg) {
								if (msg == 'true') {
									layer.close(index);
									layer.msg("删除成功", {
										icon : 6
									});
									setTimeout(function(){
										a();
									},1200);
								} else {
									layer.msg("删除失败", {
										icon : 5
									});
								}
							}
						});
					});											
			      break;
			      case 'getCheckLength':
			        var data = checkStatus.data;
			        layer.msg('选中了：'+ data.length + ' 个');
			      break;				      
			      case 'userAdd':
			    	  layer.open({
		                    type: 2,
		                    closeBtn: 2,
		                    title:'用户新增',
		                    area: ['500px', '620px'],
		                    shade: 0.8,
		                    id: (new Date()).valueOf(), //设定一个id，防止重复弹出 时间戳1280977330748
		                    btnAlign: 'r',
		                    moveType: 1, //拖拽模式，0或者1
		                    content: 'JumpToUserAdd.do'														
		                });
			      break;			      			          
			    };
			});
			//这个是用于创建点击事件的实例
	        $('.layui-form-item .layui-btn').on('click', function () {
	            var type = $(this).data('type');
	            active[type] ? active[type].call(this) : '';
	        });			
			//监听行工具事件
			table.on('tool(userList)', function(obj) {
				var data = obj.data;
				// $("#userName").attr("value",data.userName);
				if (obj.event === 'edit') {
					layer.open({
	                    type: 2,
	                    closeBtn: 2,
	                    title:'修改用户密码',
	                    area: ['500px', '250px'],
	                    shade: 0.8,
	                    id: (new Date()).valueOf(), //设定一个id，防止重复弹出 时间戳1280977330748
	                    btnAlign: 'r',
	                    moveType: 1, //拖拽模式，0或者1
	                    content: 'JtUsersUpdate.do?userId='+ data.userId
						+'&password='+data.password
	                });
				}
			});			
		});
		function a() {				
			layer.closeAll();
	        $(".layui-laypage-btn").click(); 				
	    }
		$("#UpdatePWD").on("click", function() {
		    layer.open({
		        type : 2,
		        title : '修改密码',
		        area : [ '500px', '300px' ],
		        fix : false, 
		        content : 'UpdatePWD.jsp'		  
		    });
		});
		
		function b() {				
			layer.closeAll();
			window.location.href = "loginOut.do"; 				
	    }
	</script>
	<script type="text/javascript">
<%-- 	$(function () {
 		var Session = "<%=session.getAttribute("userSession")%>";
 		if(Session == "null"){
 			window.location.href = "../login.jsp";		 			
 		}
 	});	 --%>
	</script>
	<script type="text/html" id="imgtmp">
		<img src="{{ d.imgUrl}}" >
	</script>
	<style type="text/css"> 
	.layui-table-cell{
		height:auto!important;
		white-space:normal;
	}
	</style>
	<script>
	var allcookies = document.cookie;  
	function getCookie(cookie_name){
		var allcookies = document.cookie;
		var cookie_pos = allcookies.indexOf(cookie_name);   //索引的长度
		if (cookie_pos != -1){
			cookie_pos += cookie_name.length + 1;      //这里我自己试过，容易出问题，所以请大家参考的时候自己好好研究一下。。。
			var cookie_end = allcookies.indexOf(";", cookie_pos);
			if (cookie_end == -1){
				cookie_end = allcookies.length;
			}
		var value = unescape(allcookies.substring(cookie_pos, cookie_end)); //这里就可以得到你想要的cookie的值了。。。
		}
		return value;
	}
	var cookie_val = getCookie("sessionId");
 	</script>
</body>

</html>