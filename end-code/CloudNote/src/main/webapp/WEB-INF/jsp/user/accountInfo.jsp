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

        <div class="strong">
            <p class="fl">
                <span id="one" class="hover">弱</span>
                <span id="two" class="">中</span>
                <span id="three" class="">强</span>
            </p>
        </div>
        <div class="left" style="width: 320px;height: 40px; margin-top: 60px;margin-left: 0px">
            <button id="button" onclick="window.location.href='#'">
                修改密码</button>
        </div>
    </div>

</div>

<script>
    $(function() {
        // 初始化头部小头像和下拉框名
        sendGet('${ctx}/showSelfInfo',{},true,function (res) {
            $("#accountName").html(res.userDto.tel);
            $("#emailAddr").html(res.userDto.email);
            $("#registerDate").html(res.userDto.createDate);
        },function (error) {
            toastr.error("系统错误");
            return false;
        });
    });

    function judgePasswd() {
        $.ajax({
            type:'get',
            url:'',
            asyns:false,
            dataType:'json',
            success : function (msg) {
                if (!msg.res){
                    if (msg.level == "1"){
                        $('.strong').append('<span id="strongthTip>您的密码很不安全，建议去修改密码哦~~</span>');
                        return true;
                    }
                    else if(msg.level == "2"){
                        $('#one').removeClass();
                        $('#two').addClass('hover');
                        $('.strong').append('<span id="strongthTip>您的密码不够安全，将密码复杂一点更好哦~~</span>');
                        return true;
                    }
                    else if(msg.level == "3"){
                        $('#one').removeClass();
                        $('#three').addClass('hover');
                        $('.strong').append('<span id="strongthTip>您的密码强度不错，定期改密会更安全哦~~</span>');
                        return true;
                    }
                }
                else
                    return false;
            },
            error : function (error) {
//               alert("判断密码等级出错");
                return false;
            }
        });
    }
</script>

</body>

</html>