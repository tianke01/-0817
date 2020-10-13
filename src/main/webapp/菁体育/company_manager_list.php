<?php
/**
 * 获取全部企业号 (V 3.0 )
 * @author liuxin 2018-03-24
 */
// error_reporting(E_ALL);
// ini_set('display_errors','On');
include('./util/common.php');

// 接收参数
// 客户端来源
$site = empty($_REQUEST['site'])?$_TIDE['site']:(int)$_REQUEST['site'];
// 登录标识(如果为已注册用户则获取话题分类关注状态)
$session = empty($_REQUEST['session'])?"":html_strips_trim($_REQUEST['session']);
// 企业分类编号(获取指定企业分类下的相关企业号)
$category_id = empty($_REQUEST['category_id'])?0:(int)$_REQUEST['category_id'];
$page 			= empty($_REQUEST['page'])?1:(int)$_REQUEST['page'];
$per_num		= empty($_REQUEST['per_num'])?2:(int)$_REQUEST['per_num'];
// 跨域
$callback = html_strips_trim($_REQUEST['callback']);

$watchstatus = 0;
if($session){
    sessionstart($session);
    if($_SESSION['userid']){
        //判断传值的site和session所属的用户site是否一致
        $sql_user  = 'select id from '.$_TIDE['cms_register'].' where Active=1 and siteflag='.$site.' and session="'.$session.'";';
        $query_user= $_SGLOBAL['db']->query($sql_user);
        $row_user  = $_SGLOBAL['db']->fetch_array($query_user);
        if(!$row_user){
            echo_arr(array('status'=>300,'message'=>'该用户不属于当前客户端'));
        }
    }
}
//获取到企业号管理的频道ID
$sql_channel  = 'select id from channel where id ='.$category_id.'; ';
$query_channel = $_SGLOBAL['db']->query($sql_channel);
$row_channel  = $_SGLOBAL['db']->fetch_array($query_channel);
if(!$row_channel['id']){
    echo_arr(array('status'=>500,'message'=>'获取不到企业号管理频道'));
}else{
    //获取到企业管理频道下的指定子频道（分类）
    $start = ($page-1)*$per_num;
    $tb_manager = $_TIDE['cms_s_manager_start'].$site.$_TIDE['cms_s_manager_end'];
    $sql_bemanager = 'select id,Title,company_id,Photo,Virtualconcern from '.$tb_manager.' where Active=1 and Status=1  and Category='.$category_id.'  limit '.$start.','.$per_num.';';
    $query_bemanager = $_SGLOBAL['db']->query($sql_bemanager);
    $l = 0;
    $list = array();
    //企业号管理表名
    $tb_manager = $_TIDE['cms_s_manager_start'].$site.$_TIDE['cms_s_manager_end'];
    while($row_bemanager = $_SGLOBAL['db']->fetch_array($query_bemanager)){
        $list[$l]['title'] = $row_bemanager['Title'];
        $list[$l]['company_id'] = (int)$row_bemanager['company_id'];
        $list[$l]['photo'] = $row_bemanager['Photo'];
        $list[$l]['watchcount'] += (int)$row_bemanager['Virtualconcern'];
        if($_SESSION['userid']){
            //查询出本人对企业号的关注状态
            $sql_each = 'select id from '.$_TIDE['cms_community_userwatch'].' where Active=1 and Status=1 and siteflag='.$site.' and userid='.$_SESSION['userid'].' and becompanyid='.$row_bemanager['company_id'].';';
            $query_each = $_SGLOBAL['db']->query($sql_each);
            $row_each = $_SGLOBAL['db']->fetch_array($query_each);
            if($row_each){
                $list[$l]['watchstatus'] = 1;
            }else{
                $list[$l]['watchstatus'] = 0;
            }
        }else{
            $list[$l]['watchstatus'] = 0;
        }

        $l++;
    }
}

$arr = array('status'=>'1','message'=>'成功',"result"=>$list);
echo_arr($arr);exit;
