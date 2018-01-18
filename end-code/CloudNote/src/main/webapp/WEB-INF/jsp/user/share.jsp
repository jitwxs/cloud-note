<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!--侧边栏-->
<nav class="cbp-spmenu cbp-spmenu-vertical cbp-spmenu-left" id="cbp-spmenu-s1" style="height: 1500px;background: #f7f7f7;">
    <div id="container_share">
    </div>
    <div>
        <a id="changeshare" style="width: 230px;height: 50px;line-height: 50px;margin-left: 70px;cursor: pointer;text-decoration: none"><img src="${ctx}/images/changeshare.png"> 换一批</a>
    </div>
</nav>

<script>
    var menuLeft = document.getElementById('cbp-spmenu-s1'),  //nav整个导航栏
        showLeftPush = document.getElementById('showLeftPush'),//button按钮
        body = document.getElementById("home_body");

    //点击分享按钮后获取数据
    function initShare(divAttr) {
        for (var i=0;i<divAttr.length;i++){
            $('#container_share').append('<div class="share" onclick="jumpShare(this)" share-url="'+divAttr[i].shareUrl+'">\n' +
                '                <h5>'+divAttr[i].title+'</h5>\n' +
                '                <p class="content" >'+divAttr[i].abstractText+'</p>\n' +
                '                <p class="username" >来自：'+divAttr[i].authorName+'</p>\n' +
                '                <span ><img src="${ctx}/images/star.png">'+divAttr[i].star+'</span>\n' +
                '            </div>');
        }
    }

    function jumpShare(obj) {
        var url = $(obj).attr("share-url");
        window.open(url);
    }

    //分享按钮事件,
    $('#showLeftPush').on('click',function () {
        var nav_id = document.getElementById("cbp-spmenu-s1");
        classie.toggle(this, 'active');
        classie.toggle(body, 'cbp-spmenu-push-toright');   //body 左移200px

        // 侧边栏弹出时事件
        if($('body').hasClass('cbp-spmenu-push-toright')) {
            $('#container_share').children().remove();
            //从服务器获取分享的内容
            sendGet('${ctx}/user/showOtherShareNote',{},true,function (msg) {
                if (msg.status){
                    initShare(msg.articleDtos);
                } else {
                    toastr.info("没有找到分享的内容");
                    return false;
                }
            },function (error) {
                toastr.error("系统错误");
                return false;
            });

            //换一批按钮事件
            $('#changeshare').on('click',function () {
                //从服务器获取分享的内容
                sendGet('${ctx}/user/showOtherShareNote',{},true,function (msg) {
                    if (msg.status){
                        //成功获取数据 删除container_share的所有子元素
                        $('#container_share').children().remove();
                        //在container_share里添加新的元素
                        initShare(msg.articleDtos);
                    } else {
                        toastr.info("没有找到分享的内容");
                        return false;
                    }
                },function (error) {
                    toastr.error("系统错误");
                    return false;
                });
            });

            //点击分享页div跳转到新页面
            $('.share').on('click',function () {
                var url = $(this).attr('shareurl');
                window.open(url);
            });

        }
        classie.toggle(menuLeft, 'cbp-spmenu-open');   //nav 的left:0
    });
</script>