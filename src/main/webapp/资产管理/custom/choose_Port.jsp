<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.report.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page import="org.json.JSONObject" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
    //字段id关联频道选择弹窗
    String fieldname = getParameter(request,"fieldname");
    String fieldname2 = getParameter(request,"fieldname2");
    String chooseids = getParameter(request,"chooseids");
    long begin_time = System.currentTimeMillis();
    int id = Util.getIntParameter(request,"id");
    //int siteid = CommonUtil.getSiteByCompanyid(userinfo_session.getCompany()).getId();
    /*if("Classes".equals(fieldname)){
        id = CmsCache.getChannel("s"+siteid+"_productcategory").getId();
    }else if("Color".equals(fieldname)){
        id = CmsCache.getChannel("s"+siteid+"_colors_color").getId();
    }else if("UserCode".equals(fieldname)){
        id = CmsCache.getChannel("s"+siteid+"_school").getId();
    }else if("CustomId".equals(fieldname)){
        id = CmsCache.getChannel("s"+siteid+"_custom").getId();
    }else if("ClearIco".equals(fieldname)){
        id = CmsCache.getChannel("s"+siteid+"_washico").getId();
    }else if("ModelProductUser".equals(fieldname)||"ModelPushUser".equals(fieldname)||"TechnologyUser".equals(fieldname)||"Design".equals(fieldname)){
        id = CmsCache.getChannel("s"+siteid+"_personinfo").getId();
    }else if("SupplyId".equals(fieldname)){
        id = CmsCache.getChannel("s"+siteid+"_productcompanyinfo").getId();
    }else if("FabricCategory".equals(fieldname)){
        id = CmsCache.getChannel("s"+siteid+"_ingredientmain").getId();
    }else if("Customer".equals(fieldname)){
        id = CmsCache.getChannel("s"+siteid+"_custom").getId();
    }*/
    id = CmsCache.getChannel("s53_k_i_a").getId();
    int type=Util.getIntParameter(request,"type");
    int currPage = Util.getIntParameter(request,"currPage");
    int rowsPerPage = Util.getIntParameter(request,"rowsPerPage");
    int TotalPageNumber=0;
    String sortable = Util.getParameter(request,"sortable");
    if(currPage<1)
        currPage = 1;

    if(rowsPerPage==0)
        rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage",request.getCookies()));

    if(rowsPerPage<=0)
        rowsPerPage = 30;

    Channel channel = CmsCache.getChannel(id);

    String Extra1=channel.getExtra1();
    int vmsId=0;
    if(Extra1.length()>0&&Extra1!=null) {
        System.out.println("Extra1：" + Extra1);
        JSONObject jsonObject = new JSONObject(Extra1);
        vmsId = (int) jsonObject.get("vms");
    }
    Channel parentchannel = null;
    int ChannelID = channel.getId();
    int IsWeight=channel.getIsWeight();
    int	IsComment=channel.getIsComment();
    int	IsClick=channel.getIsClick();

    boolean listAll = false;

    if(channel.isTableChannel() && channel.getType2()==8) listAll = true;

    String S_Title			=	getParameter(request,"Title");
    String S_startDate		=	getParameter(request,"startDate");
    String S_endDate		=	getParameter(request,"endDate");
    String S_User			=	getParameter(request,"User");
    int S_IsIncludeSubChannel =	getIntParameter(request,"IsIncludeSubChannel");
    int S_Status			=	getIntParameter(request,"Status");
    int S_IsPhotoNews		=	getIntParameter(request,"IsPhotoNews");
    int S_OpenSearch		=	getIntParameter(request,"OpenSearch");
    int IsDelete			=	getIntParameter(request,"IsDelete");

    String querystring = "";
    querystring = "&Title="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&startDate="+S_startDate+"&endDate="+S_endDate+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete+"&type="+type;
    String querystring1 = "&startDate="+S_startDate+"&endDate="+S_endDate+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete+"&type="+type;
    String querystring2 = "&fieldname="+fieldname+"&chooseids="+chooseids+"&id="+id;
    String uri=request.getRequestURI();
    String path=request.getContextPath();
    int Status1			=	getIntParameter(request,"Status1");


