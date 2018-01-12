<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<nav class="cbp-spmenu cbp-spmenu-vertical cbp-spmenu-left" id="cbp-spmenu-s1" style="height: 1500px;">
    <table class="table table-responsive">
        <thead>
        <tr>
            <th>用户</th>
            <th>标题</th>
            <th>链接</th>
        </tr>
        </thead>
        <tbody id="shareArticleTBody">
            <td colspan="3" style="text-align: center">没有找到他人分享的笔记</td>
        </tbody>
    </table>
</nav>

<script>
    var menuLeft = document.getElementById('cbp-spmenu-s1'),  //nav整个导航栏
        showLeftPush = document.getElementById('showLeftPush'),//button按钮
        body = document.getElementById("home_body");

    showLeftPush.onclick = function () {
        var nav_id = document.getElementById("cbp-spmenu-s1");
        classie.toggle(this, 'active');
        classie.toggle(body, 'cbp-spmenu-push-toright');   //body 左移200px
        // 侧边栏弹出时事件
        if($('body').hasClass('cbp-spmenu-push-toright')) {
            sendGet('${ctx}/user/showOtherShareNote',{},true,function (res) {
                if(res.status) {
                    var info = "";
                    for(var i=0; i<res.articleDtos.length; i++) {
                        var name = res.articleDtos[i].authorName;
                        var title = res.articleDtos[i].title;
                        var id = res.articleDtos[i].id;
                        info += '<tr><td>'+name+'</td>\n' +
                            '<td>'+title+'</td>\n' +
                            '            <td>\n' +
                            '                <a target="_blank" href="'+res.articleDtos[i].shareUrl+'">查看分享</a>\n' +
                            '            </td>\n' +
                            '        </tr>';
                    }

                    $("#shareArticleTBody").html(info);
                }
            },function (error) {
                toastr.error("系统错误");
                return false;
            });
        }
        classie.toggle(menuLeft, 'cbp-spmenu-open');   //nav 的left:0
    };1

    function showShare(obj) {
        var id = $(obj).attr("id");
        sendPost('${ctx}/user/getShareUrl',{'id':id},true,function (res) {
            if(res.status) {
                window.open(res.info);
            } else {
                toastr.error("查看分享失败");
            }
        },function (error) {
            toastr.error("系统错误");
            return false;
        });
    }
</script>