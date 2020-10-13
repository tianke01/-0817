<%@ page import="java.util.*" %>
<%@ page import="org.json.*" %>
<%@ page import="tidemedia.cms.system.*" %>
<%@ page import="tidemedia.cms.base.*" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=utf-8" language="java"%>
<%@ include file="../config1.jsp"%>
<%
    /**
     * 用途：二维码切换规则删除
     * 1,田轲 20200911 创建
     */
    //设置频道id
    int code_ChannelID=16511;//活码管理频道
    int time_ChannelID=16512;//定时切换频道
    int num_ChannelID=16513;//按次切换频道
    System.out.println("----二维码切换删除----");
    JSONObject jsonObject =new JSONObject();
    Integer type=getIntParameter(request,"type");//切换规则 0：按扫描次数上限创建 1：按链接有效期创建
    Integer permanent=getIntParameter(request,"permanent");//是否长期有效 0：非永久有效  1：永久有效
    Integer num_id=getIntParameter(request,"Num_id");
    Integer time_id=getIntParameter(request,"Time_id");
    if(num_id==0&&time_id==0){
        jsonObject.put("code",500);
        jsonObject.put("message","该切换地址无id,直接删除！");
    }

    if(permanent==0&&type==0){//按扫描次数上限修改
        HashMap<String, String> num_map = new HashMap<>();
        num_map.put("qr_codeId",0+"");
        num_map.put("Active",0+"");
        new ItemUtil().updateItemById(num_ChannelID,num_map,num_id,0);
        jsonObject.put("code",200);
        jsonObject.put("message","删除成功！");
    }else if(permanent==0&&type==1){//按链接有效期修改
        HashMap<String, String> time_map = new HashMap<>();
        time_map.put("qr_codeId",0+"");
        time_map.put("Active",0+"");
        new ItemUtil().updateItemById(time_ChannelID,time_map,time_id,0);
        jsonObject.put("code",200);
        jsonObject.put("message","删除成功！");
    }
    out.println(jsonObject.toString());
%>
