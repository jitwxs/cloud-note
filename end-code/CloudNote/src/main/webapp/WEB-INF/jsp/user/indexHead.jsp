<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<nav class="navbar navbar-default navbar-fixed-top" style="background: #7c6aa6">
    <div class="container-fluid">
        <div class="navbar-header" style="margin-top: 10px;height: 40px;position: relative;margin: 0;padding: 0;">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
                    data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <img src="${ctx}/images/pencil.png" style="width: 35px;height: 35px;margin-left: 10px;margin-top: 10px">
        </div>
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1" >
            <ul class="nav navbar-nav" style="margin-top: 5px;cursor: pointer;margin-left: 50px">
                <li><span id="showLeftPush" ><img src="${ctx}/images/look.png"></span></li>
            </ul>
            <form class="navbar-form navbar-left" style="margin-left: 57px">
                <div class="form-group">
                    <input type="text" class="form-control" id="searchContent" placeholder="标题、标签、内容">
                </div>
                <button type="button" class="btn btn-default" onclick="nbSearch()">Search</button>
            </form>
            <ul class="nav navbar-nav navbar-right" >
                <li role="presentation">
                    <img id="userSmallIcon" class="img-responsive img-rounded" style="width: 50px;height: 50px" src="" >
                </li>
                <li class="dropdown" id="changeColor">
                    <a class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                        <div id="showName">
                            <label id="userSmallName" style="color: white"></label><span class="caret"></span>
                            <span class="badge" style="background-color: red"></span>
                        </div>
                    </a>
                    <ul class="dropdown-menu" >
                        <li ><a href="javascript:void(0)" onclick="showSelfInfo()" data-toggle="modal" data-target="#showSelfInfoModal">我的信息</a></li>
                        <li class="divider"></li>
                        <li id="accountSet"><a href="${ctx}/user/accountInfo">用户中心</a></li>
                        <li class="divider"></li>
                        <li><a href="${ctx}/user/disk">我的网盘</a></li>
                        <li class="divider"></li>
                        <li><a href="${ctx}/user/notify">站内信<span class="badge" style="background-color: red"></span></a></li>
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
            $("#userBigIcon").attr('src', res.userDto.icon);

            //初始化更新头像信息
            $("#uploadIcon").val('');
            $("#fileName").html('');

            $("input:radio[name='sex'][value="+res.userDto.sex+"]").attr('checked','true');
            $("#userSign").val(res.userDto.sign);

            // 动态添加省级下拉框
            $("#areaSelect1").html('');
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
            $('.js_note_btn').css("color","#337AB7");
            sendPost('${ctx}/user/nbSearch', {'content': content}, true, function (msg) {
                if(msg.status) {
                    for(var i=0; i<msg.articles.length; i++) {
                        var id = msg.articles[i].id;
                        // var $cur = $('div').find('a[index-id="'+id+'"]');
                        var $cur = $(".js_note_btn[index-id="+id+"]");
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