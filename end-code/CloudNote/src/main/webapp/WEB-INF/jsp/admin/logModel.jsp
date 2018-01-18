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
                        <label for="logUserName" class="col-sm-2 control-label">userName</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="logUserName" readonly="readonly">
                        </div>
                    </div>
                    <div class="form-group ">
                        <label for="logType" class="col-sm-2 control-label">type</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="logType" readonly="readonly">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="logIp" class="col-sm-2 control-label">ip</label>
                        <div class="col-sm-10">
                            <input type="text" id="logIp" class="form-control" readonly="readonly">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="logUserAgent" class="col-sm-2 control-label">userAgent</label>
                        <div class="col-sm-10">
                            <textarea class="form-control dis_change_textarea" id="logUserAgent"
                                      rows="2" readonly="readonly"></textarea>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="logRequestUrl" class="col-sm-2 control-label">requestUrl</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="logRequestUrl" readonly="readonly">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="logCreateDate" class="col-sm-2 control-label">createDate</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="logCreateDate" readonly="readonly">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="logMethod" class="col-sm-2 control-label">method</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="logMethod" readonly="readonly">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="logUserAgent" class="col-sm-2 control-label">params</label>
                        <div class="col-sm-10">
                            <textarea class="form-control dis_change_textarea" id="logParams"
                                      rows="2" readonly="readonly"></textarea>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="logUserAgent" class="col-sm-2 control-label">exception</label>
                        <div class="col-sm-10">
                            <textarea class="form-control dis_change_textarea" id="logException"
                                      rows="2" readonly="readonly"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>