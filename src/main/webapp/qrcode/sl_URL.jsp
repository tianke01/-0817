<%@ page import="org.json.*" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.URLConnection" %>
<%@ page contentType="text/html;charset=utf-8" language="java"%>
<%@ include file="../config1.jsp"%>
<%
    /**
     * 用途：二维码切换规则删除
     * 1,田轲 20200911 创建
     */
    System.out.println("----URL地址是否有效判断----");
    String url=getParameter(request,"url");
    JSONObject jsonObject =new JSONObject();
    if(!"".equals(url)){
        Boolean bb = testUrlWithTimeOut(url, 1000);
        if(bb){
            jsonObject.put("code",200);
            jsonObject.put("message","地址有效！");
        }else{
            jsonObject.put("code",500);
            jsonObject.put("message","地址无效！");
        }
    }else {
        jsonObject.put("code",500);
        jsonObject.put("message","跳转地址不能为空！");
    }
    out.println(jsonObject.toString());
%>

<%!
    public static Boolean testUrlWithTimeOut(String urlString,int timeOutMillSeconds){
        long lo = System.currentTimeMillis();
        Boolean b=false;
        URL url;
        try {
            url = new URL(urlString);
            URLConnection co =  url.openConnection();
            co.setConnectTimeout(timeOutMillSeconds);
            co.connect();
            b=true;
            return b;
        } catch (Exception e1) {
            return b;
        }
    }
%>