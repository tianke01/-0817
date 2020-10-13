<%@ page import="java.util.*" %>
<%@ page import="org.json.*" %>
<%@ page import="tidemedia.cms.system.*" %>
<%@ page import="tidemedia.cms.base.*" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=utf-8" language="java"%>
<%@ include file="../config.jsp"%>

<%!
    //设置频道id
    static int code_ChannelID=16511;//二维码信息频道
    static int time_ChannelID=16512;//定时切换频道
    static int num_ChannelID=16513;//按次切换频道
%>
<%
    //活码管理接口：二维码信息单个查询接口
    //创建人:田轲
    //根据id查询二维码信息 及其切换信息
    System.out.println("----二维码单个查询----");
    JSONObject jsonObject =new JSONObject();
    jsonObject.put("code",500);
    jsonObject.put("message","数据异常！");
    int id=getIntParameter(request,"id");

    //int id=3;
    Map map = new HashMap();
    try {
        map = selectQrCode(id);
        jsonObject.put("data",map);
        jsonObject.put("code",200);
        jsonObject.put("message","成功！");
    } catch (MessageException e) {
        e.printStackTrace();
    } catch (SQLException e) {
        e.printStackTrace();
    }
    out.println(jsonObject.toString());

%>

<%!


    /**
     * 查询单个二维码信息
     * @param id
     * @return
     * @throws MessageException
     * @throws SQLException
     */
    public static Map selectQrCode(int id) throws MessageException, SQLException {
        Map map = new HashMap();
        Document doc = new Document(id,code_ChannelID);//查询二维码信息
        String Title = doc.getTitle();//二维码名称
        int type = doc.getIntValue("type");//切换规则 0：按扫描次数上限创建 1：按链接有效期创建
        int permanent = doc.getIntValue("permanent");//是否长期有效 0：非永久有效  1：永久有效
        String jump_address = doc.getValue("jump_address");//跳转地址
        map.put("qr_codeId",id);
        map.put("Title",Title);
        map.put("type",type);
        map.put("permanent",permanent);
        map.put("jump_address",jump_address);
        //非永久有效
        if(permanent==0){
            if(type==0){//按扫描次数上限创建
                map = selectNumSwitch(map, id);
            }else if(type==1){//按链接有效期创建
                map = selectTimeSwitch(map, id);
            }
        }
        return map;
    }

    /**
     * 查询按次扫描数据
     * @param map
     * @param id
     * @return
     * @throws MessageException
     * @throws SQLException
     */
    public static Map selectNumSwitch(Map map,int id) throws MessageException, SQLException {
        Channel channel= CmsCache.getChannel(num_ChannelID);//根据频道ID获取频道对象
        String tableName=channel.getTableName();
        String sql="select * from "+tableName+" where qr_codeId="+id+" order by switching_order";
        TableUtil tu=new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        //ArrayList<NumSwitch> al = new ArrayList<>();
        ArrayList al = new ArrayList();
        while (rs.next()){
            Map map1 = new HashMap();
            map1.put("Num_id",rs.getInt("id"));
            map1.put("Num_address",rs.getString("Title"));
            map1.put("Number",rs.getInt("number"));
            map1.put("Switching_order",rs.getInt("switching_order"));
            map1.put("Qr_codeId",rs.getInt("qr_codeId"));
            map1.put("Active",rs.getInt("active"));
            al.add(map1);
        }
        tu.closeRs(rs);
        map.put("NumSwitch",al);
        return map;
    }

    /**
     * 查询切换时间扫描数据
     * @param map
     * @param id
     * @return
     * @throws MessageException
     * @throws SQLException
     */
    public static Map selectTimeSwitch(Map map,int id) throws MessageException, SQLException {
        Channel channel= CmsCache.getChannel(time_ChannelID);//根据频道ID获取频道对象
        String tableName=channel.getTableName();
        String sql="select * from "+tableName+" where qr_codeId="+id+" order by switching_order";
        TableUtil tu=new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        //ArrayList<TimeSwitch> al = new ArrayList<>();
        ArrayList al = new ArrayList();
        while (rs.next()){
            Map map1 = new HashMap();
            map1.put("Time_id",rs.getInt("id"));
            map1.put("Switching_addresss",rs.getString("Title"));
            map1.put("Switching_time",rs.getString("switching_time"));
            map1.put("Switching_order",rs.getInt("switching_order"));
            map1.put("Qr_codeId",rs.getInt("qr_codeId"));
            map1.put("Active",rs.getInt("active"));
            al.add(map1);
        }
        tu.closeRs(rs);
        map.put("TimeSwitch",al);
        return map;
    }
%>

