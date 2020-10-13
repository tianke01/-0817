package com.tidemedia.color;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 *
 * @Auther: tianke
 * @Date: 2020/09/27/16:37
 * @Description:
 */
public class HslTest {

    public static void main(String[] args) throws Exception {
        String path = "E:\\照片\\新建文件夹\\miaosu_wulimi-016.jpg";
        RGB rgb = HslTest.getMainRgb(path);
        String s = convertRGBToHex(rgb.getRed(), rgb.getGreen(), rgb.getBlue());
        System.out.println(s);
    }

    /**
     * 获取图片主色调的rgb值
     * @param path
     * @return
     * @throws Exception
     */
    public static RGB getMainRgb (String path) throws Exception{
        Map<Float, Integer> hueCountMap = new HashMap<>();
        Map<HSL, Integer> hslCountMap = new HashMap<>();
        //BufferedImage image = ImageIO.read(new URL(path));
        BufferedImage image = ImageIO.read(new File(path));
        int width = image.getWidth();
        int height = image.getHeight();
        int minx = image.getMinX();
        int miny = image.getMinY();
        //计算各点的hsl值，并统计数量
        for (int i = minx; i < width; i++) {
            for (int j = miny; j < height; j++) {
                int pixel = image.getRGB(i, j);
                Color color = new Color(pixel);
                RGB rgb = new RGB(color.getRed(), color.getGreen(), color.getBlue());
                HSL hsl = ColorConverter.RGB2HSL(rgb);
                float h = computeHue(hsl.getH());
                float s = computeSAndL(hsl.getS());
                float l = computeSAndL(hsl.getL());
                HSL newHSL = new HSL(h, s, l);
                //统计hue值数量
                Integer count = hueCountMap.get(h);
                if(count == null){
                    hueCountMap.put(h, 1);
                }else{
                    hueCountMap.put(h, count + 1);
                }
                //统计HSL数量
                count = hslCountMap.get(newHSL);
                if(count == null){
                    hslCountMap.put(newHSL, 1);
                }else{
                    hslCountMap.put(newHSL, count + 1);
                }
            }
        }
        //查找数量最多的hue值
        float maxHue = 0;
        int maxCount = 0;
        for(Map.Entry<Float, Integer> entry : hueCountMap.entrySet()){
            float hue = entry.getKey();
            int count = entry.getValue();
            if(count > maxCount){
                maxCount = count;
                maxHue = hue;
            }
        }
        //查找maxHue中数量最多的hsl值
        HSL maxHSL = null;
        maxCount = 0;
        for(Map.Entry<HSL, Integer> entry : hslCountMap.entrySet()){
            HSL hsl = entry.getKey();
            int count = entry.getValue();
            if(hsl.getH() == maxHue && count > maxCount){
                maxCount = count;
                maxHSL = hsl;
            }
        }
        //hsl转rgb
        RGB resultRGB = ColorConverter.HSL2RGB(maxHSL);
        return resultRGB;
    }

    /**
     * 按格子划分h值
     * @param h
     * @return
     */
    public static float computeHue (float h){
        if(h <= 15){
            return 0;
        }
        if(15 < h && h <= 45){
            return 30;
        }
        if(45 < h && h <= 75){
            return 60;
        }
        if(75 < h && h <= 105){
            return 90;
        }
        if(105 < h && h <= 135){
            return 120;
        }
        if(135 < h && h <= 165){
            return 150;
        }
        if(165 < h && h <= 195){
            return 180;
        }
        if(195 < h && h <= 225){
            return 210;
        }
        if(225 < h && h <= 255){
            return 240;
        }
        if(255 < h && h <= 285){
            return 270;
        }
        if(285 < h && h <= 315){
            return 300;
        }
        if(315 < h && h <= 345){
            return 330;
        }
        if(345 < h){
            return 360;
        }
        return 360;
    }

    /**
     * 按格子划分s和l值
     * @param s
     * @return
     */
    public static float computeSAndL (float s){
        if(s <= 32){
            return 0;
        }
        if(32 < s && s <= 96){
            return 64;
        }
        if(96 < s && s <= 160){
            return 128;
        }
        if(160 < s && s <= 224){
            return 192;
        }
        if(s > 224){
            return 255;
        }
        return 255;
    }

    //**将rgb色彩值转成16进制代码**
    public  static String convertRGBToHex(int r, int g, int b) {
        String rFString, rSString, gFString, gSString,
                bFString, bSString, result;
        int red, green, blue;
        int rred, rgreen, rblue;
        red = r / 16;
        rred = r % 16;
        if (red == 10) rFString = "A";
        else if (red == 11) rFString = "B";
        else if (red == 12) rFString = "C";
        else if (red == 13) rFString = "D";
        else if (red == 14) rFString = "E";
        else if (red == 15) rFString = "F";
        else rFString = String.valueOf(red);

        if (rred == 10) rSString = "A";
        else if (rred == 11) rSString = "B";
        else if (rred == 12) rSString = "C";
        else if (rred == 13) rSString = "D";
        else if (rred == 14) rSString = "E";
        else if (rred == 15) rSString = "F";
        else rSString = String.valueOf(rred);

        rFString = rFString + rSString;

        green = g / 16;
        rgreen = g % 16;

        if (green == 10) gFString = "A";
        else if (green == 11) gFString = "B";
        else if (green == 12) gFString = "C";
        else if (green == 13) gFString = "D";
        else if (green == 14) gFString = "E";
        else if (green == 15) gFString = "F";
        else gFString = String.valueOf(green);

        if (rgreen == 10) gSString = "A";
        else if (rgreen == 11) gSString = "B";
        else if (rgreen == 12) gSString = "C";
        else if (rgreen == 13) gSString = "D";
        else if (rgreen == 14) gSString = "E";
        else if (rgreen == 15) gSString = "F";
        else gSString = String.valueOf(rgreen);

        gFString = gFString + gSString;

        blue = b / 16;
        rblue = b % 16;

        if (blue == 10) bFString = "A";
        else if (blue == 11) bFString = "B";
        else if (blue == 12) bFString = "C";
        else if (blue == 13) bFString = "D";
        else if (blue == 14) bFString = "E";
        else if (blue == 15) bFString = "F";
        else bFString = String.valueOf(blue);

        if (rblue == 10) bSString = "A";
        else if (rblue == 11) bSString = "B";
        else if (rblue == 12) bSString = "C";
        else if (rblue == 13) bSString = "D";
        else if (rblue == 14) bSString = "E";
        else if (rblue == 15) bSString = "F";
        else bSString = String.valueOf(rblue);
        bFString = bFString + bSString;
        result = "#" + rFString + gFString + bFString;
        return result;

    }


}
