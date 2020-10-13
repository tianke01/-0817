<%@ page import="java.util.*" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="com.google.zxing.EncodeHintType" %>
<%@ page import="com.google.zxing.MultiFormatWriter" %>
<%@ page import="com.google.zxing.BarcodeFormat" %>
<%@ page import="com.google.zxing.common.BitMatrix" %>
<%@ page import="com.google.zxing.WriterException" %>
<%@ page import="com.google.zxing.client.j2se.MatrixToImageWriter" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<%!
    /**
     * 生成二维码
     * @param context 二维码内容
     * @param width 二维码图片宽度
     * @param height 二维码图片高度
     * @return
     */
    public static BufferedImage encodeQRcode(String context, int width, int height){
        BufferedImage qrCode=null;
        try {
            Hashtable hints= new Hashtable();
            hints.put(EncodeHintType.CHARACTER_SET, "utf-8");
            BitMatrix bitMatrix = new MultiFormatWriter().encode(context, BarcodeFormat.QR_CODE, width, height,hints);
            qrCode = MatrixToImageWriter.toBufferedImage(bitMatrix);
        } catch (WriterException ex) {
            Logger.getLogger(ZxingTool.class.getName()).log(Level.SEVERE, null, ex);
        }
        return qrCode;
    }
%>