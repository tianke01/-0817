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
    //活码管理：统计模块接口-从es获取数据
    //创建人：田轲

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

    //查询 记录查询
    //types类型：1按时间段查询  2按访问来源统计  3按系统访问   4按地区统计 默认为1
    public static JSONObject query(int qr_codeId,int types,String startTime,String endTime,int currPage,int listnum,int number) throws IOException, ParseException,SQLException,MessageException,JSONException {
        JSONObject jsonObject = new JSONObject();
        BoolQueryBuilder boolQuery = QueryBuilders.boolQuery();
        boolQuery.must(QueryBuilders.rangeQuery("date")//时间
                .from(startTime).to(endTime));
        /*if(number==5){
            boolQuery.must(QueryBuilders.rangeQuery("date1")//时间
                .from(startTime).to(endTime));
        }else{
            boolQuery.must(QueryBuilders.rangeQuery("date1")//时间
                .from(startTime).to(endTime));
        }*/
        boolQuery.must(QueryBuilders.termQuery("qr_codeId", qr_codeId));//id
        //boolQuery.must(QueryBuilders.wildcardQuery("qr_codeId", "1"));
        //根据 任务id分组进行求和

        SearchRequestBuilder sbuilder = client.prepareSearch("qr_code_record_es").setTypes("document").setQuery(boolQuery);

        //SearchRequestBuilder sbuilder = client.prepareSearch("qr_code_record_es").setTypes("document");
        TermsAggregationBuilder termsBuilder;
        if(types==1){//按时间段进行分组统计
            if(number<3){
                termsBuilder = AggregationBuilders.terms("sum").field("period");
                sbuilder.addAggregation(termsBuilder);
            }else if(number==6){
                termsBuilder = AggregationBuilders.terms("sum").field("month");
                sbuilder.addAggregation(termsBuilder);
            }else{
                termsBuilder = AggregationBuilders.terms("sum").field("day");
                sbuilder.addAggregation(termsBuilder);
            }
        }else if(types==2){//按地区统计进行分组统计
            termsBuilder = AggregationBuilders.terms("sum").field("access_address");
            sbuilder.addAggregation(termsBuilder);
        }else if(types==3){//按按系统访问进行分组统计
            termsBuilder = AggregationBuilders.terms("sum").field("system_type");
            sbuilder.addAggregation(termsBuilder);
        }else if(types==4){//按访问来源进行分组统计
            termsBuilder = AggregationBuilders.terms("sum").field("access_source");
            sbuilder.addAggregation(termsBuilder);
        }
        SearchResponse responses= sbuilder.execute().actionGet();

        //得到这个分组的数据集合
        Terms terms = responses.getAggregations().get("sum");
        SearchHits hits = responses.getHits();
        SearchHit[] searhits = hits.getHits();
        for (SearchHit hit : searhits) {
            Map map = hit.getSource();
            System.out.println(map);
        }
        //List<BsKnowledgeInfoDTO> lists = new ArrayList<>();
        ArrayList all = new ArrayList();
        for(int i=0;i<terms.getBuckets().size();i++){
            //statistics
            String field =terms.getBuckets().get(i).getKey().toString();
            Long Page_visits =terms.getBuckets().get(i).getDocCount();//数量
            Map map = new HashMap();
            int ipnum=0;
            if(types==1){//按时间段进行分组统计
                if(number<3){
                    map.put("field",field);
                    ipnum=queryIpNum(qr_codeId,"period",field,startTime,endTime);
                }else if(number==6){
                    map.put("field",field+"月");
                    ipnum=queryIpNum(qr_codeId,"month",field,startTime,endTime);
                }else{
                    map.put("field",field);
                    ipnum=queryIpNum(qr_codeId,"day",field,startTime,endTime);
                }
            }else if(types==2){//按地区统计进行分组统计
                map.put("field",field);
                ipnum=queryIpNum(qr_codeId,"access_address",field,startTime,endTime);
            }else if(types==3){//按按系统访问进行分组统计
                map.put("field",field);
                ipnum=queryIpNum(qr_codeId,"system_type",field,startTime,endTime);
            }else if(types==4){//按访问来源进行分组统计
                map.put("field",field);
                ipnum=queryIpNum(qr_codeId,"access_source",field,startTime,endTime);
            }
            map.put("Visitors",ipnum);//访客量
            map.put("Page_visits",Page_visits);//访问次数
            DecimalFormat df = new DecimalFormat("0%");
            //可以设置精确几位小数
            df.setMaximumFractionDigits(0);
            double accuracy_num = ipnum * 1.0/ Page_visits * 1.0;
            map.put("percentage",df.format(accuracy_num));
            all.add(map);
        }
        jsonObject.put("data",all);
        return jsonObject ;
    }

    public static int queryIpNum(int qr_codeId,String field,String field1,String startTime,String endTime){
        int IpNum=0;
        BoolQueryBuilder boolQuery = QueryBuilders.boolQuery();
        boolQuery.must(QueryBuilders.rangeQuery("date")//时间
                .from(startTime).to(endTime));
        boolQuery.must(QueryBuilders.wildcardQuery(field, field1));
        boolQuery.must(QueryBuilders.termQuery("qr_codeId", qr_codeId));
        //boolQuery.must(QueryBuilders.wildcardQuery("qr_codeId", qr_codeId+""));
        SearchRequestBuilder sbuilder = client.prepareSearch("qr_code_record_es").setTypes("document").setQuery(boolQuery);
        TermsAggregationBuilder termsBuilder= AggregationBuilders.terms("sum").field("title");
        sbuilder.addAggregation(termsBuilder);
        SearchResponse responses= sbuilder.execute().actionGet();
        //得到这个分组的数据集合
        Terms terms = responses.getAggregations().get("sum");
        IpNum=terms.getBuckets().size();
        return IpNum;
    }


    public HashMap<String, Object> getList(int qr_codeId,int types,String startTime,String endTime,int currPage,int listnum,int number){
        HashMap<String, Object> map = new HashMap<String, Object>() ;

        try{
            JSONObject json = new JSONObject();
            init1();
            if(client!=null){
                json = query(qr_codeId,types,startTime,endTime,currPage,listnum,number);
            }
            map.put("result",json);
            map.put("code",200);
            map.put("message","成功");

        }catch(Exception e){
            map.put("code",500);
            map.put("message","程序异常");
            System.out.println(e.getMessage());
        }

        return map ;

    }

    public static String getZeroDate(java.util.Date date, int days) {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        //SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.DAY_OF_YEAR, calendar.get(Calendar.DAY_OF_YEAR) - days);
        return df.format(calendar.getTime());
    }

    public static String getCurrentDate(java.util.Date date) {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        //SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        return df.format(calendar.getTime());
    }

    //计算两个日期之间的天数
    public static int daysBetween(String smdate,String bdate) throws ParseException{
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");

        Calendar cal = Calendar.getInstance();

        cal.setTime(sdf.parse(smdate));

        long time1 = cal.getTimeInMillis();

        cal.setTime(sdf.parse(bdate));

        long time2 = cal.getTimeInMillis();

        long between_days=(time2-time1)/(1000*3600*24);

        return Integer.parseInt(String.valueOf(between_days));

    }
