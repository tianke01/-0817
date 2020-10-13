<%@ page contentType="text/html;charset=utf-8" language="java"%>
<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				org.elasticsearch.action.index.IndexResponse,
				org.elasticsearch.action.search.SearchResponse,
				org.elasticsearch.action.update.UpdateResponse,
				org.elasticsearch.client.transport.TransportClient,
				org.elasticsearch.common.settings.Settings,
				org.elasticsearch.common.transport.InetSocketTransportAddress,
				org.elasticsearch.common.xcontent.XContentFactory,
				org.elasticsearch.common.xcontent.XContentType,
				org.elasticsearch.index.query.QueryBuilder,
				org.elasticsearch.index.query.QueryBuilders,
				org.elasticsearch.index.query.BoolQueryBuilder,
				org.elasticsearch.index.query.QueryBuilders,
				org.elasticsearch.action.search.SearchRequestBuilder,
				org.elasticsearch.search.SearchHit,
				org.elasticsearch.search.SearchHits,
				org.elasticsearch.search.sort.SortOrder,
				org.elasticsearch.transport.client.PreBuiltTransportClient,
				org.elasticsearch.action.admin.indices.exists.indices.IndicesExistsRequest,
				org.elasticsearch.action.admin.indices.exists.indices.IndicesExistsResponse,
				org.elasticsearch.action.admin.indices.mapping.put.PutMappingRequest,
				org.elasticsearch.action.bulk.BulkRequestBuilder,
				org.elasticsearch.action.bulk.BulkResponse,
				org.elasticsearch.action.index.IndexRequestBuilder,
				org.elasticsearch.common.xcontent.XContentBuilder,
				org.elasticsearch.client.Requests,
				java.io.*,
				java.sql.*,
				java.net.*,
				java.text.*,
				java.util.*,org.json.JSONArray,
				org.json.*"%>
<%@ page import="org.elasticsearch.search.aggregations.bucket.terms.TermsAggregationBuilder" %>
<%@ page import="org.elasticsearch.search.aggregations.bucket.terms.Terms" %>
<%@ page import="org.elasticsearch.search.aggregations.AggregationBuilders" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%!
    static int code_ChannelID=16511;//二维码信息频道
    static int record_ChannelID=16514;//访问记录表
%>

<%
    //活码管理接口：二维码信息全部查询接口
    //创建人:田轲
    int ChannelID=getIntParameter(request,"ChannelID");//子频道
    System.out.println("----二维码全部查询----");
    JSONObject jsonObject =new JSONObject();
    Channel channels = new Channel();
    String S_Title=getParameter(request,"Title");//二维码名称
    int page1=getIntParameter(request,"page");//当前页
    int limit=getIntParameter(request,"limit");//每页条数

    String DateNow =Util.getCurrentDate("yyyy-MM-dd HH:mm:ss");
    jsonObject.put("code",500);
    jsonObject.put("message","数据异常！");
    Channel channel= CmsCache.getChannel(code_ChannelID);//根据频道ID获取频道对象
    String tableName=channel.getTableName();
    String sql="select * from "+tableName+" where active=1 and Category="+ChannelID;

    if (!S_Title.equals("")) {
        String tempTitle = S_Title.replaceAll("%", "\\\\%");
        sql += " and Title like '%" + channels.SQLQuote(tempTitle) + "%'";
    }
    if (0 == page1)
        page1 = 1;
    if (0 == limit)
        limit = 10;
    sql+=" order by id desc,CreateDate desc";
    String countsql= sql.replace("*","count(*)");
    TableUtil tu=new TableUtil();
    ResultSet rs=tu.List(sql,countsql,page1,limit);
    //总页数
    int maxPage=tu.pagecontrol.getMaxPages();
    //总记录数
    int count=tu.pagecontrol.getRowsCount();
    jsonObject.put("maxPage",maxPage);
    jsonObject.put("count",count);
    jsonObject.put("page",page1);
    jsonObject.put("pageNumber",limit);
    ArrayList al = new ArrayList();
    while (rs.next()){
        Map map = new HashMap();
        int id = rs.getInt("id");
        int todayNum = selectESById(id, 1);
        int addNum = selectESById(id, 2);
        map.put("id",id);
        map.put("Title",rs.getString("Title"));
        map.put("CreateDate", Util.FormatTimeStamp("yyyy-MM-dd HH:mm:ss",rs.getLong("CreateDate")));
        map.put("todayNum",todayNum);
        map.put("addNum",addNum);
        map.put("permanent",rs.getInt("permanent"));
        map.put("type",rs.getInt("type"));
        map.put("QR_code_location",rs.getString("QR_code_location"));
        al.add(map);
    }
    tu.closeRs(rs);
    jsonObject.put("code",200);
    jsonObject.put("data",al);
    jsonObject.put("message","成功！");
    out.println(jsonObject.toString());
