<%@ page import="tidemedia.cms.util.Util" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONException" %>
<%@ page import="org.apache.http.impl.client.CloseableHttpClient" %>
<%@ page import="org.apache.http.client.methods.*" %>
<%@ page import="org.apache.http.client.ClientProtocolException" %>
<%@ page import="java.io.IOException" %>
<%@ page import="org.apache.http.HttpEntity" %>
<%@ page import="org.apache.http.util.EntityUtils" %>
<%@ page import="org.apache.http.impl.client.HttpClients" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=utf-8" language="java"%>
<%@ include file="../config.jsp"%>

<%
    //机房温度中的温度，湿度通过客户提供的温度API接口获取参数
    String callback=getParameter(request,"callback");
    JSONObject jsonObject =new JSONObject();
    /*String requestUrl="http://47.94.166.110:9888/tcenter/custom/login.jsp?loginName=zhanshi&password=7usmCdYAWy21FUtgg1o7";
    String result =Util.doUrlByMethod(requestUrl,"","GET");
    JSONObject resultObject = new JSONObject(result).getJSONObject("data");
    Object ObjectuserId = resultObject.get("userId");
    String userId=String.valueOf(ObjectuserId);
    out.println(userId);*/

    //从登录接口获取userId
    String userId="";
    try {
        userId = getUserId();
    }catch (Exception e){
        jsonObject.put("code",500);
        jsonObject.put("message","获取userId出错，异常:"+e.toString());
    }

    //如果获取userId不执行操作
    if(!"".equals(userId)){//获取设备实时数据
        try {
            ArrayList message = getMessage(userId);
            jsonObject.put("data",message);
            jsonObject.put("code",200);
        }catch (Exception e){
            jsonObject.put("code",500);
            jsonObject.put("message","获取设备实时数据出错，异常:"+e.toString());
        }
    }
    out.println(callback+"("+jsonObject.toString()+")");
%>

<%!
    /**
     * 从登录接口获取userId
     * @return
     * @throws JSONException
     */
    private static String getUserId() throws JSONException {
        String requestUrl = "http://www.0531yun.cn/wsjc/app/Login";
        String result = Util.doUrlByMethod(requestUrl, "loginName=zhanshi&password=7usmCdYAWy21FUtgg1o7", "POST");
        JSONObject resultObject = new JSONObject(result).getJSONObject("data");
        Object ObjectuserId = resultObject.get("userId");
        return String.valueOf(ObjectuserId);
    }

    //根据用户编号、设备组编号获取设备实时数据
    public static ArrayList getMessage(String userId) throws IOException, JSONException {
        ArrayList al = new ArrayList();
        String requestUrl = "http://www.0531yun.cn/wsjc/app/GetDeviceData?groupId=";
        String result = doUrlByMethod2(requestUrl,userId);
        JSONObject resultObject = new JSONObject(result);
        JSONArray ColumnArray = resultObject.getJSONArray("data");// 获取全部栏目
        for (int i = 0; i < ColumnArray.length(); i++) {
            Map map=new HashMap();
            JSONObject ColumnObj = ColumnArray.getJSONObject(i);
            int deviceAddr = ColumnObj.getInt("deviceAddr");
            if(deviceAddr==10024840){//507机房设备地址
                map.put("EngineRoom","507机房");
                map.put("realTimeData",ColumnObj.getJSONObject("realTimeData"));
            }
            if(deviceAddr==10024878){//407机房设备地址
                map.put("EngineRoom","407机房");
                map.put("realTimeData",ColumnObj.getJSONObject("realTimeData"));
            }
            if(map.size()!=0){
                al.add(map);
            }
        }
        return al;
    }

    //请求get接口
    public static String doUrlByMethod2(String requestUrl,String userId) throws IOException {
        CloseableHttpClient httpClient = HttpClients.createDefault();
        HttpGet httpGet = null;
        //添加请求头信息 userId
        httpGet.addHeader("userId", userId);
        CloseableHttpResponse response = null;
        String result = "";
        httpGet = new HttpGet(requestUrl);
        response = httpClient.execute(httpGet);
        HttpEntity entity = response.getEntity();
        result = EntityUtils.toString(entity, "UTF-8");
        return result;
    }
%>
