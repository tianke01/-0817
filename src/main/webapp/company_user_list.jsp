<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
long begin_time = System.currentTimeMillis();

//不是租户管理员不允许访问
if(!userinfo_session.isCompanyAdmin())
{response.sendRedirect("../noperm.jsp");return;}

int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
if(currPage<1)
	currPage = 1;
if(rowsPerPage<=0)
	rowsPerPage = 20;

String Action = getParameter(request,"Action");
int GroupID = getIntParameter(request,"GroupID");
int company = getIntParameter(request,"company");
int type = getIntParameter(request,"type");//1,租户  2,用户组  0,所有用户

if(Action.equals("Del"))
{
	int id = getIntParameter(request,"id");
	UserInfo userinfo = new UserInfo(id);

	if(userinfo.getRole()==1)
	{
		if(!(new UserPerm().canManageAdminUser(userinfo_session)))
		{response.sendRedirect("../noperm.jsp");return;}
	}
	userinfo.setActionUser(userinfo_session.getId());
	userinfo.Delete(id);

	out.println("success");return;
}
String parentChannelPath ="用户管理 / ";

if(type==1){
	Company com = new Company(company);
	parentChannelPath += com.getName();
}else if(type==2&&GroupID!=-1){
	UserGroup ug = new UserGroup(GroupID);
	parentChannelPath += ug.getName();
}else{
	parentChannelPath += "所有用户";
}
%>
<!DOCTYPE html>
<html id="">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>TideCMS 7 列表</title>
<link href="../tcenter/lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../tcenter/lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../tcenter/lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../tcenter/lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../tcenter/lib/2018/select2/css/select2.min.css" rel="stylesheet">
<link href="../tcenter/lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
<link rel="stylesheet" href="../tcenter/style/2018/common.css">
<link href="../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">
<link rel="stylesheet" href="../tcenter/style/2018/bracket.css">  
<link rel="stylesheet" href="../tcenter/style/theme/theme.css">

<style>
.collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
/*tooltip相关样式*/
.bs-tooltip-right .tooltip-inner {padding: 8px 15px;font-size: 13px;border-radius: 3px;color: #ffffff;background-color: #00b297;opacity: 1;}
.tooltip.bs-tooltip-right .arrow::before,
.tooltip.bs-tooltip-auto[x-placement^="right"] .arrow::before {			
	border-right-color: #00b297;			
}
.dropdown.hidden-xs-down{
	display: flex;
}
</style>

<script src="../tcenter/lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../tcenter/common/2018/common2018.js"></script>
<script type="text/javascript" src="../tcenter/common/2018/content.js"></script>

<script>
var listType=1;
jQuery(document).ready(function(){

	$("#rowsPerPage").val('<%=rowsPerPage%>');
});
var myObject = new Object();
	myObject.title = "";
    myObject.GroupID = "<%=GroupID%>";
	 

function addUser()
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(600);
	dialog.setHeight(600);
	dialog.setUrl("../user/user_add2018.jsp?GroupID="+myObject.GroupID+"&company=<%=company%>");
	dialog.setTitle("新建用户");
	dialog.show();
}

function editUser(id)
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(600);
	dialog.setHeight(600);
	dialog.setUrl("../user/user_edit2018.jsp?id=" + id);
	dialog.setTitle("编辑用户");
	dialog.show();
}


function setPerm(id,role)
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(800);
	dialog.setHeight(650);

	if(role==1)
	{
		dialog.setWidth(550);
		dialog.setHeight(480);
	}
	else if(role==5)
	{
		dialog.setWidth(340);
		dialog.setHeight(280);
	}
	dialog.setUrl("../user/user_edit2.jsp?id=" + id);
	dialog.setTitle("设置权限");
	dialog.show();
}

function fresh(id)
{
    myObject.title = "编辑用户";
	var Feature = "dialogWidth:40em; dialogHeight:28em;center:yes;status:no;help:no";	
	var retu = window.showModalDialog
	("../tcenter/modal_dialog.jsp?target=test/user_test.jsp&id=" + id,myObject,Feature);
}

function user_enable(id,flag)
{
	
	var	dialog = new top.TideDialog();
	dialog.setWidth(320);
	dialog.setHeight(240);
	dialog.setUrl("../user/user_enable2018.jsp?id=" + id +"&flag=" + flag);
	dialog.setTitle("权限设置");
	dialog.show();	
}

