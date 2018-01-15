<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<jsp:include page="left.jsp"/>

<body>
    <div class="container" style="text-align: center;">
        <h2 >系统日志</h2>
        <table class="table table-responsive table-bordered table-hover">
            <thead>
            <tr>
                <th>标题</th>
                <th>访问IP</th>
                <th>用户代理</th>
                <th>请求路径</th>
                <th>记录时间</th>
                <th>请求参数</th>
                <th>异常信息</th>
            </tr>
            </thead>
            <tbody>
                <c:forEach items="${lists}" var="item">
                    <tr>
                        <td>${item.title}</td>
                        <td>${item.ip}</td>
                        <td>${item.userAgent}</td>
                        <td>${item.requestUrl}</td>
                        <td><fmt:formatDate value="${item.createDate}" dateStyle="medium" pattern="yyyy-MM-dd HH:mm"/></td>
                        <td>${item.params}</td>
                        <td>${item.exception}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</body>

</html>