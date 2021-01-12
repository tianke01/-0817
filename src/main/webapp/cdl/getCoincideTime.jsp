<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page import="javax.print.Doc" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!

    public String getParentChannelPath(Channel channel) throws MessageException, SQLException{

        String path = "";
        ArrayList arraylist = channel.getParentTree();

        if ((arraylist != null) && (arraylist.size() > 0))
        {
            for (int i = 0; i < arraylist.size(); ++i)
            {
                Channel ch = (Channel)arraylist.get(i);

                if((i+1)==arraylist.size()){//当前频道名
                    path = path + ch.getName() ;// + ((i < arraylist.size() - 1) ? " / " : "");
                }else{
                    path = path + ch.getName() +" / ";// javascript:jumpContent("+ch.getId()+")
                }
            }
        }

        arraylist = null;

        return path;
    }
%>
<%
    long begin_time = System.currentTimeMillis();
    int link_channelid = getIntParameter(request,"LinkChannelID");
    if(link_channelid==0){
        link_channelid= getIntParameter(request,"id");
    }
    int	channelid = getIntParameter(request,"channelid");
    int	itemid1 = getIntParameter(request,"itemid");
    int id = channelid;
    int globalid = getIntParameter(request,"globalid");
    int currPage = getIntParameter(request,"currPage");
    int rowsPerPage = getIntParameter(request,"rowsPerPage");
    int sortable = getIntParameter(request,"sortable");
    int rows = getIntParameter(request,"rows");
    int cols = getIntParameter(request,"cols");
    int fieldgroup = getIntParameter(request,"fieldgroup");

    if(currPage<1)
        currPage = 1;

    if(rowsPerPage==0)
        rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage",request.getCookies()));

    if(rowsPerPage<=0)
        rowsPerPage = 20;

    if(rows==0)
        rows = Util.parseInt(Util.getCookieValue("rows",request.getCookies()));
    if(cols==0)
        cols = Util.parseInt(Util.getCookieValue("cols",request.getCookies()));

    if(rows==0)
        rows = 10;
    if(cols==0)
        cols = 5;

    Channel channel = CmsCache.getChannel(channelid);
    if(channel==null || channel.getId()==0)
    {
        response.sendRedirect("../content/content_nochannel.jsp");
        return;
    }
    if(!channel.hasRight(userinfo_session,1))
    {
        response.sendRedirect("../noperm.jsp");return;
    }
    id = channelid = channel.getTableChannelID();
    channel = CmsCache.getChannel(channelid);
    Channel parentchannel = null;
    int ChannelID = channel.getId();
    int IsWeight=channel.getIsWeight();
    int	IsComment=channel.getIsComment();
    int	IsClick=channel.getIsClick();
    String gids = "";

    int listType = 0;
    listType = getIntParameter(request,"listtype");
    listType = 1;

    boolean listAll = false;

    if(channel.isTableChannel() && channel.getType2()==8) listAll = true;

    String S_Title			=	getParameter(request,"Title");
    String S_CreateDate		=	getParameter(request,"CreateDate");
    String S_CreateDate1	=	getParameter(request,"CreateDate1");
    String S_User			=	getParameter(request,"User");
    int S_IsIncludeSubChannel =	getIntParameter(request,"IsIncludeSubChannel");
    int S_Status			=	getIntParameter(request,"Status");
    int S_IsPhotoNews		=	getIntParameter(request,"IsPhotoNews");
    int S_OpenSearch		=	getIntParameter(request,"OpenSearch");
    int IsDelete			=	getIntParameter(request,"IsDelete");

    int Status1			=	getIntParameter(request,"Status1");

    String querystring = "";
    querystring = "&Title="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&CreateDate="+S_CreateDate+"&CreateDate1="+S_CreateDate1+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete+"&Status1="+Status1+"&globalid="+globalid+"&channelid="+channelid+"&fieldgroup="+fieldgroup;

    String pageName = request.getServletPath();
    int pindex = pageName.lastIndexOf("/");
    if(pindex!=-1)
        pageName = pageName.substring(pindex+1);



    String SiteAddress = channel.getSite().getUrl();
