<%@ page
import="java.sql.*,tidemedia.cms.util.*,tidemedia.cms.system.*,tidemedia.cms.base.*,tidemedia.cms.user.*,java.util.*,java.sql.*"
%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
    /**
     * 1、陈金峰 2020.09.09 修改  增加租户管理员可以创建子分类
     */
if(userinfo_session.getRole()!=1)
{
	response.sendRedirect("../noperm.jsp");
	return;
}

String Submit = getParameter(request,"Submit");
String city_name = getParameter(request,"city_name");
String photo_request=getParameter(request,"Photo");
String phototop_request=getParameter(request,"PhotoTop");
String Summary_request=getParameter(request,"Summary");
int level  = getIntParameter(request,"level");
int itemid  = getIntParameter(request,"itemid");
int channelid = getIntParameter(request,"channelid");
Document doc = new Document(itemid,channelid);
String Title = doc.getValue("Title");
String Summary = doc.getValue("Summary");
String Photo = doc.getValue("Photo");
String Parent= doc.getValue("Parent");
String PhotoTop=doc.getValue("PhotoTop");
int thislevel=doc.getIntValue("Level");
int globalid = doc.getGlobalID();

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

if(Submit.equals("Submit"))
{	
	Channel channel = CmsCache.getChannel(channelid);
	String channel_name = channel.getTableName();
	TableUtil tu = new TableUtil();
	String updatesql = "update "+channel_name+" set Title='"+city_name+"' ,Photo='"+photo_request+"' ,PhotoTop='"+phototop_request+"' ,Summary='"+Summary_request+"' where Status=1 and id="+itemid;
	tu.executeUpdate(updatesql);
	//action=3更新操作
	/*String json = "{action:3,itemid:\""+itemid+"\",globalid:\""+globalid+"\",title:\""+city_name+"\",level:\""+(level)+"\"}";
	out.println("<script>top.TideDialogClose({refresh:'right.update("+json+");'});</script>");*/
	out.println("<script>top.TideDialogClose();window.parent.frames[0].doupclick('"+Parent+"');</script>");
	return;
}

java.util.Date thedate = new java.util.Date();

%>
<!DOCTYPE HTML>
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
	var name = document.getElementById(fieldname).value;
	if(name.indexOf("http")!=-1){
		window.open(name);
	}else{
		window.open('<%=SiteUrl%>'+name);
	}  
	
}
function check()
{	
	if($("#city_name").val()=="")
	{
		alert("no kong");
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
     <form name="form" action="multi_category_edit2018.jsp?channelid=<%=channelid%>&itemid=<%=itemid%>&level=<%=level%>&Submit=Submit" method="post" id="jobform">

                            <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
                                <div class="config-box">
                                    <ul>
                                        <li class="block mg-t-20">    
                                            <div class="row">
                                                <label class="left-fn-title" >名称：</label>
                                                <label class="wd-230">
				                                <input class="form-control" name="city_name" id="city_name" placeholder="" type="text" value="<%=Title%>">
			                                    </label>
                                            </div>		
                                            <div class="row">
                    							<label class="left-fn-title" >备注：</label>
                    							<label class="wd-230">
                    								<input class="form-control" name="Summary" id="Summary" placeholder="" type="text" value="<%=Summary%>">
                    							</label>
                    						</div>
                                            <!--<div class="row" id="tr_Photo">
                                                <label class="left-fn-title"  id="desc_Photo">图片：</label>
                                                <label class="wd-300">
				                                   <input class="form-control" placeholder="" type="text" name="Photo" id="Photo" value="<%=Photo%>" size="80">
			                                    </label>
                                                <input class="btn btn-primary tx-size-xs mg-l-10 " href="javascript:;" name="" type="button" value="选择" onclick="selectImage('Photo')">
                                                <input class="btn btn-primary tx-size-xs mg-l-10 " href="javascript:;" name="" type="button" value="预览" onclick="previewFile('Photo')">
                                            </div>
											<%if(thislevel==1){%>
											 <div class="row" id="tr_Photo">
                                                <label class="left-fn-title"  id="desc_PhotoTop">模块主题图片：</label>
                                                <label class="wd-300">
				                                   <input class="form-control" placeholder="" type="text" name="PhotoTop" id="PhotoTop" value="<%=PhotoTop%>" size="80">
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
									<input type="hidden" name="pparent" value="<%=Parent%>">
                                    <button name="startButton" type="button" class="btn btn-primary tx-size-xs" id="startButton" onclick="check()">确认</button>
                                    <button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消
		                            </button>
                          
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
