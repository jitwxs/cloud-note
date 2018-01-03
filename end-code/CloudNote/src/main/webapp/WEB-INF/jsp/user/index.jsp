<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <title>无道云笔记</title>
    <!-- Required meta tags always come first -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${ctx}/css/bootstrap.css">
    <link rel="stylesheet" href="${ctx}/css/message.css">
    <!-- jQuery first, then Bootstrap JS. -->
    <script src="${ctx}/js/jquery-3.2.1.min.js"></script>
    <script src="${ctx}/js/bootstrap.js"></script>
</head>

<body style="padding: 50px;">

<input type="hidden" id="uid" name="uid" value="${uid}">
<!-- 引入模块框 -->
<jsp:include page="showUserInfo.jsp"/>
<!-- 引入模块框 -->
<jsp:include page="importNote.jsp"/>

<nav class="navbar navbar-default navbar-fixed-top" style="height: 50px;">
    <div class="container-fluid">
        <!--无道云的图标-->
        <%--<div class="navbar-header">--%>
            <%--<a class="navbar-brand" href="#">--%>
                <%--<img alt="Brand" src="...">--%>
            <%--</a>--%>
        <%--</div>--%>

        <!--设置-->
        <ul class="nav navbar-nav navbar-right">
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    设置 <b class="caret"></b>
                </a>
                <ul class="dropdown-menu">
                    <li id="msg"><a href="javascript:void(0)" onclick="showUserInfo()" data-toggle="modal" data-target="#showUserInfoModal">个人信息</a></li>
                    <li class="divider"></li>
                    <li id="account"><a href="#">账户设置</a></li>
                    <li class="divider"></li>
                    <li id="share"><a href="#">查看分享</a></li>
                    <li class="divider"></li>
                    <li id="import"><a href="javascript:void(0)" data-toggle="modal" data-target="#importNoteModal">导入笔记</a></li>
                    <li class="divider"></li>
                    <li id="help"><a href="#">帮助</a></li>
                </ul>
            </li>
        </ul>
        <!--头像-->
        <%--<div class=" navbar-right" style="margin-right: 30px;">--%>
            <%--<img src="cinqueterre.jpg" class="img-responsive" alt="Cinque Terre">--%>
        <%--</div>--%>
        <!--搜索-->
        <div>
            <form class="navbar-form navbar-left" role="search">
                <div class="form-group">
                    <input type="text" class="form-control" style="border:none; background:none;outline:none;"
                           placeholder="Search"/>
                </div>
                <button type="submit" class="btn btn-default">查找</button>
            </form>
        </div>
    </div>
</nav>

<script>
    function showUserInfo() {
        var id = $("#uid").val();
        $.ajax({
            url : "${ctx}/user/showUserInfo",
            type : "post",
            dataType : "json",
            data : {
                "id": id
            },
            async : true,
            success : function(res) {
                $("#userId").val(res.id);
                $("#userTel").val(res.tel);
                $("#userName").val(res.name);
                $("#userEmail").val(res.email);
                $("#userArea").val(res.area);

                // 设置头像url
                $("#userIcon").attr('src',"${ctx}/upload/"+res.icon);
                //初始化更新头像信息
                $("#uploadIcon").val('');
                $("#fileName").html('');

                $("input:radio[name='sex'][value="+res.sex+"]").attr('checked','true');
                $("#userSign").val(res.sign);
            },
            error: function () {
                $.message({
                    message: '未知错误',
                    type: 'error'
                });
            }
        });
    }
</script>
</body>
</html>