<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<nav class="navbar navbar-default navbar-fixed-top">
    <div class="container-fluid">
        <div class="navbar-header" style="margin-top: 10px;height: 40px;position: relative">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
                    data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a href="javascript:void(0)" class="navbar-brand"
               style="font-family:'Open Sans', Arial, sans-serif;font-size: 20px;color: black;">
                无道云笔记</a>
            <img src="${ctx}/images/favicon.png" style="width: 50px;height: 40px;" alt="无道云笔记">
        </div>
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1" >
            <ul class="nav navbar-nav">
                <li><a id="showLeftPush" href="javascript:void(0)">随便逛逛</a></li>
            </ul>
            <form class="navbar-form navbar-left">
                <div class="form-group">
                    <input type="text" class="form-control" id="searchContent" placeholder="文章、标签、内容">
                </div>
                <button type="button" class="btn btn-default" onclick="nbSearch()">Search</button>
            </form>
            <ul class="nav navbar-nav navbar-right">
                <li role="presentation">
                    <img id="userSmallIcon" class="img-responsive img-rounded" style="width: 50px;height: 50px" src="" >
                </li>
                <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                        <div id="showName"><label id="userSmallName"></label><span class="caret"></span></div>
                    </a>
                    <ul class="dropdown-menu">
                        <li ><a href="javascript:void(0)" onclick="showSelfInfo()" data-toggle="modal" data-target="#showSelfInfoModal">我的信息</a></li>
                        <li class="divider"></li>
                        <li id="accountSet"><a href="${ctx}/user/accountInfo">用户中心</a></li>
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
            $("#userTel").val(res.userDto.tel);
            $("#userId").val(res.userDto.id);
            $("#userName").val(res.userDto.name);
            $("#userEmail").val(res.userDto.email);
            $("#userArea").val(res.userDto.areaName);

            // 设置头像url
            $("#userBigIcon").attr('src',"${ctx}/upload/"+ res.userDto.tel + "/images/" + res.userDto.icon);
            //初始化更新头像信息
            $("#uploadIcon").val('');
            $("#fileName").html('');

            $("input:radio[name='sex'][value="+res.userDto.sex+"]").attr('checked','true');
            $("#userSign").val(res.userDto.sign);

            // 动态添加省级下拉框
            for(var i=0; i<res.areas.length; i++) {
                $("#areaSelect1").append("<option value='"+res.areas[i].id+"'>"+res.areas[i].name+"</option>");
            }
        },function (error) {
            toastr.error("系统错误");
            return false;
        });
    }

    function nbSearch() {
        var content = $("#searchContent").val();
        if(content == null || content == "") {
            toastr.info("想搜啥请告诉我呀");
            return false;
        } else {
            sendPost('${ctx}/user/nbSearch', {'content': content}, true, function (msg) {
                if(msg.status) {
                    for(var i=0; i<msg.articles.length; i++) {
                        var id = msg.articles[i].id;
                        var $cur = $('div').find('a[index-id="'+id+'"]');

                        $cur.css("color","red");
                    }
                }
            }, function (error) {
                toastr.error("系统错误");
                return false;
            });
        }
    }
</script>