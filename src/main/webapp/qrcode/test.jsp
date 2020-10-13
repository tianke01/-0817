<%@ page import="tidemedia.cms.system.CmsCache" %>
<%@ page import="tidemedia.cms.system.Channel" %>
<%@ page import="tidemedia.cms.base.TableUtil" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="tidemedia.cms.util.Util" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    int code_ChannelID=24410;//访问记录频道
    Channel channel= CmsCache.getChannel(code_ChannelID);//根据频道ID获取频道对象
    String tableName=channel.getTableName();
    String sql="select * from "+tableName+" where" +timeSql("","",0);

    TableUtil tu=new TableUtil();
    ResultSet rs = tu.executeQuery(sql);
    while (rs.next()){
        int id=rs.getInt("id");
        String s = Util.FormatDate("yyyy-MM-dd", rs.getLong("CreateDate") * 1000);
        out.println(id);
        out.println(s);
    }
    tu.closeRs(rs);
%>

<%!
    public static String timeSql(String startTime,String endTime,int timeType) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar calendar = Calendar.getInstance();
        Date date = new Date();
        long datel1 = Util.getFromTime(sdf.format(date), "");//转换类型 代表后的时间
        long datel2;//转换类型 代表前的时间
        String timeSql = "";
        if (timeType == 0) {//默认为今天
            timeSql = " CreateDate >= " + datel1;
            return timeSql;
        } else if (timeType == 1) {//昨天
            calendar.add(Calendar.DATE, -1);
            date = calendar.getTime();
            datel2 = Util.getFromTime(sdf.format(date), "");
            timeSql = " CreateDate >= " + datel2 + " and CreateDate <" + datel1;
            return timeSql;
        } else if (timeType == 2) {//一周内
            calendar.add(Calendar.DATE, -7);
            date = calendar.getTime();
            datel2 = Util.getFromTime(sdf.format(date), "");
            timeSql = " CreateDate >= " + datel2;
            return timeSql;
        } else if (timeType == 4) {
            datel1 = Util.getFromTime(endTime, "");
            datel2 = Util.getFromTime(startTime, "");
            timeSql = " CreateDate >= " + datel2+ " and CreateDate <" + datel1;
            return timeSql;
        }else{
            return "error";
        }

    }
%>
