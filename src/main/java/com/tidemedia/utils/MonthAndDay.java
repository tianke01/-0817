package com.tidemedia.utils;

import java.text.SimpleDateFormat;
import java.util.Calendar;

/**
 * Created with IntelliJ IDEA.
 *
 * @Auther: tianke
 * @Date: 2020/09/18/11:01
 * @Description:
 */
public class MonthAndDay {
    public static void main(String[] args) {
        for(int i=11;i>=0;i--) {
            System.out.println(i+"--------------");
            System.out.println(getTime(i+1));
            System.out.println(getTime(i));
            System.out.println("--------------");
        }
    }

    public static String getTime(int i){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date date = new java.util.Date();
        Calendar cal = Calendar.getInstance();
        int day = cal.get(Calendar.DATE);
        cal.setTime(date);
        cal.add(Calendar.MONTH, -(i-1));
        cal.add(Calendar.DATE,-day+1);
        return sdf.format( cal.getTime());
    }
}
