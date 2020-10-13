<%@ page import="tidemedia.cms.system.CmsCache" %>
<%@ page import="tidemedia.cms.system.Channel" %>
<%@ page import="tidemedia.cms.base.TableUtil" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="tidemedia.cms.util.Util" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="tidemedia.cms.system.ItemUtil" %>
<%@ page import="tidemedia.cms.system.Document" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    Document document = new Document(2908, 16086);
    String posttime = document.getValue("posttime");
    out.println("posttime"+posttime);
    int active = document.getActive();
    document.getTitle();
    Channel channel= CmsCache.getChannel(16086);//根据频道ID获取频道对象
    String tableName=channel.getTableName();
    String sql="select * from "+tableName+" where id="+2908;
    TableUtil tu=new TableUtil();
    ResultSet rs = tu.executeQuery(sql);
    while (rs.next()){
        String posttime=rs.getString("posttime");
        out.println("posttime"+posttime);
    }
    tu.closeRs(rs);
%>