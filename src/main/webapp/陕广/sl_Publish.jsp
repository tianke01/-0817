<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONException" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%
    System.out.println("查询已办数据-------------------------------------");
    response.setHeader("Pragma","No-cache");
    response.setHeader("Cache-Control","no-cache");
    response.setDateHeader("Expires", 0);
    request.setCharacterEncoding("utf-8");
    JSONObject jsonObject =new JSONObject();

    TideJson zr_sso = CmsCache.getParameter("zr_sso").getJson();
    String oauthUrl = zr_sso.getString("oauthUrl");
    String S_Title=getParameter(request,"taskName");//任务名称
    String S_startDate=getParameter(request,"startTime");//任务发起时间 2020-09-10
    String S_endTime=getParameter(request,"endTime");//任务结束时间 2020-09-10
    int page1=getIntParameter(request,"page");//当前页
    int limit=getIntParameter(request,"limit");//每页条数
    String token = request.getParameter("access_token");//access_token
    if(page1==0){
        page1=1;
    }
    if(limit==0){
        limit=10;
    }
    UserInfo userInfo = new UserInfo();
    if (!"".equals(token)){
        String user_name = check_token(token,oauthUrl);
        userInfo = getUser(user_name);
        if (userInfo.getId() != 0){
            session.setAttribute("CMSUserInfo",userInfo);
        }
    }
    try{
        int company = userInfo.getCompany();
        String SerialNo = selectSerialNo(company);
        int FatherChannelId = selectChannelId(SerialNo);
        int SonChannelId = selectNRChannelId(FatherChannelId);
        jsonObject = selectDocumentByUserId(jsonObject,SonChannelId, userInfo.getId(), S_Title, S_startDate, S_endTime, page1, limit);
        jsonObject.put("code",0);
        jsonObject.put("message","success");
    }catch (Exception e){
        jsonObject.put("code",1);
        jsonObject.put("error","success");
        jsonObject.put("errorMessage","该用户办结列表查询失败"+e.toString());
    }
    out.println(jsonObject);
%>

<%!
    /**
     * 检验token
     * @param token
     * @param oauthUrl
     * @return
     */
    public String check_token(String token,String oauthUrl){
        String s = Util.connectHttpUrl(oauthUrl+"oauth/check_token?token="+token);
        System.out.println(oauthUrl+"oauth/check_token?token="+token);
        try {
            JSONObject object = new JSONObject(s);
            String user_name = object.getString("user_name");
            return user_name;
        }catch (Exception e){
            e.printStackTrace();
            return "";
        }
    }

    /**
     * 根据用户登录名获取用户对象
     * @param user_name
     * @return
     */
    public UserInfo getUser(String user_name){
        UserInfo user = null;
        try {
            TableUtil tu = new TableUtil("user");
            String sql = "select * from userinfo where Username='"+tu.SQLQuote(user_name)+"'";
            ResultSet rs = tu.executeQuery(sql);
            int id = 0;
            if (rs.next()){
                id = rs.getInt("id");
            }
            tu.closeRs(rs);
            user = CmsCache.getUser(id);
        }catch (Exception e){
            e.printStackTrace();
        }
        return user;
    }

    //根据租户id 查询站点id 拼接站点名称
    public String selectSerialNo(int company) throws MessageException, SQLException {
        TableUtil tu = new TableUtil();
        String sql="select * from site where company="+company;
        ResultSet rs = tu.executeQuery(sql);
        int Siteid=0;
        while (rs.next()){
            Siteid= rs.getInt("id");
            String Name = rs.getString("Name");
        }
        tu.closeRs(rs);
        String SerialNo="s"+Siteid;
        return SerialNo;
    }

    //根据站点名称 查询该站点对应的频道id
    public int selectChannelId(String SerialNo) throws MessageException, SQLException {
        TableUtil tu = new TableUtil();
        String sql="select *  from channel where SerialNo='"+SerialNo+"'";
        ResultSet rs = tu.executeQuery(sql);
        int channelId=0;
        while (rs.next()){
            channelId= rs.getInt("id");
        }
        tu.closeRs(rs);
        return channelId;
    }

    //查询内容中心的频道id
    public int selectNRChannelId(int ChannelId) throws SQLException, MessageException {
        TableUtil tu = new TableUtil();
        int channelId=0;
        String sql="select *  from channel where Name='内容中心' and ChannelCode like '"+ChannelId+"%'";
        ResultSet rs = tu.executeQuery(sql);
        while (rs.next()){
            channelId= rs.getInt("id");
        }
        tu.closeRs(rs);
        return channelId;
    }

    public JSONObject selectDocumentByUserId(JSONObject jsonObject,int ChannelId,int userId,String S_Title,String S_StartDate,String S_EndDate,int page1,int limit) throws MessageException, SQLException, JSONException {
        Channel channel= CmsCache.getChannel(ChannelId);//根据频道ID获取频道对象
        Channel channels = new Channel();
        String tableName= channel.getTableName();
        String sql="select * from "+tableName+" where active=1 and  Status=1";
        if (userId!=0) {
            sql += " and User="+userId ;
        }
        if (!S_Title.equals("")) {
            String tempTitle = S_Title.replaceAll("%", "\\\\%");
            sql += " and Title like '%" + channels.SQLQuote(tempTitle) + "%'";
        }
        if (!S_StartDate.equals("")) {
            long startTime = Util.getFromTime(S_StartDate, "");
            sql += " and CreateDate>=" + startTime;
        }
        if (!S_EndDate.equals("")) {
            long endTime = Util.getFromTime(S_EndDate, "");
            sql += " and CreateDate<" + (endTime + 86400);
        }
        sql+=" order by id desc";
        String countsql= sql.replace("*","count(*)");
        TableUtil tu = new TableUtil();
        ResultSet rs=tu.List(sql,countsql,page1,limit);
        //总页数
        int maxPage=tu.pagecontrol.getMaxPages();
        //总记录数
        int count=tu.pagecontrol.getRowsCount();
        //jsonObject.put("maxPage",maxPage);
        jsonObject.put("sum",count);
        //jsonObject.put("page",page1);
        //jsonObject.put("pageNumber",limit);
        ArrayList al = new ArrayList();
        while (rs.next()){
            Map map = new HashMap();
            int GlobalID= rs.getInt("GlobalID");
            Document document = CmsCache.getDocument(GlobalID);
            int ItemID = document.getId();
            int ChannelID = document.getChannelID();
            String CreateDate = document.getCreateDate();
            String UserName = document.getUserName();
            String Title = document.getTitle();
            String path = "https://zycftcenter.gdwlcloud.com/cms" + "/content/document.jsp?ItemID=" + ItemID + "&ChannelID=" + ChannelID;
            map.put("taskId", GlobalID);//任务id
            map.put("taskName", Title);//任务名称
            map.put("sponsorId", userId);//发起人id
            map.put("sponsorName", UserName);//发起人名称
            map.put("sponsorTime", CreateDate);//任务发起时间
            map.put("operateUrl", path);//立即处理url  application1
            //String application1 = approveDocument2.getApplication();
            String S_taskType =document.getValue("application");
            map.put("S_taskType", S_taskType);
            al.add(map);
        }
        tu.closeRs(rs);
        jsonObject.put("data",al);
        return jsonObject;
    }

%>


