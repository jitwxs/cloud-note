<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <title>无道云笔记</title>
    <%-- Required meta tags always come first --%>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <%-- Bootstrap CSS --%>
    <link rel="stylesheet" href="${ctx}/css/bootstrap.css">
    <%-- 弹窗CSS --%>
    <link rel="stylesheet" href="${ctx}/css/toastr.css">
    <%-- jQuery first, then Bootstrap JS. --%>
    <script src="${ctx}/js/jquery-3.2.1.min.js"></script>
    <script src="${ctx}/js/bootstrap.js"></script>
    <%-- 弹窗依赖 --%>
    <script src="${ctx}/js/toastr.js"></script>
    <%-- 封装ajax --%>
    <script src="${ctx}/js/http.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
        }
        nav {
            width: 100%;
            height: 50px;
            background: #7e6aa7;
            position: relative;
        }
        nav img {
            width: 150px;
            height: 50px;
            float: left;
        }
        #search_btn {
            float: left;
            width: 70px;
            height: 33px;
            background: lightskyblue;
            margin-top: 8px;
            margin-left: 5px;
            color: white;
            font-size: 13px;
            line-height: 20px;
            border-radius: 5px;
        }
        #result_num .number {
            font-size: 12px;
            color: #999999;
            width: 40%;
            margin-top: 10px;
            margin-left: 15%;
        }
        #result_container .box1 {
            width: 100%;
            height: 100%;
            margin-top: 10px;
            cursor: pointer
        }
        #result_container .title {
            color: #0000EE;
            text-decoration: underline;
            font-size: 18px;
            cursor: pointer
        }
    </style>
</head>

<body>
<!--头部-->
<nav style="">
    <!--logo-->
    <a href="${ctx}/user/index"><img id="goback_btn" src="${ctx}/images/logo_word.png" style="cursor: pointer;width: 12%;height: 30px;margin-top: 0.5%"></a>

    <!--搜索框-->
    <form method="post" id="searchForm" action="${ctx}/user/nbSearch">
        <input id="search_key" type="text"
               class="form-control" name="keywords" placeholder="标题、标签、内容" style="width: 40%;float:left;margin-top: 8px;margin-left: 3%" >
        <a id="search_btn" class="btn" onclick="nbSearch()">Search</a>
    </form>
</nav>

<div id="result_num">
    <p class="number">为你找到相关结果约${result.size()}个</p>
</div>

<!--文章显示区域-->
<div id="result_container" style="margin-top: 10px;width: 40%;margin-left: 15%">
    <!--测试数据-->
    <div class="box1">
        <a class="title"></a>
        <div class="content">
            <c:forEach items="${result}" var="item">
                <div class="box1">
                    <a class="title" href="${ctx}/user/searchResult?id=${item.noteId}">${item.noteName}</a>
                    <c:if test="${item.tag.length() > 0}">
                        <span class="title2"
                              style="color: grey;font-size: 15px;margin-left: 10px;border: 1px grey solid;padding: 2px;border-radius: 5px">${item.tag}</span>
                    </c:if>
                    <div class="content">${item.content}</div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<script>
    function nbSearch() {
        var keywords = $("#search_key").val();
        if(keywords == null || keywords == "") {
            toastr.info("想搜啥请告诉我呀");
            return false;
        } else {
            $("#searchForm").submit();
        }
    }
</script>
</body>
</html>