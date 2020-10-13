package com.tidemedia.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;

/**
 * Created with IntelliJ IDEA.
 *
 * @Auther: tianke
 * @Date: 2020/08/21/16:06
 * @Description:
 */
public class DownloadUtil {

    public static String getJsonStringAt(String urlString) {
        StringBuffer strBuf = new StringBuffer();
        try {
            URL url = new URL(urlString);
            URLConnection conn = url.openConnection();
            BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            String line = null;
            while((line = reader.readLine()) != null) {
                strBuf.append(line + " ");
            }
            reader.close();
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return strBuf.toString();
    }

    public static void main(String[] args) {
        String jsonStr = DownloadUtil.getJsonStringAt("http://whois.pconline.com.cn/ipJson.jsp?ip=1.80.222.92&json=true");
        System.out.println(jsonStr);
    }
}