%>


<%
    System.out.println("es查询");
    //int qr_codeId =1;
    //int types =1;//类型：1按时间段查询  2按地区统计  3按系统访问   4按访问来源统计 默认为1
    //int number=4;//时间条件（时长） 1 今天  2 昨天  3 近7天  4 近30天  5时间段  默认为1
    String startTime="";//开始日期
    String endTime="";//结束日期
    int Page_visits=0;//页面访问次数
    int Visitors=0;//访客量
    int qr_codeId  	= getIntParameter(request,"qr_codeId");
    int types  	= getIntParameter(request,"types");
    int number = getIntParameter(request, "number");
    startTime 	= getParameter(request,"begin");
    endTime 	= getParameter(request,"end");
    int currPage  	= getIntParameter(request,"page");//页码
    int listnum  	= getIntParameter(request,"per_num");//每页显示数量
    java.util.Date date = new java.util.Date();
    switch (number) {
        case 2:
            startTime = getZeroDate(date, 1);
            endTime = getZeroDate(date, 0);
            break;
        case 3:
            startTime = getZeroDate(date, 6);
            endTime = getZeroDate(date, -1);
            break;
        case 4:
            startTime = getZeroDate(date, 29);
            endTime = getZeroDate(date, -1);
            break;
        case 5:
            break;
        default:
            startTime = getZeroDate(date, 0);
            endTime = getCurrentDate(date);
            break;
    }
    if(currPage==0){
        currPage = 1 ;
    }
    if(listnum==0){
        listnum = 10 ;
    }
%>
<%
    System.out.println(startTime+"---"+endTime+"---"+number);
    int days = daysBetween(startTime, endTime);
    if(days>30){
        number=6;
    }
    JSONObject json = new JSONObject();
    HashMap<String, Object> map = getList(qr_codeId,types,startTime,endTime,currPage,listnum,number);
    json = new JSONObject(map);
    //JSONObject result=json.getJSONObject("result");
    //JSONArray array=result.getJSONArray("list");
    //JSONArray arrayTemp=delRepeatIndexid(array);
    //json.remove("result");
    //result.put("list",arrayTemp);
    //json.put("result",result);
    out.println(json.toString());
%>










