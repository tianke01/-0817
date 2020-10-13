<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!

public String getParentChannelPath(Channel channel) throws MessageException, SQLException{

    String path = "";
    ArrayList arraylist = channel.getParentTree();

    if ((arraylist != null) && (arraylist.size() > 0))
    {
      for (int i = 0; i < arraylist.size(); ++i)
      {
        Channel ch = (Channel)arraylist.get(i);

		if((i+1)==arraylist.size()){//当前频道名
			path = path + ch.getName() ;// + ((i < arraylist.size() - 1) ? " / " : "");
		}else{
			path = path + ch.getName() +" / ";// javascript:jumpContent("+ch.getId()+")
		}        
      }
    }

    arraylist = null;

    return path;
}
%>
<%
long begin_time = System.currentTimeMillis();
int id = getIntParameter(request,"id");
int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
int sortable = getIntParameter(request,"sortable");
int rows = getIntParameter(request,"rows");
int cols = getIntParameter(request,"cols");
if(currPage<1)
	currPage = 1;

if(rowsPerPage==0)
	rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage",request.getCookies()));

if(rowsPerPage<=0)
	rowsPerPage = 20;

if(rows==0)
	rows = Util.parseInt(Util.getCookieValue("rows",request.getCookies()));
if(cols==0)
	cols = Util.parseInt(Util.getCookieValue("cols",request.getCookies()));

if(rows==0)
	rows = 10;
if(cols==0)
	cols = 5;

Channel channel = CmsCache.getChannel(id);
if(channel==null || channel.getId()==0)
{
	response.sendRedirect("../content/content_nochannel.jsp");
	return;
}

Channel parentchannel = null;
int ChannelID = channel.getId();
int IsWeight=channel.getIsWeight();
int	IsComment=channel.getIsComment();
int	IsClick=channel.getIsClick();
String gids = "";

String S_Title			=	getParameter(request,"Title");
String S_CreateDate		=	getParameter(request,"CreateDate");
String S_CreateDate1	=	getParameter(request,"CreateDate1");
String S_User			=	getParameter(request,"User");
int S_Level				=	getIntParameter(request,"Level_");
int S_Parent			=	getIntParameter(request,"Parent");

int S_IsIncludeSubChannel =	getIntParameter(request,"IsIncludeSubChannel");
int S_Status			=	getIntParameter(request,"Status");
int S_IsPhotoNews		=	getIntParameter(request,"IsPhotoNews");
int S_OpenSearch		=	getIntParameter(request,"OpenSearch");
int IsDelete			=	getIntParameter(request,"IsDelete");

int Status1			=	getIntParameter(request,"Status1");

boolean listAll = false;

String querystring = "";
querystring = "&Title="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&CreateDate="+S_CreateDate+"&CreateDate1="+S_CreateDate1+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete+"&Status1="+Status1+"&Level"+S_Level+"&Parent="+S_Parent;

String pageName = request.getServletPath();
int pindex = pageName.lastIndexOf("/");
if(pindex!=-1)
	pageName = pageName.substring(pindex+1);

if(!channel.hasRight(userinfo_session,1))
{
	response.sendRedirect("../noperm.jsp");return;
}

boolean canApprove = channel.hasRight(userinfo_session,ChannelPrivilegeItem.CanApprove);

String SiteAddress = channel.getSite().getUrl();

