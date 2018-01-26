<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<html>
<head>
    <title>Error</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%-- 引入bootstrap --%>
    <link rel="stylesheet" type="text/css" href="${ctx}/css/bootstrap.css">
    <%-- 引入JQuery  bootstrap.js--%>
    <script src="${ctx}/js/jquery-3.2.1.min.js"></script>
    <script src="${ctx}/js/bootstrap.js"></script>

    <style type="text/css">
        body {
            background-color: #0099CC;
            color: #FFFFFF;
            font-family: Microsoft Yahei, "Helvetica Neue", Helvetica, Hiragino Sans GB, WenQuanYi Micro Hei, sans-serif;
            margin-left: 100px;
        }
        .face {
            font-size: 100px;
        }
        p{
            font-size: 24px;
            padding: 8px;
            line-height: 40px;
        }
        .tips {
            font-size: 16px
        }

        /*针对小屏幕的优化*/
        @media screen and (max-width: 600px) {
            body{
                margin: 0 10px;
            }
            p{
                font-size: 18px;
                line-height: 30px;
            }
            .tips {
                display: inline-block;
                padding-top: 10px;
                font-size: 14px;
                line-height: 20px;
            }
        }
    </style>
</head>
<body>
    <span class="face">:(</span>
    <p>发生了不可预知的情况<br>
    <p class="lead">错误信息：${message}</p>
        <span class="tips">如果您想了解更多信息，请将当前网址和错误信息发送到邮箱：jitwxs@foxmail.com</span>
    </p>
</body>
</html>