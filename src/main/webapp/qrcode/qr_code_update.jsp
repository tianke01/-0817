<%@ page import="java.util.*" %>
<%@ page import="org.json.*" %>
<%@ page import="tidemedia.cms.system.*" %>
<%@ page import="tidemedia.cms.base.*" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="com.google.zxing.EncodeHintType" %>
<%@ page import="com.google.zxing.common.BitMatrix" %>
<%@ page import="com.google.zxing.MultiFormatWriter" %>
<%@ page import="com.google.zxing.BarcodeFormat" %>
<%@ page import="com.google.zxing.client.j2se.MatrixToImageWriter" %>
<%@ page import="com.google.zxing.WriterException" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.IOException" %>
<%@ page contentType="text/html;charset=utf-8" language="java"%>
<%@ include file="../config.jsp"%>
<%
    /**
     * 用途：二维码修改
     * 1,田轲 20200818 创建
     */
    //设置频道id
    int code_ChannelID=16511;//活码管理频道
    int time_ChannelID=16512;//定时切换频道
    int num_ChannelID=16513;//按次切换频道
    //获取系统参数
    String png_url=CmsCache.getParameterValue("png_url")+"qr_code";
    String png_path=CmsCache.getParameterValue("png_path")+"/qr_code";
    String read_qr_code=CmsCache.getParameterValue("png_url")+"read_qr_code.jsp";
    System.out.println("----二维码修改----");
    JSONObject jsonObject =new JSONObject();
    //活码管理所需数据
    Integer qr_codeId=getIntParameter(request,"qr_codeId");
    Document doc=new Document(qr_codeId,code_ChannelID);
    int GlobalID=doc.getGlobalID();
    String NewTitle= getParameter(request, "Title");//二维码名称
    String Title=doc.getTitle();
    Integer type=getIntParameter(request,"type");//切换规则 0：按扫描次数上限创建 1：按链接有效期创建
    Integer permanent=getIntParameter(request,"permanent");//是否长期有效 0：非永久有效  1：永久有效
    String jump_address = getParameter(request, "jump_address");//跳转地址
    if("".equals(jump_address)){
        jsonObject.put("message","跳转地址不能为空");
        jsonObject.put("code",500);
        out.println(jsonObject.toString());
    }
    if(qr_codeId==0){
        jsonObject.put("message","二维码id不能为空");
        jsonObject.put("code",500);
        out.println(jsonObject.toString());
    }else{
        HashMap<String, String> code_map = new HashMap<>();
        if(!"".equals(NewTitle)&&!"".equals(Title)){//判断是否为空
            if(!Title.equals(NewTitle)){
                if(!selectTitle(NewTitle,code_ChannelID)){
                    code_map.put("Title",NewTitle);
                    code_map.put("permanent",permanent+"");
                    code_map.put("jump_address",jump_address);
                    new ItemUtil().updateItemByGid(code_ChannelID,code_map,GlobalID,0);
                    if(permanent==1&&type==0){//当修改为永久有效后，删除切换记录（按扫描次数上限）
                        String Sql="delete from "+CmsCache.getChannel(num_ChannelID).getTableName()+" where qr_codeId="+qr_codeId;
                        new ItemUtil().executeUpdate(Sql);
                    }else if(permanent==1&&type==1){//当修改为永久有效后，删除切换记录（按链接有效期）
                        String Sql="delete from "+CmsCache.getChannel(time_ChannelID).getTableName()+" where qr_codeId="+qr_codeId;
                        new ItemUtil().executeUpdate(Sql);
                    }
                    if(permanent==0&&type==0){//按扫描次数上限修改
                        //按次切换所需数据
                        String num_addresss= getParameter(request, "num_addresss");//跳转地址
                        String numbers=getParameter(request, "numbers");//跳转次数
                        String num_ids=getParameter(request, "num_ids");//按次切换数据id
                        String[] num_addresss2 = num_addresss.split(",");
                        String[] numbers2 = numbers.split(",");
                        String[] num_ids2 =new String[]{};
                        if(!"".equals(num_ids)){
                            num_ids2 = num_ids.split(",");
                        }
                        String num_address="";
                        String number="";
                        Integer num_id;
                        if(num_addresss2.length==numbers2.length){
                            for(int i=0; i<num_addresss2.length; i++){
                                HashMap<String, String> num_map = new HashMap<>();
                                num_address= num_addresss2[i];
                                number=numbers2[i];
                                num_map.put("Title",num_address);
                                num_map.put("number",number);
                                num_map.put("switching_order",i+1+"");
                                if(i>=num_ids2.length){//当i>num_ids2.length表示新增了地址
                                    num_map.put("qr_codeId",qr_codeId+"");
                                    ItemUtil.addItemGetGlobalID(num_ChannelID, num_map);
                                }else{
                                    num_id= Integer.valueOf(num_ids2[i]);
                                    new ItemUtil().updateItemById(num_ChannelID,num_map,num_id,0);
                                }
                            }
                        }
                    }else if(permanent==0&&type==1){//按链接有效期修改
                        //按时间切换所需数据
                        String switching_addresss= getParameter(request, "switching_addresss");//跳转地址
                        String switching_times= getParameter(request, "switching_times");//跳转时间
                        String time_ids=getParameter(request, "time_ids");//按次切换数据id
                        String[] switching_addresss2 = switching_addresss.split(",");
                        String[] switching_times2 = switching_times.split(",");
                        String[] time_ids2=new String[]{};
                        if(!"".equals(time_ids)){
                            time_ids2 = time_ids.split(",");
                        }
                        String switching_address="";
                        String switching_time="";
                        Integer time_id;
                        if(switching_addresss2.length==switching_times2.length){
                            for(int i=0; i<switching_addresss2.length; i++){
                                HashMap<String, String> time_map = new HashMap<>();
                                switching_address=switching_addresss2[i];
                                switching_time=switching_times2[i];
                                time_map.put("Title",switching_address);
                                time_map.put("switching_time",switching_time);
                                time_map.put("switching_order",i+1+"");
                                if(i>=time_ids2.length) {//当i>time_ids2.length表示新增了地址
                                    time_map.put("qr_codeId",qr_codeId+"");
                                    ItemUtil.addItemGetGlobalID(time_ChannelID, time_map);
                                }else{
                                    time_id= Integer.valueOf(time_ids2[i]);
                                    new ItemUtil().updateItemById(time_ChannelID,time_map,time_id,0);
                                }
                            }
                        }
                    }
                    jsonObject.put("QR_code_location",doc.getValue("QR_code_location"));
                    jsonObject.put("message","修改成功！");
                    jsonObject.put("code",200);
                    out.println(jsonObject.toString());
                }else {
                    jsonObject.put("message","该二维码名称已存在！");
                    jsonObject.put("code",500);
                    out.println(jsonObject.toString());
                }
            }else {
                code_map.put("type",type+"");
                code_map.put("permanent",permanent+"");
                code_map.put("jump_address",jump_address);
                new ItemUtil().updateItemByGid(code_ChannelID,code_map,GlobalID,0);
                if(permanent==1&&type==0){//当修改为永久有效后，删除切换记录（按扫描次数上限）
                    String Sql="delete from "+CmsCache.getChannel(num_ChannelID).getTableName()+" where qr_codeId="+qr_codeId;
                    new TableUtil().executeUpdate(Sql);
                }else if(permanent==1&&type==1){//当修改为永久有效后，删除切换记录（按链接有效期）
                    String Sql="delete from "+CmsCache.getChannel(time_ChannelID).getTableName()+" where qr_codeId="+qr_codeId;
                    new TableUtil().executeUpdate(Sql);
                }
                if(permanent==0&&type==0){//按扫描次数上限修改
                    //按次切换所需数据
                    String num_addresss= getParameter(request, "num_addresss");//跳转地址
                    String numbers=getParameter(request, "numbers");//跳转次数
                    String num_ids=getParameter(request, "num_ids");//按次切换数据id
                    String[] num_addresss2 = num_addresss.split(",");
                    String[] numbers2 = numbers.split(",");
                    String[] num_ids2 =new String[]{};
                    if(!"".equals(num_ids)){
                        num_ids2 = num_ids.split(",");
                    }
                    String num_address="";
                    String number="";
                    Integer num_id;
                    if(num_addresss2.length==numbers2.length){
                        for(int i=0; i<num_addresss2.length; i++){
                            HashMap<String, String> num_map = new HashMap<>();
                            num_address= num_addresss2[i];
                            number=numbers2[i];
                            num_map.put("Title",num_address);
                            num_map.put("number",number);
                            num_map.put("switching_order",i+1+"");
                            if(i>=num_ids2.length){//当i>num_ids2.length表示新增了地址
                                num_map.put("qr_codeId",qr_codeId+"");
                                ItemUtil.addItemGetGlobalID(num_ChannelID, num_map);
                            }else{
                                num_id= Integer.valueOf(num_ids2[i]);
                                new ItemUtil().updateItemById(num_ChannelID,num_map,num_id,0);
                            }
                        }
                    }
                }else if(permanent==0&&type==1){//按链接有效期修改
                    //按时间切换所需数据
                    String switching_addresss= getParameter(request, "switching_addresss");//跳转地址
                    String switching_times= getParameter(request, "switching_times");//跳转时间
                    String time_ids=getParameter(request, "time_ids");//按次切换数据id
                    String[] switching_addresss2 = switching_addresss.split(",");
                    String[] switching_times2 = switching_times.split(",");
                    String[] time_ids2=new String[]{};
                    if(!"".equals(time_ids)){
                        time_ids2 = time_ids.split(",");
                    }
                    String switching_address="";
                    String switching_time="";
                    Integer time_id;
                    if(switching_addresss2.length==switching_times2.length){
                        for(int i=0; i<switching_addresss2.length; i++){
                            HashMap<String, String> time_map = new HashMap<>();
                            switching_address=switching_addresss2[i];
                            switching_time=switching_times2[i];
                            time_map.put("Title",switching_address);
                            time_map.put("switching_time",switching_time);
                            time_map.put("switching_order",i+1+"");
                            if(i>=time_ids2.length) {//当i>time_ids2.length表示新增了地址
                                time_map.put("qr_codeId",qr_codeId+"");
                                ItemUtil.addItemGetGlobalID(time_ChannelID, time_map);
                            }else{
                                time_id= Integer.valueOf(time_ids2[i]);
                                new ItemUtil().updateItemById(time_ChannelID,time_map,time_id,0);
                            }
                        }
                    }
                }
                jsonObject.put("QR_code_location",doc.getValue("QR_code_location"));
                jsonObject.put("message","修改成功！");
                jsonObject.put("code",200);
                out.println(jsonObject.toString());
            }

        }else{
            jsonObject.put("message","二维码名称不能为空");
            jsonObject.put("code",500);
            out.println(jsonObject.toString());
        }
    }


%>

<%!
    /**
     * 判断二维码名称是否唯一
     * @param Title 二维码名称
     * @return
     */
    public boolean selectTitle(String Title,int ChannelID) throws MessageException, SQLException {
        Channel channel= CmsCache.getChannel(ChannelID);//根据频道ID获取频道对象
        String tableName=channel.getTableName();
        String sql="select Title from "+tableName+" where Title = '"+Title+"' and active=1";
        TableUtil tu=new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        boolean next = rs.next();
        tu.closeRs(rs);
        return next;
    }


%>
