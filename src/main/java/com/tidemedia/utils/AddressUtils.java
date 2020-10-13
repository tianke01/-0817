package com.tidemedia.utils;

/**
 * Created with IntelliJ IDEA.
 *
 * @Auther: tianke
 * @Date: 2020/08/21/14:00
 * @Description:
 */


import com.alibaba.fastjson.JSONObject;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

/**
 *  根据IP地址获取详细的地域信息
 *  @project:personGocheck
 *  @class:AddressUtils.java
 *  @author:heguanhua E-mail:37809893@qq.com
 *  @date：Nov 14, 2012 6:38:25 PM
 */
public class AddressUtils {

    public static String getAddresses(String content, String encodingString){
        //调用淘宝API
        String urlStr = "http://whois.pconline.com.cn/ipJson.jsp";

//        String returnStr = getResult(urlStr, content,encodingString);
//        if(returnStr != null){
//            System.out.println(returnStr);
//            return  returnStr;
//        }
        return null;
    }

    private static String getResult(String urlStr, String content, String encodingString) throws Exception {
        URL url = null;
        HttpURLConnection connection = null;
        url = new URL(urlStr);
        // 新建连接实例
        connection = (HttpURLConnection) url.openConnection();
        // 设置连接超时时间，单位毫秒
        //connection.setConnectTimeout(20000);
        // 设置读取数据超时时间，单位毫秒
        //connection.setReadTimeout(20000);
        //是否打开输出流
        connection.setDoOutput(true);
        //是否打开输入流
        connection.setDoInput(true);
        //提交方法 POST|GET
        connection.setRequestMethod("POST");
        //是否缓存
        connection.setUseCaches(false);
        //打开连接端口
        connection.connect();
        //打开输出流往对端服务器写数据
        DataOutputStream out = new DataOutputStream(connection.getOutputStream());
        //写数据，即提交表单 name=xxx&pwd=xxx
        out.writeBytes(content);
        //刷新
        out.flush();
        //关闭输出流
        out.close();
        // 往对端写完数据对端服务器返回数据 ,以BufferedReader流来读取
        BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream(),"UTF-8"));
        StringBuffer buffer = new StringBuffer();
        String line = "";

        while ((line = reader.readLine()) != null){
            buffer.append(line);
        }
        reader.close();
        JSONObject nluResult = JSONObject.parseObject(buffer.toString());
        System.out.println(nluResult);
        return buffer.toString();
    }

    // 测试
    public static void main(String[] args) throws Exception {
        String urlStr = "http://whois.pconline.com.cn/ipJson.jsp";
        String ip = "1.80.222.92";
        String result = getResult(urlStr, ip, "");
        System.out.println(result);
    }
}

