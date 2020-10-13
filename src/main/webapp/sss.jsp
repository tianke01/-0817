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
<%@ include file="../../config1.jsp"%>
<!-- 活码管理接口：二维码扫描记录信息  -->
<!-- 创建人：田轲  -->

<%

    /*String tablename = CmsCache.getChannel("register").getTableName();
    System.out.println("tablename:"+tablename);
    TableUtil tu = new TableUtil();
    String sql = "select * from "+tablename;
    System.out.println(sql);
    ResultSet rs  = tu.executeQuery(sql);
    while(rs.next()){
        int id=rs.getInt("id");
        System.out.println("id"+id);
    }

    tu.closeRs(rs);*/



%>



