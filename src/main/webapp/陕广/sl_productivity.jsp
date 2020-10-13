<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
                java.sql.*,
				java.net.*,
				java.text.*,
				java.util.*,org.json.JSONArray,
				org.json.*"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../config1.jsp"%>
<%
    JSONObject jsonObject =new JSONObject();
    jsonObject.put("code",500);
    jsonObject.put("message","数据异常！");
    Channel channel = new Channel();
    String S_Title="";
    String S_UserName="";
    String Release_channel="";
    int S_company=getIntParameter(request,"company");//租户
    S_Title=getParameter(request,"Title");//标题
    S_UserName=getParameter(request,"UserName");//作者
    int S_Status=getIntParameter(request,"Status");//状态 1 未审核，2 审核通过
    Release_channel=getParameter(request,"Release_channel");//发布渠道
    String S_startDate=getParameter(request,"startDate");//开始时间
    String S_endDate=getParameter(request,"endDate");//结束时间

    String whereSql="";

    if(!S_Title.equals("")){
        String tempTitle=S_Title.replaceAll("%","\\\\%");
        whereSql += " and Title like '%" + channel.SQLQuote(tempTitle) + "%'";
    }
    if(!S_UserName.equals("")){
        String tempUserName=S_UserName.replaceAll("%","\\\\%");
        whereSql += " and publisher_name like '%" + channel.SQLQuote(tempUserName) + "%'";
    }
    if(S_Status!=0){
        whereSql += " and Status=" + (S_Status-1);
    }
    if(!Release_channel.equals("")){
        String tempRelease_channel=Release_channel.replaceAll("%","\\\\%");
        whereSql += " and column_bofang like '%" + channel.SQLQuote(tempRelease_channel) + "%'";
    }
    if(!S_startDate.equals("")){
        long startTime=Util.getFromTime(S_startDate,"");
        whereSql += " and CreateDate>="+startTime ;
    }
    if(!S_endDate.equals("")){
        long endTime=Util.getFromTime(S_endDate,"");
        whereSql += " and CreateDate<"+(endTime+86400);
    }
    System.out.println("whereSql---------"+whereSql);

    if(S_company!=0){
        Productivity productivity = selectCategory(S_company);
        Productivity productivity1 = selectProductivity(productivity, whereSql);
        System.out.println(productivity1.toString());
        Map map = new HashMap();
        map.put("Company",productivity1.getCompany());
        map.put("Volume",productivity1.getVolume());
        map.put("Throughput",productivity1.getThroughput());
        map.put("Rejected",productivity1.getRejected());
        map.put("Materials",productivity1.getMaterials());
        map.put("Release_channel",productivity1.getRelease_channel());
        jsonObject.put("code",200);
        jsonObject.put("message","成功！");
        jsonObject.put("data",map);
    }else{
        ArrayList<Integer> channels = selectCompany();
        ArrayList<Integer> arrayList = removeDuplicate_1(channels);//去重，获得所有租户id
        ArrayList all = new ArrayList();
        for (int i = 0; i < arrayList.size(); i++) {
            int id=arrayList.get(i);
            Productivity productivity = selectCategory(id);
            Productivity productivity1 = selectProductivity(productivity, whereSql);
            //System.out.println(productivity1.toString());  //.get(index)
            Map map = new HashMap();
            map.put("Company",productivity1.getCompany());
            map.put("Volume",productivity1.getVolume());
            map.put("Throughput",productivity1.getThroughput());
            map.put("Rejected",productivity1.getRejected());
            map.put("Materials",productivity1.getMaterials());
            map.put("Release_channel",productivity1.getRelease_channel());
            all.add(map);
        }
        jsonObject.put("code",200);
        jsonObject.put("message","成功！");
        jsonObject.put("data",all);
    }
    out.println(jsonObject.toString());





%>

