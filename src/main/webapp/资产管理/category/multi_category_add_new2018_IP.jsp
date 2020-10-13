<%@ page
import="java.sql.*,tidemedia.cms.util.*,tidemedia.cms.system.*,tidemedia.cms.base.*,tidemedia.cms.user.*,java.util.*,java.sql.*"
%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
	/**
	 * 陈金峰 20200908	修改		让租户管理员也可以访问话题管理
	 */
	if(userinfo_session.getRole()!=1)
{
	response.sendRedirect("../noperm.jsp");
	return;
}

String Submit = getParameter(request,"Submit");
String city_name = getParameter(request,"city_name");
int level  = getIntParameter(request,"level");
int index  = getIntParameter(request,"index");
String photo_request=getParameter(request,"Photo");
String phototop_request=getParameter(request,"PhotoTop");
int itemid  = getIntParameter(request,"itemid");
int channelid = getIntParameter(request,"channelid");
Channel channel2 = CmsCache.getChannel(channelid);
String channel_name = channel2.getTableName();
String Summary_request=getParameter(request,"Summary");

//图片库频道编号
int sys_channelid_image = 0;
TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置
sys_channelid_image = photo_config.getInt("channelid");
Channel channel_ = null ;
Site site = null ;
String SiteUrl = "";
if(sys_channelid_image>0){
	channel_ = CmsCache.getChannel(sys_channelid_image);
	site = channel_.getSite();
	SiteUrl = site.getExternalUrl();
}else{
	channel_ = CmsCache.getChannel(channelid);
	site = channel_.getSite();
	SiteUrl = site.getUrl();
}
Document doc = new Document(itemid,channelid);


