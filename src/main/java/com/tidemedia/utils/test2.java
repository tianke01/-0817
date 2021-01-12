package com.tidemedia.utils;


import org.json.JSONArray;
import org.json.JSONException;

import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;


/**
 * Created with IntelliJ IDEA.
 *
 * @Auther: tianke
 * @Date: 2020/08/24/16:51
 * @Description:
 */
public class test2 {

    public static void main(String[] args) throws JSONException {
        String json="[{\"id\":\"1132610\",\"text\":\"大国。讲究\"}]";
        JSONArray array = new JSONArray(json);
        List<Integer> idList = new ArrayList<>();
        for (int i = 0; i < array.length(); i++) {
            int id2 = array.getJSONObject(i).getInt("id");
            idList.add(id2);
        }
        System.out.println(idList);
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
