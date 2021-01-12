<%@ page import="java.util.*" %>
<%@ page import="org.json.*" %>
<%@ page import="tidemedia.cms.system.*" %>
<%@ page import="tidemedia.cms.base.*" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="tidemedia.cms.base.TableUtil" %>
<%@ page import="tidemedia.cms.util.TideJson" %>
<%@ page contentType="text/html;charset=utf-8" language="java"%>
<%@ include file="../config.jsp"%>

<%
    //机柜资源总量/可用机柜资源数量接口。
    String callback=getParameter(request,"callback");
    System.out.println("----机柜资源总量/可用机柜资源数量接口----");
    JSONObject jsonObject =new JSONObject();
    try{
        Map map = selectNum();//已用机柜资源数量
        jsonObject.put("code",200);
        jsonObject.put("data",map);
        jsonObject.put("message","成功");
    }catch (Exception e){
        jsonObject.put("code",500);
        jsonObject.put("message","数据异常:"+e.toString());
    }
    out.println(callback+"("+jsonObject.toString()+")");
%>

<%!
    /**
     * 查询资源数量
     * @return
     * @throws MessageException
     * @throws SQLException
     */
    public static Map  selectNum() throws MessageException, SQLException {
        Map map=new HashMap();
        int UsedNum=0;
        int Sum=0;
        int AvailableNum=0;
        //在系统参数中获取所需频道id
        TideJson TJ_Channel = CmsCache.getParameter("zichan").getJson();
        int EngineRoomChannelID = TJ_Channel.getInt("EngineRoom");//资源池基本信息频道ID
        Channel channel= CmsCache.getChannel(EngineRoomChannelID);//根据频道ID获取频道对象
        String tableName=channel.getTableName();
        String sql="select * from "+tableName+" where Level=3 and active=1";
        TableUtil tu=new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        while (rs.next()){
            int isUsed = rs.getInt("IsUsed");
            if(isUsed==0){
                AvailableNum++;
            }else if(isUsed==1){
                UsedNum++;
            }
            Sum++;
        }
        tu.closeRs(rs);
        map.put("AvailableNum",AvailableNum);
        map.put("UsedNum",UsedNum);
        map.put("Sum",Sum);
        return map;
    }
%>
