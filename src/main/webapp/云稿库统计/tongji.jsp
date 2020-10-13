<%@ page import="tidemedia.cms.base.*" %>
<%@ page import="tidemedia.cms.util.*" %>
<%@ page import="tidemedia.cms.system.*" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.JSONObject" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../config1.jsp"%>
<%


    //在系统参数中获取所需频道id
    TideJson TJ_Channel = CmsCache.getParameter("TJ_Channel").getJson();
    int private_library = TJ_Channel.getInt("private_library");//私有库频道ID
    int private_library_SC = TJ_Channel.getInt("private_library_SC");//素材库频道ID
    int private_library_CP = TJ_Channel.getInt("private_library_CP");//成品库频道ID
    int private_library_CJ = TJ_Channel.getInt("private_library_CJ");//采集库频道ID
    int shared_library = TJ_Channel.getInt("shared_library");//共享库频道ID
    int download_record = TJ_Channel.getInt("download_record");//下载记录频道ID

    System.out.println("----内容采用统计----");
    JSONObject jsonObject =new JSONObject();
    int number=getIntParameter(request,"number");//查询时间  1：周 2：月  3：年
    if(number==0){
        jsonObject.put("code",500);
        jsonObject.put("message","number值不能为空");
    }else{
        try{
            int UserNum = selectUserNum();//当前用户数量
            int SYNum = selectSYNum(private_library);//私有库数量
            int CPNum=selectPLNum(private_library_CP);//成品库数量
            int CJNum=selectPLNum(private_library_CJ);//第三方采集数量
            int GXNum=selectGXNum(shared_library);//共享库已发数量
            int CPDownloadNum=selecDownloadNum(download_record,private_library,private_library_CP,"","");//成品库下载次数
            int CJDownloadNum=selecDownloadNum(download_record,private_library,private_library_CJ,"","");//第三方采集下载次数
            ArrayList al = selectMonthCPDownloadNum(number,download_record,private_library,private_library_CP);//统计当前日期前一个月内每天的成品库下载次数
            jsonObject.put("code",200);
            jsonObject.put("UserNum",UserNum);
            jsonObject.put("SYNum",SYNum);
            jsonObject.put("CPNum",CPNum);
            jsonObject.put("CJNum",CJNum);
            jsonObject.put("GXNum",GXNum);
            jsonObject.put("CPDownloadNum",CPDownloadNum);
            jsonObject.put("CJDownloadNum",CJDownloadNum);
            jsonObject.put("MonthCPDownloadNum",al);
        }catch (Exception e){
            jsonObject.put("code",500);
            jsonObject.put("message","数据异常:"+e.toString());
        }
    }
    out.println(jsonObject.toString());


%>