%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="robots" content="noindex, nofollow">
    <link rel="Shortcut Icon" href="../favicon.ico">
    <title>TideCMS</title>
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">

    <link rel="stylesheet" href="../style/2018/bracket.css">
    <link rel="stylesheet" href="../style/2018/sidebar-menu-template.css">
    <link rel="stylesheet" href="../style/2018/common.css">
    <style>
        html,body{height:100%;}
        .br-mainpanel{margin-top: 0px;margin-left: 230px;}
        .br-subleft{left: 0 !important;top: 0 !important;}
        body{background: #fff;}
        .br-pageheader{background: #fff;}
        .collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
        .search-box {display: none;}
        .border-radius-5{border-radius: 5px;}
        .select2-container--default .select2-selection--single{ height: 30px; }
        .select2-container--default .select2-selection--single .select2-selection__arrow{height: 30px;}
        .search-content { padding: 10px 15px; min-height: auto;}
        #tide_content_tfoot1 {padding: .75rem;display: flex;border-top: none;align-items: center;color: #000;}
        td>label{cursor: pointer;}
    </style>

    <script src="../lib/2018/jquery/jquery.js"></script>
    <script src="../common/2018/common2018.js"></script>


</head>

<body class="collapsed-menu email">

<div class="bg-white modal-box">

    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">


        <div class="br-pageheader pd-y-15 pd-md-l-20">
            <nav class="breadcrumb pd-0 mg-0 tx-12">
                <span class="breadcrumb-item active">当前位置：<%=channel.getName()%></span>
            </nav>
            <div class="mg-l-auto">
                <a href="javascript:;" class="btn btn-primary mg-r-10 pd-x-10-force pd-y-5-force btn-search"><i class="fa fa-search mg-r-3"></i><span>检索</span></a>
            </div><!-- btn-group -->
        </div><!-- br-pageheader -->
        <%

            int S_UserID = 0;
            long weightTime = 0;
            int IsActive = 1;
            if(IsDelete==1) IsActive=0;

            if(!S_User.equals("")){
                TableUtil tu2 = new TableUtil();
                String sql2="select * from userinfo where Name='"+tu2.SQLQuote(S_User)+"'";
                ResultSet Rs2 = tu2.executeQuery(sql2);
                if(Rs2.next()){
                    S_UserID=Rs2.getInt("id");
                }else{
                    S_UserID=0;
                }
            }

            if(channel.getIsWeight()==1)
            {
                //权重排序
                java.util.Calendar nowDate = new java.util.GregorianCalendar();
                nowDate.set(Calendar.HOUR_OF_DAY,0);
                nowDate.set(Calendar.MINUTE,0);
                nowDate.set(Calendar.SECOND,0);
                nowDate.set(Calendar.MILLISECOND,0);
                weightTime = nowDate.getTimeInMillis()/1000;
            }

            String Table = channel.getTableName();

            String ListSql = "select id,Title,Weight,GlobalID,User,FROM_UNIXTIME(ModifiedDate) as ModifiedDate,Status,Category,User,Photo,SwitchName,PortNumber,RelevanceFacility";
            if(channel.getIsWeight()==1)
                ListSql += ",case when CreateDate>"+weightTime+" then (Weight+"+weightTime+") else CreateDate end  as newtime";
            ListSql += " from " + Table;
            String CountSql = "select count(*) from "+Table;


            if(channel.getType()==Channel.Category_Type)
            {
                ListSql += " where Category=" + channel.getId() + " and Active=" + IsActive;
                CountSql += " where Category=" + channel.getId() + " and Active=" + IsActive;
            }
            else if(channel.getType()==Channel.MirrorChannel_Type)
            {
                Channel linkChannel = channel.getLinkChannel();
                if(linkChannel.getType()==Channel.Category_Type)
                {
                    ListSql += " where Category=" + linkChannel.getId() + " and Active=" + IsActive;
                    CountSql += " where Category=" + linkChannel.getId() + " and Active=" + IsActive;
                }
                else
                {
                    ListSql += " where Category=0 and Active=" + IsActive;
                    CountSql += " where Category=0 and Active=" + IsActive;
                }
            }
            else
            {
                ListSql += " where "+ (!listAll?Table+".Category=0 and ":"")+" Active=" + IsActive;
                CountSql += " where "+(!listAll?Table+".Category=0 and ":"")+" Active=" + IsActive;
            }

            String WhereSql = "";

            if(!S_Title.equals("")){
                String tempTitle=S_Title.replaceAll("%","\\\\%");
                WhereSql += " and Title like '%" + channel.SQLQuote(tempTitle) + "%'";
            }
            if(!S_startDate.equals("")){
                long startTime=Util.getFromTime(S_startDate,"");
                WhereSql += " and CreateDate>="+startTime ;
            }
            if(!S_endDate.equals("")){
                long endTime=Util.getFromTime(S_endDate,"");
                WhereSql += " and CreateDate<"+(endTime+86400);
            }

            if(S_UserID>0)
            {
                WhereSql += " and User="+S_UserID;
            }

            if(S_IsPhotoNews==1)
                WhereSql += " and IsPhotoNews=1";
            if(S_Status!=0)
                WhereSql += " and Status=" + (S_Status-1);

            if(Status1!=0)
            {
                if(Status1==-1)
                    WhereSql += " and Status=0";
                else
                    WhereSql += " and Status=" + Status1;
            }

            WhereSql+= " and Status!=0 ";
            ListSql += WhereSql;
            CountSql += WhereSql;

            if(channel.getIsWeight()==1)
            {
                ListSql += " order by newtime desc,id desc";
            }
            else
            {
                ListSql += " order by OrderNumber desc,id desc";
            }
System.out.println(ListSql);
            TableUtil tu = new TableUtil();
            ResultSet Rs = tu.List(ListSql,CountSql,currPage,rowsPerPage);
            TotalPageNumber = tu.pagecontrol.getMaxPages();
            int TotalNumber = tu.pagecontrol.getRowsCount();
        %>

        <!--æç´¢-->
        <div class="search-box" style="display:none;">
            <div class="search-content bg-white">
                <form name="search_form" action="<%=uri%>?id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring1%><%=querystring2%>" method="post" onSubmit="document.search_form.OpenSearch.value='1';">
                    <div class="row">
                        <!--æ é¢-->
                        <div class="mg-r-10 search-item">
                            <input class="form-control search-title" placeholder="标题" type="text" name="Title" value=""  onClick="this.select()">
                        </div>
                        <div class="search-item mg-b-30">
                            <input type="submit" name="Submit" value="检索" class="btn btn-primary tx-size-xs">
                            <input type="hidden" name="OpenSearch" id="OpenSearch" value="1">
                        </div>
                    </div><!-- row -->

                </form>
            </div>
        </div><!--æç´¢-->

        <!--åè¡¨-->
        <div class="br-pagebody pd-x-15 mg-t-10 mg-b-15">
            <div class="card bd-0 shadow-base">

                <table class="table mg-b-0  ui-sortable" id="content-table">
                    <thead>
                    <tr>
                        <th class="wd-5p wd-60"><span class="pd-l-10">选择</span></th>
                        <th class="tx-12-force tx-mont tx-medium header">交换机名称</th>
                        <th class="tx-12-force tx-mont tx-medium header">模块</th>
                        <th class="tx-12-force tx-mont tx-medium header">端口号</th>
                        <th class="tx-12-force tx-mont tx-medium header">关联设备</th>
                        <th class="tx-12-force tx-mont tx-medium header">负责人</th>
                        <%--<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-120 wd-author header">码率</th>
                        <th class="tx-12-force wd-100 tx-mont tx-medium hidden-xs-down wd-80 header" style="text-align: center">预览</th>--%>
                    </tr>
                    </thead>
                    <tbody>

                    <%
                        int j = 0;

                        while(Rs.next())
                        {
                            int id_ = Rs.getInt("id");
                            int GlobalID = Rs.getInt("GlobalID");
                            int category = Rs.getInt("Category");
                            int user = Rs.getInt("User");
                            String Title	= convertNull(Rs.getString("Title"));
                            String SwitchName = convertNull(Rs.getString("SwitchName"));
                            String PortNumber = convertNull(Rs.getString("PortNumber"));
                            String RelevanceFacility = convertNull(Rs.getString("RelevanceFacility"));
                            int OrderNumber = TotalNumber-j-((currPage-1)*rowsPerPage);
                            j++;
                    %>
                    <tr class="tide_item" No="<%=j%>"   ItemID="<%=id_%>" OrderNumber="<%=OrderNumber%>"  GlobalID="<%=GlobalID%>" id="jTip<%=j%>_id">
                        <td class="valign-middle" align="center" valign="middle">
                            <%if(type==1){%>
                            <label class="rdiobox mg-b-0 mg-l-10">
                                <input type="radio" name="choose" value="<%=id_%>" title="<%=Title%>" SwitchName="<%=SwitchName%>" PortNumber="<%=PortNumber%>" RelevanceFacility="<%=RelevanceFacility%>"><span></span>
                            </label>
                            <%}else if(type==2){%>
                            <label class="ckbox mg-b-0 mg-l-10">
                                <input type="checkbox" name="choose" value="<%=id_%>" title="<%=Title%>" SwitchName="<%=SwitchName%>" PortNumber="<%=PortNumber%>" RelevanceFacility="<%=RelevanceFacility%>"><span></span>
                            </label>
                            <%}%>
                        </td>
                        <td class="hidden-xs-down" valign="middle"><%=SwitchName%></td>
                        <td class="hidden-xs-down" valign="middle"><%=Title%></td>
                        <td class="hidden-xs-down" valign="middle"><%=PortNumber%></td>
                        <td class="hidden-xs-down" valign="middle"><%=RelevanceFacility%></td>
                        <td class="dropdown hidden-xs-down" align="center" valign="middle">
                            <a href="javascript:view(<%=id_%>);" class="btn pd-0 mg-r-5" title="预览"><i class="fa fa-eye tx-18 handle-icon" aria-hidden="true"></i></a>
                        </td>
                    </tr>
                    <%}
                        tu.closeRs(Rs);
                    %>

                    </tbody>
                </table>
                <script>
                    var page={id:'<%=id%>',currPage:'<%=currPage%>',rowsPerPage:'<%=rowsPerPage%>',querystring:'<%=querystring%>',TotalPageNumber:<%=TotalPageNumber%>};
                    
                </script>

                <%if(TotalPageNumber>0){%>

                <!--分页-->
                <div id="tide_content_tfoot">
                    <span class="mg-r-20 ">共<%=TotalNumber%>条</span>
                    <span class="mg-r-20 "><%=currPage%>/<%=TotalPageNumber%>页</span>
                    <%if(TotalPageNumber>1){%>
                    <div class="jump_page ">
                        <span class="">跳至:</span>
                        <label class="wd-60 mg-b-0">
                            <input class="form-control" placeholder="" type="text" name="jumpNum" id="jumpNum">
                        </label>
                        <span class="">页</span>
                        <a href="javascript:goToPage();" class="tx-14">Go</a>
                    </div>
                    <%}%>

                    <div class="btn-group mg-l-auto">
                        <%if(currPage>1){%><a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a><%}%>
                        <%if(currPage<TotalPageNumber){%><a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a><%}%>
                    </div><!-- btn-group -->
                </div><!--分页-->
                <%}%>

            </div>
        </div><!--åè¡¨-->
        <div class="content_bot">
            <div class="left"></div>
            <div class="right"></div>
        </div>
    </div>

    <div class="btn-box" style="position: absolute;bottom: 0;width: 100%;">
        <div class="modal-footer" >
            <button name="submitButton" type="submit" class="btn btn-primary tx-size-xs"  id="submitButton" onclick="next();">确认</button>
            <button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
        </div>
    </div>

    <script src="../lib/2018/popper.js/popper.js"></script>
    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../lib/2018/moment/moment.js"></script>
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
    <script src="../lib/2018/peity/jquery.peity.js"></script>
    <script src="../lib/2018/datatables/jquery.dataTables.js"></script>
    <script src="../lib/2018/datatables-responsive/dataTables.responsive.js"></script>
    <script src="../lib/2018/select2/js/select2.min.js"></script>
    <script src="../common/2018/bracket.js"></script>
    <script>
        var currRowsPerPage = <%=rowsPerPage%>;
        var currPage = <%=currPage%>;
        var ChannelID = <%=id%>;
        var Parameter = "&ChannelID=" + ChannelID + "&rowsPerPage=" + currRowsPerPage + "&currPage=" + currPage;
        //查看
        function view(id) {
            if(typeof (id)=="undefined") {

                var obj = getCheckbox();
                id = obj.id;
                if (obj.length == 0) {
                    TideAlert("提示", "请先选择要查看的文档！");
                    return;
                }else if(obj.length>1){
                    TideAlert("提示","请选择一个查看的文件！");
                    return;
                }
            }
            window.open("../content/document_look.jsp?ItemID=" + id + Parameter);
        }
        var type=<%=type%>;
        var chooseids = '<%=chooseids%>';
        $(function () {
            if(chooseids!=""){
                if(type==1){
                    $('input:radio[value='+chooseids+']').prop("checked","checked");
                }else if(type==2){
                    var ids=chooseids.split(",");
                    for (let i = 0; i <ids.length ; i++) {
                        $('input:checkbox[value='+ids[i]+']').prop("checked","checked");
                    }
                }

            }
        })
        function next()
        {
            if(type==1){
                var checkedCheckbox = $('input:radio:checked');
                if (checkedCheckbox.length == 0) {
                    //dialog.showAlert("请选择图标！", "danger");
                    alert("请选择一项")
                    return false;
                } else {
                    var id = checkedCheckbox.val();
                    var SwitchName = checkedCheckbox.attr("SwitchName");
                    var title = checkedCheckbox.attr("title");
                    var PortNumber = checkedCheckbox.attr("PortNumber");
                    var RelevanceFacility = checkedCheckbox.attr("RelevanceFacility");
                    //console.log(personnelArr);
                    //top.TideDialogClose({suffix: '_1', recall: true, returnValue: {type:1,iconArr:iconArr}});
                    parent.$("#<%=fieldname%>").val(SwitchName+"-"+PortNumber);
                    parent.$("#<%=fieldname2%>").val(RelevanceFacility);
                    //parent.$("#tr_<%=fieldname%>").css("display","none");
                    //parent.$("#field_FabricCategory").css("display","none");
                    
                    parent.getDialog().Close();
                }
            }else if(type==2){
                var checkedCheckbox = $('input:checkbox:checked');
                if (checkedCheckbox.length == 0) {
                    //dialog.showAlert("请选择图标！", "danger");
                    alert("请选择一项")
                    return false;
                } else {
                    var ids = "";
                    var title = "";
                    checkedCheckbox.each(function(i,v){
                        if(ids.length==0){
                            ids+=$(v).val();
                            title+=$(v).attr("title");
                        }else{
                            ids+=","+$(v).val();
                            title+=","+$(v).attr("title");
                        }

                    });

                    //console.log(iconArr);
                    parent.$("#<%=fieldname%>").val(SwitchName+"-"+PortNumber);
                    parent.$("#<%=fieldname2%>").val(RelevanceFacility);
                    //top.TideDialogClose({suffix: '_1', recall: true, returnValue: {type:1,iconArr:iconArr}});
                    //parent.getDialog().Close({close:function(){parent.washIconIn(iconArr,ids)}});
                    parent.getDialog().Close();
                }
            }

        }


        $(".btn-search").click(function(){
            $(".search-box").toggle(0);
            //window.parent.setTimeoutIfa();
        })
        function gopage(currpage)
        {
            var href="<%=uri%>?currPage="+currpage+"&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%><%=querystring2%>";

            this.location = href;
        }
        function goToPage(){
            var num=jQuery("#jumpNum").val();
            if(num==""){
                alert("请输入数字!");
                jQuery("#jumpNum").focus();
                return;}
            var reg=/^[0-9]+$/;
            if(!reg.test(num)){
                alert("请输入数字!");
                jQuery("#jumpNum").focus();
                return;
            }
            if(num><%=TotalPageNumber%>)
                num=<%=TotalPageNumber%>;
            if(num<1)
                num=1;
            var href="<%=uri%>?currPage="+num+"&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%><%=querystring2%>";
            document.location.href=href;
        }


    </script>




</div>
</body>
</html>
