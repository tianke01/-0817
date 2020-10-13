<%@ page import="java.util.*" %>
<%@ page import="org.json.*" %>
<%@ page import="tidemedia.cms.system.*" %>
<%@ page import="tidemedia.cms.base.*" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="java.util.zip.ZipOutputStream" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.util.zip.ZipEntry" %>
<%@ page import="java.io.InputStream" %>
<%@ page contentType="text/html;charset=utf-8" language="java"%>
<%@ include file="../config1.jsp"%>

<%!
    //设置频道id
    static int code_ChannelID=16511;//活码管理频道
    static int time_ChannelID=16512;//定时切换频道
    static int num_ChannelID=16513;//按次切换频道
%>

<%
    /**
     * 用途：二维码批量下载
     * 1,田轲 20200913 创建
     */

    System.out.println("----二维码批量下载----");
    JSONObject jsonObject =new JSONObject();
    //活码管理所需数据
    String code_ids=getParameter(request, "code_ids");//二维码id
    if(!"".equals(code_ids)){
        String[] code_ids2 = code_ids.split(",");
        Integer code_id;
        ArrayList<String> urls = new ArrayList<>();
        ArrayList<String> titles = new ArrayList<>();
        for(int i=0; i<code_ids2.length; i++){
            code_id= Integer.valueOf(code_ids2[i]);
            Channel channel= CmsCache.getChannel(code_ChannelID);//根据频道ID获取频道对象
            String tableName=channel.getTableName();
            String sql="select * from "+tableName+" where id="+code_id;
            TableUtil tu=new TableUtil();
            ResultSet rs = tu.executeQuery(sql);
            while (rs.next()){
                String url=rs.getString("QR_code_location");
                String Title=rs.getString("Title");
                urls.add(url);
                titles.add(Title);
            }
            tu.closeRs(rs);
        }
        downLoadImgs(urls,titles,response);
        jsonObject.put("message","成功！");
        jsonObject.put("code",200);
    }else {
        jsonObject.put("message","二维码id不能为空！");
        jsonObject.put("code",500);
    }
    out.println(jsonObject.toString());
%>

<%!
    public static void downLoadImgs(ArrayList<String> urls,ArrayList<String> titles,HttpServletResponse response) throws IOException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmm");
        String nowTimeString=sdf.format(new Date());
        String[] files = new String[urls.size()];
        urls.toArray(files);
        String downloadFilename = nowTimeString+".zip";//文件的名称
        downloadFilename = URLEncoder.encode(downloadFilename, "UTF-8");//转换中文否则可能会产生乱码
        response.setContentType("application/octet-stream");// 指明response的返回对象是文件流
        response.setHeader("Content-Disposition", "attachment;filename=" + downloadFilename);// 设置在下载框默认显示的文件名
        ZipOutputStream zos = new ZipOutputStream(response.getOutputStream());
        for (int i = 0; i < files.length; i++) {
            URL url = new URL(files[i]);
            zos.putNextEntry(new ZipEntry(titles.get(i)+".png"));
            InputStream fis = url.openConnection().getInputStream();
            byte[] buffer = new byte[1024];
            int r = 0;
            while ((r = fis.read(buffer)) != -1) {
                zos.write(buffer, 0, r);
            }
            fis.close();
        }
        zos.flush();
        zos.close();
    }
%>
