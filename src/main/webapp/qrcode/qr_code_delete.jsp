<%@ page import="java.util.*" %>
<%@ page import="org.json.*" %>
<%@ page import="tidemedia.cms.system.*" %>
<%@ page import="tidemedia.cms.base.*" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=utf-8" language="java"%>
<%@ include file="../config1.jsp"%>

<%!
    //设置频道id
    static int code_ChannelID=16511;//活码管理频道
    static int time_ChannelID=16512;//定时切换频道
    static int num_ChannelID=16513;//按次切换频道
%>

<%
    /**
     * 用途：二维码删除
     * 1,田轲 20200911 创建
     */

    System.out.println("----二维码删除----");
    JSONObject jsonObject =new JSONObject();
    jsonObject.put("message","系统异常！");
    jsonObject.put("code",500);
    //活码管理所需数据
    String code_ids=getParameter(request, "code_ids");//二维码id
    if(!"".equals(code_ids)){
        String[] code_ids2 = code_ids.split(",");
        Integer code_id;
        for(int i=0; i<code_ids2.length; i++){
            code_id= Integer.valueOf(code_ids2[i]);
            deleteQr_code(code_id);
        }
        jsonObject.put("message","删除成功！");
        jsonObject.put("code",200);
    }else {
        jsonObject.put("message","二维码id不能为空！");
        jsonObject.put("code",500);
    }
    out.println(jsonObject.toString());
%>

<%!
    public static void deleteQr_code(int qr_codeId) throws SQLException, MessageException {
        Document doc=new Document(qr_codeId,code_ChannelID);
        int GlobalID=doc.getGlobalID();
        //删除二维码管理表
        Channel channel= CmsCache.getChannel(code_ChannelID);//根据频道ID获取频道对象
        String tableName=channel.getTableName();
        String code_sql="update "+tableName+" set Active=0 and QR_code_address='' where id="+qr_codeId;
        new TableUtil().executeUpdate(code_sql);
        if(doc.getIntValue("permanent")==0){
            if(doc.getIntValue("type")==0){//删除按次切换表
                Channel num_channel= CmsCache.getChannel(num_ChannelID);//根据频道ID获取频道对象
                String num_tableName=num_channel.getTableName();
                String num_sql="update "+num_tableName+" set Active=0  where qr_codeId="+qr_codeId;
                new TableUtil().executeUpdate(num_sql);
            }else if(doc.getIntValue("type")==1){//删除定时切换表
                Channel time_channel= CmsCache.getChannel(time_ChannelID);//根据频道ID获取频道对象
                String time_tableName=time_channel.getTableName();
                String time_sql="update "+time_tableName+" set Active=0  where qr_codeId="+qr_codeId;
                new TableUtil().executeUpdate(time_sql);
            }
        }
    }
%>
