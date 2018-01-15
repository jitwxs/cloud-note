<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<head>
    <meta charset="UTF-8">
    <title>无道云笔记 - 后台</title>
    <link rel="stylesheet" href="${ctx}/css/admin_home.css">
    <link rel="stylesheet" href="${ctx}/css/bootstrap.css">

    <link rel="stylesheet" href="${ctx}/css/admin_iconfont.css">
    <link rel="stylesheet" href="${ctx}/css/toastr.css">

    <script src="${ctx}/js/jquery-3.2.1.min.js"></script>
    <script src="${ctx}/js/bootstrap.js"></script>
    <script src="${ctx}/js/admin_nav.js"></script>
    <script src="${ctx}/js/toastr.js"></script>
    <script src="${ctx}/js/echarts.js"></script>
    <script src="${ctx}/js/http.js"></script>
</head>

<!--侧边栏-->
<div class="nav">
    <!-- 汉堡图标 -->
    <div class="nav-top">
        <div id="mini" style="border-bottom:1px solid rgba(255,255,255,.1)"><img src="${ctx}/images/admin_mini.png" ></div>
    </div>
    <!--列表-->
    <ul>
        <!--网站管理-->
        <li class="nav-item">
            <a href="javascript:;">
                <!--网站配置的图标和文字-->
                <i class="my-icon nav-icon icon_1"></i>
                <span>网站信息</span>
                <i class="my-icon nav-more"></i>
            </a>
            <ul>
                <li><a href="${ctx}/admin/userInfo"><span>用户信息</span></a></li>
                <li><a href="javascript:;"><span>登陆时间</span></a></li>
                <li><a href="javascript:;"><span>文章分享</span></a></li>
                <li><a href="${ctx}/admin/systemLog"><span>系统日志</span></a></li>
                <li><a href="javascript:;"><span>系统设置</span></a></li>
            </ul>
        </li>

        <!--笔记管理-->
        <li class="nav-item">
            <a href="javascript:;">
                <i class="my-icon nav-icon icon_2"></i>
                <span>笔记管理</span>
                <i class="my-icon nav-more"></i>
            </a>
            <ul>
                <li><a href="javascript:;"><span>笔记审核</span></a></li>
                <li><a href="javascript:;"><span>分享管理</span></a></li>
                <li><a href="javascript:;"><span>笔记回收</span></a></li>
                <li><a href="javascript:;"><span>笔记日志</span></a></li>
            </ul>
        </li>

        <!--用户管理-->
        <li class="nav-item">
            <a href="javascript:;">
                <i class="my-icon nav-icon icon_3"></i>
                <span>用户管理</span>
                <i class="my-icon nav-more"></i>
            </a>
            <ul>
                <li><a href="javascript:;"><span>用户列表</span></a></li>
                <li><a href="javascript:;"><span>添加用户</span></a></li>
                <li><a href="javascript:;"><span>小黑屋</span></a></li>
            </ul>
        </li>

        <!--个人账户设置-->
        <li class="nav-item">
            <a href="javascript:;">
                <i class="my-icon nav-icon icon_4"></i>
                <span>账户设置</span>
                <i class="my-icon nav-more"></i>
            </a>
            <ul>
                <li><a href="javascript:;"><span>更改密码</span></a></li>
                <li><a href="${ctx}/logout"><span>注销登陆</span></a></li>
            </ul>
        </li>
    </ul>
</div>