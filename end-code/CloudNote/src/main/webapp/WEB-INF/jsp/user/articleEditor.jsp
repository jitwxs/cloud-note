<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>
<div style="height: 1500px"></div>
<div>
    <div id="editor">
        <p>欢迎使用 <b>wangEditor</b> 富文本编辑器</p>
    </div>
    <button id="getContent" onclick="saveContent()">获取HTML（不包含样式）</button>
    <%--<button id="getJSON">获取JSON</button>--%>
    <button id="setContent">动态设置内容</button>
    <button id="downloadNote" href="">下载笔记</button>

    <script type="text/javascript">
        var E = window.wangEditor;
        var editor = new E('#editor');
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

        // // 获取内容的json
        // document.getElementById('getJSON').addEventListener('click', function () {
        //     var json = editor.txt.getJSON(); // 获取 JSON 格式的内容
        //     var jsonStr = JSON.stringify(json);
        //     alert("json：" + jsonStr);
        // }, false);

        // TODO 后期加上笔记id
        function saveContent() {
            var content = editor.txt.html();
            $.ajax({
                url : "${ctx}/user/saveArticle",
                type : "post",
                dataType : "text",
                data : {
                    // "id" : ,
                    "data" : content
                },
                async :true,
                success : function(res) {
                },
                error : function(){
                    alert("发生错误");
                }
            });
        }

        // 设置内容值
        document.getElementById('setContent').addEventListener('click', function () {
            $.ajax({
                    url : "${ctx}/user/showUserNote",
                    type : "post",
                    dataType : "text",
                    data : {
                         "key" : "value"
                    },
                    async :true,
                    success : function(res) {
                        editor.txt.html(res);
                    },
                    error : function(){
                        alert("出现错误!");
                    }
                });
        }, false);

        // 下载笔记
        document.getElementById('downloadNote').addEventListener('click', function () {
            var content = editor.txt.html();
            $.ajax({
                url : "${ctx}/user/downloadNote",
                type : "post",
                dataType : "text",
                data : {
                    "data" : content
                },
                async :true,
                success : function(res) {
                    $('#downloadNote').attr('href',res);
                    alert("下载成功!");
                },
                error : function(){
                    alert("出现错误!");
                }
            });
        }, false);
    </script>
</div>