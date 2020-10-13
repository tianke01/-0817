package com.tidemedia.utils;

import com.google.zxing.*;
import com.google.zxing.client.j2se.BufferedImageLuminanceSource;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.common.HybridBinarizer;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Created with IntelliJ IDEA.
 *
 * @Auther: tianke
 * @Date: 2020/08/21/9:16
 * @Description:
 */
public class ZxingTool {

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
            System.out.println("异常："+e.toString());
        } catch (NotFoundException e) {
            System.out.println("异常："+e.toString());
        }
        return qrCodeText;
    }



    public static void main(String[] args) {
        int type=1;
        if(type==1){
            String s = ZxingTool.decodeQRcode("D:\\3.png");
            System.out.println(s);
        }else if (type==2){
            BufferedImage bufferedImage = ZxingTool.encodeQRcode("http://123.56.71.230:999/tcenter2020/renmin/read_qr_code.jsp?id=11", 500, 500);
            try {
                ImageIO.write(bufferedImage,"png",new File("D:\\test.png"));
            } catch (IOException e) {
                System.out.println("异常："+e.toString());
            }
        }
    }
}
