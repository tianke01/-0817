<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page import="static tidemedia.cms.util.Util2.getIntParameter" %>
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
    int globalid = getIntParameter(request,"globalid");
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="Shortcut Icon" href="../favicon.ico">
    <title>创建赛制</title>
    <link rel="stylesheet" href="http://47.94.166.110:8888/tcenter/style/2018/bracket.css">
    <link rel="stylesheet" href="http://47.94.166.110:8888/tcenter/style/2018/common.css">
    <link rel="stylesheet" href="http://47.94.166.110:8888/tcenter/lib/2018/select2/css/select2.min.css">
    <link rel="stylesheet" href="http://47.94.166.110:8888/tcenter/lib/2018/font-awesome/css/font-awesome.css">
    <script src="http://47.94.166.110:8888/tcenter/lib/2018/jquery/jquery.js"></script>
    <script src="http://47.94.166.110:8888/tcenter/lib/2018/select2/js/select2.min.js"></script>

</head>

<body>
<!-- 主线时间 -->
<div class="card mg-t-15">
    <div class="card-body">
        <h5 class="card-title tx-18 tx-light">
            主线时间
            <a href="javascript:;" class="ft-right tx-12 J-fold-unfold">收缩</a>
        </h5>
        <div class="rounded table-responsive">
            <table class="table mg-b-0 bd-b">
                <tbody>
                <%
                    TideJson cdl_ChannelID = CmsCache.getParameter("cdl_ChannelID").getJson();
                    int CoincideTime = cdl_ChannelID.getInt("CoincideTime");
                    Channel channel= CmsCache.getChannel(16515);
                    String tableName = channel.getTableName();
                    String sql="select * from "+tableName+" where Active=1 and ParentId="+globalid;
                    System.out.println(sql);
                    TableUtil tu = new TableUtil();
                    ResultSet rs = tu.executeQuery(sql);
                    System.out.println("-------"+rs.next());
                    if(rs.next()){
                %>
                <tr>
                    <th class="wd-60" style="vertical-align: top;">
                        <div class="mg-b-10 mg-t-10">001</div>
                    </th>
                    <td>
                        <div class="clearfix mg-b-10 mg-t-10">
                            <span class="ft-left mg-r-5">主线名称：</span>
                            <input class="form-control ft-left wd-200 pd-4" placeholder="" type="text">
                        </div>
                        <div class="clearfix mg-b-10 mg-t-10">
                            <span class="ft-left mg-r-5">时间类型：</span>
                            <select class="competition-time1 wd-100">
                                <option value="0">赛时</option>
                                <option value="1">非赛时</option>
                            </select>
                            <select class="competition-time1 wd-95">
                                <option value="0">正计时</option>
                                <option value="0">倒计时</option>
                            </select>
                        </div>
                    </td>
                    <td>
                        <div class="clearfix mg-b-10 mg-t-10">
                            <span class="ft-left mg-r-5">主线时长：</span>
                            <input class="form-control ft-left wd-40 pd-4" value="12" placeholder="" type="text">
                            <span class="ft-left pd-x-5">时</span>
                            <input class="form-control ft-left wd-40 pd-4" value="90" placeholder="" type="text">
                            <span class="ft-left pd-x-5">分</span>
                            <input class="form-control ft-left wd-40 pd-4" value="120" placeholder="" type="text">
                            <span class="ft-left pd-x-5">秒</span>
                        </div>
                        <div class="clearfix mg-b-10 mg-t-10">
                            <span class="ft-left mg-r-5">复位时间：</span>
                            <input class="form-control ft-left wd-40 pd-4" value="12" placeholder="" type="text">
                            <span class="ft-left pd-x-5">时</span>
                            <input class="form-control ft-left wd-40 pd-4" value="90" placeholder="" type="text">
                            <span class="ft-left pd-x-5">分</span>
                            <input class="form-control ft-left wd-40 pd-4" value="120" placeholder="" type="text">
                            <span class="ft-left pd-x-5">秒</span>
                        </div>
                    </td>
                    <td>
                        <div class="clearfix mg-b-10 mg-t-10">
                            <span class="ft-left mg-r-5">起点时间：</span>
                            <input class="form-control ft-left wd-40 pd-4" value="12" placeholder="" type="text">
                            <span class="ft-left pd-x-5">时</span>
                            <input class="form-control ft-left wd-40 pd-4" value="90" placeholder="" type="text">
                            <span class="ft-left pd-x-5">分</span>
                            <input class="form-control ft-left wd-40 pd-4" value="120" placeholder="" type="text">
                            <span class="ft-left pd-x-5">秒</span>
                        </div>
                        <div class="clearfix mg-b-10 mg-t-10">
                            <span class="ft-left mg-r-5">时间溢出：</span>
                            <div class="ft-left">
                                <select class="competition-time1 wd-50">
                                    <option value="0">是</option>
                                    <option value="1">否</option>
                                </select>
                            </div>
                            <span class="ft-left mg-l-15">颜色：</span>
                            <input class="pd-0 mg-0 ht-25 wd-20 bd-0 bg-white ft-left" name="color" type="color" value="#fc0303">
                            <span class="ft-left mg-x-5">走</span>
                            <input class="pd-0 mg-0 ht-25 wd-20 bd-0 bg-white ft-left" name="color" type="color" value="#74f750">
                            <span class="ft-left mg-x-5">到</span>
                        </div>
                    </td>
                    <td>
                        <a href="javascript:;" class="ft-right J-del-time">删除</a>
                    </td>
                </tr>
                </tbody>
                <%
                    }else{

                    }
                    while (rs.next()){
                        String title = rs.getString("Title");
                        rs.getString("");
                    }
                    tu.closeRs(rs);
                %>
            </table>
            <div class="clearfix">
                <a href="javascript:;" class="ft-right mg-t-0 J-add-btn J-add-main-time">新增</a>
            </div>
        </div>
    </div>
