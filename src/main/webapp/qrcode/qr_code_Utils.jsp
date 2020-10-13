<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.io.IOException" %>
<%@ page import="static tidemedia.cms.util.CommonUtil.getIntParameter" %>
<%@ page import="static tidemedia.cms.util.CommonUtil.getParameter" %>
<%@ page import="com.google.zxing.*" %>
<%@ page import="com.google.zxing.common.HybridBinarizer" %>
<%@ page import="com.google.zxing.client.j2se.BufferedImageLuminanceSource" %>
<%@ page contentType="text/html;charset=utf-8" language="java"%>
<%
    System.out.println("二维码工具类");
    String path="";
    Integer status=getIntParameter(request,"status");
    path= getParameter(request, "path");
    System.out.println(path);
    if("".equals(path)){
        String codepath = decodeQRcode(path);
        System.out.println(codepath);
    }

%>
<%!
    /**
     * 解析读取二维码
     * @param qrCodePath 二维码图片路径
     * @return
     */
    public static String decodeQRcode(String qrCodePath){
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
            Result result = new MultiFormatReader().decode(binaryBitmap, hints);
            qrCodeText = result.getText();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (NotFoundException e) {
            e.printStackTrace();
        }
        return qrCodeText;
    }
%>
