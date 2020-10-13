<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*"%>

<%@ page import="io.github.hengyunabc.zabbix.api.ZabbixApi" %>
<%@ page import="io.github.hengyunabc.zabbix.api.DefaultZabbixApi" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="com.alibaba.fastjson.JSONArray" %>
<%@ page import="io.github.hengyunabc.zabbix.api.RequestBuilder" %>
<%@ page import="io.github.hengyunabc.zabbix.api.Request" %>
<%@ page import="tidemedia.cms.base.TableUtil" %>
<%@ page import="tidemedia.cms.base.MessageException" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.HashMap" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
    //服务器频道
    Channel channel = CmsCache.getChannel("s53_server");
    if(channel==null){
        return;
    }
    int channelId = channel.getId();
    String tableName = channel.getTableName();
    //获取zabbix数据
    String url = "http://watch.juyun.tv/api_jsonrpc.php";
    String username = "Admin";
    String password = "tidemedia@2017";
    zabbixApi = new DefaultZabbixApi(url);
    zabbixApi.init();
    boolean login = zabbixApi.login(username, password);
    if(!login){
        Log.SystemLog("zabbix","zabbix登录失败");
        return;
    }

    //获取主机集合
    JSONArray hostArray = getHostList();
    for (int i = 0; i < hostArray.size(); i++) {
        String hostid = hostArray.getJSONObject(i).getString("hostid");
        System.out.println("hostid======"+hostid);
        //获取主机ip
        JSONArray interfaceArray = getHostinterface(hostid);
        System.out.println(interfaceArray.toString());

        if(interfaceArray.size()==0){
            continue;
        }
        System.out.println("interfaceArray==="+interfaceArray.size());
        JSONObject interfaceJson = interfaceArray.getJSONObject(0);
        String ip = interfaceJson.getString("ip");
        String port = interfaceJson.getString("port");
        //查询此ip对应后台服务器
        int globalId = getGlobalIdByIp(ip,tableName);
        if(globalId==0){
            continue;
        }
        String iowait = "";
        String CPULoad = "";
        String AvailableSpace = "";
        //String DiskIo = "";
        String MemoryCapacity = "";
        String swap = "";
        String MemoryUsage = "";
        int TcpNum = 0;
        System.out.println("11111111111111");
        //获取cpu信息
        JSONArray cpu = getItemByApplication(hostid,"CPU",new String[]{"name","key_","prevvalue"});
        for (int j = 0; j < cpu.size(); j++) {
            JSONObject json = cpu.getJSONObject(j);
            String prevvalue = json.getString("prevvalue");
            String key_ = json.getString("key_");
            if(key_.equals("system.cpu.util[,iowait]")){
                iowait = prevvalue;
            }
            if(key_.equals("system.cpu.load[all,avg5]")){
                CPULoad = prevvalue;
            }
        }
        System.out.println("2222222222222222");
        //获取硬盘信息
        JSONArray file = getItemByApplication(hostid,"Filesystems",new String[]{"name","key_","prevvalue"});
        for (int j = 0; j < file.size(); j++) {
            JSONObject json = file.getJSONObject(j);
            String prevvalue = json.getString("prevvalue");
            String key_ = json.getString("key_");
            if(key_.equals("vfs.fs.size[/,free]")){
                AvailableSpace = prevvalue;
            }
        }
        System.out.println("33333333333333");
        //获取内存信息
        JSONArray memory = getItemByApplication(hostid,"Memory",new String[]{"name","key_","prevvalue"});
        for (int j = 0; j < memory.size(); j++) {
            JSONObject json = memory.getJSONObject(j);
            String prevvalue = json.getString("prevvalue");
            String key_ = json.getString("key_");
            if(key_.equals("vm.memory.size[total]")){
                MemoryCapacity = prevvalue;
            }
            if(key_.equals("vm.memory.size[pavailable]")){
                MemoryUsage = prevvalue;
            }
            if(key_.equals("system.swap.size[,pfree]")){
                swap = prevvalue;
            }
        }
        System.out.println("4444444444444444");
        //tcp连接数
        JSONArray tcp_status = getItemByApplication(hostid,"tcp_status",new String[]{"name","key_","prevvalue"});
        for (int j = 0; j < tcp_status.size(); j++) {
            JSONObject json = memory.getJSONObject(j);
            int prevvalue = json.getIntValue("prevvalue");
            String key_ = json.getString("key_");
            if(key_.equals("tcp.status[ESTABLISHED]")){
                TcpNum = prevvalue;
            }
        }
        Document document = CmsCache.getDocument(globalId);
        System.out.println("ip=="+ip);
        System.out.println("Title=="+document.getTitle());
        System.out.println("iowait=="+iowait);
        System.out.println("CPULoad=="+CPULoad);
        System.out.println("AvailableSpace=="+AvailableSpace);
        System.out.println("MemoryCapacity=="+MemoryCapacity);
        System.out.println("MemoryUsage=="+MemoryUsage);
        System.out.println("TcpNum=="+TcpNum);
        //更新服务器监控数据
        HashMap<String,String> map = new HashMap<>();
        map.put("iowait",iowait+"");
        map.put("CPULoad",0+"");
        map.put("AvailableSpace",AvailableSpace+"");
        map.put("MemoryCapacity",MemoryCapacity+"");
        map.put("MemoryUsage",MemoryUsage+"");
        map.put("swap",swap+"");
        map.put("TcpNum",TcpNum+"");


        ItemUtil.updateItem(channelId,map,globalId,1);
    }

