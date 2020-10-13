<%@ page import="tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>

<!-- 活码管理接口：图片下载  -->
<!-- 创建人：田轲  -->
//http://apptest.api-people.top/cms/download.jsp?Type=File&FileName=content2018.jsp&FolderName=/cms/renmin&SiteId=21
<%
    System.out.println("图片下载");
    String QR_code_location = getParameter(request,"QR_code_location");
    String fName = QR_code_location.trim();
    String tomcatPath = request.getRealPath("/");
    String FileName = fName.substring(fName.lastIndexOf("/")+1);
    String downloadjsp=tomcatPath+"cms/download.jsp?Type=File&FolderName=/cms/renmin/qr_code&SiteId=21&FileName="+FileName;
    response.sendRedirect(downloadjsp);
%>
