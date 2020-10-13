<%@ page
import="java.sql.*,tidemedia.cms.util.*,tidemedia.cms.system.*,tidemedia.cms.base.*,tidemedia.cms.user.*,java.util.*,java.sql.*"
%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(! userinfo_session.isAdministrator())
{
	response.sendRedirect("../noperm.jsp");
	return;
}

int itemid_  = getIntParameter(request,"itemid");
int channelid = getIntParameter(request,"channelid");
int level_ = getIntParameter(request,"level");

int haschild = getIntParameter(request,"haschild");
if(haschild!=0 || level_==0)
{
	Channel channel = CmsCache.getChannel(channelid);
	String channel_name = channel.getTableName();
	TableUtil tu = new TableUtil();
	String sql = "select * from "+channel_name+"  where Status=1 and Parent="+itemid_;
	ResultSet rs = tu.executeQuery(sql);
	String str ="";
	if(level_==0)
	{
		str += "<div id=\"level"+(level_+1)+"\" class=\"c_m_box first\" style=\"\"><ul >";
	}
	else
	{
		str += "<div id=\"level"+(level_+1)+"\" class=\"c_m_box\" style=\"\"><ul >";
	}
	while(rs.next())
	{
		int itemid = rs.getInt("id");
		String Title = rs.getString("Title");
		int Level = rs.getInt("Level");
		int Parent = rs.getInt("Parent");
		int hasN = rs.getInt("hasNextLevel");
		int gid = rs.getInt("GlobalID");
		if(hasN == 0)
		{
			str +="<li class=\"no_arrow\" hasNext=\""+hasN+"\" itemid=\""+itemid+"\" level=\""+Level+"\" globalid=\""+gid+"\">"+Title+"</li>";
		}
		else
		{
			str +="<li class=\"\" hasNext=\""+hasN+"\" itemid=\""+itemid+"\" level=\""+Level+"\" globalid=\""+gid+"\">"+Title+"</li>";
		}
	}
	str += "</ul></div>";
	out.println(str);
	tu.closeRs(rs);
}
%>
