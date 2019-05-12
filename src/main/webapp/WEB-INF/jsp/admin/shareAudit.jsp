<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<jsp:include page="left.jsp"/>

<!-- 引入模态框 -->
<jsp:include page="shareModel.jsp"/>

<body class="admin_body">
<!--主体-->
<div class="admin_container">
    <h2 class="admin_table_title">分享审核</h2>
    <div id="toolbar" style="margin-right: 20px;">
        <button id="btn_delete" type="button" class="btn btn-default" onclick="delete_more()">
            <span class="glyphicon glyphicon-remove" aria-hidden="true">删除</span>
        </button>
    </div>
    <div class="admin_table_div2">
        <table id="shareAuditTable" class="table table-responsive table-bordered tab-content table-hover"
               style="margin-right: 10%;">
        </table>
    </div>
</div>

<script>
    window.operateEvents = {
        'click .detail': function (e, value, row, index) {
            var url = row.shareUrl;
            window.open(url);
        },
        'click .cancel': function (e, value, row, index) {
            $("#shareNoteId").val(row.id);
            $("#shareNoteTitle").val(row.title);
            $("#controlType").val(1);
            $("#shareModalLabel").text("取消分享");
            openShareModel();
        },
        'click .del': function (e, value, row, index) {
            var id = row.id;
            $("#shareNoteTitle").val(row.title);
            deleteArticle(id);
        }
    };

    function AddFunctionAlty(value, row, index) {
        return ['  <button id="btn_detail" type="button" class="btn btn-default detail">\n' +
        '            <span class="glyphicon glyphicon-search" aria-hidden="true" >查看</span>\n' +
        '        </button>',
            '  <button id="btn_cancel" type="button" class="btn btn-default cancel">\n' +
            '            <span class="glyphicon glyphicon-remove" aria-hidden="true" >取消</span>\n' +
            '        </button>',
            '  <button id="btn_delect" type="button" class="btn btn-default del">\n' +
            '            <span class="glyphicon glyphicon-trash" aria-hidden="true" >删除</span>\n' +
            '        </button>'].join("")
    }

    $(function () {
        sendGet('${ctx}/admin/prepareShareAudit', {}, false, function (value) {
            $table = $('#shareAuditTable').bootstrapTable(
                {
                    data: value,   //最终的JSON数据放在这里
                    striped: true,
                    cache: false,
                    height: 700,
                    toolbar: '#toolbar',
                    pagination: true,
                    sidePagination: "client",
                    pageNumber: 1,
                    pageSize: 10,
                    pageList: [5, 10, 20],
                    showColumns: true,
                    minimunCountColumns: 2,
                    sort: false,
                    sortOrder: "asc",
                    search: true,
                    showRefresh: true,
                    clickToSelect: true,
                    showToggle: true,
                    cardView: false,    //是否显示详细视图
                    detaView: false,
                    showExport: true,//显示导出按钮
                    exportTypes: ['excel', 'json', 'xml', 'txt', 'sql'],
                    columns: [
                        {
                            field: "checked",
                            checkbox: true
                        },
                        {
                            field: 'authorTel',
                            title: '账户',
                            align: 'center',
                            valign: 'center',
                            sortable: false
                        },
                        {
                            field: 'authorName',
                            title: '用户名',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'title',
                            title: '标题',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'star',
                            title: 'Star',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'createDate',
                            title: '创建时间',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: "button",
                            title: "操作",
                            align: 'center',
                            formatter: AddFunctionAlty,
                            events: operateEvents
                        }

                    ]
                })
        }, function (error) {
            toastr.error("系统错误");
            return false;
        });
    });

    function delete_more() {
        var row = $(shareAuditTable).bootstrapTable('getSelections');
        deleteArticle(row);
    }

    function deleteArticle(obj) {
        var ids = new Array();
        if (typeof (obj) == "string") {
            ids.push(obj);
        } else if (typeof (obj) == "object") {
            var titles = "";
            for (var i = 0; i < obj.length; i++) {
                ids.push(obj[i].id);
                titles += obj[i].title + "、";
            }
            titles = titles.substr(0, titles.length-1);
            $("#shareNoteTitle").val(titles);
        }
        $("#shareNoteId").val(ids);
        $("#controlType").val(2);
        $("#shareModalLabel").text("删除分享");
        openShareModel();
    }
    
    function openShareModel () {
        sendGet('${ctx}/admin/listShareReason', {}, false, function (res) {
            $("#reasonName").html("");
            // 动态添加原因下拉框
            $("#reasonName").append("<option value=-1>请选择原因</option>");
            for (var i = 0; i < res.length; i++) {
                $("#reasonName").append("<option value='" + res[i].name + "'>" + res[i].name + "</option>");
            }
            $('#shareModal').modal('show');
        }, function (error) {
            toastr.error("系统错误");
        });
    }

</script>
</body>
</html>