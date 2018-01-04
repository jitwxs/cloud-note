<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <title>CloudNote</title>
    <!-- Required meta tags always come first -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${ctx}/css/bootstrap.css">
    <link rel="stylesheet" href="${ctx}/css/message.css">
    <link rel="stylesheet" href="${ctx}/css/wangEditor-fullscreen-plugin.css">
    <!-- jQuery first, then Bootstrap JS. -->
    <script src="${ctx}/js/jquery-3.2.1.min.js"></script>
    <script src="${ctx}/js/bootstrap.js"></script>
    <!-- wangEditor依赖 -->
    <script src="${ctx}/js/wangEditor.js"></script>
    <script src="${ctx}/js/wangEditor-fullscreen-plugin.js"></script>
</head>

<body>
<h1>首页</h1>

<a href="${ctx}/login">登陆</a>
<a href="${ctx}/register">注册</a>

<hr>

<div>
    <div id="editor">
        <p>欢迎使用 <b>wangEditor</b> 富文本编辑器</p>
    </div>
    <button id="getContent" onclick="saveContent()">获取HTML（不包含样式）</button>
    <%--<button id="getJSON">获取JSON</button>--%>
    <button id="setContent">动态设置内容</button>
    <div>
        <p>扫描到的内容：</p>
        <label id="scanContent"></label>
    </div>

    <script type="text/javascript">
        var E = window.wangEditor;
        var editor = new E('#editor');
        // // 自定义 onchange 触发的延迟时间，默认为 200 ms
        // editor.customConfig.onchangeTimeout = 1000; // 单位 ms
        // // 动态扫描文件内容
        // editor.customConfig.onchange = function (html) {
        //     // 动态侦测内容改变
        //     $("#scanContent").html(html);
        // };
        // 对输入网络图片地址的校验
        editor.customConfig.linkImgCheck = function (src) {
            alert("即将上传图片url："+src);// 图片的链接

            return true // 返回 true 表示校验成功
            // return '验证失败' // 返回字符串，即校验失败的提示信息
        };
        // 回掉得到上传网络图片的地址
        editor.customConfig.linkImgCallback = function (url) {
            alert("上传图片地址："+url); // url 即插入图片的地址
        };
        // 对输入链接的校验
        editor.customConfig.linkCheck = function (text, link) {
            alert("链接文字：" + text);// 插入的文字
            alert("链接url：" + link);// 插入的链接

            return true // 返回 true 表示校验成功
            // return '验证失败' // 返回字符串，即校验失败的提示信息
        };
        // // 区域获得焦点
        // editor.customConfig.onfocus = function () {
        //     alert("获得焦点：");
        // };
        // 区域失去焦点
        editor.customConfig.onblur = function (html) {
            saveContent(html);
        };

        // 配置服务器端上传地址
        // editor.customConfig.uploadImgServer = '';
        // // 将图片大小限制为 3M（默认为5M）
        // editor.customConfig.uploadImgMaxSize = 3 * 1024 * 1024;
        // // 限制一次最多上传 5 张图片，默认为10000
        // editor.customConfig.uploadImgMaxLength = 5;
        // //上传图片时可自定义传递一些参数，例如传递验证的token等。参数会被添加到formdata中。
        // // editor.customConfig.uploadImgParams = {
        // //     token: 'abcdef12345'  // 属性值会自动进行 encode ，此处无需 encode
        // // };
        // // 将参数拼接到url上
        // // editor.customConfig.uploadImgParamsWithUrl = true;
        // // 将 timeout 时间改为 3s，默认为10s
        // editor.customConfig.uploadImgTimeout = 3000;

        editor.create();
        // 初始化全屏插件
        E.fullscreen.init('#editor');

        // // 获取内容的html
        // document.getElementById('getContent').addEventListener('click', function () {
        //     alert("内容：" + editor.txt.html());
        // }, false);

        function saveContent(html) {
            alert("内容：" + editor.txt.html());
        }

        // // 获取内容的json
        // document.getElementById('getJSON').addEventListener('click', function () {
        //     var json = editor.txt.getJSON(); // 获取 JSON 格式的内容
        //     var jsonStr = JSON.stringify(json);
        //     alert("json：" + jsonStr);
        // }, false);

        // 设置内容值
        document.getElementById('setContent').addEventListener('click', function () {
            editor.txt.html('<p>存放服务器得到的数据</p>')
        }, false);
    </script>
</div>

<jsp:include page="/WEB-INF/jsp/global/footer.jsp"/>

</body>

</html>