function user_delete(id,name)
{
	

	var url="../user/user_del2018.jsp?id="+id+"&name="+name;
	var	dialog = new top.TideDialog();
		dialog.setWidth(300);
		dialog.setHeight(260);
		dialog.setUrl(url);
		dialog.setTitle("删除用户");
		dialog.show();
}
function Enable(id){
	var	dialog = new top.TideDialog();
		dialog.setWidth(400);
		dialog.setHeight(450);
		dialog.setUrl("../user/company_index.jsp?id="+id);
		dialog.setTitle("关联租户");
		dialog.show();
}
function Disable(id){
	var url = "../user/user_company_action.jsp?userid="+id+"&type=2";
	$.ajax({
		type:"GET",
		url:url, 
		success: function(msg){
			document.location.reload();
		}
	});
}

function gopage(currpage) {
	var url = "../company/company_user_list.jsp?GroupID=<%=GroupID%>&type=<%=type%>&company=<%=company%>&currPage=" + currpage + "&rowsPerPage=<%=rowsPerPage%>";
	this.location = url;
}


/* 
$(document).ready(function() {
	$("#oTable").tablesorter({headers: { 0: { sorter: false}}});
});
*/
</script>
</head>
<body class="collapsed-menu email">
<%
	TableUtil tu_user = new TableUtil("user");
String ListSql = "select id,jurong,Role,company,Tel,Status,LastLoginDate,Name,Email,Username,UNIX_TIMESTAMP(ExpireDate) as ExpireDate from userinfo";
String CountSql = "select count(*) from userinfo";

if(type==1){
	ListSql += " where company="+company;
	CountSql += " where company="+company;
}else if(type==2){
	ListSql += " where company=0";
	CountSql += " where company=0";
}else{
	if(userinfo_session.getCompany()!=0){
		ListSql += " where company="+userinfo_session.getCompany();
		CountSql += " where company="+userinfo_session.getCompany();
	}else{
		ListSql += " where 1=1";
		CountSql += " where 1=1";
	}
}


if(GroupID==0)
{
	ListSql += " and GroupID=0 or GroupID is null order by Role,id";
	CountSql += " and GroupID=0 or GroupID is null";
}
else if(GroupID==-1)
{
	ListSql += " order by Role,id";
	CountSql += "";
}
else
{
	ListSql += " and GroupID=" + GroupID + " order by Role,id";
	CountSql += " and GroupID=" + GroupID;
}



long nowdate = System.currentTimeMillis()/1000;
	
ResultSet Rs = tu_user.List(ListSql,CountSql,currPage,rowsPerPage);
int TotalPageNumber = tu_user.pagecontrol.getMaxPages();
int TotalNumber = tu_user.pagecontrol.getRowsCount();
	%>
<div class="br-mainpanel br-mainpanel-file" id="js-source">  
	
	<div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
          <span class="breadcrumb-item active"><%=parentChannelPath%></span>
        </nav>
    </div><!-- br-pageheader -->
	<%if(userinfo_session.isCompanyAdmin()){%>
    <div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
		<div class="btn-group hidden-xs-down mg-l-auto">
			<a href="javascript:addUser();" class="btn btn-outline-info" >新建用户</a>
		</div>
		<div class="btn-group mg-l-10 hidden-sm-down">
		  <%if(currPage>1){%>
			<a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
		  <%}%>
		  <%if(currPage<TotalPageNumber){%>
			<a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
		  <%}%>
		</div>
    </div>
	<%}else{%>
	<!-- btn-group -->
	<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
		<div class="btn-group hidden-xs-down mg-l-auto">
		</div>
		<div class="btn-group mg-l-10 hidden-sm-down">
		  <%if(currPage>1){%>
			<a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
		  <%}%>
		  <%if(currPage<TotalPageNumber){%>
			<a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
		  <%}%>
		</div>
    </div>
		
	<%}%>
		<!-- btn-group -->
	
	<!--列表-->
	 <div class="br-pagebody pd-x-20 pd-sm-x-30">
		<div class="card bd-0 shadow-base">
			<table class="table mg-b-0" id="content-table">
				<thead>
				  <tr>
					<th class="wd-5p">
					 编号
					</th>
					<th class="tx-12-force tx-mont tx-medium">角色</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">姓名</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">手机号码</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">聚融业务</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">最近登录时间</th>
					<th class="tx-12-force wd-250 tx-mont tx-medium hidden-xs-down">操作</th>
					<th class="tx-12-force tx-mont tx-medium hidden-xs-down">登录控制</th>
				  </tr>
				</thead>
				<tbody>
