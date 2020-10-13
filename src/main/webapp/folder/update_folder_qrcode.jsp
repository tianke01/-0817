<%@ page import="java.util.*" %>
<%@ page import="org.json.*" %>
<%@ page import="tidemedia.cms.system.*" %>
<%@ page import="tidemedia.cms.base.TableUtil" %>
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
     * 用途：修改二维码所在文件夹
     * 1,田轲 20200912 创建
     */
    System.out.println("----修改二维码所在文件夹----");
    JSONObject jsonObject =new JSONObject();
    //Integer folder_id=getIntParameter(request,"folder_id");//文件夹id
    String code_ids=getParameter(request, "code_ids");//二维码id
    //if(!"".equals(code_ids)&&folder_id!=0){
    if(!"".equals(code_ids)){
        String[] code_ids2 = code_ids.split(",");
        Integer code_id;
        for(int i=0; i<code_ids2.length; i++){
            HashMap<String, String> code_map = new HashMap<>();
            code_id= Integer.valueOf(code_ids2[i]);
            Document doc=new Document(code_id,code_ChannelID);
            int globalID = doc.getGlobalID();
            String updateSql="update item_snap set ChannelID=16527  where GlobalID="+globalID;
            new TableUtil().executeUpdate(updateSql);
        }
        jsonObject.put("message","移动成功！");
        jsonObject.put("code",200);
    }else {
        jsonObject.put("message","文件夹id和二维码id不能为空！");
        jsonObject.put("code",500);
    }
    out.println(jsonObject.toString());
%>
