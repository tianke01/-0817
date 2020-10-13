<%@ page import="tidemedia.cms.system.*,
                 org.json.*,
				 tidemedia.cms.base.*,
				 tidemedia.cms.util.*,
				 java.util.*,
				 java.sql.*,
				 tidemedia.cms.user.UserInfo,
				 java.net.URLEncoder"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
	public JSONArray listChannel_JS(UserInfo user) throws JSONException,MessageException,SQLException{		
		JSONArray array = new JSONArray();
		int ChannelNumber = 0;
		ChannelNumber = Tree2019.getChannelNumber();
		Channel ch = CmsCache.getChannel(-1);
		ArrayList childs = ch.getAllChildChannelIDs();

		if ((childs != null) && (childs.size() > 0)){
			for (int i = 0; i < childs.size(); ++i) {
				JSONObject o = new JSONObject();
				int channelid = ((Integer)childs.get(i)).intValue();
				Channel child = CmsCache.getChannel(channelid);
				int type = child.getType();
				String channelname = child.getName();

				if (child.getIsShowDraftNumber() == 1)
				{
					int num = child.getNumber(0);
					if (num > 0)
						channelname = channelname + " (" + num + ")";
				}
				if ((type == 5) || (user.hasChannelShowRight(channelid))) {
					String varName = "lsh_" + channelid;
					String icon = new Tree2019().getIcon(child);

					o.put("name", channelname);
					o.put("id", channelid);
					o.put("type", type);
					o.put("icon", icon);
					JSONArray oo = listChannel_JS(channelid, varName, user, ChannelNumber);
					o.put("child", oo);
					array.put(o);
				}
			}
		}
		return array;
   }
   public JSONArray listChannel_JS(int id, String s, UserInfo user, int channelnum) throws JSONException,MessageException,SQLException{
		
		JSONArray array = new JSONArray();

		Channel ch = CmsCache.getChannel(id);
		ArrayList childs = ch.getAllChildChannelIDs();
		if ((childs != null) && (childs.size() > 0)) {

			for (int i = 0; i < childs.size(); ++i) {

				JSONObject o = new JSONObject();

				int channelid = ((Integer)childs.get(i)).intValue();
				Channel child = CmsCache.getChannel(channelid);
				int type = child.getType();
				String channelname = child.getName();

				if (child.getIsShowDraftNumber() == 1){
				  int num = child.getNumber(0);
				  if (num > 0)
					channelname = channelname + " (" + num + ")";
				}

				if (user.hasChannelShowRight(channelid)) {
					String varName = "lsh_" + channelid;
					String icon = "";
					icon = new Tree2019().getIcon(child);

					if (child.getType2() == 3)
						icon = new Tree2019().getIconByType2(child.getType2());

					if ((channelnum > 100) && (child.hasChild(user))){
						o.put("load", 1);
					}else{
						o.put("load", 0);
					}

					o.put("name", channelname);
					o.put("id", channelid);
					o.put("type", type);
					o.put("icon", icon);

					if (channelnum <= 100) {
						JSONArray oo = listChannel_JS(channelid, varName, user, 0);
						o.put("child", oo);
					}
					array.put(o);
				}
			}
		}
		return array;
	}

%>
<%
String Action = getParameter(request,"Action");
int		ChannelID	=	getIntParameter(request,"ChannelID");
int		LinkChannelID	=	getIntParameter(request,"LinkChannelID");
int		GlobalID	=	getIntParameter(request,"GlobalID");
int		fieldgroup	=	getIntParameter(request,"fieldgroup");
Tree2019 tree = new Tree2019();
String channel_tree_string = "";
JSONArray arr= tree.listChannel_json(LinkChannelID,"tree",userinfo_session,20);

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>TideCMS 9.0 <%=CmsCache.getCompany()%></title>

<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">

<link rel="stylesheet" href="../style/2018/bracket.css">
<link rel="stylesheet" href="../style/2018/sidebar-menu-template.css">
<link rel="stylesheet" href="../style/2018/common.css">

<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../common/2018/common2018.js"></script>
<script src="../common/2018/TideDialog2018.js"></script>
<script language=javascript>
var dir = "";
window.onresize = function(){	
	if(document.getElementById("right")){
		document.getElementById("right").style.height =Math.max(document.documentElement.clientHeight-8,0) + "px";				
	}
}
function changeFrameHeight(_this){
	$(_this).css("height",document.documentElement.clientHeight-8);
}

