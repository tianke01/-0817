package com.tidemedia.entity;

/**
 * Created with IntelliJ IDEA.
 *
 * @Auther: tianke
 * @Date: 2020/08/24/16:03
 * @Description:
 */
public class Record {
    private String Title="";//ip地址
    private String address="";//地址
    private String source="";//来源
    private String system_type="";//访问系统
    private int qr_codeId=0;//二维码id
    private int page_visits=0;//页面访问次数
    private int visitors=0;//访客量

    public String getTitle() {
        return Title;
    }

    public void setTitle(String title) {
        Title = title;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getSystem_type() {
        return system_type;
    }

    public void setSystem_type(String system_type) {
        this.system_type = system_type;
    }

    public int getQr_codeId() {
        return qr_codeId;
    }

    public void setQr_codeId(int qr_codeId) {
        this.qr_codeId = qr_codeId;
    }

    public int getPage_visits() {
        return page_visits;
    }

    public void setPage_visits(int page_visits) {
        this.page_visits = page_visits;
    }

    public int getVisitors() {
        return visitors;
    }

    public void setVisitors(int visitors) {
        this.visitors = visitors;
    }
}