//获取频道路径
    String parentChannelPath = getParentChannelPath(channel);
%>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="Shortcut Icon" href="../favicon.ico">
    <title>TideCMS 列表</title>

    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
    <link rel="stylesheet" href="../style/2018/bracket.css">
    <link rel="stylesheet" href="../style/2018/common.css">
    <style>
        .collapsed-menu .br-mainpanel-file {margin-left: 0;margin-top: 0;}
        table.table-fixed{table-layout: fixed;word-break: break-all;word-wrap: break-word}
        table.table-fixed,table.table-fixed th,table.table-fixed td{border:1px solid #dee2e6;
            border-collapse: collapse !important;}
        .list-pic-box{width: 100%;height: 0;padding-bottom: 56.25%;overflow: hidden;text-align: center;}
        .list-pic-box img{max-width: 100%;min-width:100%;min-height: 100%;height: auto;display: block;}
        .cm_size input{ width: 95%; }
        .td_size input{ width: 60px; }
        .metre input{ width: 60px; }
        .beizhu{ /*width: 200px !important;*/ }
        .dataTables_filter input, .form-control{ padding: 0.3rem 0.4rem; }
        .table td, .table th{ padding: 0.45rem; }
        #content-table tr th:nth-child(2) { min-width: 120px; }
        #content-table td.dropdown{display: flex;}
        #content-table td.dropdown>a{margin-right: 4px;min-width: 20px;}
    </style>

    <script src="../lib/2018/jquery/jquery.js"></script>
    <script type="text/javascript" src="../common/2018/common2018.js"></script>
    <script type="text/javascript" src="../common/2018/content.js"></script>

    <script>
        var listType = 1;
        var rows = <%=rows%>;
        var cols = <%=cols%>;
        var itemid1 = <%=itemid1%>;
        var ChannelID = <%=ChannelID%>;
        var channelid = <%=channelid%>;
        var LinkChannelID = <%=link_channelid%>;
        var globalid = <%=globalid%>;
        var currRowsPerPage = <%=rowsPerPage%>;
        var currPage = <%=currPage%>;
        var fieldgroup = <%=fieldgroup%>;
        var Parameter = "&ChannelID="+ChannelID+"&rowsPerPage="+currRowsPerPage+"&currPage="+currPage+"&LinkChannelID="+LinkChannelID+"&GlobalID="+globalid;
        var pageName = "<%=pageName%>";
        var idss="";

        var order_numbers = "";
        if(pageName=="") pageName = "content.jsp";

        function gopage(currpage)
        {
            var url = pageName + "?currPage="+currpage+"&id=<%=link_channelid%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
            this.location = url;
        }

        function list(str)
        {
            var url = pageName + "?id=<%=link_channelid%>&rowsPerPage=<%=rowsPerPage%>";
            if(typeof(str)!='undefined')
                url += "&" + str;
            this.location = url;
        }

        function Preview22(id)
        {
            tidecms.dialog("../video/video_player.jsp?id="+id,640,510,"视频预览");
        }

        function editDocument(itemid)
        {

            var url = $("#item_"+itemid).attr("url");
            window.open(url);
        }

        function selectItem()
        {
            if(globalid==0)
            {
                $.getJSON("../content/document_getnew.jsp?id="+parent.channelid, function(o){
                    itemid = o.itemid;
                    globalid = o.globalid;
                    parent.document.form.GlobalID.value = o.globalid;
                    parent.document.form.ItemID.value = o.itemid;
                    parent.document.form.Action.value = "Update";
                    //var url="../content/select_child_item2018.jsp?ChannelID="+ChannelID+"&LinkChannelID="+LinkChannelID+"&GlobalID="+globalid+"&fieldgroup="+fieldgroup;
                    var url="../content/select_child_channel_tree2018.jsp?ChannelID="+ChannelID+"&LinkChannelID="+LinkChannelID+"&GlobalID="+globalid+"&fieldgroup="+fieldgroup;
                    window.open(url);
                });
            }
            else
            {
                //var url="../content/select_child_item2018.jsp?ChannelID="+ChannelID+"&LinkChannelID="+LinkChannelID+"&GlobalID="+globalid+"&fieldgroup="+fieldgroup;
                var url="../content/select_child_channel_tree2018.jsp?ChannelID="+ChannelID+"&LinkChannelID="+LinkChannelID+"&GlobalID="+globalid+"&fieldgroup="+fieldgroup;
                window.open(url);
            }
        }

        function getGlobalIDNew(){
            var pfid="";
            jQuery("#content-table input:checked").each(function(i){
                var obj=jQuery(this).parent().parent().parent();
                if(i==0){
                    pfid+=jQuery(obj).attr("productfabricinfoid");
                }else{
                    pfid+=","+jQuery(obj).attr("productfabricinfoid");
                }

            });
            var obj={length:jQuery("#content-table input:checked").length,pfid:pfid};
            return obj;
        }
        function delItem(){
            var obj=getGlobalIDNew();
            var message = "确实要删除这"+obj.length+"项吗？";
            if(obj.length==0){
                alert("请先选择要删除的文件！");
            }else{
                if(confirm(message)){
                    var url="/tcenter_youka/productapi/sizeinfodel?ProductSizeInfoIds="+obj.pfid;
                    $.ajax({
                        type: "GET",
                        url: url,
                        success: function(data){
                            if(data.code==200){
                                dialog.showAlert( "删除成功！" );
                                document.location.href=document.location.href;
                            }else{
                                commonPop(data.message);
                            }

                        }
                    });
                }
            }
        }
        function change(s,id)
        {
            var value=jQuery(s).val();
            var exp = new Date();
            exp.setTime(exp.getTime() + 300*24*60*60*1000);
            document.cookie = "rowsPerPage="+value;
            document.location.href = pageName+"?id="+id+"&rowsPerPage="+value+"&GlobalID=<%=globalid%>&ItemID=&ChannelID="+ChannelID+"&LinkChannelID="+LinkChannelID;
        }
        function double_click()
        {
            /*jQuery("#content-table .tide_item").dblclick(function(){
            var obj=jQuery(":checkbox",jQuery(this));
            obj.trigger("click");
            editDocument(obj.val());
            });*/
        }
        function editDocument1()
        {
            var obj=getCheckbox();
            if(obj.length==0){
                alert("请先选择要修改的文件！");
                return;
            }
            if(obj.length>1){
                alert("请选择一个文件！");
                return;
            }

            editDocument(obj.id);
        }
        function editDocument(itemid)
        {
            var url="../content/document.jsp?ItemID="+itemid+"&ChannelID=" + LinkChannelID;
            window.open(url);
        }
        function Preview2(id)
        {
            window.open("../content/document_preview.jsp?ItemID=" + id + "&ChannelID="+LinkChannelID);
        }

        function sort(id){
            var iframe = window.frameElement.id;
            var start_sort = false;
            $(".tide_item").each(function(){
                idss += (idss==""?"":",") +$(this).attr("GlobalID");
                order_numbers += (order_numbers==""?"":",") +$(this).attr("OrderNumber");

            });
            var url = "content_gather_sort2018.jsp?";
            var data="ids="+idss+"&order_numbers="+order_numbers+"&Globalid="+id+"&channelid="+ChannelID+"&LinkChannelID="+LinkChannelID+"&globalid="+globalid+"&iframe="+iframe;	//globalid为父文章id编辑传过来
            var urldata= url + data;
            var	dialog = new top.TideDialog();
            dialog.setWidth(320);
            dialog.setHeight(260);
            //dialog.setSuffix('_1');
            dialog.setUrl(urldata);
            dialog.setTitle("排序");
            dialog.show();
        }
        function sortDoc(){

            var obj=getCheckbox();
            if(obj.length!=1){
                ddalert("请选择一个待排序的选项","(function dd(){getDialog().Close({suffix:'html'});})()");
            }else{

                sortDoc1(obj.id);
            }
        }
        function sortDoc1(id){
            var Globalid = $("#item_"+id).attr("GlobalID");
            sort(Globalid);
        }
        function content_gather_addDocument(channelid)
        {
            var url="../content/document.jsp?ItemID=0&ChannelID=" + channelid;
            window.open(url);
        }
    </script>
