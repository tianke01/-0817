<%@ page import="org.elasticsearch.action.search.SearchResponse,
                 org.elasticsearch.client.transport.TransportClient,
                 org.elasticsearch.index.query.BoolQueryBuilder,
                 org.elasticsearch.index.query.QueryBuilders,
                 org.elasticsearch.search.SearchHit,
                 org.elasticsearch.search.SearchHits,
                 org.elasticsearch.search.sort.SortOrder" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONException" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="tidemedia.cms.base.MessageException" %>
<%@ page import="tidemedia.cms.base.TableUtil" %>
<%@ page import="tidemedia.cms.system.*" %>
<%@ page import="tidemedia.cms.user.UserInfo" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.*" %>
<%@ page import="tidemedia.cms.util.ESUtil2019" %>
<%@ page import="org.elasticsearch.search.builder.SearchSourceBuilder" %>
<%@ page contentType="text/html;charset=utf-8"%>
<%!
    public int[] getSiteID(UserInfo user) throws SQLException, MessageException {
        int company = user.getCompany();
        if (company != 0) {
            String sql = "select * from site where company = " + company;
            TableUtil tu = new TableUtil();
            ResultSet rs = tu.executeQuery(sql);
            String id = "";
            while (rs.next()) {
                if (id.length() > 0) {
                    id += "," + rs.getInt("id");
                } else {
                    id += rs.getInt("id") + "";
                }
            }
            tu.closeRs(rs);
            id += ",68";
            int[] ids = tidemedia.cms.util.Util.StringToIntArray(id, ",");
            return ids;
        } else {
            return new int[]{};
        }
    }

    //返回租户用户的栏目管理频道channelcode
    public List<String> reChannelCode(int companyId, UserInfo user) throws JSONException, MessageException, SQLException {
        JSONArray app = ChannelUtil.getApplicationChannel("app", companyId, 1, user);
        List<String> channelCodes = new ArrayList<String>();
        for (int i = 0; i < app.length(); i++) {
            JSONObject json = app.getJSONObject(i);
            int siteid = (int) json.get("siteid");
            String serialNo = "s" + siteid + "_a_a";
            channelCodes.add(CmsCache.getChannel(serialNo).getChannelCode());
        }
        return channelCodes;
    }

    //查询数量;参数，频道id,问题状态，评价
    public int getNumber(int userid, int probstatus) throws MessageException, SQLException {
        int num = 0;

        String whereSql = " where Active=1 ";
        if (probstatus != 0) {
            int status3 = probstatus - 1;
            whereSql += " and Status=" + status3;
        }
        if (userid != 0) {
            whereSql += " and User=" + userid;
        }
        String sql_count = "select count(*) from item_snap " + whereSql;
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql_count);
        if (rs.next())
            num = rs.getInt(1);
        tu.closeRs(rs);

        return num;
    }

    //其他稿件
    public JSONObject searchItemSnap(String title, int userid, boolean listAll, String startDate, String endDate, int status, int Active, int currPage, int listnum, String sort, UserInfo user, int type) throws JSONException, SQLException, MessageException {
        int[] siteIds = getSiteID(user);
        String globalid = "";
        int rowsCount = 0;
        TransportClient client = null;
        JSONObject jsonObject = new JSONObject();
        try {
            //获取索引
            String index = "tidemedia_content";
            BoolQueryBuilder boolQuery = QueryBuilders.boolQuery()
                    .must(QueryBuilders.termQuery("active", Active))
                    .must(QueryBuilders.wildcardQuery("title", "*" + title + "*"));
            int company = user.getCompany();
            List<String> channelCodes = new ArrayList<>();
            if (type != 2) {
                if (company != 0) {
                    channelCodes = reChannelCode(company, user);//获取对应租户站点下栏目管理频道channelcode
                } else {//系统管理员，拿除了文稿管理系统下的数据
                    Channel channel = ChannelUtil.getApplicationChannel("shengao");
                    String wengaoChannelCode = channel.getChannelCode();
                    boolQuery.mustNot(QueryBuilders.wildcardQuery("channelCode", wengaoChannelCode + "*"));
                }
            } else {//租户管理系统
                Channel channel = ChannelUtil.getApplicationChannel("shengao");
                int id = channel.getId();
                if (user.getCompany() != 0) {//获取符合条件的租户频道,替换ch对象，后面逻辑不变
                    id = new Tree().getChannelID(id, user);
                    channel = CmsCache.getChannel(id);
                }
                String wengaoChannelCode = channel.getChannelCode();
                channelCodes.add(wengaoChannelCode);
            }
            BoolQueryBuilder boolQuery2 = QueryBuilders.boolQuery();
            if (channelCodes.size() > 0) {
                for (String channelcode : channelCodes) {
                    boolQuery2 = boolQuery2.should(QueryBuilders.wildcardQuery("channelCode", channelcode + "*"));
                }
            }
            boolQuery.must(boolQuery2);
            if (userid != 0 && type != 1 && type != 2) {
                boolQuery.must(QueryBuilders.termQuery("user", userid));
            }
            if (status != 0) {
                boolQuery.must(QueryBuilders.termQuery("status", (status - 1)));
            }
            if (startDate != "" || endDate != "") {
                boolQuery.must(QueryBuilders.rangeQuery("createDate").from(startDate).to(endDate));
            }
            BoolQueryBuilder boolQuery3 = QueryBuilders.boolQuery();
            if (siteIds.length > 0) {
                for (int i = 0; i < siteIds.length; i++) {
                    int siteId = siteIds[i];
                    boolQuery3 = boolQuery3.should(QueryBuilders.termQuery("siteID", siteId));
                }
            }
            boolQuery.must(boolQuery3);
            System.out.println("boolquery=" + boolQuery);
            ESUtil2019 eu = ESUtil2019.getInstance();
            SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
            searchSourceBuilder.query(boolQuery);
            searchSourceBuilder.from((currPage - 1) * listnum);
            searchSourceBuilder.size(listnum);
            searchSourceBuilder.sort(sort, SortOrder.DESC);
            SearchResponse response = eu.searchDocument(index, "document", searchSourceBuilder);
            SearchHits hits = response.getHits();
            rowsCount = (int) hits.getTotalHits().value;//ES查询总数
            SearchHit[] searhits = hits.getHits();
            for (SearchHit hit : searhits) {
//                Map<String, Object> map = hit.getSourceAsMap();//使用旧ES索引时注释
                if (globalid.equals("")) {
//                    globalid = map.get("globalID") + "";//使用旧ES索引时hit.getId
                    globalid = hit.getId();
                } else {
//                    if(globalid.indexOf(map.get("globalID")+"")==-1){//使用旧ES索引时hit.getId
//                        globalid += "," + map.get("globalID");//使用旧ES索引时hit.getId
//                    }
                    if (globalid.indexOf(hit.getId()) == -1) {
                        globalid += "," + hit.getId();
                    }
                }
            }
        } catch (Exception e) {
            if (client != null) ESUtil2019.getInstance().close();
            ErrorLog.SaveErrorLog("其他错误", "ES查询错误", 0, e);
            e.printStackTrace(System.out);
        }
        jsonObject.put("rowsCout", rowsCount);
        jsonObject.put("globalids", globalid);
        return jsonObject;
    }

    //全部审核
    public JSONObject allApprove(int approveStatus, String startDate, String endDate, int currPage, int listnum, String sort, UserInfo user) throws JSONException, SQLException, MessageException {
        int[] siteIds = getSiteID(user);
        int rowsCount = 0;
        TransportClient client = null;
        JSONObject jsonObject = new JSONObject();
        JSONArray array = new JSONArray();
        try {
            //获取索引
            String index = "tidemedia_content";
            BoolQueryBuilder boolQuery = QueryBuilders.boolQuery().must(QueryBuilders.termQuery("active", 1));
            if (startDate != "" || endDate != "") {
                boolQuery.must(QueryBuilders.rangeQuery("createDate").from(startDate).to(endDate));
            }

            if (approveStatus == 1) {
                boolQuery.mustNot(QueryBuilders.termQuery("approveStatus", 0));
            } else if (approveStatus == 2) {
                boolQuery.must(QueryBuilders.termQuery("approveStatus", 100));
            } else if (approveStatus == 3) {
                boolQuery.must(QueryBuilders.termQuery("approveStatus", 101));
            }

            BoolQueryBuilder boolQuery2 = QueryBuilders.boolQuery();
            for (int i = 0; i < siteIds.length; i++) {
                int siteID = siteIds[i];
                //if (siteID == 68) continue;
                boolQuery2 = boolQuery2.should(QueryBuilders.termQuery("siteID", siteID));
            }
            boolQuery.must(boolQuery2);
            ESUtil2019 eu = ESUtil2019.getInstance();
            System.out.println("eu=="+eu);
            SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
            searchSourceBuilder.query(boolQuery);
            searchSourceBuilder.from((currPage - 1) * listnum);
            searchSourceBuilder.size(listnum);
            searchSourceBuilder.sort(sort, SortOrder.DESC);
            SearchResponse response = eu.searchDocument(index, "document", searchSourceBuilder);
            SearchHits hits = response.getHits();
            rowsCount = (int) hits.getTotalHits().value;//ES查询总数
            SearchHit[] searhits = hits.getHits();
            TableUtil tu = new TableUtil();
            for (SearchHit hit : searhits) {
                Map<String, Object> map = hit.getSourceAsMap();
                JSONObject object = new JSONObject();
                int channelId = (int) map.get("channelid");
                int Status = (int) map.get("Status");
                String documentStatus = "";
                if (Status == 0) {
                    documentStatus = "<span class='tx-orange'>草稿</span>";
                } else {
                    documentStatus = "<span class='tx-success'>已发</span>";
                }
                Channel channel = CmsCache.getChannel(channelId);
                Document document = CmsCache.getDocument(Integer.parseInt(hit.getId()));
                if (channel == null||document==null) {
                    rowsCount--;
                    continue;
                }
                String approveStatusString = "";
                int editables = 0;
                int approveStatus1 = (int) map.get("approveStatus");
                if (approveStatus1 == 100) {
                    approveStatusString = "审核通过";
                } else if (approveStatus1 == 101) {
                    approveStatusString = "审核驳回";
                } else {
                    int approveScheme = channel.getApproveScheme();
                    ArrayList<ApproveItems> approveitems = CmsCache.getApprove(approveScheme).getApproveitems();
                    for (int i = 0; i < approveitems.size(); i++) {
                        ApproveItems api = approveitems.get(i);
                        int api_step = api.getStep();
                        if(approveStatus1==api_step){
                            editables = api.getEditable();
                            approveStatusString = api.getTitle() + "审核中";
                        }
                    }
                }

                int IsPhotoNews = document.getIsPhotoNews();
                int category = document.getCategoryID();
                String SiteAddress = channel.getSite().getUrl();
                boolean canApprove = channel.hasRight(user, ChannelPrivilegeItem.CanApprove);
                boolean canDelete = channel.hasRight(user, ChannelPrivilegeItem.CanDelete);
                String channelPath = channel.getParentChannelPath().replaceAll("/", ">");
                object.put("title", map.get("Title"));
                object.put("channelId", channelId);
                object.put("status", Status);
                object.put("documentStatus", documentStatus);
                object.put("createDate", map.get("CreateDate"));
                object.put("approveStatus", approveStatusString);
                object.put("id_", document.getId());
                object.put("globalId", hit.getId());
                object.put("IsPhotoNews", IsPhotoNews);
                object.put("category", category);
                object.put("SiteAddress", SiteAddress);
                object.put("channelPath", channelPath);
                object.put("canApprove", canApprove);
                object.put("canDelete", canDelete);
                object.put("editables", editables);
                array.put(object);
            }
        } catch (Exception e) {
            if (client != null) ESUtil2019.getInstance().close();
            ErrorLog.SaveErrorLog("其他错误", "ES查询错误", 0, e);
            e.printStackTrace(System.out);
        }
        jsonObject.put("rowsCout", rowsCount);
        jsonObject.put("arr", array);
        return jsonObject;
    }
%>
