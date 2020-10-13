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
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=utf-8" language="java"%>
<%@ include file="../config1.jsp"%>
<%
    /**
     * 用途：二维码新增
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
    System.out.println("----二维码新增----");
    JSONObject jsonObject =new JSONObject();
    //活码管理所需数据
    String Title= getParameter(request, "Title");//二维码名称
    System.out.println("Title:"+Title);
    Integer type=getIntParameter(request,"type");//切换规则 0：按扫描次数上限创建 1：按链接有效期创建
    Integer permanent=getIntParameter(request,"permanent");//是否长期有效 0：非永久有效  1：永久有效
    String jump_address = getParameter(request, "jump_address");//跳转地址
    //按次切换所需数据
    String num_addresss= getParameter(request, "num_addresss");//跳转地址
    String numbers=getParameter(request, "numbers");//跳转次数
    String[] num_addresss2 = num_addresss.split(",");
    String[] numbers2 = numbers.split(",");
    String num_address="";
    String number="";
    //按时间切换所需数据
    String switching_addresss= getParameter(request, "switching_addresss");//跳转地址
    String switching_times= getParameter(request, "switching_times");//跳转时间
    String[] switching_addresss2 = switching_addresss.split(",");
    String[] switching_times2 = switching_times.split(",");
    String switching_address="";
    String switching_time="";
    HashMap<String, String> map = new HashMap<>();
    HashMap<String, String> map2 = new HashMap<>();
    HashMap<String, String> map3 = new HashMap<>();
    System.out.println("----二维码新增----");
    if(!selectTitle(Title,code_ChannelID)){
        map.put("Title",Title);
        map.put("type",type+"");
        map.put("permanent",permanent+"");
        map.put("jump_address",jump_address);
        int GlobalID = ItemUtil.addItemGetGlobalID(code_ChannelID, map);
        Document doc=new Document(GlobalID);
        int qr_codeId = doc.getId();
        //获取qr_codeId后，生成二维码指向地址：QR_code_address，制造并保存二维码图片
        String QR_code_address=read_qr_code+"?id="+qr_codeId;
        //生成二维码图片
        BufferedImage bufferedImage = encodeQRcode(QR_code_address, 500, 500);
        //生成二维码保存位置
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String filename=sdf.format(new Date());
        if (filename.indexOf(".") >= 0) {
            // split()中放正则表达式; 转义字符"\\."代表 "."
            String[] fileNameSplitArray = filename.split("\\.");
            // 加上random戳,防止附件重名覆盖原文件
            filename = fileNameSplitArray[0] + (int) (Math.random() * 100000) + "." + fileNameSplitArray[1];
        }
        filename+=".png";
        try {
            //保存二维码
            ImageIO.write(bufferedImage,"png",new File(png_path+"/"+filename));
        } catch (IOException e) {
            jsonObject.put("message","异常："+e.toString());
        }
        //二维码存储位置：QR_code_location
        String QR_code_location=png_url+"/"+filename;
        Channel channel= CmsCache.getChannel(code_ChannelID);//根据频道ID获取频道对象
        String tableName=channel.getTableName();
        String updateSql="update "+tableName+" set QR_code_address = '"+QR_code_address+"' , QR_code_location = '"+QR_code_location+"' where id="+qr_codeId;
        new TableUtil().executeUpdate(updateSql);
        //判断此二维码是否长期有效  0：非永久有效  1：永久有效
        if(permanent==0){
            //非永久有效 判断其切换规则
            if(type==0){//0：按扫描次数上限创建
                if(num_addresss2.length==numbers2.length){
                    for(int i=0; i<num_addresss2.length; i++){
                        num_address= num_addresss2[i];
                        number=numbers2[i];
                        map2.put("Title",num_address);
                        map2.put("number",number);
                        map2.put("qr_codeId",qr_codeId+"");
                        map2.put("switching_order",i+1+"");
                        ItemUtil.addItemGetGlobalID(num_ChannelID, map2);
                    }
                }
            }else if(type==1){//1：按链接有效期创建
                if(switching_addresss2.length==switching_times2.length){
                    for(int i=0; i<switching_addresss2.length; i++){
                        switching_address= switching_addresss2[i];
                        switching_time=switching_times2[i];
                        map3.put("Title",switching_address);
                        map3.put("switching_time",switching_time);
                        map3.put("qr_codeId",qr_codeId+"");
                        map3.put("switching_order",i+1+"");
                        ItemUtil.addItemGetGlobalID(time_ChannelID, map3);
                    }
                }
            }
        }
        jsonObject.put("data","新增成功！");
        jsonObject.put("code",200);
        jsonObject.put("qr_codeId",qr_codeId);
        jsonObject.put("QR_code_location",QR_code_location);
        out.println(jsonObject.toString());
    }else{
        jsonObject.put("message","该二维码名称已存在！");
        jsonObject.put("code",500);
        out.println(jsonObject.toString());
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

    /**
     * 生成二维码
     * @param context 二维码内容
     * @param width 二维码图片宽度
     * @param height 二维码图片高度
     * @return
     */
    public static BufferedImage encodeQRcode(String context, int width, int height) throws WriterException {
        BufferedImage qrCode=null;
        Hashtable hints= new Hashtable();
        hints.put(EncodeHintType.CHARACTER_SET, "utf-8");
        BitMatrix bitMatrix = new MultiFormatWriter().encode(context, BarcodeFormat.QR_CODE, width, height,hints);
        qrCode = MatrixToImageWriter.toBufferedImage(bitMatrix);
        return qrCode;
    }


%>
