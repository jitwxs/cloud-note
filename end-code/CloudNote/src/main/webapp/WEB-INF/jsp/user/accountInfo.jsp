<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<%-- 引入头部 --%>
<jsp:include page="settingHead.jsp"/>

<body>
<div class="container">
    <div class="box1" >
        <h4> 账号信息</h4>
        <hr>
        <ol >账号：<label id="accountName"></label></ol>
        <ol >绑定邮箱：<label id="emailAddr"></label></ol>
        <ol >注册日期：<label id="registerDate"></label></ol>
    </div>

</div>

<script>
    $(function() {
        sendGet('${ctx}/showSelfInfo',{},true,function (res) {
            $("#accountName").html(res.userDto.tel);
            $("#emailAddr").html(res.userDto.email);
            $("#registerDate").html(res.userDto.createDate);
        },function (error) {
            toastr.error("系统错误");
            return false;
        });
    });
</script>

</body>

</html>