%>

<%!
    private ZabbixApi zabbixApi;
    //获取主机集合
    public JSONArray getHostList() throws Exception {
        Request request = RequestBuilder.newBuilder().method("host.get")
                .paramEntry("output", new String[]{"hostid"})
                //.paramEntry("output", new String[]{"host", "name", "description", "hostid"})
                //.paramEntry("selectGroups", "extend")
                //.paramEntry("groupids", "4")
                //.paramEntry("hostids", "10257")
                .build();
        JSONObject response = zabbixRequest(request);
        JSONArray result = response.getJSONArray("result");
        return result;
    }


    //获取监控项数据
    public JSONArray getItemByApplication(String hostid,String application,String[] output ) throws Exception {
        Request request = RequestBuilder.newBuilder().method("item.get").paramEntry("output", output)
                .paramEntry("monitored", "true")
                .paramEntry("hostids", hostid)
                //.paramEntry("interfaceids", new String[]{"9"})
                .paramEntry("application", application)
                .build();
        JSONObject response = zabbixRequest(request);
        zabbixError(response);
        JSONArray result = response.getJSONArray("result");
        return result;
    }
    //获取主机ip
    public JSONArray getHostinterface(String hostid) throws Exception {
        Request request = RequestBuilder.newBuilder().method("hostinterface.get")
                .paramEntry("selectGroups", "extend")
                .paramEntry("hostids", hostid)
                .build();
        JSONObject response = zabbixRequest(request);
        zabbixError(response);
        JSONArray result = response.getJSONArray("result");
        return result;
    }

    private JSONObject zabbixRequest(Request request) throws Exception {
        JSONObject response = zabbixApi.call(request);
        return response;
    }
    private void zabbixError(JSONObject response) throws Exception {
        if (!org.apache.commons.lang.StringUtils.isBlank(response.getString("error")))
            throw new Exception("向Zabbix请求出错了！" + com.alibaba.fastjson.JSON.parseObject(response.getString("error")).getString("data"));
    }

    public int getGlobalIdByIp(String ip,String tableName) throws MessageException, SQLException {
        int globalid = 0;
        TableUtil tu = new TableUtil();
        String sql = "select GlobalID from "+tableName+" where active=1 and IP='"+ip+"'";
        ResultSet rs = tu.executeQuery(sql);
        if(rs.next()){
            globalid = rs.getInt("GlobalID");
        }
        tu.closeRs(rs);
        return globalid;
    }
%>