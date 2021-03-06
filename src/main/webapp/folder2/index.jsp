<%@ page language="java" contentType="text/html; charset=utf-8"
         pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="renderer" content="webkit">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="Shortcut Icon" href="../static/favicon.ico">
    <title>内容页</title>
    <link rel="stylesheet" type="text/css" href="./css/font-awesome.css">
    <link rel="stylesheet" type="text/css" href="./css/ionicons.css">
    <link rel="stylesheet" type="text/css" href="./css/perfect-scrollbar.css">
    <link rel="stylesheet" type="text/css" href="./css/jquery.switchButton.css">
    <link rel="stylesheet" type="text/css" href="./css/summernote-bs4.css">
    <link rel="stylesheet" type="text/css" href="./css/select2.min.css">
    <link rel="stylesheet" type="text/css" href="./css/common.css">
    <link rel="stylesheet" type="text/css" href="./css/jquery.tagit.css" />
    <link rel="stylesheet" type="text/css" href="./css/toggles-full.css" >
    <link rel="stylesheet" type="text/css" href="./css/jquery-ui.css" />
    <link rel="stylesheet" type="text/css" href="./css/jquery-ui-timepicker-addon.css" />
    <link rel="stylesheet" type="text/css" href="./css/jquery.dataTables.css">
    <link rel="stylesheet" type="text/css" href="./css/bracket.css">
    <style>
        .text-wrapper{
            top: 50%; left: 50%;
            transform: translate(-50%, -50%);
        }
        #haslivecode{
            display: none;
        }
        #nolivecode{
            display: none;
        }
    </style>
</head>
<body>
<!-- ########## START: MAIN PANEL ########## -->
<div class="br-mainpanel mg-l-0 mg-t-0">
    <div class="bg-white mg-10 pd-l-20 pd-r-20 pd-t-10" id="hasLivecode">
        <div class="list-header" style="display: flex;justify-content: space-between;">
            <div class="left" style="display: flex;align-items: center;">
                <label class="ckbox mg-b-0 mg-r-40 mg-l-10">
                    <input type="checkbox" name="checkAll">
                    <span>全选</span>
                </label>
                <a href="javascript:;" class="btn btn-light bg-gray-400 pd-4 mg-r-10 wd-80 tx-gray-800" id="headDelBtn">删除</a>
                <a href="javascript:;" class="btn btn-light bg-gray-400 pd-4 mg-r-10 wd-80 tx-gray-800" id="packDownload">打包下载</a>
                <a href="javascript:;" class="btn btn-light bg-gray-400 pd-4 mg-r-10 wd-80 tx-gray-800" id="moveLivecode">移动</a>
                <span style="display:none;">已选中x个二维码</span>
            </div>
            <div class="right" style="display: flex;align-items: center;">
                <div class="input-group mg-r-35">
                    <input type="text" class="form-control" id="searchText" placeholder="Search for...">
                    <span class="input-group-btn">
							<button class="btn bd bg-white tx-gray-600" type="button"><i class="fa fa-search"></i></button>
						</span>
                </div>
                <a href="javascript:;" class="btn btn-light bg-gray-400 tx-gray-800 addNewLivecodeBtn">+ 新建活码</a>
            </div>
        </div>
        <div class="mg-t-10">
            <table class="table mg-b-0">
                <tbody>
                <tr>
                    <td class="valign-middle">
                        <label class="ckbox mg-b-0">
                            <input type="checkbox" name="livecodeId" value="6">
                            <span></span>
                        </label>
                    </td>
                    <td class="valign-middle">
                        <div>二维码名称</div>
                        <div class="">2019.12.12 14:11</div>
                    </td>
                    <td class="valign-middle">
                        <span>今日扫描x次</span>
                        <span>累计扫描x次</span>
                    </td>
                    <td class="valign-middle">
                        <a href="javascript:;" class="livecodePre" data-url="">查看</a> | <a href="javascript:;">下载</a> 二维码
                    </td>
                    <td class="valign-middle">
                        <a href="javascript:;" class="livecodeStatistics">统计</a>
                    </td>
                    <td class="valign-middle">
                        <a href="javascript:;" class="editCurrLivecode" data-id="6">编辑</a>
                    </td>
                    <td class="valign-middle">
                        <a href="javascript:;" class="deleteCurrLivecode" data-id="6">删除</a>
                    </td>
                </tr>
                </tbody>
            </table>
            <div id="tide_content_tfoot">
                <label class="ckbox mg-b-0 mg-r-30 ">
                    <input type="checkbox" id="checkAll_1" name="checkAll"><span></span>
                </label>
                <span class="mg-r-20 ">共<span id="totalList">37</span>条</span>
                <span class="mg-r-20 "><span id="currPage">1</span>/<span id="totalPage">2</span>页</span>


                <div class="jump_page ">
                    <span class="">跳至:</span>
                    <label class="wd-60 mg-b-0">
                        <input class="form-control" placeholder="" type="text" name="jumpNum" id="jumpNum">
                    </label>
                    <span class="">页</span>
                    <a href="javascript:;" class="tx-14">Go</a>
                </div>


                <div class="each-page-num mg-l-auto">
                    <span class="">每页显示:</span>
                    <select class="form-control select2 wd-80">
                        <option value="5">5</option>
                        <option value="10">10</option>
                        <option value="15">15</option>
                        <option value="25">25</option>
                        <option value="30">30</option>
                        <option value="50">50</option>
                        <option value="80">80</option>
                        <option value="100">100</option>
                        <option value="200">200</option>
                        <option value="500">500</option>
                    </select>
                    <span class="">条</span>
                </div>
            </div>
        </div>
    </div>
    <div class="pos-fixed t-0 l-0 r-0 b-0 bg-white mg-10 text-center" id="noLivecode">
        <div class="text-wrapper pos-absolute">
            <p class="tx-20">该目录下还未创建过网址跳转活码</p>
            <p>选择新建活码，快速创建</p>
            <a href="javascript:;"
               class="btn btn-light pd-r-20 pd-l-20 addNewLivecodeBtn">+ 新建活码</a>
        </div>
    </div>
