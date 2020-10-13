<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="com.google.zxing.LuminanceSource" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.FileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="com.google.zxing.client.j2se.BufferedImageLuminanceSource" %>
<%@ page import="com.google.zxing.common.HybridBinarizer" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page import="com.google.zxing.*" %>
<%@ page import="com.google.zxing.NotFoundException" %>
<%@ page import="tidemedia.cms.system.CmsCache" %>
<%@ page contentType="text/html;charset=utf-8" language="java"%>
<%@ include file="../config1.jsp"%>
<%
    /**
     * 用途：图片上传
     * 1,田轲 20200818 创建
     */
    System.out.println("图片上传");
    JSONObject jsonObject =new JSONObject();
    jsonObject.put("code",500);
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    String uploadPath= CmsCache.getParameterValue("png_path")+"/img";
    FileItemFactory factory = new DiskFileItemFactory();
    ServletFileUpload servletFileUpload = new ServletFileUpload(factory);
    servletFileUpload.setHeaderEncoding("UTF-8");// 解决文件名乱码的问题
    List<FileItem> fileItemsList = servletFileUpload.parseRequest(request);
    String fileName="";
    int i=1;
    for (FileItem item : fileItemsList) {
        //判断该文件是否是普通的表单类型，该处是file类型进入判断
        if (!item.isFormField()) {
            //上传文件的名称
            fileName = item.getName();
            String FileExt = "";
            int index = fileName.lastIndexOf(".");
            if(index!=-1)
            {
                FileExt = fileName.substring(index+1);
            }
            if(FileExt.equalsIgnoreCase("gif") || FileExt.equalsIgnoreCase("jpg") || FileExt.equalsIgnoreCase("bmp") || FileExt.equalsIgnoreCase("jpeg") || FileExt.equalsIgnoreCase("png")){
                if (fileName.indexOf(".") >= 0) {
                    // split()中放正则表达式; 转义字符"\\."代表 "."
                    String[] fileNameSplitArray = fileName.split("\\.");
                    // 加上random戳,防止附件重名覆盖原文件
                    fileName = fileNameSplitArray[0] + (int) (Math.random() * 100000) + "." + fileNameSplitArray[1];
                }
                uploadPath =uploadPath+(uploadPath.endsWith("/")?"":"/")+sdf.format(new Date())+"/";
                System.out.println(uploadPath+fileName);
                File file = new File(uploadPath+fileName);
                //判断目录是否存在 ，不存在则创建
                if (!file.getParentFile().exists()) {
                    file.getParentFile().mkdirs();//创建文件
                }
                item.write(file);
                String path= uploadPath+fileName;
                Map map = decodeQRcode(path);
                if(map.get("code").equals(200)){
                    jsonObject.put("code",200);
                    jsonObject.put("url",map.get("codepath"));
                    out.println(jsonObject.toString());
                }else {
                    jsonObject.put("message",map.get("message"));
                }
            }else {
                jsonObject.put("message","你上传的图片:"+fileName+",格式不符合要求。");
                out.println(jsonObject.toString());
            }
        }
    }


%>

<%!
    /**
     * 解析读取二维码
     * @param qrCodePath 二维码图片路径
     * @return 二维码内容
     */
    public static Map decodeQRcode(String qrCodePath){
        Map map = new HashMap();
        map.put("code",500);
        BufferedImage image;
        String qrCodeText = null;
        try {
            image = ImageIO.read(new File(qrCodePath));
            LuminanceSource source = new BufferedImageLuminanceSource(image);
            Binarizer binarizer = new HybridBinarizer(source);
            BinaryBitmap binaryBitmap = new BinaryBitmap(binarizer);
            Map<DecodeHintType, Object> hints = new HashMap<DecodeHintType, Object>();
            hints.put(DecodeHintType.CHARACTER_SET, "UTF-8");
            //优化精度
            hints.put(DecodeHintType.TRY_HARDER, Boolean.TRUE);
            // 对图像进行解码
            //Result result = new MultiFormatReader().decode(binaryBitmap, hints);
            //qrCodeText = result.getText();
            Result result=null;
            Boolean a=true;
            try {
                System.out.println("------------aaaaaaaaa-----------------");
                result = new MultiFormatReader().decode(binaryBitmap, hints);
            } catch (ReaderException re) {
                System.out.println("------------bbbbbbbbb-----------------");
                a=false;
                map.put("message","该图片解析无内容"+re.toString());
                return map;
            } finally {
                if(a) {
                    qrCodeText = result.getText();
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        map.put("codepath",qrCodeText);
        map.put("code",200);
        return map;
    }

%>