<%!
    private static int ChannelID=17738;//选题任务管理系统
    private static String ChannelCode="17736_17737_17738_";//选题任务管理系统

    //17736_17737_17738_
    //查询所有租户id
    public static ArrayList<Integer> selectCompany() throws MessageException, SQLException {
        ArrayList<Integer> arrayList=new ArrayList<>();
        String sql="select company from channel where ChannelCode like '"+ChannelCode+"%'";
        TableUtil tu=new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        while (rs.next()){
            int company=rs.getInt("company");
            arrayList.add(company);
        }
        tu.closeRs(rs);
        return arrayList;
    }

    //根据租户id 查询所有Category  Productivity
    public static Productivity selectCategory(int company) throws MessageException, SQLException {
        String sql="select * from channel where ChannelCode like '"+ChannelCode+"%' and company="+company;
        TableUtil tu=new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        String Category="";
        while (rs.next()){
            String ChannelCoders=rs.getString("ChannelCode");
            Category+="'"+ChannelCoders.substring(ChannelCoders.length()-6,ChannelCoders.length())+"',";
        }
        tu.closeRs(rs);
        Category=Category.substring(0,Category.length()-1).replaceAll("[_]","");
        Productivity productivity = new Productivity();
        productivity.setCompany(company);
        productivity.setCategory(Category);
        return productivity;
    }

    //根据频道id查询该频道下文章的发稿量、通过量、驳回量、素材量、发布渠道
    public static Productivity selectProductivity(Productivity productivity,String whereSql) throws MessageException, SQLException {
        productivity.setVolume(selectNum(productivity,1,whereSql));
        productivity.setThroughput(selectNum(productivity,2,whereSql));
        productivity.setRejected(selectNum(productivity,3,whereSql));
        Productivity productivity1 = selectRelease_channel(productivity, whereSql);
        return productivity1;
    }


    //统计数量
    public static int selectNum(Productivity productivity,int type,String whereSql) throws MessageException, SQLException {
        int num=0;
        String tableName= CmsCache.getChannel(ChannelID).getTableName();
        String sql="select count(*) from "+tableName+" where category in ("+productivity.getCategory()+")"+whereSql;
        if(type==1){//查询发稿量
            sql=sql;
        }else if(type==2){//查询通过量
            sql=sql+" and task_status in (1,3)";
        }else if(type==3){//查询驳回量
            sql=sql+" and task_status = 2";
        }
        TableUtil tu=new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        while (rs.next()){
            num=rs.getInt(1);
        }
        tu.closeRs(rs);
        return num;
    }

    //统计发布渠道
    public static Productivity selectRelease_channel(Productivity productivity,String whereSql) throws MessageException, SQLException {
        String tableName= CmsCache.getChannel(ChannelID).getTableName();
        String column_bofang="";
        String sql="select column_bofang from "+tableName+" where category in ("+productivity.getCategory()+")"+whereSql+" group by column_bofang";
        TableUtil tu=new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        while (rs.next()){
            column_bofang=rs.getString("column_bofang");
            if(column_bofang!=null){
                column_bofang+=",";
            }
        }
        tu.closeRs(rs);
        if(column_bofang!=null&&column_bofang.length()>1){
            productivity.setRelease_channel(column_bofang.substring(0,column_bofang.length()-1));
        }
        return productivity;
    }


    public static ArrayList<Integer> removeDuplicate_1(ArrayList<Integer> list){
        for(int i =0;i<list.size()-1;i++){
            for(int j=list.size()-1;j>i;j--){
                if(list.get(i).equals(list.get(j)))
                    list.remove(j);
            }
        }
        return list;
    }

    public static class Productivity{
        int company=0;//租户
        String Category="";//频道id
        int Volume=0;//发稿量
        int Throughput=0;//通过量
        int Rejected=0;//驳回量
        int materials=0;//素材量
        String Release_channel="";//发布渠道
        public String getCategory() {
            return Category;
        }

        public void setCategory(String category) {
            Category = category;
        }

        public int getCompany() {
            return company;
        }

        public void setCompany(int company) {
            this.company = company;
        }

        public int getVolume() {
            return Volume;
        }

        public void setVolume(int volume) {
            Volume = volume;
        }

        public int getThroughput() {
            return Throughput;
        }

        public void setThroughput(int throughput) {
            Throughput = throughput;
        }

        public int getRejected() {
            return Rejected;
        }

        public void setRejected(int rejected) {
            Rejected = rejected;
        }

        public int getMaterials() {
            return materials;
        }

        public void setMaterials(int materials) {
            this.materials = materials;
        }

        public String getRelease_channel() {
            return Release_channel;
        }

        public void setRelease_channel(String release_channel) {
            Release_channel = release_channel;
        }


    }
%>
