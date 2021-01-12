<%@ page import="org.json.JSONObject" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="java.net.*" %>
<%@ page contentType="text/html;charset=utf-8" language="java"%>
<%@ include file="../config.jsp"%>
<%
    JSONObject jsonObject =new JSONObject();
    String bruteUrl="http://IP/awareness/view/brute_view.json";
    String loginUrl="http://IP/awareness/view/login_view.json";
    try {
        List<Map<String, Object>> al = new ArrayList<Map<String, Object>>();
        getLoginMessage(loginUrl,al);//获取login_view.json
        getBruteMessage(bruteUrl,al);//获取brute_view.json
        //根据time对list集合内map进行排序
        Collections.sort(al, new Comparator<Map<String, Object>>() {
            @Override
            public int compare(Map<String, Object> o1, Map<String, Object> o2) {
                String time1 = (String) o1.get("time");
                String time2 = (String) o2.get("time");
                return time2.compareTo(time1);
            }
        });
        jsonObject.put("data",al);
        jsonObject.put("message","成功");
        jsonObject.put("code",200);
    }catch (Exception e){
        jsonObject.put("code",500);
        jsonObject.put("message","获取json数据出错，异常:"+e.toString());
    }
    out.println(jsonObject.toString());
%>

<%!

    /**
     * 获取异常登录数据存入到map
     * @param jsonUrl
     * @param al
     * @throws IOException
     * @throws ParseException
     */
    public static void getLoginMessage(String jsonUrl,List<Map<String, Object>> al) throws IOException, ParseException {
        String s = readJsonFile(jsonUrl);
        List<Map<String,String>> listObjectFir = (List<Map<String,String>>) com.alibaba.fastjson.JSONArray.parse(s);
        for(Map<String,String> mapList : listObjectFir){
            Map<String, Object> map=new HashMap<String, Object>();
            for (Map.Entry entry : mapList.entrySet()){
                if("err_ip".equals(entry.getKey())){
                    map.put("ip",entry.getValue());
                    map.put("message","异常登录");
                }
                if("message".equals(entry.getKey())){
                    map.put("num",entry.getValue());//发生次数
                }
                if("stat".equals(entry.getKey())){
                    map.put("stat",entry.getValue());//stay 1是发生报警，还未处理，0是已处理
                }
                if("time".equals(entry.getKey())){
                    String s1 = String.valueOf(entry.getValue());
                    Date date = new SimpleDateFormat("yyyyMMddHHmm").parse(s1);
                    String now = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date);
                    map.put("time",now);
                }
            }
            al.add(map);
        }
    }

    /**
     * 获取暴力破解数据存入到map
     * @param jsonUrl
     * @param al
     * @throws IOException
     * @throws ParseException
     */
    public static void getBruteMessage(String jsonUrl,List<Map<String, Object>> al) throws IOException, ParseException {
        String s = readJsonFile(jsonUrl);
        List<Map<String, String>> listObjectFir = (List<Map<String, String>>) com.alibaba.fastjson.JSONArray.parse(s);
        for (Map<String, String> mapList : listObjectFir) {
            Map<String, Object> map = new HashMap<String, Object>();
            for (Map.Entry entry : mapList.entrySet()) {
                if ("message".equals(entry.getKey())) {
                    String message = String.valueOf(entry.getValue());
                    String[] split = message.split("_");
                    map.put("ip", split[0]);
                    map.put("num", split[1]);//发生次数
                    map.put("message", "暴力破解");//发生次数
                }
                if ("stat".equals(entry.getKey())) {
                    map.put("stat", entry.getValue());//stay 1是发生报警，还未处理，0是已处理
                }
                if ("time".equals(entry.getKey())) {
                    String s1 = String.valueOf(entry.getValue());
                    Date date = new SimpleDateFormat("yyyyMMddHHmm").parse(s1);
                    String now = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date);
                    map.put("time", now);
                }
            }
            al.add(map);
        }
    }

    /**
     * 读取json文件
     * @param filepath
     * @return
     * @throws IOException
     */
    public static String readJsonFile(String filepath) throws IOException {
        URL url = new URL(filepath);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.connect();
        InputStream inputStream = connection.getInputStream();
        //对应的字符编码转换
        Reader reader = new InputStreamReader(inputStream, "UTF-8");
        BufferedReader bufferedReader = new BufferedReader(reader);
        String str = null;
        StringBuffer sb = new StringBuffer();
        while ((str = bufferedReader.readLine()) != null) {
            sb.append(str);
        }
        reader.close();
        connection.disconnect();
        return sb.toString();
    }
%>
