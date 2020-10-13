<%@ page import="java.util.*" %>
<%@ page import="org.json.*" %>
<%@ page import="tidemedia.cms.system.*" %>
<%@ page contentType="text/html;charset=utf-8" language="java"%>
<%@ include file="../config1.jsp"%>
<%!
    //设置频道id
    static int folder_ChannelID=16526;//文件夹频道
%>

<%
    /**
     * 用途：文件夹新增
     * 1,田轲 20200912 创建
     */
    System.out.println("----文件夹新增----");
    String Title= getParameter(request, "folder_Title");//文件夹名称
    JSONObject jsonObject =new JSONObject();
    if(!"".equals(Title)){
        HashMap<String, String> map = new HashMap<>();
        map.put("Title",Title);
        int GlobalID = ItemUtil.addItemGetGlobalID(folder_ChannelID, map);
        Document doc=new Document(GlobalID);
        int folder_id = doc.getId();
        Map map1 = new HashMap();
        map1.put("folder_id",folder_id);
        map1.put("Title",Title);
        jsonObject.put("data",map1);
        jsonObject.put("message","新增文件夹成功！");
        jsonObject.put("code",200);
    }else {
        jsonObject.put("message","文件夹名称不能为空！");
        jsonObject.put("code",500);
    }
    out.println(jsonObject.toString());
%>