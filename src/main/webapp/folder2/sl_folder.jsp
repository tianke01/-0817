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
    static int code_ChannelID=16511;//二维码信息频道
    static int folder2_ChannelID=16527;//默认文件夹频道
%>

<%
    //活码管理接口：查询所有文件夹
    //创建人:田轲
    System.out.println("----文件夹查询----");
    JSONObject jsonObject =new JSONObject();
    jsonObject.put("code",500);
    Channel channel= CmsCache.getChannel(folder2_ChannelID);//根据频道ID获取频道对象
    String tableName=channel.getTableName();
    String sql="select * from "+tableName;
    TableUtil tu=new TableUtil();
    ResultSet rs = tu.executeQuery(sql);
    while (rs.next()){
        int globalID = rs.getInt("GlobalID");
        Document document = new Document(globalID);
        int channelID = document.getChannelID();
        System.out.println("channelID:"+channelID+"</br>");
    }
    tu.closeRs(rs);

%>

<%!
    /**
     * 根据folder_id查询该文件夹下二维码数量
     * @param folder_id
     * @return
     * @throws MessageException
     * @throws SQLException
     */
    public static int slQrcodeByFolderId(int folder_id) throws MessageException, SQLException {
        int num=0;
        Channel channel= CmsCache.getChannel(code_ChannelID);//根据频道ID获取频道对象
        String tableName=channel.getTableName();
        String sql="select count(*) from "+tableName+" where active=1 and folderId="+folder_id;
        TableUtil tu=new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        while (rs.next()){
            num= rs.getInt(1);
        }
        tu.closeRs(rs);
        return num;
    }
%>
