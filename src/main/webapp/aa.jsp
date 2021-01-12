<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="tidemedia.cms.system.Document" %>
<%@ page import="tidemedia.cms.system.CmsCache" %>
<%@ page import="tidemedia.cms.util.*" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="tidemedia.cms.system.ItemUtil" %>
<%@ page import="tidemedia.cms.base.TableUtil" %>
<%@ page import="java.net.*" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="tidemedia.cms.system.Channel" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="tidemedia.cms.base.MessageException" %>
<%@ page import="java.sql.SQLException" %>
<%@ include file="../../config1.jsp"%>

<!-- 创建人：田轲  -->

<%

    String aaa=selectChannelid(16519);
    out.println(aaa);
    //out.println("--------------------------:"+json.toString());

    //TableUtil tu = new TableUtil();
    /*TableUtil tu_user = new TableUtil("user");
  	String sql="select * from userinfo where id=420 ";
	ResultSet Rs = tu_user.executeQuery(sql);
  	if(Rs.next()){
  	    out.println("--------------------------:"+Rs.getString("Name"));
  	}*/
	/*String sql = "show create table weixin_account";
	ResultSet rs = tu.executeQuery(sql);
	if(rs.next()){
		out.print(rs.getString("create table"));
	}
	tu.closeRs(rs);*/

    //String tableName = CmsCache.getChannel("code").getTableName();
    // out.println("--------------------------:"+tableName);
    //TableUtil tu = new TableUtil();
    //channel表增加内容页布局字段content_layout
    //tu.executeUpdate("alter table channel add column  EditorType int(1) default 0;");
    /*String sql = "select * from "+tableName +" where Tel='15704661426' order by CreateDate desc limit 1";
    ResultSet rs  = tu.executeQuery(sql);
    while(rs.next()){
        String Title=rs.getString("Title");
        //String username=rs.getString("name");
        out.println("Title"+Title);
    }*/

    /*String tablename = CmsCache.getChannel("register").getTableName();
    System.out.println("tablename:"+tablename);
    TableUtil tu = new TableUtil();
    String sql = "select * from "+tablename;
    System.out.println(sql);
    ResultSet rs  = tu.executeQuery(sql);
    while(rs.next()){
        int id=rs.getInt("id");
        //String username=rs.getString("name");
        out.println("id"+id);
    }

    tu.closeRs(rs);*/

    /*
    TableUtil tu = new TableUtil("user");
    String sql = "select * from userinfo where id=420";
    ResultSet rs  = tu.executeQuery(sql);
    while(rs.next()){
        int id=rs.getInt("id");
        String username=rs.getString("name");
        out.println("id"+id+username);
    }
    tu.closeRs(rs);*/
%>

<%!
    public static String selectChannelid(int channelid) throws MessageException, SQLException {
        String channelids=channelid+",";
        String Sql = "select * from channel where Parent=" + channelid;
        TableUtil tu = new TableUtil();
        ResultSet Rs = tu.executeQuery(Sql);
        while (Rs.next()) {
            int id = Rs.getInt("id");
            channelids+=id+",";
        }
        tu.closeRs(Rs);
        channelids=channelids.substring(0,channelids.length()-1);
        return channelids;
    }
%>



