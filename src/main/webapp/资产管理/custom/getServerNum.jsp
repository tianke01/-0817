<%@ page import="tidemedia.cms.util.Util" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONException" %>
<%@ page import="java.io.IOException" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="java.util.*" %>
<%@ page import="tidemedia.cms.util.*" %>
<%@ page import="tidemedia.cms.system.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="tidemedia.cms.base.*" %>
<%@ page import="static tidemedia.cms.util.Util2.getParameter" %>
<%@ page contentType="text/html;charset=utf-8" language="java"%>
<%@ include file="../config.jsp"%>

<%
    //机房服务器数量，网络设备数量
    String callback=getParameter(request,"callback");
    JSONObject jsonObject =new JSONObject();

    Map map = getServerMessage();
    map.put("JHJNum",getJHJNum());
    jsonObject.put("data",map);
    jsonObject.put("code",200);
    jsonObject.put("message","成功");

    out.println(callback+"("+jsonObject.toString()+")");
%>

<%!

    //服务器数量信息
    public static Map getServerMessage() throws MessageException, SQLException {
        Map map=new HashMap();
        int ServerNum=0;//总数
        int RightNum=0;//正常数量
        int WrongNum=0;//错误数量
        TideJson TJ_Channel = CmsCache.getParameter("zichan").getJson();
        int serverChannelID = TJ_Channel.getInt("server");//资源池基本信息频道ID
        Channel channel= CmsCache.getChannel(serverChannelID);//根据频道ID获取频道对象
        String tableName=channel.getTableName();
        String sql="select * from "+tableName+" where active=1";
        TableUtil tu=new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        while (rs.next()){
            ServerNum=ServerNum+1;
            String businessStatus = rs.getString("BusinessStatus");
            if("0".equals(businessStatus)){//目前设定正确为0 错误为1 String类型
                RightNum=RightNum+1;
            }else{
                WrongNum=WrongNum+1;
            }
        }
        tu.closeRs(rs);
        map.put("ServerNum",ServerNum);
        map.put("RightNum",RightNum);
        map.put("WrongNum",WrongNum);
        return map;
    }

    //交换机数量
    public static int getJHJNum() throws MessageException, SQLException {
        int num=0;
        TideJson TJ_Channel = CmsCache.getParameter("zichan").getJson();
        int jhjEquipmentChannelID = TJ_Channel.getInt("jhjEquipment");//资源池基本信息频道ID
        Channel channel= CmsCache.getChannel(jhjEquipmentChannelID);//根据频道ID获取频道对象
        String tableName=channel.getTableName();
        String sql="select count(*) from "+tableName+" where active=1";
        TableUtil tu=new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        while (rs.next()){
            num=rs.getInt(1);
        }
        tu.closeRs(rs);
        return num;
    }
%>
