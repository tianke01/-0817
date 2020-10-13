<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String fieldname = getParameter(request,"fieldname");
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<title>导航列表</title>
		<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
		<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
		<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
		<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
		<link href="../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">

		<!-- Bracket CSS -->
		<link rel="stylesheet" href="../style/2018/bracket.css">
		<link rel="stylesheet" href="../style/2018/common.css">

		<style>
			html,body {width: 100%;height: 100%;}
			ul,li{list-style: none;}
		  .collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
		  .search-box {display: none;}
		  .border-radius-5{border-radius: 5px;}
		  .topic-list-box{padding: 0px;min-height: 700px;}
		  .topicItem{float: left;}
		  .topicItem:nth-child(n+2){border-left: none;}
		  .topicItem1{width:190px;border: 1px solid #bbbbbb;height: 720px;}      
		  ul li{padding: 0px 10px;cursor: pointer;border-bottom: 1px solid #bbbbbb;line-height: 36px;display: flex;justify-content: flex-start;align-items: center;}
		  ul li a{color: #495057;display: inline-block;}
		  ul li .fa{font-size: 20px;display: none;;margin-left: auto;}
		  ul li.on{background: #ced4da;}
		  ul li.on a{color: #000;}
		  ul li[hasnext="1"] .fa{display: block;}
		  ul li.cur{background: #23bf08;}
		  ul li.cur a{color: #fff;}
		  ul li.cur .fa{color: #fff;}
		  .config-box ul li{display: flex;}
		  label.rdiobox{margin-bottom: 0;}
		  .card{border: none;}
		</style>

		<script src="../lib/2018/jquery/jquery.js"></script>
		<script type="text/javascript" src="../common/2018/common2018.js"></script>
		<script type="text/javascript" src="../common/2018/content.js"></script>
		<script>
			var listType = 0 ;
		</script>

	</head>

	<body class="collapsed-menu" onload="importFirst()">
		<div class="bg-white modal-box">
			<div class="modal-body modal-body-btn pd-20 overflow-y-auto">
				<div class="config-box" id="category">
					<div class="card ">
						<input type="hidden" name="hide" id="hideinfo" value="" />
						<div class="topic-list-box class_manage c_m_main" id="category_manage"></div>
					</div>
				</div>
			</div>
			<!--modal-body-->

			<div class="btn-box" style="position: absolute;bottom: 0;width: 100%;">
				<div class="modal-footer">
					<input type="hidden" name="ChannelID" value="15933">
					<button name="startButton" type="submit" class="btn btn-primary tx-size-xs" onclick="confirm();" id="startButton">确认</button>
					<button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs"
					 data-dismiss="modal" id="btnCancel1">取消</button>
					<input type="hidden" name="Submit" value="Submit">
				</div>
			</div>
		</div>
		<!-- modal-box -->


		<script src="../lib/2018/popper.js/popper.js"></script>
		<script src="../lib/2018/bootstrap/bootstrap.js"></script>
		<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
		<script src="../lib/2018/moment/moment.js"></script>
		<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
		<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
		<script src="../common/2018/bracket.js"></script>

		<script>
			$(function() {
				$(".topicItem").delegate("li", "click", function() {
					$(".topicItem li.cur").removeClass("cur");
					$(this).addClass("cur");
				})
			});


			//获取屏幕的宽高
			var viewH = $(window).height();
			var viewW = $(window).width();
			var fieldname = '<%=fieldname%>';
			function importFirst() {
				//跳转到返回页面
				var url = "getProductCategory.jsp?level=0&fieldname=" + fieldname;
				$.ajax({
					type: "GET",
					url: url,
					success: function(msg) {
						$(".c_m_main").append(msg);
						clickinfo();
					}
				});
			}

			function clickinfo() {
				$(".c_m_box ul li").click(function() {

					$(".c_m_box ul li[class='cur']").attr("class", "on");
					$(".c_m_box ul li").removeClass("cur");

					$(this).addClass("on cur");

					var leve = $(".c_m_box ul li[class='on cur']").attr("level");

					$(".c_m_box ul li[level=" + leve + "]").removeClass("on");

					var haschild = $(".cur").attr("hasNext");

					if (haschild == 0) {
						var leve2 = $(".c_m_box ul li[class='no_arrow on cur']").attr("level");
						$(".c_m_box ul li[level=" + leve2 + "]").removeClass("on");
					}

					var itemid = $(".cur").attr("itemid");
					var level = $(".cur").attr("level");
					var url = "getProductCategory.jsp?itemid=" + itemid + "&level=" + level + "&haschild=" + haschild+ "&fieldname=" + fieldname;

					$.ajax({
						type: "GET",
						url: url,
						success: function(msg) {
							//关闭子类信息
							var size = $(".c_m_box").length;

							for (var i = size; i > 0; i--) {
								$("#level" + (parseInt(level) + i)).remove();
							}
							$(".c_m_main").append(msg);
							var size2 = $(".c_m_box").length;

							for (var i = size2; i > 1; i--) {
								$("#level" + (parseInt(level) + i)).remove();
							}
							var size2 = $(".c_m_box").length;

							clickinfo();
						}

					});

					$(".c_m_box ul li").unbind('click'); //解除绑定
				});
			}
			/*
			1、class_manage层：高度=屏幕高度-105px；（当宽度>c_m_main层的宽度时，宽度=c_m_box层的个数x200px-1px，当宽度<c_m_main层的宽度时，宽度=屏幕宽度-244px；）
			2、c_m_main层：宽度=c_m_box层的个数x200px-1px；
			3、c_m_box层：高度=屏幕高度-105px；第一个c_m_box层需要加first类名； 屏幕$(window).height()$(window).width()
			*/

			function multi_add_new() {
				var itemid = $(".cur").attr("itemid");
				var level = $(".cur").attr("level");
				var titleinfo = "";

				if (typeof(level) == 'undefined') {
					titleinfo = "添加一级导航";
				} else {
					titleinfo = "添加子导航";
				}
				//跳转添加第一级jsp处理
				var url = "../navigation/navigation_add.jsp?itemid=" + itemid + "&level=" + level;
				var dialog = new top.TideDialog();
				dialog.setWidth(550);
				dialog.setHeight(350);
				dialog.setUrl(url);
				dialog.setTitle(titleinfo);
				dialog.show();
			}

			//编辑
			function multi_edit() {
				var itemid = $(".cur").attr("itemid");
				var level = $(".cur").attr("level");

				if (typeof(level) != 'undefined') {
					//跳转到处理编辑的jsp
					var url = "../navigation/navigation_edit.jsp?itemid=" + itemid;
					var dialog = new top.TideDialog();
					dialog.setWidth(550);
					dialog.setHeight(350);
					dialog.setUrl(url);
					dialog.setTitle("编辑当前信息");
					dialog.show();
				}
			}

			function multi_sort() {
				var itemid = $(".cur").attr("itemid");
				var level = $(".cur").attr("level");

				if (typeof(level) != 'undefined') {
					//跳转到处理编辑的jsp
					var url = "../navigation/document_sort.jsp?ItemID=" + itemid;
					var dialog = new top.TideDialog();
					dialog.setWidth(350);
					dialog.setHeight(250);
					dialog.setUrl(url);
					dialog.setTitle("排序");
					dialog.show();
				}
			}

			//删除提示
			function multi_del() {
				var level = $(".cur").attr("level");

				if (typeof(level) != 'undefined') {
					multi_del_check();
				} else {
					TideAlert("提示", "请选择一个导航");
					return false;
				}
			}

			//判断是否有子话题
			function multi_del_check() {
				var itemid = $(".cur").attr("itemid");
				var url = "navigation_delete_check.jsp?itemid=" + itemid;
				$.ajax({
					type: "GET",
					url: url,
					success: function(msg) {
						var message = "确实要删除当前导航？删除后，数据无法恢复";
						if (msg.trim() == 1) {
							message = "当前话题有子导航，如直接删除会删除相关子导航,确定删除吗？删除后，数据无法恢复";
						}

						if (confirm(message)) {
							multi_del_procedure();
						}
					}
				});
			}

			//删除程序
			function multi_del_procedure() {
				var itemid = $(".cur").attr("itemid");
				var url = "navigation_delete.jsp?itemid=" + itemid;
				$.ajax({
					type: "GET",
					url: url,
					success: function(msg) {
						document.location.href = document.location.href;
					}
				});
			}

			//点击空白处取消选择
			$(".topic-list-box").click(function(e) {
				var _con = $('.topicItem ul li'); // 目标区域
				if (!_con.is(e.target) && _con.has(e.target).length === 0) { // Mark 
					$(".topicItem li.cur").removeClass('cur')
				}
				e.stopPropagation()
				//return false;
			});
			function confirm() {
				var checkedCheckbox = $('input:radio:checked');
				if (checkedCheckbox.length == 0) {
					//dialog.showAlert("请选择图标！", "danger");
					alert("请选择IP信息")
					return false;
				} else {
				    var level1 = $("#level1 .on a").html();
				    var level2 = $("#level2 .on a").html();
				    var level3 = $("#level3 .on a").html();
					var Code = checkedCheckbox.attr("code");
					var id = checkedCheckbox.val();
					//alert(fieldname+"---"+level1+"---"+level2+"---"+level3);
					parent.$("#"+fieldname).val(Code);
					
					/*(fieldname=='Title'){
						parent.$("#"+fieldname).val(Code);
					}else{
						parent.$("#"+fieldname).val(id);
						parent.$("#"+fieldname+"Name").val();
					}*/
					parent.getDialog().Close();
				}
			}
		</script>
	</body>
</html>
