<%@ page import="tidemedia.cms.system.*,
                java.util.*,tidemedia.cms.util.*,
                java.sql.*,tidemedia.cms.base.*,
                tidemedia.cms.scheduler.*,
                tidemedia.cms.publish.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
    public String reviewBaoliao(int doc_id,int ChannelID,int type,int userId) throws Exception{
        String message = "";
        try{/* HashMap map_doc = new HashMap();
        tidemedia.cms.system.Document document = new tidemedia.cms.system.Document();
        document.setRelatedItemsList(RelatedItemsList);
        document.setChannelID(ChannelID);
        document.setUser(userinfo_session.getId());
        document.setModifiedUser(userinfo_session.getId());
        map_doc.put("baoliaostatus",type+"");//状态
        return document.UpdateDocument(map_doc);;*/
            //改变爆料状态
            HashMap map_doc = new HashMap();
            map_doc.put("returnStatus",type+"");//状态
            ItemUtil.updateItemById(ChannelID, map_doc, doc_id, userId);
            //频道发布
            int		IncludeSubChannel	= 0;
            int		PublishAllItems		= 0;
            PublishManager publishmanager = PublishManager.getInstance();
            publishmanager.ChannelPublish(ChannelID,IncludeSubChannel,userId,PublishAllItems);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "处理成功";
    }


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

    //根据ChannelID选择文章属性 音视频 图集 稿件 直播
    public void addByChannelIDAndDoc_id(int doc_id,int ChannelID) throws SQLException, MessageException {
        TideJson Shared_Library = CmsCache.getParameter("Shared_Library").getJson();
        int shared_library = Shared_Library.getInt("shared_library");//共享库频道ID
        int shared_library_a = Shared_Library.getInt("shared_library_a");//音视频库频道ID
        int shared_library_b = Shared_Library.getInt("shared_library_b");//图集库频道ID
        int shared_library_c = Shared_Library.getInt("shared_library_c");//稿件库频道ID
        int shared_library_d = Shared_Library.getInt("shared_library_d");//直播库频道ID
        if(ChannelID==16267){//图文和稿件
            HashMap<String,String> map = getDraft(doc_id, ChannelID);
            ItemUtil.addItemGetGlobalID(shared_library_b, map);//加入到图集库
            ItemUtil.addItemGetGlobalID(shared_library_c, map);//加入到稿件库
        }else if(ChannelID==16268){//直播
            HashMap<String,String> map = getDraft(doc_id, ChannelID);
            ItemUtil.addItemGetGlobalID(shared_library_d, map);//加入到直播库
        }else if(ChannelID==16566){//音视频
            HashMap<String,String> map = getDraft(doc_id, ChannelID);
            ItemUtil.addItemGetGlobalID(shared_library_a, map);//加入到音视频库
        }
    }


%>

<%

    try{
        Integer ChannelID = getIntParameter(request,"ChannelID");
        Integer doc_id = getIntParameter(request,"doc_id");
        Integer userId = userinfo_session.getId();
        Integer type = getIntParameter(request,"type");
        addByChannelIDAndDoc_id(doc_id,ChannelID);
        out.println(reviewBaoliao(doc_id,ChannelID,type,userId));
    }catch(Exception e){
        System.out.println(e.getMessage());
        out.println("保存没有成功，请重新尝试。");
    }
%>