String p = doc.getValue("Parent");
int parent = 0;
if(!"".equals(p))
{
	parent = Integer.parseInt(p);
}
if(Submit.equals("Submit"))
{
	Channel channel = CmsCache.getChannel(channelid);
	HashMap map = new HashMap();
	map.put("Title", city_name);
	if(itemid==0)
	{
		map.put("Parent", 0+"");
	}
	else
	{
		map.put("Parent", parent+"");
	}
	if(level==0)
	{
		map.put("Level", 1+"");
	}
	else
	{
		map.put("Level", (level)+"");
	}
	map.put("Summary",Summary_request);
	map.put("Photo",photo_request);
	map.put("PhotoTop",phototop_request);
	map.put("PublishDate",Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
	map.put("Status","1");
	map.put("tidecms_addGlobal", "1");
	ItemUtil util_ = new ItemUtil();
	int globalid = util_.addItem(channelid,map).getGlobalID();
	
	Document doc_ = new Document(globalid);
	int itemid_  = doc_.getId();
    
    
    
    if(level==3){
        for(int i=1;i<255;i++){
            HashMap map2 = new HashMap();
            String city_name2=city_name.substring(0,city_name.indexOf("/")-1)+i;
            map2.put("Photo","");
            map2.put("Title", city_name2);
            map2.put("Parent", itemid_+"");
            map2.put("Level", (level+1)+"");
            map2.put("PublishDate",Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
            map2.put("Status","1");
            map2.put("tidecms_addGlobal", "1");
            //System.out.println(map2);
            int globalid2 = util_.addItem(channelid,map2).getGlobalID();
            Document doc_2 = new Document(globalid2);
            int itemid_2  = doc_2.getId();
            String updateSql2 = "update "+channel_name+" set hasNextLevel=1 where id="+itemid_;
            System.out.println("1234567");
            new TableUtil().executeUpdate(updateSql2);
        }
    }
    
	//action=1同级添加
	// String json = "{action:1,itemid:\""+itemid_+"\",globalid:\""+globalid+"\",title:\""+city_name+"\",level:\""+(level)+"\"}";
	if(level==2){
		out.println("<script>top.TideDialogClose();window.parent.frames[0].setReturnValue("+index+");</script>");
	}else{
		out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
	}
    
	//out.println("<script>top.TideDialogClose({suffix:'_2',recall:true,returnValue:{refresh:true,json:"+json+"}});</script>");
    //out.println("<script>top.TideDialogClose({refresh:'right.update("+json+");'});</script>");  老版文件原型
	return;

	
}

java.util.Date thedate = new java.util.Date();

%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="robots" content="noindex, nofollow">
	<title>TideCMS</title>
	<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
	<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
	<!--<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">-->
	<link rel="stylesheet" href="../style/2018/bracket.css">
	<link rel="stylesheet" href="../style/2018/common.css">
	<script src="../lib/2018/jquery/jquery.js"></script>
	<script type="text/javascript" src="../common/common.js"></script>
	<script type="text/javascript" src="../common/2018/TideDialog2018.js"></script>
	<style>
		.modal-backdrop {
			background-color: rgba(0, 0, 0,0.15) !important;
		}
		@media (min-width: 576px){
			.modal-dialog {
				max-width: 800px;
				margin: 10px auto;
			}
		}
	</style>
	<script>
		function selectImage(fieldname)
		{
			var	dialog = new TideDialog();
			dialog.setWidth(740);
			dialog.setHeight(540);
			dialog.setLayer(3);
			dialog.setZindex(10000);
			dialog.setUrl("../content/insertfile.jsp?ChannelID=<%=channelid%>&Type=Image&fieldname="+fieldname);
			dialog.setTitle("图片上传");
			dialog.show();
		}
		function previewFile(fieldname)
		{
			var	dialog = new top.TideDialog();
			var name = document.getElementById(fieldname).value;
			if(name==""){
				dialog.showAlert("请先上传图片","danger");
				return;
			}
			if(name.indexOf("http")!=-1){
				window.open(name);
			}else{
				window.open('<%=SiteUrl%>'+name);
			}

		}
		function check()
		{
			if($("#city_name").val().trim()=="")
			{
				alert("请输入名称");
			}
			else
			{
				var cityname = $("#city_name").val();
				//跳转处理确定按钮的jsp
				var url="check_hascity.jsp?itemid="+<%=itemid%>+"&channelid="+<%=channelid%>+"&cityname="+encodeURIComponent(cityname);
				$.ajax({
					type: "get",
					url: url,
					success: function(msg){

						if(msg==1){
							alert("该记录已在本级存在！");
						}else{
							$("#jobform").submit();
						}
					}
				});
			}
		}


	</script>
	<style>
		html,
		body {
			width: 100%;
			height: 100%;
		}
	</style>
</head>
<body>
<div class="bg-white modal-box">
	<form name="form" action="multi_category_add_new2018_IP.jsp?channelid=<%=channelid%>&itemid=<%=itemid%>&level=<%=level%>&Submit=Submit" method="post" id="jobform">

		<div class="modal-body modal-body-btn pd-20 overflow-y-auto">
			<div class="config-box">
				<ul>
					<li class="block mg-t-20">
						<div class="row">
							<label class="left-fn-title" >名称：</label>
							<label class="wd-230">
								<input class="form-control" name="city_name" id="city_name" placeholder="" type="text" value="<%=city_name%>">
							</label>
						</div>
						<div class="row">
							<label class="left-fn-title" >备注：</label>
							<label class="wd-230">
								<input class="form-control" name="Summary" id="Summary" placeholder="" type="text" value="<%=Summary_request%>">
							</label>
						</div>
						<!--<div class="row" id="tr_Photo">
							<label class="left-fn-title"  id="desc_Photo">图片：</label>
							<label class="wd-300">
								<input class="form-control" placeholder="" type="text" name="Photo" id="Photo" value="<%=photo_request%>" size="80">
							</label>
							<input class="btn btn-primary tx-size-xs mg-l-10 " href="javascript:;" name="" type="button" value="选择" onclick="selectImage('Photo')">
							<input class="btn btn-primary tx-size-xs mg-l-10 " href="javascript:;" name="" type="button" value="预览" onclick="previewFile('Photo')">
						</div>
						<%if(level==1){%>
						<div class="row" id="tr_Photo">
							<label class="left-fn-title"  id="desc_PhotoTop">模块主题图片：</label>
							<label class="wd-300">
								<input class="form-control" placeholder="" type="text" name="PhotoTop" id="PhotoTop" value="<%=phototop_request%>" size="80">
							</label>
							<input class="btn btn-primary tx-size-xs mg-l-10" href="javascript:;" name="" type="button" value="选择" onclick="selectImage('PhotoTop')">
							<input class="btn btn-primary tx-size-xs mg-l-10 " href="javascript:;" name="" type="button" value="预览" onclick="previewFile('PhotoTop')">
						</div>-->
						<%}%>
					</li>
				</ul>
			</div>
		</div>
		<!--modal-body-->

		<div class="btn-box" style="position: absolute;bottom: 0;width: 100%;">
			<div class="modal-footer">
				<input type="hidden" name="CopyMode"  id="CopyMode" value="1">
				<input type="hidden" name="Submit" value="Submit">
				<input type="hidden" name="SiteId" value="">
				<input type="hidden" name="index" value="<%=index%>">
				<button name="startButton" type="button" class="btn btn-primary tx-size-xs" id="startButton" onclick="check()">确认</button>
				<button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>

			</div>
		</div>
		<div id="ajax_script" style="display:none;"></div>
	</form>
</div>
<!-- modal-box -->
</body>

<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<!--   <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script> -->
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/peity/jquery.peity.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<!-- <script src="../common/2018/bracket.js"></script>  -->
</html>
