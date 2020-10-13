package com.tidemedia.utils;


import java.net.URL;
import java.net.URLConnection;


/**
 * Created with IntelliJ IDEA.
 *
 * @Auther: tianke
 * @Date: 2020/08/24/16:51
 * @Description:
 */
public class test2 {

    public static void main(String[] args) {
        testUrlWithTimeOut("https://www.baidu.com/", 1000);
    }

    public static String testUrlWithTimeOut(String urlString,int timeOutMillSeconds){
        long lo = System.currentTimeMillis();
        URL url;
        try {
            url = new URL(urlString);
            URLConnection co =  url.openConnection();
            co.setConnectTimeout(timeOutMillSeconds);
            co.connect();
            System.out.println("连接可用");
            return "连接可用";
        } catch (Exception e1) {
            System.out.println("连接打不开!");
            return "";
        }
    }

}
