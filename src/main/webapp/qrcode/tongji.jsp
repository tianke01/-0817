<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
    //设置频道id
    static int folder_ChannelID=16526;//文件夹频道
    static int code_ChannelID=16511;//二维码信息频道
    static int time_ChannelID=16512;//定时切换频道
    static int num_ChannelID=16513;//按次切换频道
%>
<%
    /**
     * 用途：二维码访问统计界面
     * 1,田轲 20200912 创建
     */
    int qr_codeId = getIntParameter(request,"qr_codeId");
    Document document = new Document(qr_codeId, code_ChannelID);
    String Title = document.getTitle();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
    <link href="../style/contextMenu.css" type="text/css" rel="stylesheet" />
    <link rel="stylesheet" href="layui/css/layui.css"  media="all">
    <style>
        .collapsed-menu .br-mainpanel-file {margin-left: 0;margin-top: 0;}
        table th,table td{border-collapse: collapse !important;text-align: center;}
        .nav-pills .nav-link:focus, .nav-pills .nav-link:hover{background-color:#e9ecef ;}
        .line-chart-box{background: #f3f3f3;}
        /*th{border-right: rgba(0,0,0,.11) solid 1px;}*/
        @media (max-width: 575px){
            table .hidden-xs-down {word-break: normal;}
        }
        /* css注释：对divcss5-right设置float:right即可让对象靠右浮动 */

    </style>

    <script src="../lib/2018/jquery/jquery.js"></script>
    <script type="text/javascript" src="../common/2018/common2018.js"></script>
    <!-- <script type="text/javascript" src="../common/common.js"></script> -->

    <script type="text/javascript" src="../common/jquery-ui-1.8.2.datepicker.min.js"></script>
    <script type="text/javascript" src="js/highcharts.js"></script>
    <script type="text/javascript" src="js/exporting.js"></script>
    <script>
        var qr_codeId = <%=qr_codeId%>;


        //自定义查询
        function check(types)
        {
            if(types==1){var begin = $("#begin1").val();var end = $("#end1").val();}
            if(types==2){var begin = $("#begin2").val();var end = $("#end2").val();}
            if(types==3){var begin = $("#begin3").val();var end = $("#end3").val();}
            if(types==4){var begin = $("#begin4").val();var end = $("#end4").val();}
            if(begin==""||end=="")
            {
                alert("请输入查询时间");
                return ;
            }
            getPeriodforEs(types,5,begin,end);
            $(".nav-item .nav-link").removeClass("active");
        }

        function setCss(types,number)
        {
            if(types==1){getPeriodforEs(types,number,begin1,end1);}
            if(types==2){getPeriodforEs(types,number,begin2,end2);}
            if(types==3){getPeriodforEs(types,number,begin3,end3);}
            if(types==4){getPeriodforEs(types,number,begin4,end4);}
            $("#begin1").val("");
            $("#end1").val("");
            $("#begin2").val("");
            $("#end2").val("");
            $("#begin3").val("");
            $("#end3").val("");
            $("#begin4").val("");
            $("#end4").val("");
        }

        function setTypes(types,number)
        {
            if(types==1){getPeriodforEs(types,number,begin1,end1);}
            if(types==2){getPeriodforEs(types,number,begin2,end2);}
            if(types==3){getPeriodforEs(types,number,begin3,end3);}
            if(types==4){getPeriodforEs(types,number,begin4,end4);}
            //getPeriodforEs(types,number,begin,end);
            $("#begin1").val("");
            $("#end1").val("");
            $("#begin2").val("");
            $("#end2").val("");
            $("#begin3").val("");
            $("#end3").val("");
            $("#begin4").val("");
            $("#end4").val("");
        }

        function getPeriodforEs(types,number,begin,end){
            $.ajax({
                url:"es_qr_code.jsp",
                data:'types='+types+'&number='+number+'&begin='+begin+'&end='+end+'&qr_codeId='+qr_codeId,
                type:'POST',
                dataType:"json",
                success: function (data) {
                    console.log(data);
                    var result=data.result.data;
                    if(data.status == 1){
                        if(result.length>0){
                            $(".search-result-no").hide();
                            $(".Rdferee_man_body").html("");
                            var str = "";
                            $.each(result, function (vi, va) {
                                str +='<tr>';
                                if(types==1){str += '<td class="">' + va.period +'</td>  ';}
                                if(types==2){str += '<td class="">' + va.access_address +'</td>  ';}
                                if(types==3){str += '<td class="">' + va.system_type +'</td>  ';}
                                if(types==4){str += '<td class="">' + va.access_source +'</td>  ';}
                                str += '<td class="">' + va.Page_visits +'</td>  ';
                                str += '<td class="">' + va.Visitors +'</td>  ';
                                str += '<td class="">' + va.percentage +'</td>  ';
                                str +='</tr>';
                            })
                            $(".Event_man_body").html(str);
                        }else{
                            $(".Event_man_body").html("无数据");
                            $(".search-result-no").show();
                        }
                    }
                },error: function (data) {
                    alert("获取数据失败");
                }
            });
        }






    </script>

</head>

<body class="collapsed-menu email" onload="setTypes(1,1);">
<div class="br-mainpanel br-mainpanel-file" id="js-source">
    <div class="card bd-0 shadow-base mg-t-20 pd-x-30 pd-t-30 pd-b-30">
        <div class=" bd-0 shadow-base">
            <div class="layui-tab layui-tab-card">
                <div style="height: 30px"><span style="font-size: 20px">二维码名称： <%=Title%></span></div>
                <ul class="layui-tab-title" >
                    <li class="layui-this" lay-id="11" onclick="setTypes(1,1);">按访问时间统计</li>
                    <li lay-id="22" onclick="setTypes(2,1);">按地区分布统计</li>
                    <li lay-id="33" onclick="setTypes(3,1);">按系统分布统计</li>
                    <li lay-id="44" onclick="setTypes(4,1);">按访问来源统计</li>
                </ul>
                <div class="layui-tab-content">
                    <div class="layui-tab-item layui-show">
                        <div class="d-flex align-items-center justify-content-start flex-wrap">
                            <div class="rounded d-flex align-items-center mg-r-20 flex-lg-nowrap">
                                <ul class="nav nav-pills flex-column flex-md-row rounded flex-lg-nowrap wd-300" id="nav-day1" role="tablist">
                                    <li class="nav-item mg-r-10 "><a class="nav-link bg-gray-200 pd-x-15 pd-y-8 active" name="today" data-toggle="tab" href="#" role="tab" aria-expanded="false" onclick="setCss(1,1);">今天</a></li>
                                    <li class="nav-item mg-r-10"><a class="nav-link bg-gray-200 pd-x-15 pd-y-8" name="yesteday" data-toggle="tab" href="#" role="tab" aria-expanded="false" onclick="setCss(1,2);">昨天</a></li>
                                    <li class="nav-item mg-r-10"><a class="nav-link bg-gray-200 pd-x-15 pd-y-8" name="week" data-toggle="tab" href="#" role="tab" aria-expanded="false" onclick="setCss(1,3);">最近7天</a></li>
                                    <li class="nav-item"><a class="nav-link bg-gray-200 pd-x-15 pd-y-8" name="month" data-toggle="tab" href="#" role="tab" aria-expanded="true" onclick="setCss(1,4);">近30天</a></li>
                                </ul>
                            </div>

                            <div class="mg-r-20 d-flex align-items-center" >
                                <span class="mg-r-2">时间区间: </span>
                                <div class="wd-160 mg-r-10 search-item">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
                                        <input type="text" class="layui-input" id="begin1" placeholder="yyyy-MM-dd" name="startDate">
                                    </div>
                                </div>
                                <div class="wd-20 mg-r-5 ht-40 d-flex align-items-center justify-content-start">至</div>
                                <div class="wd-160 mg-r-10 search-item">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
                                        <input type="text" class="layui-input" id="end1" placeholder="yyyy-MM-dd" name="endDate">
                                    </div>
                                </div>
                            </div>
                            <input style="float: right" type="submit" onclick="check(1);" name="Submit" value="查询" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14">
                        </div>
                        <div class="card bd-0 shadow-base mg-t-15 ">
                            <table class="table mg-b-0 " id="content-table1">
                                <thead>
                                <tr class="bg-gray-200">
                                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">时间分布</th>
                                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">页面访问次数</th>
                                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down" >访客量</th>
                                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">访客次数占比</th>
                                </tr>
                                </thead>
                                <tbody class="Event_man_body">
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="layui-tab-item">
                        <div class="d-flex align-items-center justify-content-start flex-wrap">
                            <div class="rounded d-flex align-items-center mg-r-20 flex-lg-nowrap">
                                <ul class="nav nav-pills flex-column flex-md-row rounded flex-lg-nowrap wd-300" id="nav-day2" role="tablist">
                                    <li class="nav-item mg-r-10 "><a class="nav-link bg-gray-200 pd-x-15 pd-y-8 active" name="today" data-toggle="tab" href="#" role="tab" aria-expanded="false" onclick="setCss(2,1);">今天</a></li>
                                    <li class="nav-item mg-r-10"><a class="nav-link bg-gray-200 pd-x-15 pd-y-8" name="yesteday" data-toggle="tab" href="#" role="tab" aria-expanded="false" onclick="setCss(2,2);">昨天</a></li>
                                    <li class="nav-item mg-r-10"><a class="nav-link bg-gray-200 pd-x-15 pd-y-8" name="week" data-toggle="tab" href="#" role="tab" aria-expanded="false" onclick="setCss(2,3);">最近7天</a></li>
                                    <li class="nav-item"><a class="nav-link bg-gray-200 pd-x-15 pd-y-8" name="month" data-toggle="tab" href="#" role="tab" aria-expanded="true" onclick="setCss(2,4);">近30天</a></li>
                                </ul>
                            </div>

                            <div class="mg-r-20 d-flex align-items-center" >
                                <span class="mg-r-2">时间区间: </span>
                                <div class="wd-160 mg-r-10 search-item">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
                                        <input type="text" class="layui-input" id="begin2" placeholder="yyyy-MM-dd" name="startDate">
                                    </div>
                                </div>
                                <div class="wd-20 mg-r-5 ht-40 d-flex align-items-center justify-content-start">至</div>
                                <div class="wd-160 mg-r-10 search-item">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
                                        <input type="text" class="layui-input" id="end2" placeholder="yyyy-MM-dd" name="endDate">
                                        <!--<input type="text" class="form-control fc-datepicker CreateDate search-time" placeholder="YYYY-MM-DD" name="endDate" value="" id="end">-->
                                    </div>
                                </div>
                            </div>
                            <input style="float: right" type="submit" onclick="check(2);" name="Submit" value="查询" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14">
                        </div>
                        <div class="card bd-0 shadow-base mg-t-15 ">
                            <table class="table mg-b-0 " id="content-table2">
                                <thead>
                                <tr class="bg-gray-200">
                                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">来源地域</th>
                                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">页面访问次数</th>
                                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down" >访客量</th>
                                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">访客次数占比</th>
                                </tr>
                                </thead>
                                <tbody class="Event_man_body">
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="layui-tab-item">
                        <div class="d-flex align-items-center justify-content-start flex-wrap">
                            <div class="rounded d-flex align-items-center mg-r-20 flex-lg-nowrap">
                                <ul class="nav nav-pills flex-column flex-md-row rounded flex-lg-nowrap wd-300" id="nav-day3" role="tablist">
                                    <li class="nav-item mg-r-10 "><a class="nav-link bg-gray-200 pd-x-15 pd-y-8 active" name="today" data-toggle="tab" href="#" role="tab" aria-expanded="false" onclick="setCss(3,1);">今天</a></li>
                                    <li class="nav-item mg-r-10"><a class="nav-link bg-gray-200 pd-x-15 pd-y-8" name="yesteday" data-toggle="tab" href="#" role="tab" aria-expanded="false" onclick="setCss(3,2);">昨天</a></li>
                                    <li class="nav-item mg-r-10"><a class="nav-link bg-gray-200 pd-x-15 pd-y-8" name="week" data-toggle="tab" href="#" role="tab" aria-expanded="false" onclick="setCss(3,3);">最近7天</a></li>
                                    <li class="nav-item"><a class="nav-link bg-gray-200 pd-x-15 pd-y-8" name="month" data-toggle="tab" href="#" role="tab" aria-expanded="true" onclick="setCss(3,4);">近30天</a></li>
                                </ul>
                            </div>

                            <div class="mg-r-20 d-flex align-items-center" >
                                <span class="mg-r-2">时间区间: </span>
                                <div class="wd-160 mg-r-10 search-item">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
                                        <input type="text" class="layui-input" id="begin3" placeholder="yyyy-MM-dd" name="startDate">
                                    </div>
                                </div>
                                <div class="wd-20 mg-r-5 ht-40 d-flex align-items-center justify-content-start">至</div>
                                <div class="wd-160 mg-r-10 search-item">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
                                        <input type="text" class="layui-input" id="end3" placeholder="yyyy-MM-dd" name="endDate">
                                        <!--<input type="text" class="form-control fc-datepicker CreateDate search-time" placeholder="YYYY-MM-DD" name="endDate" value="" id="end">-->
                                    </div>
                                </div>
                            </div>
                            <input style="float: right" type="submit" onclick="check(3);" name="Submit" value="查询" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14">
                        </div>
                        <div class="card bd-0 shadow-base mg-t-15 ">
                            <table class="table mg-b-0 " id="content-table3">
                                <thead>
                                <tr class="bg-gray-200">
                                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">系统类型</th>
                                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">页面访问次数</th>
                                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down" >访客量</th>
                                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">访客次数占比</th>
                                </tr>
                                </thead>
                                <tbody class="Event_man_body">
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="layui-tab-item">
                        <div class="d-flex align-items-center justify-content-start flex-wrap">
                            <div class="rounded d-flex align-items-center mg-r-20 flex-lg-nowrap">
                                <ul class="nav nav-pills flex-column flex-md-row rounded flex-lg-nowrap wd-300" id="nav-day4" role="tablist">
                                    <li class="nav-item mg-r-10 "><a class="nav-link bg-gray-200 pd-x-15 pd-y-8 active" name="today" data-toggle="tab" href="#" role="tab" aria-expanded="false" onclick="setCss(4,1);">今天</a></li>
                                    <li class="nav-item mg-r-10"><a class="nav-link bg-gray-200 pd-x-15 pd-y-8" name="yesteday" data-toggle="tab" href="#" role="tab" aria-expanded="false" onclick="setCss(4,2);">昨天</a></li>
                                    <li class="nav-item mg-r-10"><a class="nav-link bg-gray-200 pd-x-15 pd-y-8" name="week" data-toggle="tab" href="#" role="tab" aria-expanded="false" onclick="setCss(4,3);">最近7天</a></li>
                                    <li class="nav-item"><a class="nav-link bg-gray-200 pd-x-15 pd-y-8" name="month" data-toggle="tab" href="#" role="tab" aria-expanded="true" onclick="setCss(4,4);">近30天</a></li>
                                </ul>
                            </div>

                            <div class="mg-r-20 d-flex align-items-center" >
                                <span class="mg-r-2">时间区间: </span>
                                <div class="wd-160 mg-r-10 search-item">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
                                        <input type="text" class="layui-input" id="begin4" placeholder="yyyy-MM-dd" name="startDate">
                                        <!--<input type="text" class="form-control fc-datepicker CreateDate search-time" placeholder="YYYY-MM-DD" name="startDate" value="" id="begin">-->
                                    </div>
                                </div>
                                <div class="wd-20 mg-r-5 ht-40 d-flex align-items-center justify-content-start">至</div>
                                <div class="wd-160 mg-r-10 search-item">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
                                        <input type="text" class="layui-input" id="end4" placeholder="yyyy-MM-dd" name="endDate">
                                        <!--<input type="text" class="form-control fc-datepicker CreateDate search-time" placeholder="YYYY-MM-DD" name="endDate" value="" id="end">-->
                                    </div>
                                </div>
                            </div>
                            <input style="float: right" type="submit" onclick="check(4);" name="Submit" value="查询" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14">
                        </div>
                        <div class="card bd-0 shadow-base mg-t-15 ">
                            <table class="table mg-b-0 " id="content-table4">
                                <thead>
                                <tr class="bg-gray-200">
                                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">访问来源</th>
                                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">页面访问次数</th>
                                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down" >访客量</th>
                                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">访客次数占比</th>
                                </tr>
                                </thead>
                                <tbody class="Event_man_body">

                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- br-pageheader -->
    <!--列表-->
    <div class="br-pagebody pd-x-0-force mg-t-0-force">
        <div class="card shadow-base">
            <div class="pd-x-30 pd-t-30 pd-b-15">

            </div>
        </div>


    </div>
    <!--列表-->


    <script src="../lib/2018/popper.js/popper.js"></script>
    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../lib/2018/moment/moment.js"></script>
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>

    <script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
    <script src="../lib/2018/select2/js/select2.min.js"></script>
    <script src="../common/2018/bracket.js"></script>
    <script src="../common/2018/echarts.common.min.js"></script>
    <script src="layui/layui.js" charset="utf-8"></script>
    <script>
        layui.use('element', function(){
            var $ = layui.jquery
                ,element = layui.element; //Tab的切换功能，切换事件监听等，需要依赖element模块
        });
        layui.use('laydate', function(){
            var laydate = layui.laydate;

            //常规用法
            laydate.render({
                elem: '#end1'
            });
            laydate.render({
                elem: '#end2'
            });
            laydate.render({
                elem: '#end3'
            });
            laydate.render({
                elem: '#end4'
            });
            laydate.render({
                elem: '#begin1'
            });
            laydate.render({
                elem: '#begin2'
            });
            laydate.render({
                elem: '#begin3'
            });
            laydate.render({
                elem: '#begin4'
            });
        });
    </script>



</div>

</body>

</html>