</script>
<style>
	.br-mainpanel{margin-top: 0px;margin-left: 230px;}
</style>
<script>
	
</script>
</head>

<body class="collapsed-menu email" onLoad="">
   
	<div class="br-subleft br-subleft-file">
        <ul class="sidebar-menu">	  	  

		</ul>
    </div><!-- br-subleft -->
	<div class="br-mainpanel">      
      <iframe src="../custom/select_child_content2018_pxjdk.jsp?ChannelID=<%=ChannelID%>&LinkChannelID=<%=LinkChannelID%>&GlobalID=<%=GlobalID%>&fieldgroup=<%=fieldgroup%>" id="template_frame" style="width: 100%;height: 100%;"  scrolling="auto" frameborder="0" onload="changeFrameHeight(this)"></iframe>  
    </div><!-- br-mainpanel -->
	<script src="../lib/2018/popper.js/popper.js"></script>
	<script src="../lib/2018/bootstrap/bootstrap.js"></script>
	<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
	<script src="../lib/2018/moment/moment.js"></script>
	<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
	<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
	<!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->

	<!--<script src="../lib/2018/datatables/jquery.dataTables.js"></script>-->
	<!--<script src="../lib/2018/datatables-responsive/dataTables.responsive.js"></script>-->
	<script src="../lib/2018/select2/js/select2.min.js"></script>
	<script src="../common/2018/bracket.js"></script>
	<script src="../common/2018/sidebar-menu-channel.js"></script>
	<script>
	var ChannelID = "<%=ChannelID%>";
	var LinkChannelID = "<%=LinkChannelID%>";
	var GlobalID = "<%=GlobalID%>";
	var fieldgroup = "<%=fieldgroup%>";

        $(function(){
		$('.br-mailbox-list,.br-subleft').perfectScrollbar();				
		//============ =============================================================================
				var menu = $('.sidebar-menu');
				var json = <%=arr%>;
				for(var i=0;i<json.length;i++){
					var html = '';
					if(json[i].child && json[i].child.length>0)
					{
						html = '<li class="treeview">';
					}
					else
					{
						html = '<li>';
					}
					if( json[i].load==1 || (json[i].child!=null && json[i].child.length>0) ){
					html += '<a href="#" load="'+json[i].load+'" channelid="'+json[i].id+'"><i class="fa fisrtNav fa-home " have="1"></i> <span>'+json[i].name+'</span></a>';
                    }else{
						html += '<a href="#" load="'+json[i].load+'" channelid="'+json[i].id+'"><i class="fa fisrtNav fa-home " have="0"></i> <span>'+json[i].name+'</span></a>';
					}
					if(json[i].child && json[i].child.length>0)
					{
						html += '<ul class="treeview-menu">' + get_menu_html(json[i]) + '</ul>';
					}
					html += '</li>';
					menu.append(html);
				}
			
				//多级导航自定义
				$.sidebarMenu(menu);
			});
		function get_menu_html(json)
		{
			var html = "";
			if(json.child && json.child.length>0)
			{
				var json_ = json.child;
				for(var i=0;i<json_.length;i++){
					html += '<li><a href="#" load="'+json_[i].load+'" channelid="'+json_[i].id+'">'
				 if(json_[i].load==1||(json_[i].child && json_[i].child.length>0)){
					html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>' 
				}else{
					html += '<i class="fa fa-angle-right op-5" hava="0"></i>' 
					} 
					html +='<span>'+json_[i].name+'</span></a>';

					if(json_[i].child && json_[i].child.length>0){
						html += '<ul class="treeview-menu">' + get_menu_html(json_[i]) + '</ul>';
					}
					html += '</li>';
				}
			}
			return html;
		 }
//========================================================================
		$.sidebarMenu = function(menu) {
			var animationSpeed = 300;
		  
			$(menu).on('click', 'li a', function(e) {
				var $this = $(this);
				var checkElement = $this.next();
				var LinkChannelID2 = $this.attr("channelid");		
				sidebarMenu_show(checkElement,animationSpeed,$this);
                changeFrameSrc( window.frames["template_frame"] , "../custom/select_child_content2018_pxjdk.jsp?ChannelID="+ChannelID+"&LinkChannelID="+LinkChannelID+"&GlobalID="+GlobalID+"&fieldgroup="+fieldgroup+"&LinkChannelID2="+LinkChannelID2 );						
			});
		}	
    </script>
</body>
</html>
