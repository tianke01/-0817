<%@ page import="org.json.JSONArray,
                 org.json.JSONObject,
                 tidemedia.cms.base.TableUtil,
                 tidemedia.cms.system.*" %>
<%@ page import="tidemedia.cms.util.TideJson" %>
<%@ page import="tidemedia.cms.util.Util" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="tidemedia.cms.base.MessageException" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp" %>

<%!

%>

<%
    String sql2 = "SELECT * FROM `approve_items` where parent=241";
    TableUtil tu2=new TableUtil();
    ResultSet rs2 = tu2.executeQuery(sql2);
    out.println("id------Title------users------step------url------<br>");
    while (rs2.next()){
        int id = rs2.getInt("id");
        String Title = rs2.getString("Title");
        String users = rs2.getString("users");
        int step = rs2.getInt("step");
        String url = rs2.getString("url");
        out.println(id+"------"+Title+"------"+users+"------"+step+"------"+url+"------<br>");
    }
    tu2.closeRs(rs2);


    out.println("<br>");
    String sql = "SELECT * FROM approve_document where ChannelID =23811 and ItemID=6343";
    TableUtil tu=new TableUtil();
    ResultSet rs = tu.executeQuery(sql);
    out.println("id------UserId------UserName------Title------ApproveItemId------ApproveItemName------<br>");
    while (rs.next()){
        int id = rs.getInt("id");
        int UserId = rs.getInt("UserId");
        String userName = rs.getString("UserName");
        String Title = rs.getString("Title");
        int ApproveItemId = rs.getInt("ApproveItemId");
        String ApproveItemName = rs.getString("ApproveItemName");
        out.println(id+"------"+UserId+"------"+userName+"------"+Title+"------"+ApproveItemId+"------"+ApproveItemName+"------");
    }
    tu.closeRs(rs);
    System.out.println();
    CmsCache.delApprove(241);
%>


