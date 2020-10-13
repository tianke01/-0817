<%@ page import="java.util.*" %>
<%@ page import="org.json.*" %>
<%@ page import="tidemedia.cms.system.*" %>
<%@ page contentType="text/html;charset=utf-8" language="java"%>
<%@ include file="../config1.jsp"%>
<%!
    //设置频道id
    static int folder_ChannelID=16526;//文件夹频道
    static int code_ChannelID=16511;//二维码信息频道
    static int time_ChannelID=16512;//定时切换频道
    static int num_ChannelID=16513;//按次切换频道
%>

<%
    /**
     * 用途：文件夹修改名称
     * 1,田轲 20200912 创建
     */
    System.out.println("----文件夹修改名称----");
    JSONObject jsonObject =new JSONObject();
    String Title= getParameter(request, "folder_Title");//文件夹名称
    Integer folder_id=getIntParameter(request,"folder_id");//文件夹id
    Document document = new Document(folder_id, folder_ChannelID);
    System.out.println(Title+"---"+folder_id);
    if(!"".equals(Title)&&folder_id!=0){
        HashMap<String, String> map = new HashMap<>();
        map.put("Title",Title);
        new ItemUtil().updateItemByGid(folder_ChannelID,map,document.getGlobalID(),0);
        jsonObject.put("message","修改成功！");
        jsonObject.put("code",200);
    }else {
        jsonObject.put("message","文件夹名称和Id不能为空！");
        jsonObject.put("code",500);
    }
    out.println(jsonObject.toString());
%>