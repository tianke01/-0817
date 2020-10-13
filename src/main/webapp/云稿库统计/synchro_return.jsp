<%@ page import="java.util.*" %>
<%@ page import="org.json.*" %>
<%@ page import="tidemedia.cms.system.*" %>
<%@ page import="tidemedia.cms.base.*" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="tidemedia.cms.util.TideJson" %>
<%@ include file="../config1.jsp"%>
<%
    TideJson Shared_Library = CmsCache.getParameter("shared_library").getJson();
    int shared_library = Shared_Library.getInt("shared_library");//私有库频道ID
    int shared_library_a = Shared_Library.getInt("shared_library_a");//素材库频道ID
    int shared_library_b = Shared_Library.getInt("shared_library_b");//成品库频道ID
    int shared_library_d = Shared_Library.getInt("shared_library_d");//采集库频道ID
    //Integer ItemID=getIntParameter(request,"doc_id");
    //Integer ChannelID=getIntParameter(request,"ChannelID");
    HashMap<String,String> map = getDraft(1, 16267);
    ItemUtil.addItemGetGlobalID(shared_library, map);

%>



<%!


    //获取回传内容管理图文数据
    public HashMap<String,String> getPic(int ItemID,int ChannelID) throws SQLException, MessageException {
        Document document=new Document(ItemID,ChannelID);
        String Title = document.getValue("Title");//标题
        String publishDate = document.getPublishDate();//发布日期
        String Photo=document.getValue("Photo");//照片
        int User = document.getUser();//作者
        HashMap<String,String> map=new HashMap<>();
        map.put("Title",Title);
        map.put("Photo",Photo);
        map.put("User",User+"");
        map.put("type",0+"");
        return map;
    }

    //获取回传内容管理稿件数据
    public HashMap<String,String> getDraft(int ItemID,int ChannelID) throws SQLException, MessageException {
        Document document=new Document(ItemID,ChannelID);
        String Title = document.getValue("Title");//标题
        int User = document.getUser();//作者
        String publishDate = document.getPublishDate();//发布日期
        String Photo=document.getValue("Photo");//照片
        HashMap<String,String> map=new HashMap<>();
        map.put("Title",Title);
        map.put("Photo",Photo);
        map.put("User",User+"");
        map.put("type",2+"");
        return map;
    }

    //获取回传内容管理直播数据
    public HashMap<String,String> getLive(int ItemID,int ChannelID) throws SQLException, MessageException {
        Document document=new Document(ItemID,ChannelID);
        String Title = document.getValue("Title");//标题
        int User = document.getUser();//作者
        String publishDate = document.getPublishDate();//发布日期
        String Photo=document.getValue("Photo");//照片
        HashMap<String,String> map=new HashMap<>();
        map.put("Title",Title);
        map.put("Photo",Photo);
        map.put("User",User+"");
        return map;
    }

    //获取回传内容管理视频数据
    public HashMap<String,String> getVideo(int ItemID,int ChannelID) throws SQLException, MessageException {
        Document document=new Document(ItemID,ChannelID);
        String Title = document.getValue("Title");//标题
        int User = document.getUser();//作者
        String publishDate = document.getPublishDate();//发布日期
        String Photo=document.getValue("Photo");//照片
        int VideoID = document.getGlobalID();//视频编号
        String VideoUrl = selectByVideoID(VideoID);
        String video_source = document.getValue("video_source");//视频源文件
        String video_source_size =document.getValue("video_source_size");//视频源文件大小
        int Duration = document.getIntValue("Duration");//时长
        String zl =document.getValue("zl");//帧率
        String ml =document.getValue("ml");//码率
        String bmfs =document.getValue("bmfs");//编码方式
        String fbl =document.getValue("fbl");//分辨率
        HashMap<String,String> map=new HashMap<>();
        map.put("Title",Title);
        map.put("Photo",Photo);
        map.put("User",User+"");
        map.put("VideoUrl",VideoUrl);
        map.put("Videoid",VideoID+"");
        map.put("type",1+"");
        map.put("Audio",video_source_size);
        map.put("Time",Duration+"");
        map.put("Format",bmfs);
        map.put("Resolution",fbl);
        return map;
    }


    //根据文章GlobalID在视频地址查询视频地址
    public String selectByVideoID(int VideoID) throws MessageException, SQLException {
        String Url="";
        Channel channel= CmsCache.getChannel(4);//根据频道ID获取频道对象
        String tableName=channel.getTableName();
        String sql="select Url  from "+tableName+" where Parent="+VideoID;
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        while (rs.next()){
            Url = rs.getString("Url");
        }
        tu.closeRs(rs);
        return Url;
    }


%>