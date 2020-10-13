<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
                java.sql.*,
				java.net.*,
				java.text.*,
				java.util.*,org.json.JSONArray,
				org.json.*"%>
<%@ page import="tidemedia.cms.user.UserInfo" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../config1.jsp"%>
<%
    System.out.println("查询代办数据-------------------------------------");
    response.setHeader("Pragma","No-cache");
    response.setHeader("Cache-Control","no-cache");
    response.setDateHeader("Expires", 0);
    request.setCharacterEncoding("utf-8");

    JSONObject jsonObject =new JSONObject();
    jsonObject.put("code",1);
    jsonObject.put("message","error");
    TideJson zr_sso = CmsCache.getParameter("zr_sso").getJson();
    String oauthUrl = zr_sso.getString("oauthUrl");
    String S_Title=getParameter(request,"taskName");//任务名称
    String S_startDate=getParameter(request,"startTime");//任务发起时间 2020-09-10
    int page1=getIntParameter(request,"page");//当前页
    int limit=getIntParameter(request,"limit");//每页条数
    String token = request.getParameter("access_token");//access_token
    UserInfo userInfo = new UserInfo();
    if (!"".equals(token)){
        String user_name = check_token(token,oauthUrl);
        userInfo = getUser(user_name);
        if (userInfo.getId() != 0){
            session.setAttribute("CMSUserInfo",userInfo);
        }
    }
    //ApproveItemId 审核环节编号
    //UserId UserId
    // status Action
    //        if (status == 0) {
    //            sql += " and Action > -1";
    //            sql1 += " and Action > -1";
    //        } else {
    //            sql += " and Action = " + (status - 1);
    //            sql1 += " and Action = " + (status - 1);
    //        }
    //request request
    //application 审核类型  频道application
    //pagenum 第几页
    //pagesize 条数
    //S_Title 标题
    //S_startDate 开始时间
    //S_endDate 结束时间
    //public JSONObject getMyApprove(String approveItemIds, int UserId, int status, HttpServletRequest request, String application, int pagenum, int pagesize, String S_Title, String S_startDate, String S_endDate)

    //ApproveDocument approveDocument = new ApproveDocument();
    //out.println(userInfo.getUsername()+"-"+userInfo.getId()+"-------</br>");
    Map map = new HashMap();
    String DateNow =Util.getCurrentDate("yyyy-MM-dd HH:mm:ss");
    Map map1 = getMyApprove(map,"", userInfo.getId(), 1, request, "", page1, limit, S_Title, S_startDate, DateNow);
    if(!map.isEmpty()){
        jsonObject.put("data",map1);
        jsonObject.put("code",0);
        jsonObject.put("message","success");
    }
    out.println(jsonObject.toString());
%>

