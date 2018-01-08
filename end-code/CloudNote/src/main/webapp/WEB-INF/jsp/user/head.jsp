<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<nav class="navbar navbar-default navbar-fixed-top">
    <div class="container-fluid">
        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
            <a class="navbar-brand" href="#">
                <img alt="无道云笔记" src="${ctx}/images/favicon.png" style="width: 40px; height: 40px;">
            </a>
        </div>

        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
                <li><a id="showLeftPush" href="#">我的分享</a></li>
            </ul>
            <form class="navbar-form navbar-left">
                <div class="form-group">
                    <input type="text" class="form-control" placeholder="文章、标签、内容">
                </div>
                <button type="submit" class="btn btn-default">Serach</button>
            </form>
            <ul class="nav navbar-nav navbar-right">
                <li role="presentation">
                    <img src="" class="img-responsive" alt="Cinque Terre">
                </li>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                        <div id="showId"><shiro:principal/> <span class="caret"></span></div>
                    </a>
                    <ul class="dropdown-menu">
                        <li id="msg"><a href="javascript:void(0)" onclick="showSelfInfo()" data-toggle="modal" data-target="#showSelfInfoModal">个人信息</a></li>
                        <li class="divider"></li>
                        <li id="account"><a href="${ctx}/user/resetPassword">账户设置</a></li>
                        <li class="divider"></li>
                        <li id="share"><a href="#">查看分享</a></li>
                        <li class="divider"></li>
                        <li id="import"><a href="javascript:void(0)" data-toggle="modal" data-target="#importNoteModal">导入笔记</a></li>
                        <li class="divider"></li>
                        <li id="help"><a href="#">帮助</a></li>
                        <li class="divider"></li>
                        <li ><a href="${ctx}/logout">注销</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<script>
    function showSelfInfo() {
        sendGet('${ctx}/showSelfInfo',{},true,function (res) {
            $("#userId").val(res[0].id);
            $("#userTel").val(res[0].tel);
            $("#userName").val(res[0].name);
            $("#userEmail").val(res[0].email);
            $("#userArea").val(res[0].areaName);

            // 设置头像url
            $("#userBigIcon").attr('src',"${ctx}/upload/"+ userTel + "/images/" + res[0].icon);
            //初始化更新头像信息
            $("#uploadIcon").val('');
            $("#fileName").html('');

            $("input:radio[name='sex'][value="+res[0].sex+"]").attr('checked','true');
            $("#userSign").val(res.sign);

            // 动态添加省级下拉框
            for(var i=0; i<res[1].length; i++) {
                $("#areaSelect1").append("<option value='"+res[1][i].id+"'>"+res[1][i].name+"</option>");
            }
        },function (error) {
            toastr.error("系统错误");
            return false;
        });
    }
</script>