//获取频道路径
String parentChannelPath = getParentChannelPath(channel);
%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>内容列表</title>
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">

    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">  
    <link rel="stylesheet" href="../style/2018/common.css">
	 <script src="../lib/2018/jquery/jquery.js"></script>
     <script type="text/javascript" src="../common/2018/common2018.js"></script>
     <script type="text/javascript" src="../common/2018/content.js"></script>

	<style>
      ul,li{list-style: none;}
      .collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
      .search-box {display: none;}
      .border-radius-5{border-radius: 5px;}
      .topic-list-box{padding: 20px;min-height: 700px;}
	  .topicItem::-webkit-scrollbar {width: 3px;margin-right: 1px}
	  .topicItem::-webkit-scrollbar-track {background-color: #e0e0e0}
	  .topicItem::-webkit-scrollbar-thumb {background-color: rgba(0,0,0,.2)}
	  .topicItem::-webkit-scrollbar-button {background-color: #e0e0e0}
	  .topicItem::-webkit-scrollbar-corner {background-color: #000}
	  .topicItem::-webkit-scrollbar-thumb{background-color: #999;-webkit-border-radius: 3px;border-radius: 3px;}
	  .topicItem::-webkit-scrollbar-thumb:vertical:hover{background-color: #efefef;}
	  .topicItem::-webkit-scrollbar-thumb:vertical:active{background-color: #efefef;}
	  .topicItem::-webkit-scrollbar-button{display: none;}
	  .topicItem::-webkit-scrollbar-track{background-color:#efefef;}
      .topicItem{float: left;overflow-y: auto;}
      .topicItem:nth-child(n+2){border-left: none;}
      .topicItem1{width:199px;border: 1px solid #bbbbbb;height: 720px;}      
      ul li{padding: 0px 10px;cursor: pointer;border-bottom: 1px solid #bbbbbb;
      	line-height: 36px;display: flex;
      	justify-content: space-between;align-items: center;}
      ul li a{color: #495057;display: inline-block;  overflow: hidden;text-overflow: ellipsis;display: -webkit-box;-webkit-line-clamp: 1;-webkit-box-orient: vertical;}
      ul li .fa{font-size: 20px;display: none;}
      ul li.on{background: #ced4da;}
      ul li.on a{color: #000;}
      ul li[hasnext="1"] .fa{display: block;}
      ul li.cur{background: #23bf08;}
      ul li.cur a{color: #fff;}
      ul li.cur .fa{color: #fff;}
    </style>
<script>
var globalid_=0;
var ChannelID = <%=ChannelID%>;
var listType=0;
</script>	
  </head>
  <body class="collapsed-menu" onload="importFirst()"> 
    <div class="br-mainpanel br-mainpanel-file" id="js-source">      
      <div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
          <span class="breadcrumb-item active"><%=parentChannelPath%></span>
        </nav>
        <!--<div class="mg-l-auto">
          <a href="#" class="btn btn-info mg-r-10 pd-x-10-force pd-y-5-force" onClick="multi_add_new();"><i class="fa fa-plus mg-r-3"></i><span>新建</span></a>   
          <a href="#" class="btn btn-info mg-r-10 pd-x-10-force pd-y-5-force " onClick="multi_add();"><i class="fa fa-plus mg-r-3"></i><span>新建子分类</span></a>              
          <a href="#" class="btn btn-info mg-r-10 pd-x-10-force pd-y-5-force" onClick="multi_edit();"><i class="fa fa-edit mg-r-3"></i><span>编辑</span></a>              
          <a href="#" class="btn btn-info mg-r-10 pd-x-10-force pd-y-5-force " onClick="multi_del();"><i class="fa fa-trash mg-r-3"></i><span>删除</span></a> 
        </div><!-- btn-group -->
      </div><!-- br-pageheader -->
      <div class="br-pagebody pd-x-20 mg-t-25" id="category">
      	<div class="d-flex align-items-center justify-content-start mg-b-20">
	        <div class="btn-group mg-l-auto hidden-sm-down">
                <a href="javascript:multi_add_new();" class="btn btn-outline-info">新建</a>
				<a href="javascript:multi_add();" class="btn btn-outline-info add"><i class="fa fa-plus mg-r-3"></i>新建子分类</a>
				<a href="javascript:multi_edit();" class="btn btn-outline-info">编辑</a>
				<a href="javascript:multi_del();" class="btn btn-outline-info">删除</a>			
			</div>
		</div>
        <div class="card bd-0 shadow-base">
		   <input type="hidden" name="hide" id="hideinfo" value=""/>
          <div class="topic-list-box class_manage c_m_main" id="category_manage">
          	
          </div>         
        </div>
      </div><!-- br-pagebody -->
       
    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->

   
    <script src="../lib/2018/popper.js/popper.js"></script>
    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../lib/2018/moment/moment.js"></script>
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>    
    <script src="../common/2018/bracket.js"></script>    
    <script>
      $(function(){
       
//      $('.topicItem').perfectScrollbar();
        $(".topicItem").delegate("li","click",function(){
        	$(".topicItem li.cur").removeClass("cur");
        	$(this).addClass("cur");
        })
      });

      $("#category_manage").on("click","#level4 ul",function() {
          $(".add").hide();
      })

      $("#category_manage").on("click","#level1 ul",function() {
          $(".add").show();
      })

//获取屏幕的宽高
var viewH = $(window).height();
var viewW = $(window).width();
var	dialog = new top.TideDialog();

function importFirst()
{
	//跳转到返回页面
	var url="shownextinfo_new2018.jsp?channelid="+ChannelID+"&level=0";
	$.ajax({
		type: "GET",
		url: url,
		success: function(msg)
		{
			$(".c_m_main").append(msg);
			//$(".c_m_box").width(500);
			//$(".c_m_box").height(viewH-105);
			//$(".class_manage").height(viewH-105);
			//var size = $(".c_m_box").length;
			//$(".c_m_main").width(size*200-1);
			//$(".class_manage").width(size*200-1);
			clickinfo();
		}
	});
}
 
function double_click()
{
	$(".class_manage li").dblclick(function(){
		var itemid = $(".cur").attr("itemid");
		window.console.info(itemid);
	});
}

function clickinfo()
{
	$(".c_m_box ul li").click(function()
	{
		
		$(".c_m_box ul li[class='cur']").attr("class","on");
		$(".c_m_box ul li").removeClass("cur");
		
		$(this).addClass("on cur");
		
		var leve = $(".c_m_box ul li[class='on cur']").attr("level");
		 
		$(".c_m_box ul li[level="+leve+"]").removeClass("on");

		var haschild = $(".cur").attr("hasNext");	
		
		if(haschild==0)
		{
			var leve2 = $(".c_m_box ul li[class='no_arrow on cur']").attr("level");
			$(".c_m_box ul li[level="+leve2+"]").removeClass("on");
		}
		
		var itemid = $(".cur").attr("itemid");
		var level = $(".cur").attr("level");
		var url="shownextinfo_new2018.jsp?itemid="+itemid+"&channelid="+ChannelID+"&level="+level+"&haschild="+haschild;
		
			$.ajax({
				type: "GET",
				url: url,
				success: function(msg)
				{
					//关闭子类信息
					var size = $(".c_m_box").length;
					
					for(var i=size ; i>0 ; i--)
					{
						$("#level"+(parseInt(level)+i)).remove();
					}
					$(".c_m_main").append(msg);
					var size2 = $(".c_m_box").length;
					
					for(var i=size2 ; i>1 ; i--)
					{
						$("#level"+(parseInt(level)+i)).remove();
					}
					var size2 = $(".c_m_box").length;
					
					//设置宽高
				//	$(".c_m_box").height(viewH-105);
				//	$(".c_m_main").width(size2*200-1);
				//	$(".class_manage").width(size2*200-1);
				//	$(".class_manage").height(viewH-105);
				//	var m_w = $(".class_manage").width();
					
				//	if(((size2)*200-1)>(viewW-36))
				//	{
				//		$(".class_manage").width(viewW-36);
				//	}
				//	document.getElementById('category_manage').scrollLeft = (document.documentElement.scrollWidth);
					clickinfo();
				}
				
			});

		$(".c_m_box ul li").unbind('click');//解除绑定
	});
}
/*
1、class_manage层：高度=屏幕高度-105px；（当宽度>c_m_main层的宽度时，宽度=c_m_box层的个数x200px-1px，当宽度<c_m_main层的宽度时，宽度=屏幕宽度-244px；）
2、c_m_main层：宽度=c_m_box层的个数x200px-1px；
3、c_m_box层：高度=屏幕高度-105px；第一个c_m_box层需要加first类名； 屏幕$(window).height()$(window).width()
*/

function setReturnValue(index,b) {
    var $this = $('#level1').find('li').eq(index);
    var hasnext = $this.attr("hasnext");
    if(hasnext==0){
        $this.attr("hasnext",1);
    }
    if(typeof (b)!='undefined'&&b){
        $this.attr("hasnext",0);
    }
    $this.trigger('click');
}

function multi_add_new()
{
	var itemid = $(".cur").attr("itemid");
	var level = $(".cur").attr("level");
	var titleinfo = "";
	
	if(typeof(level) == 'undefined')
	{
		titleinfo = "添加第一级信息";
	}
	else
	{
		titleinfo = "添加同级信息";
	}
	//跳转添加第一级jsp处理
	var url="../category/multi_category_add_new2018_IP.jsp?itemid="+itemid+"&channelid="+ChannelID+"&level="+level;
		dialog.setWidth(935);
		dialog.setHeight(620);
		//dialog.setSuffix('_2');
		dialog.setUrl(url);
		dialog.setTitle(titleinfo);
		dialog.show();
}
//添加子分类
function multi_add()
{
	var itemid = $(".cur").attr("itemid");
	var level = $(".cur").attr("level");
	if(typeof(level) != 'undefined')
	{
		//跳转到添加子分类jsp进行处理
		var url="../category/multi_category_add2018_IP.jsp?itemid="+itemid+"&channelid="+ChannelID+"&level="+level;
		dialog.setWidth(935);
		dialog.setHeight(620);
		dialog.setUrl(url);
		dialog.setTitle("添加子类信息");
		dialog.show();
	}else{
        dialog.showAlert("请选择一个栏目","danger");
        return false;
    }
	
}

//编辑
function multi_edit()
{
	var itemid = $(".cur").attr("itemid");
	var level = $(".cur").attr("level");
	
	if(typeof(level) != 'undefined')
	{
		//跳转到处理编辑的jsp
		var url="../category/multi_category_edit2018_IP.jsp?itemid="+itemid+"&channelid="+ChannelID;
		//dialog.setWidth(635);
		//dialog.setHeight(420);
		dialog.setWidth(935);
		dialog.setHeight(620);
		dialog.setUrl(url);
		dialog.setTitle("编辑当前信息");
		dialog.show();
	}else{
        dialog.showAlert("请选择一个话题","danger");
        return false;
    }
}
//删除程序
function multi_del_procedure()
{
	var itemid = $(".cur").attr("itemid");
	var url="multi_category_delete.jsp?itemid="+itemid+"&channelid="+ChannelID;
	$.ajax({
		type: "GET",
		url: url,
		success: function(msg){document.location.href=document.location.href;}
	});
}
//判断是否有子话题
function multi_del_check()
{
	var itemid = $(".cur").attr("itemid");
	var url="multi_category_delete_check.jsp?itemid="+itemid+"&channelid="+ChannelID;
	$.ajax({
		type: "GET",
		url: url,
		success: function(msg){
			var message = "确实要删除当前话题？删除后，数据无法恢复";
			if(msg.trim()==1){
				message = "当前话题有子话题，如直接删除会删除相关子话题,确定删除吗？删除后，数据无法恢复";
			}
			if(confirm(message))
			{
				multi_del_procedure();
			}
			//TideConfirm("提示",message,"multi_del_procedure","content");
		}
	});
}

//删除提示
function multi_del()
{
//	var itemid = $(".cur").attr("itemid");
	var level = $(".cur").attr("level");
	
	if(typeof(level) != 'undefined')
	{
		multi_del_check();
//		var message = "确实要删除这项吗？删除后，数据无法恢复";
//		TideConfirm("提示",message,"multi_del_procedure","content");
		
/*		if(confirm(message))
		{
			//跳转到处理删除的jsp
			var url="multi_category_delete.jsp?itemid="+itemid+"&channelid="+ChannelID;
			$.ajax({
				type: "GET",
				url: url,
				success: function(msg){document.location.href=document.location.href;}
			});
		}  */
		
	}else{
        dialog.showAlert("请选择一个话题","danger");
		return false;
	}
	
}

function doupclick(itemid,hasNextLevel) {
  if(hasNextLevel==0){
      //$(".c_m_box ul li[itemid="+itemid+"]").removeClass("no_arrow");
      $(".c_m_box ul li[itemid="+itemid+"]").attr("hasNext",2);
  }
  $(".c_m_box ul li[itemid="+itemid+"]").click();
}

function update(json)
{
	var action = json.action;
	var itemid = json.itemid;
	var globalid = json.globalid;
	var title = json.title;
	var level = json.level;
	//action=3更新
	if(action==3)
	{
		$(".c_m_box ul li[class *='cur']").html(title);
	}
	else
	{
		//action其它情况都是添加操作
		if(level==0){
			level=1;
		} 
		             
		var str = "<li globalid=\""+globalid+"\" level=\""+level+"\" itemid=\""+itemid+"\" hasnext=\"0\" class=\"no_arrow\"><a href=\"#\">"+title+"</a><i class=\"fa fa-caret-right\"></i></li>";
		$("#level"+level+" ul").append(str);
		
		if(action==2)
		{
			var le  = 	$(".c_m_box ul li[class='no_arrow cur']").attr("level");
			$(".c_m_box ul li[class='no_arrow cur']").attr("hasnext","1");
			$(".c_m_box ul li[class='no_arrow cur']").attr("class","cur");
			$(".c_m_box ul li[class='cur']").click(function(){});
			$(".c_m_box ul li[class='cur']").click();
			//window.console.info(le+"---");
		}
	}
	clickinfo();
}	 
 $(function(){
       
//      $('.topicItem').perfectScrollbar();
        $(".topicItem").delegate("li","click",function(){
        	$(".topicItem li.cur").removeClass("cur");
        	$(this).addClass("cur");
        })
  
      }); 
    </script>
  </body>
</html>
