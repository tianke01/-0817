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
<%@ include file="../config1.jsp"%>
<!-- 活码管理接口：二维码扫描记录信息  -->
<!-- 创建人：田轲  -->

<%
    int code_ChannelID=16511;//二维码管理频道
    int record_ChannelID=16514;//访问记录频道
    System.out.println("扫描二维码，接收id值，按值查询活码实际指向的跳转地址");
    int id= getIntParameter(request, "id");
    //访问ip地址
    String ip=getRealIp(request);
    String aaa=request.getRemoteAddr();
    System.out.println("aaa"+aaa);
    String Title=ip;
    //访问时间段period
    String DateNow = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss"));
    String period=DateNow.substring(11,14)+"00";
    //访问地址access_address
    String access_address = getJsonStringAt("http://whois.pconline.com.cn/ipJson.jsp?ip=" + ip + "&json=true");
    //IPSeeker ipSeeker = IPSeeker.getInstance();
    //String access_address =ipSeeker.getArea(ip);
    String userAgent = request.getHeader("user-agent").toLowerCase();;
    //访问系统
    String system_type="";
    if(userAgent.indexOf("android") != -1){
        system_type="Android端";
    }else if(userAgent.indexOf("iphone") != -1 || userAgent.indexOf("ipad") != -1 || userAgent.indexOf("ipod") != -1){
        system_type="IOS端";
    }
    //访问来源access_source
    String access_source="";
    if(userAgent.indexOf("micromessenger") != -1){
        access_source="微信";
    }else if(userAgent.indexOf("qq") != -1 ){
        access_source="QQ";
    }else if(userAgent.indexOf("weibo") != -1 ){
        access_source="微博";
    }else if(userAgent.indexOf("dingtalk") != -1 ){
        access_source="钉钉";
    }else if(userAgent.indexOf("alipayclient") != -1 ){
        access_source="支付宝";
    }else{
        access_source="其他";
    }
    System.out.println("userAgent:"+userAgent);
    System.out.println("访问ip:"+ip);
    System.out.println("访问时间："+DateNow);
    System.out.println("访问地址:"+access_address);
    System.out.println("访问来源:"+access_source);
    System.out.println("访问系统:"+system_type);
    System.out.println("访问时间段:"+period);
    HashMap<String, String> map = new HashMap<>();
    map.put("Title",ip);
    map.put("access_address",access_address);
    map.put("access_source",access_source);
    map.put("system_type",system_type);
    map.put("qr_codeId",id+"");
    map.put("period",period);
    int GlobalID = ItemUtil.addItemGetGlobalID(record_ChannelID, map);
    Document Doc= CmsCache.getDocument(id,code_ChannelID);
    new TableUtil().executeUpdate("update " + CmsCache.getChannel(code_ChannelID).getTableName()+" set number="+(Doc.getIntValue("number")+1)+" where id="+id);
    System.out.println("访问次数:"+(Doc.getIntValue("number")+1));
    String jump_address = Doc.getValue("jump_address");
    //getJsonStringAt("http://apptest.api-people.top/cms/renmin/qr_code_update_es.jsp?globalid="+GlobalID);
    String urlString="http://apptest.api-people.top/cms/renmin/qr_code_update_es.jsp?globalid="+GlobalID;
    URL url = new URL(urlString);
    URLConnection conn = url.openConnection();
    new BufferedReader(new InputStreamReader(conn.getInputStream(), "gb2312"));
    response.sendRedirect(jump_address);
%>

<%!
    public static String getRealIp(HttpServletRequest request) {
        String ip = request.getHeader("x-forwarded-for");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
            if(ip.equals("127.0.0.1") || ip.equals("0:0:0:0:0:0:0:1")){
                //根据网卡取本机配置的IP
                InetAddress inet=null;
                try {
                    inet = InetAddress.getLocalHost();
                } catch (UnknownHostException e) {
                    e.printStackTrace();
                }
                ip= inet.getHostAddress();
            }
        }
        //对于通过多个代理的情况，第一个IP为客户端真实IP,多个IP按照','分割
        if(ip!=null && ip.length()>15){ //"***.***.***.***".length() = 15
            if(ip.indexOf(",")>0){
                ip = ip.substring(0,ip.indexOf(","));
            }
        }
        return ip;
    }

    public static String getJsonStringAt(String urlString) {
        StringBuffer strBuf = new StringBuffer();
        try {
            URL url = new URL(urlString);
            URLConnection conn = url.openConnection();
            BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "gb2312"));
            String line = null;
            while((line = reader.readLine()) != null) {
                strBuf.append(line + " ");
            }
            reader.close();
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        String pro[]=strBuf.toString().split(",");
        String[] split = pro[1].split(":");
        return split[1].substring(1, split[1].length() -1);
    }


%>



