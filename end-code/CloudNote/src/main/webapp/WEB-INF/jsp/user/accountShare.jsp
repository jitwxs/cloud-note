<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<%-- 引入头部 --%>
<jsp:include page="settingHead.jsp"/>

<body>
<div class="container">
    <div class="box1" >
        <h4> 我的分享</h4>
        <hr>
        <table class="table table-responsive">
            <thead>
            <tr>
                <th>标题</th>
                <th>创建时间</th>
                <th>管理</th>
            </tr>
            </thead>
            <tbody id="selfShareArticleTBody">
            <td colspan="3" style="text-align: center">你还没有分享的笔记</td>
            </tbody>
        </table>
    </div>

</div>

<script>
    $(function() {
        sendGet('${ctx}/user/showShareNote',{},true,function (res) {
            if(res.status) {
                var info = "";
                for(var i=0; i<res.articles.length; i++) {
                    var id = res.articles[i].id;
                    var title = res.articles[i].title;
                    var url = res.articles[i].shareUrl;
                    var create_date = res.articles[i].createDate;
                    info += '<tr data-id="'+id+'"><td>'+title+'</td>\n' +
                        '<td>'+create_date+'</td>\n' +
                        '            <td>\n' +
                        '                <a target="_blank" href="'+url+'">查看分享</a>\n' +
                        '                <a href="javascript:void(0)" onclick="cancelShare(this)">取消分享</a>\n' +
                        '            </td>\n' +
                        '        </tr>';
                }
                $("#selfShareArticleTBody").html(info);
            }
        },function (error) {
            toastr.error("系统错误");
            return false;
        });
    });

    function cancelShare(obj) {
        var noteId = $(obj).parent().parent().attr("data-id");
        sendPost('${ctx}/user/cancelShare', {'noteId': noteId}, true, function (msg) {
            if(msg.status) {
                location.reload(true);
            } else {
                toastr.error("取消分享失败");
            }
        }, function (error) {
            toastr.error("内部错误");
            return false;
        });
    }
</script>

</body>

</html>