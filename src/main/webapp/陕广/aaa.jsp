<%@ page import="org.apache.http.HttpEntity,
				org.apache.http.HttpResponse,
				org.apache.http.client.HttpClient,
				org.apache.http.client.methods.HttpPost,
				org.apache.http.entity.StringEntity,
				org.apache.http.impl.client.HttpClients,
				org.apache.http.util.EntityUtils"%>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="tidemedia.cms.base.TableUtil" %>
<%@ page import="tidemedia.cms.ip.IPSeeker" %>
<%@ page import="tidemedia.cms.page.TongjiUtil" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config.jsp"%>
<%!
    public static String getCurrentDate(java.util.Date date){
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        return df.format(calendar.getTime());
    }

    public static String getZeroDate(java.util.Date date,int days){
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.DAY_OF_YEAR,calendar.get(Calendar.DAY_OF_YEAR) - days);

        return df.format(calendar.getTime());
    }
	/*
	public static String getProvince( String areaCode) throws Exception{
		String address="[{\"0\":\"国外\"},{\"1\":\"中国\"},{\"2\":\"北京\"},{\"3\":\"天津\"},{\"4\":\"上海\"},{\"5\":\"重庆\"},{\"6\":\"河北\"},{\"7\":\"山西\"},{\"8\":\"辽宁\"},{\"9\":\"吉林\"},{\"10\":\"黑龙江\"},{\"11\":\"江苏\"},{\"12\":\"浙江\"},{\"13\":\"安徽\"},{\"14\":\"福建\"},{\"15\":\"江西\"},{\"16\":\"山东\"},{\"17\":\"河南\"},{\"18\":\"湖北\"},{\"19\":\"湖南\"},{\"20\":\"广东\"},{\"21\":\"海南\"},{\"22\":\"四川\"},{\"23\":\"贵州\"},{\"24\":\"云南\"},{\"25\":\"陕西\"},{\"26\":\"甘肃\"},{\"27\":\"青海\"},{\"28\":\"台湾\"},{\"29\":\"新疆\"},{\"30\":\"广西\"},{\"31\":\"宁夏\"},{\"32\":\"内蒙\"},{\"33\":\"西藏\"},{\"34\":\"香港\"},{\"35\":\"澳门\"}]";
		JSONArray ja = new JSONArray(address);
		for(int i=0;i<ja.length();i++)
		{
			JSONObject temp =ja.getJSONObject(i);
			if(temp.has(areaCode))
			{
				return temp.getString(areaCode);
			}
		}
		return "";
	}
*/
%>
<%
    /**
     *
     *	@info 地区数据统计
     *	@author wanghailong
     * @date 2014/02/17
     *
     **/

    int site = getIntParameter(request,"id");
    int number = getIntParameter(request,"number");
    int type = getIntParameter(request,"type");
    long current = System.currentTimeMillis();
    java.util.Date date = new java.util.Date();
    String begintime = getParameter(request,"begin");
    String endtime = getParameter(request,"end");
    switch (number)
    {
        case 2:
            begintime = getZeroDate(date,1);
            endtime = getZeroDate(date,0);
            break;
        case 3:
            begintime = getZeroDate(date,7);
            endtime = getZeroDate(date,0);
            break;
        case 4:
            begintime = getZeroDate(date,30);
            endtime = getZeroDate(date,0);
            break;
        case 5:
            break;
        default :
            begintime = getZeroDate(date,0);
            endtime = getZeroDate(date,-1);
            break;
    }

    String query = "{\"query\":{\"bool\":{\"must\":[{\"term\":{\"site\":"+site+"}},{\"range\":{\"date\":{\"gte\":\""+begintime+"\",\"lte\":\""+endtime+"\"}}}]}},\"size\":0,\"aggs\":{\"group_by_ip\":{\"terms\":{\"field\":\"ip\"}}}}";
    System.out.println("query="+query);
    HttpPost post = new HttpPost(request.getScheme() + "://" + request.getServerName() + ":9200/tidemedia_tongji_app_log/_search");
    post.setHeader("Content-Type", "application/json");
    //设置请求体
    post.setEntity(new StringEntity(query));
    //获取返回信息
    HttpClient Client = HttpClients.createDefault();
    HttpResponse httpResponse = Client.execute(post);
    HttpEntity entity = httpResponse.getEntity();
    String result = EntityUtils.toString(entity);
    System.out.println("result="+result);
    JSONObject jsonObject = new JSONObject(result);
    JSONArray jsonArray = jsonObject.getJSONObject("aggregations").getJSONObject("group_by_ip").getJSONArray("buckets");
    IPSeeker ipSeeker = IPSeeker.getInstance();
    List<Integer> nums = new ArrayList<Integer>();
    List<String> areas = new ArrayList<String>();
    Map<String,List> res = new HashMap<String,List>();
    Map<String,String> areaNum = new HashMap<String,String>();
    for (int i = 0; i < jsonArray.length(); i++) {
        JSONObject jsonObject1 = jsonArray.getJSONObject(i);
        String ip = jsonObject1.getString("key");
        int doc_count = jsonObject1.getInt("doc_count");
        String country = ipSeeker.getCountry(ip);
        int index = -1;
        int country_ = 0;//按国家统计
        //按国家统计会发生中国的省份出现在国家中，只需在下面if中判断即可
        if((index = country.indexOf("西藏"))!=-1||(index = country.indexOf("宁夏"))!=-1||(index = country.indexOf("新疆"))!=-1||(index = country.indexOf("省"))!=-1||(index = country.indexOf("市"))!=-1||(index = country.indexOf("区"))!=-1|| (index = country.indexOf("旗"))!=-1||( index = country.indexOf("州"))!=-1)
        {
            country = country.substring(0,index);//只保留，省、市、州、旗,区之前的数据
            country_ = 1;//中国，按省统计
        }
        if(country.equals("局域网"))continue;//局域网不统计
        int ip_code = TongjiUtil.getAreaCode(country);
        if(ip_code>1000)
            country_=ip_code;
        else if(ip_code>=1&&ip_code<1000)
            country_=1;//中国
        else if(ip_code<1)
            country_=0;
        String address=TongjiUtil.getProvince(ip_code+"");
        System.out.println("address"+address);
        if(type==0&&country_==1)address="中国";
        if(!areas.contains(address)){
            areas.add(address);
            nums.add(doc_count);
            areaNum.put(address,doc_count+"");
        }else{
            int i1 = areas.indexOf(address);
            Integer integer = nums.get(i1);
            nums.set(i1,integer+doc_count);
            areaNum.put(address,doc_count+integer+"");
        }
    }
    List<String> exist = new ArrayList<String>();
    List<String> notExist = new ArrayList<String>();
    List<Map> mapdata = new ArrayList<Map>();
    String[] address = {"HKG:香港","HAI:海南","YUN:云南","BEJ:北京","TAJ:天津","XIN:新疆","TIB:西藏","QIH:青海","GAN:甘肃","NMG:内蒙古","NXA:宁夏","SHX:山西","LIA:辽宁","JIL:吉林","HLJ:黑龙江","HEB:河北","SHD:山东","HEN:河南","SHA:陕西","SCH:四川","CHQ:重庆", "HUB:湖北","ANH:安徽","JSU:江苏","SHH:上海","ZHJ:浙江","FUJ:福建","TAI:台湾","JXI:江西","HUN:湖南","GUI:贵州","GXI:广西","GUD:广东"};
    for(int i=0;i<address.length;i++){
        String temp = address[i];
        String[]arr = temp.split(":");
        if(areas.contains(arr[1]))
            exist.add(address[i]);
        else
            notExist.add(address[i]);
    }
    for(int i=0;i<exist.size();i++)
    {
        Map<String,String> map = new HashMap<String,String>();
        String temp = exist.get(i);
        String[] array = temp.split(":");
        map.put("des","<br/><span style='font-weight:normal;'>用户访问量为:"+areaNum.get(array[1])+"</span>");
        map.put("name",array[1]);
        map.put("cha",array[0]);
        mapdata.add(map);
    }
    for(int i=0;i<notExist.size();i++)
    {
        Map<String,String> map = new HashMap<String,String>();
        String temp = notExist.get(i);
        String[] array = temp.split(":");
        map.put("des","<br/>无数据");
        map.put("name",array[1]);
        map.put("cha",array[0]);
        mapdata.add(map);
    }
    res.put("num",nums);
    res.put("area",areas);
    res.put("data",mapdata);
    JSONObject jo = new JSONObject(res);
    out.println(jo.toString());

	/*List<Integer> nums = new ArrayList<Integer>();
	List<String> areas = new ArrayList<String>();
	Map<String,List> res = new HashMap<String,List>();
	Map<String,String> areaNum = new HashMap<String,String>();
	TableUtil tu = new TableUtil();
	String sql = "select sum(num) as num,area,country from page_area where site="+site+" and date between '"+begintime+"' and '"+endtime +"'";

	if(type==0)
		sql +=" group by country order by num desc";//按国家
	else
		sql +="  and country="+type+" group by area order by num desc";
	if(number==3 || number==4 || number==5)
	{

	}
	System.out.println(sql);
	ResultSet rs1 = tu.executeQuery(sql);
	int sum = 0;
	while(rs1.next())
	{
		Map<String,Integer> temp = new HashMap<String,Integer>();
		int num = rs1.getInt(1);
		int area = rs1.getInt(2);
		int country = rs1.getInt(3);
		*//*if(type==0&&country==1)
		{
			sum+=num;
		}
		else
		{*//*
			nums.add(num);
			String address=TongjiUtil.getProvince(area+"");
			if(type==0&&country==1)address="中国";
			areas.add(address);
			areaNum.put(address,num+"");

		//}
	}
	*//*if(type==0)
	{
			nums.add(sum);
			areas.add("中国");
			areaNum.put("中国",sum+"");
	}*//*
	List<String> exist = new ArrayList<String>();
	List<String> notExist = new ArrayList<String>();
	List<Map> mapdata = new ArrayList<Map>();
	String[] address = {"HKG:香港","HAI:海南","YUN:云南","BEJ:北京","TAJ:天津","XIN:新疆","TIB:西藏","QIH:青海","GAN:甘肃","NMG:内蒙古","NXA:宁夏","SHX:山西","LIA:辽宁","JIL:吉林","HLJ:黑龙江","HEB:河北","SHD:山东","HEN:河南","SHA:陕西","SCH:四川","CHQ:重庆", "HUB:湖北","ANH:安徽","JSU:江苏","SHH:上海","ZHJ:浙江","FUJ:福建","TAI:台湾","JXI:江西","HUN:湖南","GUI:贵州","GXI:广西","GUD:广东"};
	for(int i=0;i<address.length;i++){
	 	String temp = address[i];
	 	String[]arr = temp.split(":");
	 	if(areas.contains(arr[1]))
	 		exist.add(address[i]);
	 	else
	 		notExist.add(address[i]);
	 }
	 for(int i=0;i<exist.size();i++)
	 {
	 	Map<String,String> map = new HashMap<String,String>();
	 	String temp = exist.get(i);
	 	String[] array = temp.split(":");
	 	map.put("des","<br/><span style='font-weight:normal;'>用户访问量为:"+areaNum.get(array[1])+"</span>");
	 	map.put("name",array[1]);
		map.put("cha",array[0]);
	 	mapdata.add(map);
	 }
	 for(int i=0;i<notExist.size();i++)
	 {
	 	Map<String,String> map = new HashMap<String,String>();
	 	String temp = notExist.get(i);
	 	String[] array = temp.split(":");
	 	map.put("des","<br/>无数据");
		map.put("name",array[1]);
		map.put("cha",array[0]);
	 	mapdata.add(map);
	 }
	res.put("num",nums);
	res.put("area",areas);
	res.put("data",mapdata);
//	res.put("area_num",area_num);
	JSONObject jo = new JSONObject(res);
	//System.out.println(jo.toString());
	out.println(jo.toString());

	tu.closeRs(rs1);*/
%>