</head>

<body class="collapsed-menu email">

<div class="br-mainpanel br-mainpanel-file" id="js-source">

    <!--	<div class="br-pageheader pd-y-15 pd-md-l-20">
			<nav class="breadcrumb pd-0 mg-0 tx-12">
				<span class="breadcrumb-item active"><%=parentChannelPath%></span>
			</nav>
		</div>  -->
    <!--操作-->
    <div class="d-flex align-items-center justify-content-start mg-b-20 mg-sm-b-30">
        <div class="btn-group mg-l-10 hidden-xs-down mg-l-auto">
            <a href="javascript:;" class="btn btn-outline-info" onClick="addArow();">添加</a>
            <a href="javascript:;" class="btn btn-outline-info" onClick="delItem();">删除</a>
            <%--<a href="javascript:;" class="btn btn-outline-info" onClick="editDocument1();">编辑</a>--%>
        </div>
        <!-- btn-group -->
        <%
            int S_UserID = 0;
            long weightTime = 0;
            int IsActive = 1;
            if(IsDelete==1) IsActive=0;
//尺码
//System.out.println("time:"+weightTime);
            String Table = "relation_"+channelid+"_"+link_channelid;
//System.out.println("table="+Table);
            String ListSql = "select * from " + Table;
            String CountSql = "select count(*) from "+Table;
            String WhereSql = " where GlobalID="+globalid;
            ListSql += WhereSql + " order by OrderNumber desc";
            CountSql += WhereSql;
            int listnum = rowsPerPage;
            if(listType==2) listnum = cols*rows;

            TableUtil tu = channel.getTableUtil();
            ResultSet Rs = tu.List(ListSql,CountSql,currPage,listnum);
            String ids = "";
            while(Rs.next())
            {
                int childglobalid = Rs.getInt("ChildGlobalID");
                if(ids.length()>0)
                    ids += "," + childglobalid + "";
                else
                    ids += childglobalid + "";
            }
            tu.closeRs(Rs);
            int TotalPageNumber = tu.pagecontrol.getMaxPages();
            int TotalNumber = tu.pagecontrol.getRowsCount();
            Document doc = null;
            ArrayList<Document> sizeArray= new ArrayList<>();
            System.out.println(ids);
            ArrayList<Document> psizeinfoArray= new ArrayList<>();
            String sizeids= "";
            if(ids.length()>0){
                String sizeid[]=ids.split(",");
                for (int i = 0; i < sizeid.length; i++) {
                    doc = CmsCache.getDocument(Integer.parseInt(sizeid[i]));
                    if(sizeids.length()>0)
                        sizeids += "," + doc.getId() + "";
                    else
                        sizeids += doc.getId() + "";
                    sizeArray.add(doc);
                }
            }
            int siteid = channel.getSiteID();