</div>
<!-- 主线时间 end-->
<!-- 重合时间 -->
<div class="card mg-t-15">
    <div class="card-body">
        <h5 class="card-title tx-18 tx-light">
            重合时间
            <a href="javascript:;" class="ft-right tx-12 J-fold-unfold">收缩</a>
        </h5>
        <div class="rounded table-responsive">
            <table class="table mg-b-0 bd-b">
                <tbody>
                <tr>
                    <th class="wd-60" style="vertical-align: top;">
                        <div class="mg-b-10 mg-t-10">001</div>
                    </th>
                    <td>
                        <div class="clearfix mg-b-10 mg-t-10">
                            <span class="ft-left mg-r-5">主线名称：</span>
                            <input class="form-control ft-left wd-200 pd-4" placeholder="" type="text">
                        </div>
                        <div class="clearfix mg-b-10 mg-t-10">
                            <span class="ft-left mg-r-5">时间类型：</span>
                            <select class="competition-time1 wd-100">
                                <option value="0">赛时</option>
                                <option value="1">非赛时</option>
                            </select>
                            <select class="competition-time1 wd-95">
                                <option value="0">正计时</option>
                                <option value="0">倒计时</option>
                            </select>
                        </div>
                    </td>
                    <td>
                        <div class="clearfix mg-b-10 mg-t-10">
                            <span class="ft-left mg-r-5">重合时长：</span>
                            <input class="form-control ft-left wd-40 pd-4" value="12" placeholder="" type="text">
                            <span class="ft-left pd-x-5">时</span>
                            <input class="form-control ft-left wd-40 pd-4" value="90" placeholder="" type="text">
                            <span class="ft-left pd-x-5">分</span>
                            <input class="form-control ft-left wd-40 pd-4" value="120" placeholder="" type="text">
                            <span class="ft-left pd-x-5">秒</span>
                        </div>
                        <div class="clearfix mg-b-10 mg-t-10">
                            <span class="ft-left mg-r-5">复位时间：</span>
                            <input class="form-control ft-left wd-40 pd-4" value="12" placeholder="" type="text">
                            <span class="ft-left pd-x-5">时</span>
                            <input class="form-control ft-left wd-40 pd-4" value="90" placeholder="" type="text">
                            <span class="ft-left pd-x-5">分</span>
                            <input class="form-control ft-left wd-40 pd-4" value="120" placeholder="" type="text">
                            <span class="ft-left pd-x-5">秒</span>
                        </div>
                    </td>
                    <td>
                        <div class="clearfix mg-b-10 mg-t-10">
                            <span class="ft-left mg-r-5">起点时间：</span>
                            <input class="form-control ft-left wd-40 pd-4" value="12" placeholder="" type="text">
                            <span class="ft-left pd-x-5">时</span>
                            <input class="form-control ft-left wd-40 pd-4" value="90" placeholder="" type="text">
                            <span class="ft-left pd-x-5">分</span>
                            <input class="form-control ft-left wd-40 pd-4" value="120" placeholder="" type="text">
                            <span class="ft-left pd-x-5">秒</span>
                        </div>
                        <div class="clearfix mg-b-10 mg-t-10">
                            <span class="ft-left mg-r-5">时间溢出：</span>
                            <div class="ft-left">
                                <select class="competition-time1 wd-50">
                                    <option value="0">是</option>
                                    <option value="1">否</option>
                                </select>
                            </div>
                            <span class="ft-left mg-l-15">颜色：</span>
                            <input class="pd-0 mg-0 ht-25 wd-20 bd-0 bg-white ft-left" name="color" type="color" value="#fc0303">
                            <span class="ft-left mg-x-5">走</span>
                            <input class="pd-0 mg-0 ht-25 wd-20 bd-0 bg-white ft-left" name="color" type="color" value="#74f750">
                            <span class="ft-left mg-x-5">到</span>
                        </div>
                    </td>
                    <td>
                        <a href="javascript:;" class="ft-right J-del-time">删除</a>
                    </td>
                </tr>
                </tbody>
            </table>
            <div class="clearfix">
                <a href="javascript:;" class="ft-right mg-t-10 J-add-btn J-add-concide-time">新增</a>
            </div>
        </div>
    </div>
