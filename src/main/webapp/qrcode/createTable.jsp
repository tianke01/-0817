<%@ page import="tidemedia.cms.base.TableUtil" %>
<%@ page import="tidemedia.cms.base.MessageException" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%
    try {
        TableUtil tu = new TableUtil();
        tu.executeUpdate("CREATE TABLE sensitive_word (`id` int NOT NULL AUTO_INCREMENT,`Word` varchar(255) DEFAULT NULL,`Process` tinyint  DEFAULT 0,`Status` tinyint  DEFAULT 0,`Date` datetime ,`Replacement` varchar(255) DEFAULT NULL,`Author` int(11) DEFAULT 0,PRIMARY KEY (`id`))");
    } catch (MessageException e) {
        e.printStackTrace();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>