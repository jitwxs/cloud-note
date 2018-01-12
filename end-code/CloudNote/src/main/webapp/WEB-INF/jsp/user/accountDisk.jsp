<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<%-- 引入头部 --%>
<jsp:include page="settingHead.jsp"/>

<body>
<div class="container">
    <div class="box1" >
        <h4 style="margin-left: 40px">我的网盘</h4>
        </div>

    <div class="box2">
        <h4> 空间</h4>
        <hr>
        <div class="progress progress-striped active">
            <div class="progress-bar progress-bar-success" role="progressbar"
                 aria-valuenow="60" aria-valuemin="0" aria-valuemax="100"
                 style="width: 20%;">
                <span class="sr-only">20% 完成</span>
            </div>
        </div>
    </div>
</div>

</body>
</html>