<%

if(tu_user.pagecontrol.getRowsCount()>0){

	int j=0;

	while(Rs.next()){

		String Username = convertNull(Rs.getString("Username"));
		String Name = convertNull(Rs.getString("Name"));
		String Email = convertNull(Rs.getString("Email"));
		String Tel = convertNull(Rs.getString("Tel"));
		String loginDate = convertNull(Rs.getString("LastLoginDate")).replace(".0","");
		int Status = Rs.getInt("Status");
		int Role = Rs.getInt("Role");
		int companyid = Rs.getInt("company");
		int id = Rs.getInt("id");
		int ExpireDate = Rs.getInt("ExpireDate");

		String RoleName = "";
		if(Role==1){
			RoleName = "系统管理员";
			if(companyid!=0){
				RoleName = "租户管理员";
			}
		}else if(Role==2)
			RoleName = "频道管理员";
		else if(Role==3)
			RoleName = "编辑";
		else if(Role==4)
			RoleName = "站点管理员";
		else if(Role==5)
			RoleName = "视客管理员";

		String userflag = "false";
		if(Status==1){//开启
			userflag = "true";
		}

		int jurong = Rs.getInt("jurong");
		String jurongflag = "false";
		if(jurong==1){//开启
			jurongflag = "true";
		}

		j++;
%>
		<tr id="jTip<%=id%>_id">
			<td class="hidden-xs-down"><%=j%></td>
			<td class="hidden-xs-down"><%=RoleName%></td>
			<td class="hidden-xs-down"><%=Name%></td>
			<td class="hidden-xs-down"><%=Tel%></td>
			<td class="hidden-xs-down">
				<div class='toggle-wrapper'>
					<div class='toggle toggle-light primary toggle_company' data-toggle-on='<%=jurongflag%>' userId='<%=id%>' field="jurong"></div>
				</div>
			</td>
			<td class="hidden-xs-down"><%=loginDate%></td>
			<td class="dropdown hidden-xs-down">
				<button class="btn btn-info btn-sm mg-r-8 tx-13 " onclick="editUser(<%=id%>);">编辑</button>
				<button class="btn btn-info btn-sm mg-r-8 tx-13 " onclick="setPerm(<%=id%>,<%=Role%>);">权限</button>
				<%
				if(userinfo_session.getCompany()==0||Role!=1){//租户管理员只能删除编辑用户
				%>
				<button class="btn btn-info btn-sm mg-r-8 tx-13 " onclick="user_delete(<%=id%>,'<%=Name%>');">删除</button>
				<%}%>
				<%if(companyid==0){%>
					<button class="btn btn-info btn-sm mg-r-8 tx-13 " onclick="Enable(<%=id%>);">关联租户</button>
				<%}else{
					if(userinfo_session.getCompany()==0){//当前登录用户未关联租户
					%>	
					<button class="btn btn-info btn-sm mg-r-8 tx-13 " onclick="Disable(<%=id%>);">解绑租户</button>
					<%}
				}%>
				<%if(ExpireDate>0 && nowdate>ExpireDate){%>
					<!-- <img src="../images/icon/01.png">  -->
				<%}%>
			</td>
			<td class="hidden-xs-down">
				<div class='toggle-wrapper'>
					<div class='toggle toggle-light primary toggle_company' data-toggle-on='<%=userflag%>' userId='<%=id%>' field="Status"></div>
				</div>
			</td>
		</tr>
<%  }
	tu_user.closeRs(Rs);
}