</div>
<!-- 重合时间 end-->
<!-- 非重合时间 -->
<div class="card mg-t-15">
    <div class="card-body">
        <h5 class="card-title tx-18 tx-light">
            非重合时间
            <a href="javascript:;" class="ft-right tx-12 J-fold-unfold">收缩</a>
        </h5>
        <div class="rounded table-responsive">
            <table class="table mg-b-0 bd-b">
                <tbody>
                <tr>
                    <th class="wd-60" style="vertical-align: top;">
                        <div class="mg-b-10 mg-t-10">001</div>
                    </th>
                    <td>
                        <div class="clearfix mg-b-10 mg-t-10">
                            <span class="ft-left mg-r-5">主线名称：</span>
                            <input class="form-control ft-left wd-200 pd-4" placeholder="" type="text">
                        </div>
                        <div class="clearfix mg-b-10 mg-t-10">
                            <span class="ft-left mg-r-5">时间类型：</span>
                            <select class="competition-time1 wd-100">
                                <option value="0">赛时</option>
                                <option value="1">非赛时</option>
                            </select>
                            <select class="competition-time1 wd-95">
                                <option value="0">正计时</option>
                                <option value="0">倒计时</option>
                            </select>
                        </div>
                    </td>
                    <td>
                        <div class="clearfix mg-b-10 mg-t-10">
                            <span class="ft-left mg-r-5">非重时长：</span>
                            <input class="form-control ft-left wd-40 pd-4" value="12" placeholder="" type="text">
                            <span class="ft-left pd-x-5">时</span>
                            <input class="form-control ft-left wd-40 pd-4" value="90" placeholder="" type="text">
                            <span class="ft-left pd-x-5">分</span>
                            <input class="form-control ft-left wd-40 pd-4" value="120" placeholder="" type="text">
                            <span class="ft-left pd-x-5">秒</span>
                        </div>
                        <div class="clearfix mg-b-10 mg-t-10">
                            <span class="ft-left mg-r-5">复位时间：</span>
                            <input class="form-control ft-left wd-40 pd-4" value="12" placeholder="" type="text">
                            <span class="ft-left pd-x-5">时</span>
                            <input class="form-control ft-left wd-40 pd-4" value="90" placeholder="" type="text">
                            <span class="ft-left pd-x-5">分</span>
                            <input class="form-control ft-left wd-40 pd-4" value="120" placeholder="" type="text">
                            <span class="ft-left pd-x-5">秒</span>
                        </div>
                    </td>
                    <td>
                        <div class="clearfix mg-b-10 mg-t-10">
                            <span class="ft-left mg-r-5">起点时间：</span>
                            <input class="form-control ft-left wd-40 pd-4" value="12" placeholder="" type="text">
                            <span class="ft-left pd-x-5">时</span>
                            <input class="form-control ft-left wd-40 pd-4" value="90" placeholder="" type="text">
                            <span class="ft-left pd-x-5">分</span>
                            <input class="form-control ft-left wd-40 pd-4" value="120" placeholder="" type="text">
                            <span class="ft-left pd-x-5">秒</span>
                        </div>
                        <div class="clearfix mg-b-10 mg-t-10">
                            <span class="ft-left mg-r-5">时间溢出：</span>
                            <div class="ft-left">
                                <select class="competition-time1 wd-50">
                                    <option value="0">是</option>
                                    <option value="1">否</option>
                                </select>
                            </div>
                            <span class="ft-left mg-l-15">颜色：</span>
                            <input class="pd-0 mg-0 ht-25 wd-20 bd-0 bg-white ft-left" name="color" type="color" value="#fc0303">
                            <span class="ft-left mg-x-5">走</span>
                            <input class="pd-0 mg-0 ht-25 wd-20 bd-0 bg-white ft-left" name="color" type="color" value="#74f750">
                            <span class="ft-left mg-x-5">到</span>
                        </div>
                    </td>
                    <td>
                        <a href="javascript:;" class="ft-right J-del-time">删除</a>
                    </td>
                </tr>
                </tbody>
            </table>
            <div class="clearfix">
                <a href="javascript:;" class="ft-right mg-t-10 J-add-btn J-add-no-concide-time">新增</a>
            </div>
        </div>
    </div>
