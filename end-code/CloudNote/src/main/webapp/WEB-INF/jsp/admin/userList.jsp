<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">

<jsp:include page="left.jsp"/>

<!-- 引入模态框 -->
<jsp:include page="userInfoModel.jsp"/>
<jsp:include page="blackHomeModel.jsp"/>

<body class="admin_body">
<!--主体-->
<div class="admin_container">
    <h2 class="admin_table_title">用户列表</h2>

    <div id="toolbar" style="margin-right: 20px;">
        <button id="btn_delete" type="button" class="btn btn-default" onclick="delete_more()">
            <span class="glyphicon glyphicon-remove" aria-hidden="true">删除</span>
        </button>
    </div>
    <div class="admin_table_div2">
        <table id="userListTable" class="table table-responsive table-bordered tab-content table-hover" style="margin-right: 10%;">
        </table>
    </div>
</div>

<script>
    window.operateEvents = {
        'click .detail': function (e, value, row, index) {
            var tel = row.tel;
            sendPost('${ctx}/admin/showUserInfo',{"tel":tel},false,function(res) {
                $("#userInfoTel").val(res.tel);
                $("#userInfoName").val(res.name);
                $("#userInfoEmail").val(res.email);
                $("#userInfoArea").val(res.areaName);

                $("input:radio[name='sex'][value="+res.sex+"]").attr('checked','true');
                $("#userInfoSign").val(res.sign);

                $('#userInfoModal').modal('show');
            },function (error) {
                toastr.error("系统错误");
                return false;
            });
        },
        'click .addBlackHome': function (e, value, row, index) {
            var id = row.id;
            var tel = row.tel;

            $("#userBlacklistTel").val(tel);
            $("#userBlacklistId").val(id);
            sendGet('${ctx}/admin/listIllegal',{},false,function(res) {
                $("#blacklistReason").html("");
                // 动态添加原因下拉框
                $("#blacklistReason").append("<option value=-1>请选择原因</option>");
                for(var i=0; i<res.length; i++) {
                    $("#blacklistReason").append("<option value='"+res[i].id+"'>"+res[i].name+"</option>");
                }
                $('#blackHomeModal').modal('show');
            },function (error) {
                toastr.error("系统错误");
                return false;
            });
        },
        'click .del': function (e, value, row, index) {
            var tel = row.tel;
            deleteUser(tel);
        }
    };

    function AddFunctionAlty(value, row, index) {
        var roleName = row.roleName;

        if(roleName == "user") {
            return ['  <button id="btn_detail" type="button" class="btn btn-default detail">\n' +
            '            <span class="glyphicon glyphicon-search" aria-hidden="true" >查看</span>\n' +
            '        </button>',
                '  <button id="btn_cancel" type="button" class="btn btn-default addBlackHome">\n' +
                '            <span class="glyphicon glyphicon-eye-close" aria-hidden="true">封禁</span>\n' +
                '        </button>',
                '  <button id="btn_delect" type="button" class="btn btn-default del">\n' +
                '            <span class="glyphicon glyphicon-remove" aria-hidden="true" >删除</span>\n' +
                '        </button>'].join("");
        } else if(roleName == "admin") {
            return ['  <button id="btn_detail" type="button" class="btn btn-default detail">\n' +
            '            <span class="glyphicon glyphicon-search" aria-hidden="true" >查看</span>\n' +
            '        </button>'].join("");
        }
    }

    $(function () {
        sendGet('${ctx}/admin/prepareUserList',{},false,function (value) {
            $table = $('#userListTable').bootstrapTable(
                {
                    data: value,   //最终的JSON数据放在这里
                    striped: true,
                    cache: false,
                    height:700,
                    toolbar:'#toolbar',
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
                    clickToSelect:true,
                    showToggle:true,
                    cardView: false,    //是否显示详细视图
                    detaView:false,
                    showExport: true,//显示导出按钮
                    exportTypes:  ['excel','json', 'xml', 'txt', 'sql'],
                    columns: [
                        {
                            field:"checked",
                            checkbox:true
                        },
                        {
                            field: 'roleName',
                            title: '权限',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'tel',
                            title: '账户',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'name',
                            title: '用户名',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'sex',
                            title: '性别',
                            width: 100,
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'areaName',
                            title: '地区',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field: 'email',
                            title: '邮箱',
                            align: 'center',
                            valign: 'center',
                            sortable: true
                        },
                        {
                            field:"button",
                            title:"操作",
                            align: 'center',
                            formatter:AddFunctionAlty,
                            events:operateEvents
                        }
                    ]
                })
        },function (error) {
            toastr.error("系统错误");
            return false;
        });
    });

    function delete_more() {
        var row = $(userListTable).bootstrapTable('getSelections');
        deleteUser(row);
    }


    function deleteUser(obj) {
        var msg = "确定要删除选中用户吗？";
        if (confirm(msg)){
            var tels = new Array();
            if(typeof (obj) == "string") {
                tels.push(obj);
            } else if (typeof (obj) == "object") {
                for(var i=0; i< obj.length; i++) {
                    tels.push(obj[i].tel);
                }
            }
            window.location.href='${ctx}/admin/deleteUser?tels=' + tels;
        }else {
            return false;
        }
    }
</script>
</body>
</html>