%>

<%!
    //根据二维码id查询访问记录 time=1 今天  time=2 所有
    public static int selectESById(int qr_codeId,int time) throws JSONException, SQLException, MessageException, ParseException, IOException {
        String startTime="";//开始日期
        String endTime="";//结束日期
        java.util.Date date = new java.util.Date();
        JSONObject json = new JSONObject();
        int i=0;
        if(time==1){
            startTime = getZeroDate(date, 0);
            endTime = getCurrentDate(date);
        }
        init1();
        if(client!=null){
            i = query(qr_codeId,time,startTime,endTime);
        }
        return i;
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

<%!
    public static String HOST = "";
    public static int PORT = 0;
    public static String clustername = "";
    public static TransportClient client = null;

    //初始化
    public static void init1(){
        try{
            TideJson ES_json = CmsCache.getParameter("ES_Config").getJson();
            HOST = ES_json.getString("host");
            PORT = ES_json.getInt("port");//9300;
            clustername = ES_json.getString("clustername");
            if(!HOST.equals("")){
                client = ESUtil.getClient();
            }

        }catch (Exception e) {
            System.out.println(e.getMessage());
            //关闭客户端
            client.close();
        }
    }

    //time =1  搜索今天的，time=2 搜索所有的
    public static int query(int qr_codeId,int time,String startTime,String endTime) throws IOException, ParseException,SQLException,MessageException,JSONException {
        JSONObject jsonObject = new JSONObject();
        BoolQueryBuilder boolQuery = QueryBuilders.boolQuery();
        if(time==1){
            boolQuery.must(QueryBuilders.rangeQuery("date")//时间
                    .from(startTime).to(endTime));
        }
        boolQuery.must(QueryBuilders.termQuery("qr_codeId", qr_codeId));//id
        //boolQuery.must(QueryBuilders.wildcardQuery("qr_codeId", "1"));
        //根据 任务id分组进行求和

        SearchRequestBuilder sbuilder = client.prepareSearch("qr_code_record").setTypes("document").setQuery(boolQuery);

        //SearchRequestBuilder sbuilder = client.prepareSearch("qr_code_record").setTypes("document");
        TermsAggregationBuilder termsBuilder= AggregationBuilders.terms("sum").field("qr_codeId");
        sbuilder.addAggregation(termsBuilder);
        SearchResponse responses= sbuilder.execute().actionGet();

        //得到这个分组的数据集合
        Terms terms = responses.getAggregations().get("sum");
        SearchHits hits = responses.getHits();
        SearchHit[] searhits = hits.getHits();
        for (SearchHit hit : searhits) {
            Map map = hit.getSource();

        }
        //List<BsKnowledgeInfoDTO> lists = new ArrayList<>();
        ArrayList all = new ArrayList();
        int ii=0;
        for(int i=0;i<terms.getBuckets().size();i++){
            //statistics
            String field =terms.getBuckets().get(i).getKey().toString();
            Long Page_visits =terms.getBuckets().get(i).getDocCount();//数量
            Map map = new HashMap();
            map.put("Page_visits",Page_visits);//访问次数
            map.put("qr_codeId",field);

            ii= Math.toIntExact(Page_visits);
            all.add(map);
        }
        jsonObject.put("data",all);
        return ii ;
    }




%>