<%!

    /**
     *
     */
    public Map getMyApprove(Map map,String approveItemIds, int UserId, int status, HttpServletRequest request, String application, int pagenum, int pagesize, String S_Title, String S_startDate, String S_endDate) throws MessageException, SQLException, JSONException {
        Channel channels = new Channel();
        if (pagenum < 1)
            pagenum = 1;
        if (pagesize <= 0)
            pagesize = 20;
        int beginNum = (pagenum - 1) * pagesize;
        String sql = "select max(id) id from approve_document where 1 = 1";
        String sql1 = "select count(DISTINCT GlobalID) sum from approve_document where 1 = 1";
        if (UserId != 0) {
            sql += " and UserId = " + UserId;
            sql1 += " and UserId = " + UserId;
        }
        if (status == 0) {
            sql += " and Action > -1";
            sql1 += " and Action > -1";
        } else {
            sql += " and Action = " + (status - 1);
            sql1 += " and Action = " + (status - 1);
        }
        if (application.length() > 0) {
            sql += " and application = '" + application + "'";
            sql1 += " and application = '" + application + "'";
        }
        if (approveItemIds.length() > 0) {
            approveItemIds = "(" + approveItemIds + ")";
            sql += " and ApproveItemId in " + approveItemIds;
            sql1 += " and ApproveItemId in " + approveItemIds;
        }
        if (!S_Title.equals("")) {
            String tempTitle = S_Title.replaceAll("%", "\\\\%");
            sql += " and Title like '%" + channels.SQLQuote(tempTitle) + "%'";
            sql1 += " and Title like '%" + channels.SQLQuote(tempTitle) + "%'";
        }
        if (!S_startDate.equals("") && !S_endDate.equals("")) {
            sql += " and CreateDate between '" + S_startDate + "' and '" + S_endDate + "'";
            sql1 += " and CreateDate between '" + S_startDate + "' and '" + S_endDate + "'";
        }
        sql += " group by GlobalID order by id desc";
        if (pagenum != 0 && pagesize != 0) {
            sql += " limit " + beginNum + "," + pagesize;
        }
        TableUtil tu = new TableUtil();//建立JDBC对象
        ResultSet rs = tu.executeQuery(sql);
        ResultSet rs1 = tu.executeQuery(sql1);
        int totalNumber = 0;
        while(rs1.next()){
            totalNumber = rs1.getInt("sum");
        }
        rs1.close();
        List<Integer> list = new ArrayList<>();
        while(rs.next()){
            int id = rs.getInt("id");
            list.add(id);
        }
        ArrayList al = new ArrayList();
        for (int i = 0; i < list.size(); i++) {
            Integer id =  list.get(i);
            ApproveDocument2 approveDocument2 = selectGlobalID(id);
            int globalID = approveDocument2.getGlobalID();


            Document document = CmsCache.getDocument(globalID);
            int ItemID = document.getId();
            int ChannelID = document.getChannelID();
            String ApproveItemName = approveDocument2.getApproveItemName();
            String Title = document.getTitle();
            int Action1 = approveDocument2.getAction();
            String approveStatus = "";
            if (Action1 == 0) {
                approveStatus = "<span class='tx-orange'>" + ApproveItemName + "待审核<span>";
            } else if (Action1 == 1) {
                approveStatus = "<span class='tx-success'>" + ApproveItemName + "通过</span>";
            } else {
                approveStatus = "<span class='tx-danger'>" + ApproveItemName + "驳回<span>";
            }
            int category = document.getCategoryID();
            int active = document.getActive();
            //过滤已删除数据
            if (active != 1) {
                totalNumber--;
                continue;
            }
            String CreateDate = document.getCreateDate();
            String UserName = document.getUserName();
            int User=document.getUser();
            int Status = document.getStatus();
            String documentStatus = "";
            if (Status == 0) {
                documentStatus = "<span class='tx-orange'>草稿</span>";
            } else {
                documentStatus = "<span class='tx-success'>已发</span>";
            }
            Channel channel = CmsCache.getChannel(ChannelID);
            String channelName = channel.getName();
            String parentChannelPath = channel.getParentChannelPath().replaceAll("/", ">");
            String path = "http://124.47.27.2/tcenter" + "/content/document.jsp?ItemID=" + ItemID + "&ChannelID=" + ChannelID;
            Map map1 = new HashMap();
            /*map1.put("title", Title);
            map1.put("GlobalID", globalID);
            map1.put("id", ItemID);
            map1.put("ChannelID", ChannelID);
            map1.put("ApproveItemName", ApproveItemName);
            map1.put("Action1", Action1);
            map1.put("date", CreateDate);
            map1.put("documentStatus", documentStatus);
            map1.put("StatusDesc", approveStatus);
            map1.put("channelPath", parentChannelPath);
            map1.put("channelName", channelName);
            map1.put("path", path);
            map1.put("category", category);
            map1.put("user", UserName);
            map1.put("type", 2);*/

            //流程中心任务生产需要的数据operateUrl
            map1.put("taskId", globalID);//任务id
            map1.put("taskName", Title);//任务名称
            map1.put("sponsorId", User);//发起人id
            map1.put("sponsorName", UserName);//发起人名称
            map1.put("sponsorTime", CreateDate);//任务发起时间
            map1.put("operateUrl", path);//立即处理url  application1
            //String application1 = approveDocument2.getApplication();
            String application1 =document.getValue("application");
            map1.put("application1", application1);
            al.add(map1);
        }
        tu.closeRs(rs);

        int totalPageNumber = 0;
        if (totalNumber <= pagesize) {
            totalPageNumber = 1;
        }else{
            totalPageNumber = totalNumber / pagesize;
            if (totalNumber % pagesize > 0) {
                totalPageNumber++;
            }
        }
        map.put("list", al);
        map.put("sum", totalNumber);//总条数
        map.put("pageNum", totalPageNumber);//多少页
        return map;
    }

    //根据id查询GlobalID
    public ApproveDocument2 selectGlobalID(int id) throws SQLException, MessageException {
        String Sql = "select * from approve_document where id=" + id;
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(Sql);
        ApproveDocument2 approveDocument2=new ApproveDocument2();
        if (rs.next()){
            approveDocument2.setGlobalID(rs.getInt("GlobalID"));
            approveDocument2.setApproveItemName(rs.getString("ApproveItemName"));
            approveDocument2.setAction(rs.getInt("Action"));
            approveDocument2.setApplication(rs.getString("application"));
        }
        tu.closeRs(rs);
        return approveDocument2;
    }

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

    public static class ApproveDocument2{
        private int id;
        private int UserId;
        private String UserName;
        private String Title = "";//审核文章名称judge
        private int GlobalID;//审核文章编号globalid
        private int ItemID;//稿件ID
        private int ChannelID;//频道ID
        private int ApproveItemId;//审核环节编号
        private String ApproveItemName = "";//审核环节名称
        private int Action;//审核动作-1不需要操作0等待操作1执行了通2执行了驳回
        private String CreateDate = "";//提交审核时间
        private String ActionDate = "";//审核操作时间
        private String ActionMessage = "";//审核驳回理由
        private int EndApprove;//是否是终审
        private String application;//审核类型  频道application

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public int getUserId() {
            return UserId;
        }

        public void setUserId(int userId) {
            UserId = userId;
        }

        public String getUserName() {
            return UserName;
        }

        public void setUserName(String userName) {
            UserName = userName;
        }

        public String getTitle() {
            return Title;
        }

        public void setTitle(String title) {
            Title = title;
        }

        public int getGlobalID() {
            return GlobalID;
        }

        public void setGlobalID(int globalID) {
            GlobalID = globalID;
        }

        public int getItemID() {
            return ItemID;
        }

        public void setItemID(int itemID) {
            ItemID = itemID;
        }

        public int getChannelID() {
            return ChannelID;
        }

        public void setChannelID(int channelID) {
            ChannelID = channelID;
        }

        public int getApproveItemId() {
            return ApproveItemId;
        }

        public void setApproveItemId(int approveItemId) {
            ApproveItemId = approveItemId;
        }

        public String getApproveItemName() {
            return ApproveItemName;
        }

        public void setApproveItemName(String approveItemName) {
            ApproveItemName = approveItemName;
        }

        public int getAction() {
            return Action;
        }

        public void setAction(int action) {
            Action = action;
        }

        public String getCreateDate() {
            return CreateDate;
        }

        public void setCreateDate(String createDate) {
            CreateDate = createDate;
        }

        public String getActionDate() {
            return ActionDate;
        }

        public void setActionDate(String actionDate) {
            ActionDate = actionDate;
        }

        public String getActionMessage() {
            return ActionMessage;
        }

        public void setActionMessage(String actionMessage) {
            ActionMessage = actionMessage;
        }

        public int getEndApprove() {
            return EndApprove;
        }

        public void setEndApprove(int endApprove) {
            EndApprove = endApprove;
        }

        public String getApplication() {
            return application;
        }

        public void setApplication(String application) {
            this.application = application;
        }
    }
%>
