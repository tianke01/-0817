<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				javax.imageio.ImageIO,
				java.awt.*,
				java.awt.image.BufferedImage,
				java.io.File,
				java.util.HashMap,
				java.util.Map"%>
<%@ page import="java.net.URL" %>
<%@ page import="org.json.JSONObject" %>

<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
    /**
     * 用途：获取图片主色调
     * 1,田轲 20200928 创建
     */
    String PhotoUrl = getParameter(request,"PhotoUrl");
    JSONObject jsonObject =new JSONObject();
    if(!"".equals(PhotoUrl)){
        try{
            RGB rgb = getMainRgb(PhotoUrl);
            String s = convertRGBToHex(rgb.getRed(), rgb.getGreen(), rgb.getBlue());
            jsonObject.put("code",200);
            jsonObject.put("message","success");
            jsonObject.put("color",s);
        }catch (Exception e){
            jsonObject.put("code",500);
            jsonObject.put("message","error");
        }
    }else{
        jsonObject.put("code",500);
        jsonObject.put("message","图片地址不能为空");
    }
    out.println(jsonObject.toString());
%>


<%!
    /**
     * 获取图片主色调的rgb值
     * @param path
     * @return
     * @throws Exception
     */
    public static RGB getMainRgb (String path) throws Exception{
        Map<Float, Integer> hueCountMap = new HashMap<>();
        Map<HSL, Integer> hslCountMap = new HashMap<>();
        BufferedImage image = ImageIO.read(new URL(path));
        //BufferedImage image = ImageIO.read(new File(path));
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

    //RGB与HSL转换器
    public static class ColorConverter {
        /**
         * @param rgb
         * @return
         */
        public static HSL RGB2HSL(RGB rgb) {
            if (rgb == null) {
                return null;
            }
            int red = rgb.getRed();
            int green = rgb.getGreen();
            int blue = rgb.getBlue();
            float var_Min = Math.min(red, Math.min(blue, green));
            float var_Max = Math.max(red, Math.max(blue, green));
            float del_Max = var_Max - var_Min;
            float H = 0;
            float S = 0;
            float L = (var_Max + var_Min) / 2;
            if (del_Max == 0) {
                H = 0;
                S = 0;
            } else {
                if (L < 128) {
                    S = 256 * del_Max / (var_Max + var_Min);
                } else {
                    S = 256 * del_Max / (512 - var_Max - var_Min);
                }
                float del_R = ((360 * (var_Max - red) / 6) + (360 * del_Max / 2))
                        / del_Max;
                float del_G = ((360 * (var_Max - green) / 6) + (360 * del_Max / 2))
                        / del_Max;
                float del_B = ((360 * (var_Max - blue) / 6) + (360 * del_Max / 2))
                        / del_Max;
                if (red == var_Max) {
                    H = del_B - del_G;
                } else if (green == var_Max) {
                    H = 120 + del_R - del_B;
                } else if (blue == var_Max) {
                    H = 240 + del_G - del_R;
                }
                if (H < 0) {
                    H += 360;
                }
                if (H >= 360) {
                    H -= 360;
                }
                if (L >= 256) {
                    L = 255;
                }
                if (S >= 256) {
                    S = 255;
                }
            }
            return new HSL(H, S, L);
        }

        /**
         * @param hsl
         * @return
         */
        public static RGB HSL2RGB(HSL hsl) {
            if (hsl == null) {
                return null;
            }
            float H = hsl.getH();
            float S = hsl.getS();
            float L = hsl.getL();

            float R, G, B, var_1, var_2;
            if (S == 0) {
                R = L;
                G = L;
                B = L;
            } else {
                if (L < 128) {
                    var_2 = (L * (256 + S)) / 256;
                } else {
                    var_2 = (L + S) - (S * L) / 256;
                }
                if (var_2 > 255) {
                    var_2 = Math.round(var_2);
                }
                if (var_2 > 254) {
                    var_2 = 255;
                }
                var_1 = 2 * L - var_2;
                R = RGBFromHue(var_1, var_2, H + 120);
                G = RGBFromHue(var_1, var_2, H);
                B = RGBFromHue(var_1, var_2, H - 120);
            }
            R = R < 0 ? 0 : R;
            R = R > 255 ? 255 : R;
            G = G < 0 ? 0 : G;
            G = G > 255 ? 255 : G;
            B = B < 0 ? 0 : B;
            B = B > 255 ? 255 : B;
            return new RGB((int) Math.round(R), (int) Math.round(G), (int) Math.round(B));
        }

        /**
         * @param a
         * @param b
         * @param h
         * @return
         */
        public static float RGBFromHue(float a, float b, float h) {
            if (h < 0) {
                h += 360;
            }
            if (h >= 360) {
                h -= 360;
            }
            if (h < 60) {
                return a + ((b - a) * h) / 60;
            }
            if (h < 180) {
                return b;
            }
            if (h < 240) {
                return a + ((b - a) * (240 - h)) / 60;
            }
            return a;
        }
    }

    //HSL实体类
    public static class HSL {
        private float h;
        /** 饱和度 */
        private float s;
        /** 深度 */
        private float l;

        public HSL() {
        }

        public HSL(float h, float s, float l) {
            setH(h);
            setS(s);
            setL(l);
        }

        public float getH() {
            return h;
        }

        public void setH(float h) {
            if (h < 0) {
                this.h = 0;
            } else if (h > 360) {
                this.h = 360;
            } else {
                this.h = h;
            }
        }

        public float getS() {
            return s;
        }

        public void setS(float s) {
            if (s < 0) {
                this.s = 0;
            } else if (s > 255) {
                this.s = 255;
            } else {
                this.s = s;
            }
        }

        public float getL() {
            return l;
        }

        public void setL(float l) {
            if (l < 0) {
                this.l = 0;
            } else if (l > 255) {
                this.l = 255;
            } else {
                this.l = l;
            }
        }

        @Override
        public boolean equals(Object obj) {
            HSL theHSL = (HSL) obj;
            return this.getH() == theHSL.getH() && this.getS() == theHSL.getS() && this.getL() == theHSL.getL();
        }

        @Override
        public int hashCode() {
            return Float.valueOf(this.getH() * 1000000 + this.getS() * 1000 + this.getL()).intValue();
        }

        public String toString() {
            return "HSL {" + h + ", " + s + ", " + l + "}";
        }
    }

    //RGB实体类
    public static class RGB {
        private int red;

        private int green;

        private int blue;

        public RGB(){}

        public RGB(int red,int green,int blue){
            setRed(red);
            setBlue(blue);
            setGreen(green);
        }

        public int getRed() {
            return red;
        }

        public void setRed(int red) {
            if (red < 0) {
                this.red = 0;
            } else if (red > 255) {
                this.red = 255;
            } else {
                this.red = red;
            }
        }

        public int getGreen() {
            return green;
        }

        public void setGreen(int green) {
            if (green < 0) {
                this.green = 0;
            } else if (green > 255) {
                this.green = 255;
            } else {
                this.green = green;
            }
        }

        public int getBlue() {
            return blue;
        }

        public void setBlue(int blue) {
            if (blue < 0) {
                this.blue = 0;
            } else if (blue > 255) {
                this.blue = 255;
            } else {
                this.blue = blue;
            }
        }

        @Override
        public boolean equals(Object obj) {
            RGB theRGB = (RGB) obj;
            return this.getRed() == theRGB.getRed() && this.getGreen() == theRGB.getGreen() && this.getBlue() == theRGB.getBlue();
        }

        @Override
        public int hashCode() {
            return this.getRed() * 1000000 + this.getGreen() * 1000 + this.getBlue();
        }

        public String toString() {
            return "RGB {" + this.red + ", " + this.green + ", " + this.blue + "}";
        }
    }
%>