</div><!-- br-mainpanel -->
<!-- ########## END: MAIN PANEL ########## -->
<script src="./js/jquery.js"></script>
<script src="./js/common2018.js"></script>
<script src="./js/TideDialog2018.js"></script>
<script src="./js/jquery.dataTables.js"></script>
<script src="./js/toggles.min.js"></script>
<script src="./js/popper.js"></script>
<script src="./js/bootstrap.js"></script>
<script src="./js/perfect-scrollbar.jquery.js"></script>
<script src="./js/moment.js"></script>
<script src="./js/jquery-ui.js"></script>
<script src="./js/jquery.switchButton.js"></script>

<script src="./js/jquery.timepicker.js"></script>
<script src="./js/select2.min.js"></script>
<script src="./js/bracket.js"></script>
<script>
    class LiveCode {
        constructor() {
            this.hasLivecode = $('#hasLivecode');
            this.noLivecode = $('#noLivecode');
            this.addNewLivecodeBtn = $('.addNewLivecodeBtn');
            this.editCurrLivecode = $('.editCurrLivecode');
            this.livecodeIds = [];
            this.tbody = $('tbody');
            this.headDelBtn = $('#headDelBtn');
            this.packDownload = $('#packDownload');
            this.moveLivecode = $('#moveLivecode');
            this.checkAll = $('input[name="checkAll"]');
            this.limitSelect = $('#tide_content_tfoot select');
            this.jumpNum = $('#jumpNum');
            this.totalList = $('#totalList');
            this.currPage = $('#currPage');
            this.totalPage = $('#totalPage');
            this.searchText = $('#searchText');
            this.delLivecodeDialog = new TideDialog();
            this.livecodePreDialog = new TideDialog();
            this.page = 1;
            this.limit = 5;
            this.Title = '';
        }
        init() {
            let that = this;

            this.getData();
            this.checkAll.on('click', function() {
                if ($(this).is(':checked')) {
                    that.checkAll.each(function(index,item) {
                        $(item).prop('checked', true);
                    });
                    $("input[name='livecodeId']").each(function(index,item) {
                        $(item).prop('checked', true);
                    });
                } else {
                    that.checkAll.each(function(index,item) {
                        $(item).prop('checked', false);
                    });
                    $("input[name='livecodeId']").each(function(index,item) {
                        $(item).prop('checked', false);
                    });
                }
            })
            this.addNewLivecodeBtn.on('click', this.switchRegular);
            this.editCurrLivecode.on('click', function() {
                console.log($(this))
                window.location.href="livecodeEdit.html?type=0"
            });

            $('table').on('click', '.deleteCurrLivecode', function() {
                that.livecodeIds = $(this).data('id');
                // 显示弹窗，提示是否呀删除
                that.delLivecodeDialog.setWidth(320);
                that.delLivecodeDialog.setHeight(280);
                that.delLivecodeDialog.setUrl('livecodeDel.html');
                that.delLivecodeDialog.setTitle('确认删除这个二维码');
                that.delLivecodeDialog.show();
            });
            $('table').on('click', '.livecodePre', function() {
                // alert($(this).data('url'))
                that.livecodePreDialog.setWidth(320);
                that.livecodePreDialog.setHeight(300);
                that.livecodePreDialog.setUrl('livecodePre.html?livecodeUrl=' + $(this).data('url'));
                that.livecodePreDialog.setTitle('查看二维码');
                that.livecodePreDialog.show();
            });
            this.limitSelect.on('change', function() {
                that.limit = $(this).val();
                that.getData()
            });
            this.jumpNum.on('change', function() {
                that.page = $(this).val();
                that.currPage.text(that.page);
                that.getData()
            });
            this.searchText.on('change', function() {
                that.Title = $(this).val();
                that.page = 1;
                that.getData();
            });
            this.headDelBtn.on('click', function() {
                that.livecodeIds = [];
                console.log(that.livecodeIds)
                //获取所有选中的二维码id
                $('input[name="livecodeId"]').each(function(index, item) {
                    if ($(item).is(':checked')) {
                        that.livecodeIds.push($(item).val());
                    }
                })

                if (that.livecodeIds) {
                    // 显示弹窗，提示是否呀删除
                    that.delLivecodeDialog.setWidth(320);
                    that.delLivecodeDialog.setHeight(300);
                    that.delLivecodeDialog.setUrl('livecodeDel.html');
                    that.delLivecodeDialog.setTitle('确认删除这'+that.livecodeIds.length+'个二维码');
                    that.delLivecodeDialog.show();
                    that.livecodeIds = that.livecodeIds.join(',');
                }
            });
            this.packDownload.on('click', function() {
                that.livecodeIds = [];
                //获取所有选中的二维码id
                $('input[name="livecodeId"]').each(function(index, item) {
                    if ($(item).is(':checked')) {
                        that.livecodeIds.push($(item).val());
                    }
                })

                if (that.livecodeIds) {
                    let r = confirm('打包下载这'+that.livecodeIds.length+'个二维码？');
                    if (r == true) {
                        that.livecodeIds = that.livecodeIds.join(',');
                        window.location.href = 'http://apptest.api-people.top/cms/renmin/pic_PLdownload.jsp?code_ids=' + that.livecodeIds
                    }
                }
            });
            this.moveLivecode.on('click', function() {
                alert('移动二维码')
            })
        }
        getData() {
            const _data = {
                Title: this.Title,
                page: this.page,
                limit: this.limit,
                folder_id: ''
            }
            let that = this;
            $.ajax({
                url: 'http://apptest.api-people.top/cms/renmin/qr_code_selectAll.jsp',
                type: 'get',
                data: _data,
                dataType: 'json',
                success: function(data) {
                    if (data.code == 200) {
                        if (data.count) {
                            that.totalList.text(data.count)
                        }
                        if (data.pageNumber) {
                            that.totalPage.text(data.maxPage)
                        }
                        let _html = ''
                        $.each(data.data, function(index, item) {
                            _html += '<tr>'+
                                '<td class="valign-middle">'+
                                '<label class="ckbox mg-b-0">'+
                                '<input type="checkbox" name="livecodeId" value="'+item.id+'">'+
                                '<span></span>'+
                                '</label>'+
                                '</td>'+
                                '<td class="valign-middle">'+
                                '<div>'+item.Title+'</div>'+
                                '<div class="">'+item.CreateDate+'</div>'+
                                '</td>'+
                                '<td class="valign-middle">'+
                                '<span>今日扫描'+item.todayNum+'次</span>'+
                                '<span>累计扫描'+item.addNum+'次</span>'+
                                '</td>'+
                                '<td class="valign-middle">'+
                                '<a href="javascript:;" class="livecodePre" data-url="'+item.QR_code_location+'">查看</a> | <a href="http://apptest.api-people.top/cms/renmin/pic_PLdownload.jsp?QR_code_location='+item.QR_code_location+'">下载</a> 二维码'+
                                '</td>'+
                                '<td class="valign-middle">'+
                                '<a target="_blank" href="livecodeStatistics.html?id='+item.id+'">统计</a>'+
                                '</td>'+
                                '<td class="valign-middle">'+
                                '<a target="_blank" href="livecodeEdit.html?type='+item.type+'&permanent='+item.permanent+'&id='+item.id+'" data-url="'+item.QR_code_location+'" class="editCurrLivecode" data-id="6">编辑</a>'+
                                '</td>'+
                                '<td class="valign-middle">'+
                                '<a href="javascript:;" class="deleteCurrLivecode" data-id="'+item.id+'">删除</a>'+
                                '</td>'+
                                '</tr>';
                        })
                        that.tbody.html(_html)
                    } else {
                        alert(data.message)
                    }
                    that.whetherEmpty(true);
                },
                error: function(err) {

                }
            })
        }
        whetherEmpty(flag) {
            if (flag) {
                this.hasLivecode.show();
                this.noLivecode.hide();
            } else {
                this.hasLivecode.hide();
                this.noLivecode.show();
            }
        }
        switchRegular() {
            const reDialog = new TideDialog();
            reDialog.setWidth(450);
            reDialog.setHeight(350);
            reDialog.setUrl('switchRegular.html');
            reDialog.setTitle('选择切换规则类型');
            reDialog.show();
        }
        _deleteCurrLivecode() {
            let that = this;
            let _data = {
                code_ids: this.livecodeIds
            };
            $.ajax({
                url: 'http://apptest.api-people.top/cms/renmin/qr_code_delete.jsp',
                type: 'get',
                data: _data,
                dataType: 'json',
                success: function(data) {
                    if (data.code == 200) {
                        that.getData();
                    } else {
                        alert(data.message);
                    }
                },
                error: function(err) {
                    console.log(err)
                }
            })
        }
    }
    var liveCode = new LiveCode();
    liveCode.init();
</script>
</body>
</html>