</div>
<!-- 非重合时间 end-->
</body>
<script>
    $(".competition-time1").select2({
        minimumResultsForSearch: -1
    });

    // 展开与收起
    $('body').on('click', '.J-fold-unfold', function () {
        var T = $(this).parents('.card-body').find('table');
        var addBtn = $(this).parents('.card-body').find('.J-add-btn');
        if (T.is(':hidden')) {
            T.show();
            addBtn.show();
        } else {
            T.hide();
            addBtn.hide();
        }
    });

    // 删除
    $('body').on('click', '.J-del-time', function() {
        var currTr = $(this).parents('tr');
        var currTb = $(this).parents('tbody');
        currTr.remove();
    });

    // 新增 主线时间
    $('body').on('click', '.J-add-main-time', function () {
        var Tb = $(this).parent().parent().find('tbody');
        var TbLen = +Tb.children().length;
        //<div class="mg-b-10 mg-t-10">'$'{(TbLen+1).toString().padStart(3,'0')}</div>
        var Tr = `<tr>
              <th class="wd-60" style="vertical-align: top;">
                <div class="mg-b-10 mg-t-10"></div>
              </th>
              <td>
                <div class="clearfix mg-b-10 mg-t-10">
                  <span class="ft-left mg-r-5">主线名称：</span>
                  <input class="form-control ft-left wd-200 pd-4" placeholder="" type="text">
                </div>
                <div class="clearfix mg-b-10 mg-t-10">
                  <span class="ft-left mg-r-5">时间类型：</span>
                  <select class="competition-time1 wd-100">
                    <option value="0">赛时</option>
                    <option value="1">非赛时</option>
                  </select>
                  <select class="competition-time1 wd-95">
                    <option value="0">正计时</option>
                    <option value="0">倒计时</option>
                  </select>
                </div>
              </td>
              <td>
                <div class="clearfix mg-b-10 mg-t-10">
                  <span class="ft-left mg-r-5">主线时长：</span>
                  <input class="form-control ft-left wd-40 pd-4" value="12" placeholder="" type="text">
                  <span class="ft-left pd-x-5">时</span>
                  <input class="form-control ft-left wd-40 pd-4" value="90" placeholder="" type="text">
                  <span class="ft-left pd-x-5">分</span>
                  <input class="form-control ft-left wd-40 pd-4" value="120" placeholder="" type="text">
                  <span class="ft-left pd-x-5">秒</span>
                </div>
                <div class="clearfix mg-b-10 mg-t-10">
                  <span class="ft-left mg-r-5">复位时间：</span>
                  <input class="form-control ft-left wd-40 pd-4" value="12" placeholder="" type="text">
                  <span class="ft-left pd-x-5">时</span>
                  <input class="form-control ft-left wd-40 pd-4" value="90" placeholder="" type="text">
                  <span class="ft-left pd-x-5">分</span>
                  <input class="form-control ft-left wd-40 pd-4" value="120" placeholder="" type="text">
                  <span class="ft-left pd-x-5">秒</span>
                </div>
              </td>
              <td>
                <div class="clearfix mg-b-10 mg-t-10">
                  <span class="ft-left mg-r-5">起点时间：</span>
                  <input class="form-control ft-left wd-40 pd-4" value="12" placeholder="" type="text">
                  <span class="ft-left pd-x-5">时</span>
                  <input class="form-control ft-left wd-40 pd-4" value="90" placeholder="" type="text">
                  <span class="ft-left pd-x-5">分</span>
                  <input class="form-control ft-left wd-40 pd-4" value="120" placeholder="" type="text">
                  <span class="ft-left pd-x-5">秒</span>
                </div>
                <div class="clearfix mg-b-10 mg-t-10">
                  <span class="ft-left mg-r-5">时间溢出：</span>
                  <div class="ft-left">
                    <select class="competition-time1 wd-50">
                      <option value="0">是</option>
                      <option value="1">否</option>
                    </select>
                  </div>
                  <span class="ft-left mg-l-15">颜色：</span>
                  <input class="pd-0 mg-0 ht-25 wd-20 bd-0 bg-white ft-left" name="color" type="color" value="#fc0303">
                  <span class="ft-left mg-x-5">走</span>
                  <input class="pd-0 mg-0 ht-25 wd-20 bd-0 bg-white ft-left" name="color" type="color" value="#74f750">
                  <span class="ft-left mg-x-5">到</span>
                </div>
              </td>
              <td>
                <a href="javascript:;" class="ft-right J-del-time">删除</a>
              </td>
            </tr>`;
        Tb.append(Tr);
    });

    // 新增 重合时间
    $('body').on('click', '.J-add-concide-time', function () {
        var Tb = $(this).parent().parent().find('tbody');
        var TbLen = +Tb.children().length;
        //<div class="mg-b-10 mg-t-10">'$'{(TbLen+1).toString().padStart(3,'0')}</div>
        var Tr = `<tr>
              <th class="wd-60" style="vertical-align: top;">
                <div class="mg-b-10 mg-t-10"></div>
              </th>
              <td>
                <div class="clearfix mg-b-10 mg-t-10">
                  <span class="ft-left mg-r-5">主线名称：</span>
                  <input class="form-control ft-left wd-200 pd-4" placeholder="" type="text">
                </div>
                <div class="clearfix mg-b-10 mg-t-10">
                  <span class="ft-left mg-r-5">时间类型：</span>
                  <select class="competition-time1 wd-100">
                    <option value="0">赛时</option>
                    <option value="1">非赛时</option>
                  </select>
                  <select class="competition-time1 wd-95">
                    <option value="0">正计时</option>
                    <option value="0">倒计时</option>
                  </select>
                </div>
              </td>
              <td>
                <div class="clearfix mg-b-10 mg-t-10">
                  <span class="ft-left mg-r-5">重合时长：</span>
                  <input class="form-control ft-left wd-40 pd-4" value="12" placeholder="" type="text">
                  <span class="ft-left pd-x-5">时</span>
                  <input class="form-control ft-left wd-40 pd-4" value="90" placeholder="" type="text">
                  <span class="ft-left pd-x-5">分</span>
                  <input class="form-control ft-left wd-40 pd-4" value="120" placeholder="" type="text">
                  <span class="ft-left pd-x-5">秒</span>
                </div>
                <div class="clearfix mg-b-10 mg-t-10">
                  <span class="ft-left mg-r-5">复位时间：</span>
                  <input class="form-control ft-left wd-40 pd-4" value="12" placeholder="" type="text">
                  <span class="ft-left pd-x-5">时</span>
                  <input class="form-control ft-left wd-40 pd-4" value="90" placeholder="" type="text">
                  <span class="ft-left pd-x-5">分</span>
                  <input class="form-control ft-left wd-40 pd-4" value="120" placeholder="" type="text">
                  <span class="ft-left pd-x-5">秒</span>
                </div>
              </td>
              <td>
                <div class="clearfix mg-b-10 mg-t-10">
                  <span class="ft-left mg-r-5">起点时间：</span>
                  <input class="form-control ft-left wd-40 pd-4" value="12" placeholder="" type="text">
                  <span class="ft-left pd-x-5">时</span>
                  <input class="form-control ft-left wd-40 pd-4" value="90" placeholder="" type="text">
                  <span class="ft-left pd-x-5">分</span>
                  <input class="form-control ft-left wd-40 pd-4" value="120" placeholder="" type="text">
                  <span class="ft-left pd-x-5">秒</span>
                </div>
                <div class="clearfix mg-b-10 mg-t-10">
                  <span class="ft-left mg-r-5">时间溢出：</span>
                  <div class="ft-left">
                    <select class="competition-time1 wd-50">
                      <option value="0">是</option>
                      <option value="1">否</option>
                    </select>
                  </div>
                  <span class="ft-left mg-l-15">颜色：</span>
                  <input class="pd-0 mg-0 ht-25 wd-20 bd-0 bg-white ft-left" name="color" type="color" value="#fc0303">
                  <span class="ft-left mg-x-5">走</span>
                  <input class="pd-0 mg-0 ht-25 wd-20 bd-0 bg-white ft-left" name="color" type="color" value="#74f750">
                  <span class="ft-left mg-x-5">到</span>
                </div>
              </td>
              <td>
                <a href="javascript:;" class="ft-right J-del-time">删除</a>
              </td>
            </tr>`;
        Tb.append(Tr);
    });

    // 新增 非重合时间
    $('body').on('click', '.J-add-no-concide-time', function () {
        var Tb = $(this).parent().parent().find('tbody');
        var TbLen = +Tb.children().length;
        //<div class="mg-b-10 mg-t-10">'$'{(TbLen+1).toString().padStart(3,'0')}</div>
        var Tr = `<tr>
              <th class="wd-60" style="vertical-align: top;">

                <div class="mg-b-10 mg-t-10"></div>
              </th>
              <td>
                <div class="clearfix mg-b-10 mg-t-10">
                  <span class="ft-left mg-r-5">主线名称：</span>
                  <input class="form-control ft-left wd-200 pd-4" placeholder="" type="text">
                </div>
                <div class="clearfix mg-b-10 mg-t-10">
                  <span class="ft-left mg-r-5">时间类型：</span>
                  <select class="competition-time1 wd-100">
                    <option value="0">赛时</option>
                    <option value="1">非赛时</option>
                  </select>
                  <select class="competition-time1 wd-95">
                    <option value="0">正计时</option>
                    <option value="0">倒计时</option>
                  </select>
                </div>
              </td>
              <td>
                <div class="clearfix mg-b-10 mg-t-10">
                  <span class="ft-left mg-r-5">非重时长：</span>
                  <input class="form-control ft-left wd-40 pd-4" value="12" placeholder="" type="text">
                  <span class="ft-left pd-x-5">时</span>
                  <input class="form-control ft-left wd-40 pd-4" value="90" placeholder="" type="text">
                  <span class="ft-left pd-x-5">分</span>
                  <input class="form-control ft-left wd-40 pd-4" value="120" placeholder="" type="text">
                  <span class="ft-left pd-x-5">秒</span>
                </div>
                <div class="clearfix mg-b-10 mg-t-10">
                  <span class="ft-left mg-r-5">复位时间：</span>
                  <input class="form-control ft-left wd-40 pd-4" value="12" placeholder="" type="text">
                  <span class="ft-left pd-x-5">时</span>
                  <input class="form-control ft-left wd-40 pd-4" value="90" placeholder="" type="text">
                  <span class="ft-left pd-x-5">分</span>
                  <input class="form-control ft-left wd-40 pd-4" value="120" placeholder="" type="text">
                  <span class="ft-left pd-x-5">秒</span>
                </div>
              </td>
              <td>
                <div class="clearfix mg-b-10 mg-t-10">
                  <span class="ft-left mg-r-5">起点时间：</span>
                  <input class="form-control ft-left wd-40 pd-4" value="12" placeholder="" type="text">
                  <span class="ft-left pd-x-5">时</span>
                  <input class="form-control ft-left wd-40 pd-4" value="90" placeholder="" type="text">
                  <span class="ft-left pd-x-5">分</span>
                  <input class="form-control ft-left wd-40 pd-4" value="120" placeholder="" type="text">
                  <span class="ft-left pd-x-5">秒</span>
                </div>
                <div class="clearfix mg-b-10 mg-t-10">
                  <span class="ft-left mg-r-5">时间溢出：</span>
                  <div class="ft-left">
                    <select class="competition-time1 wd-50">
                      <option value="0">是</option>
                      <option value="1">否</option>
                    </select>
                  </div>
                  <span class="ft-left mg-l-15">颜色：</span>
                  <input class="pd-0 mg-0 ht-25 wd-20 bd-0 bg-white ft-left" name="color" type="color" value="#fc0303">
                  <span class="ft-left mg-x-5">走</span>
                  <input class="pd-0 mg-0 ht-25 wd-20 bd-0 bg-white ft-left" name="color" type="color" value="#74f750">
                  <span class="ft-left mg-x-5">到</span>
                </div>
              </td>
              <td>
                <a href="javascript:;" class="ft-right J-del-time">删除</a>
              </td>
            </tr>`;
        Tb.append(Tr);
    });
</script>

</html>
