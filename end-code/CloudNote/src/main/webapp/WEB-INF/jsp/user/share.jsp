<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<nav class="cbp-spmenu cbp-spmenu-vertical cbp-spmenu-left" id="cbp-spmenu-s1" style="height: 1500px;">
    <table class="table table-bordered table-hover">
        <thead>
        <tr>
            <th>用户</th>
            <th>标题</th>
            <th>管理</th>
        </tr>
        </thead>
        <tbody id="shareArticleTBody">
        <%--<tr><td></td>--%>
            <%--<td></td>--%>
            <%--<td>--%>
                <%--<button>查看分享</button>--%>
            <%--</td>--%>
        <%--</tr>--%>
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
            <%--sendGet('${ctx}/user/showSelfShareNote',{},false,function (res) {--%>
                <%--if(res.status) {--%>
                    <%--var info = "";--%>
                    <%--for(var i=0; i<res.articles.length; i++) {--%>
                        <%--var name = res.articles[i].title;--%>
                        <%--var id = res.articles[i].id;--%>
                        <%--info += "<tr><td>"+name+"</td>\n" +--%>
                            <%--"            <td id='"+id+"'>\n" +--%>
                            <%--"                <button onclick='copyShareUrl()'>复制链接</button>\n" +--%>
                            <%--"                <button onclick='cancelShare2()'>取消分享</button>\n" +--%>
                            <%--"            </td>\n" +--%>
                            <%--"        </tr>";--%>
                    <%--}--%>

                    <%--$("#shareArticleTBody").html(info);--%>
                <%--}--%>
            <%--},function (error) {--%>
                <%--toastr.error("系统错误");--%>
                <%--return false;--%>
            <%--});--%>
        }
        classie.toggle(menuLeft, 'cbp-spmenu-open');   //nav 的left:0
    };
</script>