%>
				</tbody>
			</table>
			<%if(TotalPageNumber>0){%>
			<!--分页-->
			<div id="tide_content_tfoot">
				<span class="mg-r-20 ">共<%=TotalNumber%>条</span>
				<span class="mg-r-20 "><%=currPage%>/<%=TotalPageNumber%>页</span>
				<%if(TotalPageNumber>1){%>
				<div class="jump_page ">
					<span class="">跳至:</span>
					<label class="wd-60 mg-b-0">
						<input class="form-control" placeholder="" type="text" name="jumpNum" id="jumpNum">
					</label>
					<span class="">页</span>
					<a href="#" id="goToId" class="tx-14">Go</a>
				</div>
				<%}%>
				<div class="each-page-num mg-l-auto">
					<span class="">每页显示:</span>
					<select name="rowsPerPage" class="form-control select2 wd-80" data-placeholder="" onChange="change(this);" id="rowsPerPage">
						<option value="10">10</option>
						<option value="15">15</option>
						<option value="20">20</option>
						<option value="25">25</option>
						<option value="30">30</option>
						<option value="50">50</option>
						<option value="80">80</option>
						<option value="100">100</option>            
					</select>
					<span class="">条</span>
				 </div>
			</div>
			<!--分页-->
			<%}%>		
		</div>
	 </div><!--列表-->

	<%if(userinfo_session.isCompanyAdmin()){%>
	<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
		<div class="btn-group hidden-xs-down mg-l-auto">
			<a href="javascript:addUser();" class="btn btn-outline-info" >新建用户</a>
		</div>
		<div class="btn-group mg-l-10 hidden-sm-down">
			<%if(currPage>1){%>
			<a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
			<%}%>
			<%if(currPage<TotalPageNumber){%>
			<a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
			<%}%>
		</div>
	</div>
	<%}else{%>
	<!-- btn-group -->
	<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
		<div class="btn-group hidden-xs-down mg-l-auto">
		</div>
		<div class="btn-group mg-l-10 hidden-sm-down">
			<%if(currPage>1){%>
			<a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
			<%}%>
			<%if(currPage<TotalPageNumber){%>
			<a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
			<%}%>
		</div>
	</div>
	<%}%>
	
	<script src="../lib/2018/jquery-toggles/toggles.min.js"></script>
	<script src="../lib/2018/popper.js/popper.js"></script>
    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../lib/2018/moment/moment.js"></script>
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
    <script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
    <script src="../lib/2018/select2/js/select2.min.js"></script>
    <script src="../common/2018/bracket.js"></script>
    <script type="text/javascript" src="../common/2018/jquery.contextmenu.js"></script>
    <script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
	<script>
		//开关相关
		//初始化
		$('.toggle').toggles({        
		  height: 25
		});
		//获取是否开或关
		$(".toggle").click(function(){
			var id = $(this).attr('userId');
			var field = $(this).attr('field');
			var myToggle = $(this).data('toggle-active');
			var flag = 1 ;
			if(myToggle==false){
				flag = 2 ;
			}

			var url = "../user/user_enable2018.jsp?id=" + id +"&flag=" + flag+"&field="+field;
            $.ajax({
                type:"get",
                url:url,
                dataType:"json",
                success:function(res){
                    if(res.code == 200){
                        var	dialog = new top.TideDialog();
                        dialog.showAlert(res.msg);
                        // location.reload();
                    }
                },
                error:function(xhr){
                    TideAlert("提示","出错啦");
                }
            })
        })
function change(obj)
{
	if(obj!=null)		this.location="../company/company_user_list.jsp?GroupID=<%=GroupID%>&type=<%=type%>&company=<%=company%>&rowsPerPage="+obj.value;
}


function setReturnValue() {
	var url =  "../company/company_user_list.jsp?rowsPerPage=<%=rowsPerPage%>&GroupID=<%=GroupID%>&type=<%=type%>&company=<%=company%>&currPage=<%=currPage%>" ;
			this.location = url;
}
jQuery(document).ready(function(){

	$("#rowsPerPage").val('<%=rowsPerPage%>');

	jQuery("#goToId").click(function(){
		var num=jQuery("#jumpNum").val();
		if(num==""){
			alert("请输入数字!");
			jQuery("#jumpNum").focus();
			return;}
		 var reg=/^[0-9]+$/;
		 if(!reg.test(num)){
			alert("请输入数字!");
			jQuery("#jumpNum").focus();
			return;
		 }

		if(num<1)
			num=1;
		var href="../company/company_user_list.jsp?GroupID=<%=GroupID%>&type=<%=type%>&company=<%=company%>&currPage="+num+"&rowsPerPage=<%=rowsPerPage%>";
		document.location.href=href;
	});

});
	</script>
</div>
</body>
</html>
