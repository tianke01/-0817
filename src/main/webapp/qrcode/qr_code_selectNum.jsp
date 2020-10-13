<%@ page import="java.util.*" %>
<%@ page import="org.json.*" %>
<%@ page import="tidemedia.cms.system.*" %>
<%@ page import="tidemedia.cms.base.*" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.io.IOException" %>
<%@ page import="tidemedia.cms.base.TableUtil" %>
<%@ page import="java.net.*" %>
<%@ page contentType="text/html;charset=utf-8" language="java"%>
<%@ include file="../config.jsp"%>



<%
    //活码管理接口：二维码信息单个查询接口
    //创建人:田轲
    //根据频道id  查询该频道的二维码数量
    int id=getIntParameter(request,"id");
    JSONObject jsonObject =new JSONObject();
    StringBuffer aaa = getJsonStringAt("http://apptest.api-people.top/cms/lib/channel_json.jsp?ChannelID=16511&json=true");
    out.println(aaa+"</br>");

    try {
        int i = selectQrCode(id);
        jsonObject.put("code",200);
        jsonObject.put("num",i);
        jsonObject.put("id",id);
    }catch (Exception e){
        jsonObject.put("code",500);
        jsonObject.put("message","失败");
    }
    out.println(jsonObject.toString());

%>

<%!
    /**
     * 根据频道id搜索该频道下二维码数量
     * @param id
     * @return
     * @throws MessageException
     * @throws SQLException
     */
    public static int selectQrCode(int id) throws MessageException, SQLException {
        int num=0;
        Channel channel= CmsCache.getChannel(id);//根据频道ID获取频道对象
        String tableName=channel.getTableName();
        String sql="select count(*) from "+tableName+" where active=1 and Category="+id;;
        TableUtil tu=new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        while (rs.next()){
            num=rs.getInt(1);
        }
        tu.closeRs(rs);
        return num;
    }

    public static StringBuffer getJsonStringAt(String urlString) {
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
        return strBuf;
    }
%>

