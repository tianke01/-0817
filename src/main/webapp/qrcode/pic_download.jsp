<%@ page import="org.json.*" %>
<%@ page import="tidemedia.cms.system.*" %>
<%@ page import="tidemedia.cms.base.*" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.io.*" %>
<%@ page import="tidemedia.cms.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.URLConnection" %>
<%@ page import="org.joda.time.format.FormatUtils" %>
<%@ page contentType="text/html;charset=utf-8" language="java"%>
<%@ include file="../config.jsp"%>

<%!
    //设置频道id
    static int code_ChannelID=16511;//活码管理频道
%>

<%
    /**
     * 用途：二维码单个下载
     * 1,田轲 20200913 创建
     */
    System.out.println("----二维码单个下载----");
    JSONObject jsonObject =new JSONObject();
    //活码管理所需数据
    int code_id=getIntParameter(request, "code_id");//二维码id
    if(code_id!=0){
        String url="";
        String Title="";
        Channel channel= CmsCache.getChannel(code_ChannelID);//根据频道ID获取频道对象
        String tableName=channel.getTableName();
        String sql="select * from "+tableName+" where id="+code_id;
        TableUtil tu=new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        while (rs.next()){
            url=rs.getString("QR_code_location");
            Title=rs.getString("Title");
        }
        tu.closeRs(rs);
        String fName = url.trim();
        String FileName = fName.substring(fName.lastIndexOf("/")+1);
        Title = URLEncoder.encode(Title, "UTF-8");//转换中文否则可能会产生乱码
        String downloadjsp="http://apptest.api-people.top/cms/renmin/download.jsp?Type=File&FolderName=/cms/renmin/qr_code&SiteId=21&FileName="+FileName+"&Title="+Title;
        response.sendRedirect(downloadjsp);
        jsonObject.put("message","成功！");
        jsonObject.put("code",200);
    }else {
        jsonObject.put("message","二维码id不能为空！");
        jsonObject.put("code",500);
    }
    out.println(jsonObject.toString());
%>
