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
				org.elasticsearch.search.SearchHit,
				org.elasticsearch.search.SearchHits,
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
				java.util.*,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<!--
作用：二维码访问记录入ES
-->
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
/*
				//创建客户端
				Map<String, String> map = new HashMap();
				map.put("cluster.name", clustername);
				Settings.Builder settings = Settings.builder().put(map);
				client = new PreBuiltTransportClient(settings.build()).addTransportAddresses(
						new InetSocketTransportAddress(InetAddress.getByName(HOST),PORT));
*/
            }
        }catch (Exception e) {
            System.out.println(e.getMessage());
            //关闭客户端
            client.close();
        }
    }
    //入库
    public static void addES(int globalid) throws IOException, ParseException,SQLException,MessageException {
        if (!indexExists("qr_code_record")) {//索引不存在，先创建索引
            createIndex("qr_code_record","document");
        }

        Document doc = new Document(globalid);
        System.out.println("doc.getStatus()"+doc.getStatus());
        if(doc!=null){
            IndexResponse response = client.prepareIndex("qr_code_record", "document", globalid+"")
                    .setSource(XContentFactory.jsonBuilder().startObject()
                            .field("id", globalid)
                            .field("channelid", doc.getChannelID())
                            .field("title", doc.getTitle())
                            .field("access_address", Util.convertNull(doc.getValue("access_address")))
                            .field("access_source", Util.convertNull(doc.getValue("access_source")))
                            .field("system_type", Util.convertNull(doc.getValue("system_type")))
                            .field("period", Util.convertNull(doc.getValue("period")))
                            .field("qr_codeId", doc.getIntValue("qr_codeId"))
                            .field("date", Util.convertNull(doc.getCreateDate().substring(0,10)))
                            .endObject()).get();
            System.out.println("入库成功！");
        }else{
            client.prepareDelete("qr_code_record", "document", globalid+"").get();//撤稿或删除
            System.out.println("入库失败！");
        }



    }

    //判断索引是否存在
    public static boolean indexExists(String index){
        IndicesExistsRequest request = new IndicesExistsRequest(index);
        IndicesExistsResponse response = client.admin().indices().exists(request).actionGet();
        if (response.isExists()) {
            return true;
        }
        return false;
    }

    //创建索引
    public static void createIndex(String index , String type ) throws IOException {
        XContentBuilder mapping = XContentFactory.jsonBuilder()
                .startObject()
                .startObject("properties")
                .startObject("id").field("type","integer").endObject()
                .startObject("channelid").field("type","integer").endObject()
                .startObject("title").field("type","string").field("index","not_analyzed").endObject()
                .startObject("access_address").field("type","string").field("index","not_analyzed").endObject()
                .startObject("access_source").field("type","string").field("index","not_analyzed").endObject()
                .startObject("system_type").field("type","string").field("index","not_analyzed").endObject()
                .startObject("period").field("type","string").field("index","not_analyzed").endObject()
                .startObject("qr_codeId").field("type","integer").endObject()
                .startObject("date").field("type","string").field("index","not_analyzed").endObject()
                .endObject()
                .endObject();

        //pois：索引名   cxyword：类型名（可以自己定义）
        PutMappingRequest putmap = Requests.putMappingRequest(index).type(type).source(mapping);
        //创建索引
        client.admin().indices().prepareCreate(index).setSettings(Settings.builder().put("number_of_replicas", "3").put("max_result_window","100000")).execute().actionGet();
        //为索引添加映射
        client.admin().indices().putMapping(putmap).actionGet();
    }

    //时间戳转日期
    public static String stampToDate(long l,String pattern) throws ParseException{

        SimpleDateFormat sdf = new SimpleDateFormat(pattern);

        return sdf.format(new java.util.Date(l*1000));
    }


%>
<%
    int globalId = getIntParameter(request,"globalid");
    System.out.println("访问数据入库！！！");
    try{
//	Document doc = new Document(globalId);
//	int channel = doc.getChannelID();
        System.out.println("ES同步:"+globalId);
        if(globalId!=0){

            long begin_time = System.currentTimeMillis();
            init1();
            if(client!=null){
                addES(globalId);
            }
        }
    }catch (Exception e) {
        System.out.println(e.getMessage());
    }
%>




