//尺码规格
            String psizeids = "";
            Channel channel_productsizeinfo = CmsCache.getChannel("s"+siteid+"_productsizeinfo");
            ListSql = "select * from "+channel_productsizeinfo.getTableName()+" where active=1 and status=1 and Parent="+globalid;
            Rs = tu.executeQuery(ListSql);
            while (Rs.next()){
                int childglobalid = Rs.getInt("GlobalID");
                if(psizeids.length()>0)
                    psizeids += "," + childglobalid + "";
                else
                    psizeids += childglobalid + "";
            }
            System.out.println("psizeids==="+psizeids);


            System.out.println(ids);
            if(psizeids.length()>0){
                String psizeid[]=psizeids.split(",");
                for (int i = 0; i < psizeid.length; i++) {
                    doc = CmsCache.getDocument(Integer.parseInt(psizeid[i]));
                    psizeinfoArray.add(doc);
                }
            }
        %>
        <%--<div class="btn-group hidden-sm-down">
        <%if(currPage>1){%>
            <a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
        <%}%>
        <%if(currPage<TotalPageNumber){%>
            <a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
        <%}%>
        </div>--%>
    </div>
    <!--操作-->

    <%--<%if(channel.hasRight(userinfo_session,1))//需要获取父独立频道权限导致功能不能使用，权限代码注释{%>--%>
    <!--列表-->
    <div class="br-pagebody pd-l-0 pd-r-0">
        <div class="card bd-0 shadow-base">

            <table class="table mg-b-0 viewpane_tbdoy " id="content-table">
                <thead>
                <tr class="tx-12-force">
                    <th class="wd-5p wd-40">选择</th>
                    <th class="wd-80">尺码规格定义</th>
                    <th class="wd-40">单位</th>
                    <%for (int i = 0; i < sizeArray.size(); i++) {%>
                    <th class="wd-30  th_size"><%=sizeArray.get(i).getTitle()%></th>
                    <%}%>
                    <th class=" ">备注</th>
                    <th class="wd-120 ">操作</th>
                </tr>
                </thead>
                <tbody>

                <%
                    for (int i = 0; i <psizeinfoArray.size() ; i++) {
                        doc = psizeinfoArray.get(i);
                        String title = doc.getTitle();
                        int id_ = doc.getId();
                        int gid = doc.getGlobalID();
                        System.out.println("gid="+gid);
                        int status = doc.getStatus();
                        String UseInfo  = doc.getValue("UseInfo");
                        Channel fsChannel = CmsCache.getChannel("s"+channel.getSiteID()+"_productdetailsizeinfo");
                        Table = fsChannel.getTableName();
                        String sql = "select * from "+Table+" where status=1 and active=1 and Parent="+globalid+" and ProductSizeId="+id_;
                        Rs = tu.executeQuery(sql);
                        int sdetailgid = 0;
                        ArrayList<Integer> fsdetaildarray = new ArrayList<>();
                        while(Rs.next()){
                            sdetailgid = Rs.getInt("GlobalID");
                            System.out.println("sdetailgid=="+sdetailgid);
                            fsdetaildarray.add(sdetailgid);
                        }
                        tu.closeRs(Rs);
                %>
                <tr no="<%=i%>" name="trnumber" itemid="<%=id_%>" productfabricinfoid="<%=id_%>" ordernumber="<%=id_%>" status="<%=status%>" globalid="<%=gid%>" id="" class="tide_item">
                    <td class="valign-middle">
                        <label class="ckbox mg-b-0">
                            <input type="checkbox" name="id" value=""><span></span>
                        </label>
                    </td>
                    <td  class="cm_size" >
                        <input class="form-control" disabled="disabled"  id="title<%=i%>"  value="<%=title%>"  type="text"  />
                    </td>
                    <td class="metre" >
                        <input class="form-control" disabled="disabled"  id="UseInfo<%=i%>"  value="<%=UseInfo%>"  type="text"  />
                    </td>
                    <%for (int j = 0; j < sizeArray.size(); j++) {
                        boolean flag = true;
                        for (int k = 0; k < fsdetaildarray.size(); k++) {
                            Document fsDoc = CmsCache.getDocument(fsdetaildarray.get(k));
                            if(sizeArray.get(j).getId() ==fsDoc.getIntValue("SizeInfoID")){%>
                    <td class="td_size">
                        <input class="form-control" disabled="disabled" name="sizeuse<%=i%>" id="size<%=i%><%=j%>" sizeid="<%=sizeArray.get(j).getId()%>" value="<%=fsDoc.getTitle()%>"  type="text" placeholder="定义" />
                    </td>
                    <%		flag = false;
                        break;
                    }}
                        if(flag){%>
                    <td class="td_size">
                        <input id="size<%=i%><%=j%>" disabled="disabled" name="sizeuse<%=i%>" class="form-control" sizeid="<%=sizeArray.get(j).getId()%>" value=""  type="text" placeholder="定义" />
                    </td>
                    <%	}

                    }%>
                    <td class="beizhu">
                        <input class="form-control" disabled="disabled"  type="text" id="Remark<%=i%>"   placeholder="备注"  value="<%=doc.getValue("Remark")%>"/>
                        <!--<textarea class="form-control" cols="1" ></textarea>-->
                    </td>
                    <td class="dropdown">
                        <a href="javascript:;" class="btn pd-0 mg-r-0 td-edia-a"><i class="fa fa-edit tx-18 handle-icon" aria-hidden="true"></i></a>
                        <a href="javascript:;" class="btn pd-0 mg-r-0 td-preview-a"><i class="fa fa-eye tx-18 handle-icon" aria-hidden="true"></i></a>
                        <a href="javascript:;" class="btn pd-0 mg-r-0 td-delete-a"><i class="fa fa-trash tx-18 handle-icon" aria-hidden="true"></i></a>
                    </td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
            <script>
                var page = {
                    id:'<%=id%>',
                    currPage: '<%=currPage%>',
                    rowsPerPage: '<%=rowsPerPage%>',
                    querystring: '<%=querystring%>',
                    TotalPageNumber: <%=TotalPageNumber%>
                };
            </script>

            <%if(TotalPageNumber>0){%>
            <!--分页-->
            <%--<div id="tide_content_tfoot">
                <label class="ckbox mg-b-0 mg-r-30 ">
                    <input type="checkbox" id="checkAll"><span></span>
                </label>
                <span class="mg-r-20 ">共<%=TotalNumber%>条</span>
                <span class="mg-r-20 "><%=currPage%>/<%=TotalPageNumber%>页</span>

                <%if(TotalPageNumber>1){%>
                <div class="jump_page ">
                    <span class="">跳至:</span>
                    <label class="wd-60 mg-b-0">
                        <input class="form-control" placeholder="" type="text" name="jumpNum" id="jumpNum">
                    </label>
                    <span class="">页</span>
                    <a href="javascript:jumpPage();" class="tx-14">Go</a>
                </div>
                <%}%>
                <%if(listType==1){%>
                <div class="each-page-num mg-l-auto">
                    <span class="">每页显示:</span>
                    <select name="rowsPerPage" class="form-control select2 wd-80" data-placeholder="" onChange="change('#rowsPerPage','<%=link_channelid%>');" id="rowsPerPage">
                        <option value="10">10</option>
                        <option value="15">15</option>
                        <option value="20">20</option>
                        <option value="25">25</option>
                        <option value="30">30</option>
                        <option value="50">50</option>
                        <option value="80">80</option>
                        <option value="100">100</option>
                        <option value="500">500</option>
                    </select>
                    <span class="">条</span>
                 </div>
                <%}
                if(listType==2){%>
                <%}%>
            </div>--%>
            <!--分页-->
            <%--<%}%>--%>
            <div class="table-page-info" style="display: none;">
                <div class="ckbox-parent">
                    <label class="ckbox mg-b-0">
                        <input type="checkbox" id="checkAll"><span></span>
                    </label>
                </div>
            </div>
            <%}else{%>
            <script type="text/javascript">
                var page={id:'<%=id%>',currPage:'<%=currPage%>',rowsPerPage:'<%=rowsPerPage%>',querystring:'<%=querystring%>',TotalPageNumber:0};
            </script>
            <%}%>
        </div>
    </div>
    <!--列表-->
    <script src="../lib/2018/popper.js/popper.js"></script>
    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../lib/2018/moment/moment.js"></script>
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
    <!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->
    <script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
    <script src="../lib/2018/select2/js/select2.min.js"></script>
    <script src="../common/2018/bracket.js"></script>
    <script>
        $("#checkAll,#checkAll_1").click(function()
        {
            var checkboxAll = $("#content-table tr").find("td:first-child").find(":checkbox") ;
            var existChecked = false ;
            for (var i=0;i<checkboxAll.length;i++) {
                if(!checkboxAll.eq(i).prop("checked")){
                    existChecked = true ;
                }
            }
            if(existChecked){
                checkboxAll.prop("checked",true);
            }else{
                checkboxAll.removeAttr("checked");
            }
            return;
        })

        $(function() {
            'use strict';

            //show only the icons and hide left menu label by default
            $('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');

            $(document).on('mouseover', function(e) {
                e.stopPropagation();
                if ($('body').hasClass('collapsed-menu')) {
                    var targ = $(e.target).closest('.br-sideleft').length;
                    if (targ) {
                        $('body').addClass('expand-menu');

                        // show current shown sub menu that was hidden from collapsed
                        $('.show-sub + .br-menu-sub').slideDown();

                        var menuText = $('.menu-item-label,.menu-item-arrow');
                        menuText.removeClass('d-lg-none');
                        menuText.removeClass('op-lg-0-force');

                    } else {
                        $('body').removeClass('expand-menu');

                        // hide current shown menu
                        $('.show-sub + .br-menu-sub').slideUp();

                        var menuText = $('.menu-item-label,.menu-item-arrow');
                        menuText.addClass('op-lg-0-force');
                        menuText.addClass('d-lg-none');
                    }
                }
            });

            $('.br-mailbox-list,.br-subleft').perfectScrollbar();

            $('#showMailBoxLeft').on('click', function(e) {
                e.preventDefault();
                if ($('body').hasClass('show-mb-left')) {
                    $('body').removeClass('show-mb-left');
                    $(this).find('.fa').removeClass('fa-arrow-left').addClass('fa-arrow-right');
                } else {
                    $('body').addClass('show-mb-left');
                    $(this).find('.fa').removeClass('fa-arrow-right').addClass('fa-arrow-left');
                }
            });


            $(".btn-search").click(function() {
                $(".search-box").toggle(100);
            })

            // Datepicker
            $('.fc-datepicker').datepicker({
                showOtherMonths: true,
                selectOtherMonths: true,
                dateFormat: "yy-mm-dd"
            });

        });


        function ChangeTop(channelid,way){
            var obj=getCheckbox();
            if(obj.length==0){
                alert("请先选择要置顶的文档！");
                return;
            }

            var message = "确实要置顶这"+obj.length+"项吗？";
            /* if(way==2){
                 message = "确实要取消这"+obj.length+"项的置顶吗？";
             }
             */
            if(!confirm(message)){
                return;
            }

            $.ajax({
                type: "GET",
                url: "../content/changetop.jsp",
                data: {id:channelid,way:way,ids:obj.id},
                success: function(msg){
                    // alert(msg);
                    location.reload();
                }
            });
        }


        function CancleTop(channelid,way,itemid){
            /*var obj=getCheckbox();
            if(obj.length==0){
                alert("请先选择要置顶的文档！");
                return;
            }
            */
            var message = "确实要取消这篇文章的置顶吗？";
            /* if(way==2){
                 message = "确实要取消这"+obj.length+"项的置顶吗？";
             }
             */
            if(!confirm(message)){
                return;
            }

            $.ajax({
                type: "GET",
                url: "../content/changetop.jsp",
                data: {id:channelid,way:way,ids:itemid},
                success: function(msg){
                    // alert(msg);
                    location.reload();
                }
            });
            <%if(IsWeight==1){%>WeightAddColor();<%} if(IsComment==1) out.println("showCommentCount('"+gids+"');");%>
        }



        var	dialog = new top.TideDialog();
        //点击编辑
        $("body").delegate(".td-edia-a","click",function(){
            var _tr = $(this).parents("tr") ;
            _tr.find("td input[type='text']").attr("disabled",false);
            $(this).removeClass("td-edia-a").addClass("td-save-a").html('<i class="fa fa-floppy-o tx-18 handle-icon"></i>') ;
            return false;
        })
        //点击保存
        $("body").delegate(".td-save-a","click",function(){
            var _this = $(this);
            var _tr = $(this).parents("tr") ;
            var trt = $(this).parent().parent();
            var i = $(this).parent().parent().attr("no");
            let productFabricInfoId = $(this).parent().parent().attr("productfabricinfoid");
            var Parent = globalid;
            var Remark = $("#Remark"+i).val();
            var Title = $("#title"+i).val();
            var useInfo = $("#UseInfo"+i).val();
            var j = document.getElementsByName("sizeuse"+i).length;
            var Data=[];
            for (let k = 0; k < j; k++) {
                var sizeid = $("#size"+i+k).attr("sizeid");
                var desc = $("#size"+i+k).val();
                Data.push({"sizeId": sizeid, "desc": desc});
            }
            //Data+="]";
            var dd = {};
            dd.productGlobalId = Parent ;
            dd.productSizeInfoId = productFabricInfoId  ;
            dd.remark = Remark ;
            dd.useInfo = useInfo ;
            dd.title = Title ;
            dd.data = Data;
            $.ajax({
                type:"post",
                url:"/tcenter_youka/productapi/sizeinfoadd",
                data:JSON.stringify(dd),
                dataType :"json",
                contentType: 'application/json',
                //headers: {'Content-Type': 'application/json'},
                //jsonp:"callback",
                success:function(data){
                    console.log(data);
                    if(data.code==200){
                        trt.attr("productfabricinfoid",data.data);
                        _tr.find("td input[type='text']").attr("disabled",true).attr("placeholder","");
                        _this.removeClass("td-save-a").addClass("td-edia-a").html('<i class="fa fa-edit tx-18 handle-icon"></i>') ;
                        dialog.showAlert( "保存成功！" );
                    }else{
                        commonPop(data.message);
                    }
                },
                error:function(){
                }
            });

        })
        function addArow() {
            var array ='<%=sizeids%>';
            var i=document.getElementsByName("trnumber").length;;
            var sizeid="";
            if(array.length>0){
                sizeid = array.split(",");
            }
            var html ='';
            html+='<tr no="'+i+'"  name="trnumber" itemid="" productfabricinfoid="0" ordernumber="" status="" globalid="" id="" class="tide_item">';
            html+='<td class="valign-middle"><label class="ckbox mg-b-0"><input type="checkbox" name="id"  value=""><span></span></label></td>';
            html+='<td  class="cm_size" ><input class="form-control"  id="title'+i+'"   type="text"  /></td>';
            html+='<td class="metre" ><input class="form-control"  id="UseInfo'+i+'" value="CM"  type="text"  /></td>';
            if(sizeid.length>0){
                for (let j = 0; j < sizeid.length; j++) {
                    html+='<td class="td_size"><input class="form-control" name="sizeuse'+(i)+'" id="size'+i+j+'" sizeid="'+sizeid[j]+'" value=""  type="text" placeholder="定义" /></td>';
                }
            }
            html+='<td class="beizhu"><input class="form-control"  id="Remark'+i+'" value=""  type="text" placeholder="备注" /></td>';
            html+='<td class="dropdown">';
            html+='<a href="javascript:;" class="btn pd-0 mg-r-0 td-save-a"><i class="fa fa-floppy-o tx-18 handle-icon" aria-hidden="true"></i></a>';
            html+='<a href="javascript:;" class="btn pd-0 mg-r-0 td-preview-a"><i class="fa fa-eye tx-18 handle-icon" aria-hidden="true"></i></a>';
            html+='<a href="javascript:;" class="btn pd-0 mg-r-0 td-delete-a"><i class="fa fa-trash tx-18 handle-icon" aria-hidden="true"></i></a>';
            html+='</td></tr>';
            $("tbody").append(html);
            top.adjustRelationIfa(<%=fieldgroup%>);
        }

        $("body").delegate(".td-delete-a","click",function(){
            var message = "确实要删除这项吗？";
            if(confirm(message)){
                var productFabricInfoId = $(this).parent().parent().attr("productfabricinfoid");
                $.ajax({
                    type:"get",
                    url:"/tcenter_youka/productapi/sizeinfodel?ProductSizeInfoIds="+productFabricInfoId,
                    success:function(data){
                        console.log(data);
                        if(data.code==200){
                            dialog.showAlert( "删除成功！" );
                            document.location.href=document.location.href;
                        }else{
                            commonPop(data.message);
                        }
                    }
                });
            }

        })

    </script>

</div>
<%if(channel.getListJS().length()>0){out.println("<script type=\"text/javascript\">");out.println(channel.getListJS());out.println("</script>");}%>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
<script>
    $(function () {
        //console.log(<%=fieldgroup%>)
        top.adjustRelationIfa(<%=fieldgroup%>);
    })
</script>
</body>

</html>
