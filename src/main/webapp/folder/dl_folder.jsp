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
    static int folder_ChannelID=16526;//文件夹频道
    static int code_ChannelID=16511;//二维码信息频道
    static int time_ChannelID=16512;//定时切换频道
    static int num_ChannelID=16513;//按次切换频道
    Log.debug();


%>

<%
    /**
     * 用途：文件夹删除
     * 1,田轲 20200912 创建
     */
    System.out.println("----文件夹删除----");
    JSONObject jsonObject =new JSONObject();
    String Title= getParameter(request, "folder_Title");//文件夹名称
    Integer folder_id=getIntParameter(request,"folder_id");//文件夹id
    Document document = new Document(folder_id, folder_ChannelID);
    Channel register = CmsCache.getChannel("register");
    String channelCode = register.getChannelCode();
    System.out.println(Title+"---"+folder_id);
    if(!"".equals(Title)&&folder_id!=0){
        if(Title.equals(document.getTitle())){
            HashMap<String, String> map = new HashMap<>();
            map.put("Active",0+"");
            new ItemUtil().updateItemByGid(folder_ChannelID,map,document.getGlobalID(),0);
            Channel channel= CmsCache.getChannel(code_ChannelID);//根据频道ID获取频道对象
            String tableName=channel.getTableName();
            String sql="select * from "+tableName+" where active=1  and folderId="+folder_id;
            TableUtil tu=new TableUtil();
            ResultSet rs = tu.executeQuery(sql);
            while (rs.next()){
                int qr_codeId = rs.getInt("id");
                deleteQrcode(qr_codeId);
            }
            tu.closeRs(rs);
            jsonObject.put("message","删除成功！");
            jsonObject.put("code",200);
        }else{
            jsonObject.put("message","无该文件夹！");
            jsonObject.put("code",500);
        }
    }else {
        jsonObject.put("message","文件夹名称和Id不能为空！");
        jsonObject.put("code",500);
    }
    out.println(jsonObject.toString());
%>

<%!
    public static void deleteQrcode(int qr_codeId) throws MessageException, SQLException {
        //删除二维码管理表
        Document doc=new Document(qr_codeId,code_ChannelID);
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