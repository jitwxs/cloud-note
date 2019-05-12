<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/global/taglib.jsp" %>

<div class="modal fade" id="logModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">日志信息</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label for="logUserName" class="col-sm-2 control-label">用户名</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="logUserName" readonly="readonly">
                        </div>
                    </div>
                    <div class="form-group ">
                        <label for="logTitle" class="col-sm-2 control-label">标题</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="logTitle" readonly="readonly">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="logIp" class="col-sm-2 control-label">IP</label>
                        <div class="col-sm-10">
                            <input type="text" id="logIp" class="form-control" readonly="readonly">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="logUserAgent" class="col-sm-2 control-label">用户代理</label>
                        <div class="col-sm-10">
                            <textarea class="form-control dis_change_textarea" id="logUserAgent"
                                      rows="2" readonly="readonly"></textarea>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="logRequestUrl" class="col-sm-2 control-label">请求路径</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="logRequestUrl" readonly="readonly">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="logCreateDate" class="col-sm-2 control-label">创建时间</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="logCreateDate" readonly="readonly">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="logMethod" class="col-sm-2 control-label">方法</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="logMethod" readonly="readonly">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="logParams" class="col-sm-2 control-label">参数</label>
                        <div class="col-sm-10">
                            <textarea class="form-control dis_change_textarea" id="logParams"
                                      rows="2" readonly="readonly"></textarea>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="logException" class="col-sm-2 control-label">异常信息</label>
                        <div class="col-sm-10">
                            <textarea class="form-control dis_change_textarea" id="logException"
                                      rows="2" readonly="readonly"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>