<%!

    /**
     * 当前用户数量
     * @return
     * @throws MessageException
     * @throws SQLException
     */
    public static int selectUserNum() throws MessageException, SQLException {
        int UserNum=0;
        String sql="select count(*) as sum from userinfo ";
        TableUtil tu = new TableUtil("user");
        ResultSet rs = tu.executeQuery(sql);
        while (rs.next()){
            UserNum= rs.getInt("sum");
        }
        tu.closeRs(rs);
        return UserNum;
    }


    /**
     * 私有库数量
     * @param ChannelID 私有库频道id
     * @return
     * @throws MessageException
     * @throws SQLException
     */
    public static int selectSYNum(int ChannelID) throws MessageException, SQLException {
        int SYNum=0;
        Channel channel= CmsCache.getChannel(ChannelID);//根据频道ID获取频道对象
        String tableName=channel.getTableName();
        String sql="select count(*) as sum from "+tableName+" where active=1 and Category!=0";
        TableUtil tu=new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        while (rs.next()){
            SYNum=rs.getInt("sum");
        }
        tu.closeRs(rs);
        return SYNum;
    }


    /**
     * 私有库子频道-成品库数量-第三方采集数量
     * @param ChannelID 频道分类ID
     * @return
     * @throws MessageException
     * @throws SQLException
     */
    public static int selectPLNum(int ChannelID) throws MessageException, SQLException {
        int PLNum=0;
        Channel channel= CmsCache.getChannel(ChannelID);//根据频道ID获取频道对象
        String tableName=channel.getTableName();
        String sql="select count(*) as sum from "+tableName+" where active=1 and Category="+ChannelID;
        TableUtil tu=new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        while (rs.next()){
            PLNum=rs.getInt("sum");
        }
        tu.closeRs(rs);
        return PLNum;
    }


    /**
     * 共享库已发布数量
     * @param ChannelID 共享库频道id
     * @return
     * @throws MessageException
     * @throws SQLException
     */
    public static int selectGXNum(int ChannelID) throws MessageException, SQLException {
        int GXNum=0;
        Channel channel= CmsCache.getChannel(ChannelID);//根据频道ID获取频道对象
        String tableName=channel.getTableName();
        String sql="select count(*) as sum from "+tableName+"";
        TableUtil tu=new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        while (rs.next()){
            GXNum=rs.getInt("sum");
        }
        tu.closeRs(rs);
        return GXNum;
    }

    /**
     *
     * @param ChannelID 下载记录频道id
     * @param ChannelID2 共享库频道id
     * @param CategoryID 成品库分类id
     * @param S_StartDate 开始日期
     * @param S_EndDate 结束日期
     * @return
     * @throws MessageException
     * @throws SQLException
     */
    public static int selecDownloadNum(int ChannelID,int ChannelID2,int CategoryID,String S_StartDate,String S_EndDate) throws MessageException, SQLException {
        int DownloadNum=0;
        Channel channel= CmsCache.getChannel(ChannelID);//根据频道ID获取频道对象
        String tableName=channel.getTableName();
        String sql="select count(*) as sum,Title from "+tableName+" where active=1 and Doc_channelID="+ChannelID2+" and Dod_categoryID="+CategoryID;
        if (!S_StartDate.equals("")) {
            long startTime = Util.getFromTime(S_StartDate, "");
            sql += " and CreateDate>=" + startTime;
        }
        if (!S_EndDate.equals("")) {
            long endTime = Util.getFromTime(S_EndDate, "");
            sql += " and CreateDate<" + (endTime + 86400);
        }
        TableUtil tu=new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        while (rs.next()){
            DownloadNum=rs.getInt("sum");

        }
        tu.closeRs(rs);
        return DownloadNum;
    }


    /**
     * 统计当前日期前一个月内每天的成品库下载次数
     * @param number 查询时间  1：周 2：月  3：年
     * @param ChannelID 下载记录频道id
     * @param ChannelID2 共享库频道id
     * @param CategoryID 成品库分类id
     * @return
     * @throws MessageException
     * @throws SQLException
     */
    public static ArrayList selectMonthCPDownloadNum(int number,int ChannelID,int ChannelID2,int CategoryID) throws MessageException, SQLException {
        ArrayList all = new ArrayList();
        if(number==1){
            for(int i=6;i>=0;i--){
                Map map=new HashMap();
                java.util.Date date = new java.util.Date();
                String startTime = getZeroDate(date, i);
                String endTime = getZeroDate(date, i);
                int CPDownloadNum = selecDownloadNum(ChannelID, ChannelID2, CategoryID, startTime,endTime);
                map.put("day",startTime);
                map.put("CPDownloadNum",CPDownloadNum);
                all.add(map);
            }
        }else if(number==2){
            for(int i=29;i>=0;i--){
                Map map=new HashMap();
                java.util.Date date = new java.util.Date();
                String startTime = getZeroDate(date, i);
                String endTime = getZeroDate(date, i);
                int CPDownloadNum = selecDownloadNum(ChannelID, ChannelID2, CategoryID, startTime,endTime);
                map.put("day",startTime);
                map.put("CPDownloadNum",CPDownloadNum);
                all.add(map);
            }
        }else if(number==3){
            for(int i=11;i>=0;i--) {
                Map map=new HashMap();
                String startTime = getTime(i+1);
                String endTime = getTime(i);
                int CPDownloadNum = selecDownloadNum(ChannelID, ChannelID2, CategoryID, startTime,endTime);
                map.put("day",startTime.substring(0,7));
                map.put("CPDownloadNum",CPDownloadNum);
                all.add(map);
            }
        }
        return all;
    }

    public static String getTime(int i){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date date = new java.util.Date();
        Calendar cal = Calendar.getInstance();
        int day = cal.get(Calendar.DATE);
        cal.setTime(date);
        cal.add(Calendar.MONTH, -(i-1));
        cal.add(Calendar.DATE,-day+1);
        return sdf.format( cal.getTime());
    }

    public static String getZeroDate(java.util.Date date, int days) {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.DAY_OF_YEAR, calendar.get(Calendar.DAY_OF_YEAR) - days);
        return df.format(calendar.getTime());
    }

    public static String getCurrentDate(java.util.Date date) {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        return df.format(calendar.getTime());
    }
%>
