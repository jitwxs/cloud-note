<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<head>
    <meta charset="UTF-8">
    <title>后台 - 无道云笔记</title>
    <link rel="stylesheet" href="${ctx}/css/admin_home.css">
    <link rel="stylesheet" href="${ctx}/css/bootstrap.css">
    <link rel="stylesheet" href="${ctx}/css/bootstrap-table.css">
    <link rel="stylesheet" href="${ctx}/css/bootstrap-theme.css">
    <link rel="stylesheet" href="${ctx}/css/admin_iconfont.css">
    <link rel="stylesheet" href="${ctx}/css/toastr.css">
    <link rel="stylesheet" href="${ctx}/css/simple-alert.css">

    <script src="${ctx}/js/jquery-3.2.1.min.js"></script>
    <script src="${ctx}/js/bootstrap.js"></script>
    <script src="${ctx}/js/bootstrap-table.js"></script>
    <script src="${ctx}/js/bootstrap-table-zh-CN.js"></script>
    <script src="${ctx}/js/tableExport.js"></script>
    <script src="${ctx}/js/bootstrap-table-export.js"></script>
    <script src="${ctx}/js/bootstrap-table-toolbar.js"></script>
    <script src="${ctx}/js/admin.js"></script>
    <script src="${ctx}/js/toastr.js"></script>
    <script src="${ctx}/js/simple-alert.js"></script>
    <script src="${ctx}/js/echarts.js"></script>
    <script src="${ctx}/js/http.js"></script>
</head>

<!-- 引入模态框 -->
<jsp:include page="logModel.jsp"/>

<!--侧边栏-->
<div class="nav nav-mini">
    <!-- 汉堡图标 -->
    <div class="nav-top">
        <div id="mini" style="border-bottom:1px solid rgba(255,255,255,.1)"><img src="${ctx}/images/admin_mini.png">
        </div>
    </div>
    <!--列表-->
    <ul>
        <%--首页--%>
        <li class="nav-item">
            <a href="${ctx}/admin/index">
                <!--网站配置的图标和文字-->
                <i class="my-icon nav-icon icon_7"></i>
                <span>首页</span>
                <i class="my-icon nav-more"></i>
            </a>
        </li>
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
                <li><a href="${ctx}/admin/loginInfo"><span>登陆信息</span></a></li>
                <li><a href="${ctx}/admin/shareInfo"><span>分享信息</span></a></li>
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
                <li><a href="${ctx}/admin/shareAudit"><span>分享审核</span></a></li>
                <li><a href="${ctx}/admin/noteLog"><span>笔记日志</span></a></li>
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
                <li><a href="${ctx}/admin/userList"><span>用户列表</span></a></li>
                <li><a href="${ctx}/admin/blackHome"><span>小黑屋</span></a></li>
                <li><a href="${ctx}/admin/userLog"><span>用户日志</span></a></li>
            </ul>
        </li>

        <!--网盘管理-->
        <li class="nav-item">
            <a href="javascript:;">
                <i class="my-icon nav-icon icon_4"></i>
                <span>网盘管理</span>
                <i class="my-icon nav-more"></i>
            </a>
            <ul>
                <li><a href="${ctx}/admin/panInfo"><span>网盘信息</span></a></li>
                <li><a href="${ctx}/admin/panLog"><span>网盘日志</span></a></li>
            </ul>
        </li>

        <!--通知管理-->
        <li class="nav-item">
            <a href="javascript:;">
                <i class="my-icon nav-icon icon_5"></i>
                <span>消息管理</span>
                <i class="my-icon nav-more"></i>
            </a>
            <ul>
                <li><a href="${ctx}/admin/systemNotify"><span>推送消息</span></a></li>
                <li><a href="${ctx}/admin/notifyLog"><span>消息日志</span></a></li>
            </ul>
        </li>

        <!--系统管理-->
        <li class="nav-item">
            <a href="javascript:;">
                <i class="my-icon nav-icon icon_6"></i>
                <span>系统管理</span>
                <i class="my-icon nav-more"></i>
            </a>
            <ul>
                <li><a href="${ctx}/admin/systemSetting"><span>系统设置</span></a></li>
                <li><a href="${ctx}/admin/systemLog"><span>系统日志</span></a></li>
                <li><a href="${ctx}/logout"><span>注销登陆</span></a></li>
            </ul>
        </li>
    </ul>
</div>

<script>
    function showLog(logId) {
        sendPost('${ctx}/admin/getLogInfo', {'id': logId}, false, function (res) {
            $("#logUserName").val(res.userName);
            $("#logTitle").val(res.title);
            $("#logIp").val(res.ip);
            $("#logUserAgent").val(res.userAgent);
            $("#logRequestUrl").val(res.requestUrl);
            $("#logCreateDate").val(res.createDate);
            $("#logMethod").val(res.method);
            $("#logParams").val(res.params);
            $("#logException").val(res.exception);
            $('#logModal').modal('show');
        }, function (error) {
            toastr.error("系统错误");
        });
    }

    function deleteLog(logId, url) {
        var dblChoseAlert = simpleAlert({
            "content": "确定要删除选中日志吗？",
            "buttons": {
                "确定": function () {
                    var logIds = new Array();
                    if (typeof (logId) == "string") {
                        logIds.push(logId);
                    } else if (typeof (logId) == "object") {
                        for (var i = 0; i < logId.length; i++) {
                            logIds.push(logId[i].id);
                        }
                    }
                    window.location.href = "${ctx}/admin/deleteLog?logIds=" + logIds + "&url=" + url;
                    dblChoseAlert.close();
                },
                "取消": function () {
                    dblChoseAlert.close();
                }
            }
        })
    }
</script>