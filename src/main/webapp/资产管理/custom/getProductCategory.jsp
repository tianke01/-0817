<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(! userinfo_session.isAdministrator())
{
	response.sendRedirect("../noperm.jsp");
	return;
}

int itemid_  = getIntParameter(request,"itemid");
int level_ = getIntParameter(request,"level");
int haschild = getIntParameter(request,"haschild");
String fieldname = getParameter(request,"fieldname");
	//int siteid = CommonUtil.getSiteByCompanyid(userinfo_session.getCompany()).getId();
	Channel channel = CmsCache.getChannel(fieldname);
if(haschild!=0 || level_==0)
{
	TableUtil tu = new TableUtil();
	String sql = "select * from "+channel.getTableName()+" where Active=1 and Parent="+itemid_+" order by ordernumber desc";
	ResultSet rs = tu.executeQuery(sql);
	String str ="";
	if(level_==0)
	{
		str += "<div id=\"level"+(level_+1)+"\" class=\"topicItem topicItem1 clearfix c_m_box first\" style=\"\"><ul >";
	}
	else
	{
		str += "<div id=\"level"+(level_+1)+"\" class=\"topicItem topicItem1 c_m_box\" style=\"\"><ul >";
	}
	while(rs.next())
	{
		int itemid = rs.getInt("id");
		String Title = rs.getString("Title");
		int Level = rs.getInt("Level");
		int Parent = rs.getInt("Parent");
		int hasN = rs.getInt("hasNextLevel");
		/*String Code = tu.convertNull(rs.getString("Code"));
		if(hasN == 0)
		{
			str +="<li class=\"no_arrow\" hasNext=\""+hasN+"\" itemid=\""+itemid+"\" level=\""+Level+"\"><label class=\"rdiobox\"><input type=\"radio\" code=\""+Title;
			if(Code.length()>0){
				str +="("+Code+")";
			}
			str+="\" value=\""+itemid+"\" id=\"item_type_"+itemid+"\"  name=\"item_type\"><span for=\"item_type_"+itemid+"\"> </span></label><a href=\"#\">"+Title;
			if(Code.length()>0){
				str +="("+Code+")";
			}
			str+="</a><i class=\"fa fa-caret-right\"></i></li>";
		}
		else
		{
			str +="<li class=\"\" hasNext=\""+hasN+"\" itemid=\""+itemid+"\" level=\""+Level+"\"><label class=\"rdiobox\"><input type=\"radio\" code=\""+Title;
			if(Code.length()>0){
				str +="("+Code+")";
			}
			str+="\" value=\""+itemid+"\" id=\"item_type_"+itemid+"\" name=\"item_type\"><span for=\"item_type_"+itemid+"\"> </span></label><a href=\"#\">"+Title;
			if(Code.length()>0){
				str +="("+Code+")";
			}
			str+="</a><i class=\"fa fa-caret-right\"></i></li>";
		}*/
		
		if(hasN == 0)
		{
			str +="<li class=\"no_arrow\" hasNext=\""+hasN+"\" itemid=\""+itemid+"\" level=\""+Level+"\"><label class=\"rdiobox\"><input type=\"radio\" code=\""+Title;
			
			str+="\" value=\""+itemid+"\" id=\"item_type_"+itemid+"\"  name=\"item_type\"><span for=\"item_type_"+itemid+"\"> </span></label><a href=\"#\">"+Title;
			
			str+="</a><i class=\"fa fa-caret-right\"></i></li>";
		}
		else
		{
			str +="<li class=\"\" hasNext=\""+hasN+"\" itemid=\""+itemid+"\" level=\""+Level+"\"><label class=\"rdiobox\"><input type=\"radio\" code=\""+Title;
			
			str+="\" value=\""+itemid+"\" id=\"item_type_"+itemid+"\" name=\"item_type\"><span for=\"item_type_"+itemid+"\"> </span></label><a href=\"#\">"+Title;
			
			str+="</a><i class=\"fa fa-caret-right\"></i></li>";
		}
	}
	str += "</ul></div>";

	tu.closeRs(rs);

	out.println(str);
}
%>
