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
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

    //全部审核
    public JSONObject allApprove(String taskName, String startDate, String endDate, int currPage, int listnum, String sort, UserInfo user) throws JSONException, SQLException, MessageException {
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

            //查找未审核的
            boolQuery.mustNot(QueryBuilders.termQuery("approveStatus", 0));
            //标题模糊查询
            if(!taskName.equals("")){
                boolQuery.must(QueryBuilders.wildcardQuery("title", "*"+taskName+"*"));
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

                object.put("taskId", hit.getId());//任务id
                object.put("taskName", map.get("Title"));//任务名称
                //object.put("sponsorId", );//发起人id
                //object.put("sponsorName", );//发起人名称
                object.put("sponsorTime", map.get("CreateDate"));//任务发起时间
                //
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
