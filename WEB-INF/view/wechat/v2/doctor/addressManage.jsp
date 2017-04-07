<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.com.chengyisheng.sys.constant.WebConstants" %>
<%@ page import="cn.com.chengyisheng.sys.constant.SystemParams" %>
<%@ page import="java.net.URLEncoder" %>
<%
    String client = (String)request.getSession().getAttribute(WebConstants.SESSION_CLIENT_TYPE);
    boolean isReqFromApp = true;
    if (client == null || !client.equals(WebConstants.SESSION_CLIENT_APP)){
        isReqFromApp = false;
    }
    String appToken = request.getSession().getAttribute(SystemParams.APP_JSP_REQUEST_TOKEN_PARAM_NAME) != null ? 
            URLEncoder.encode((String)request.getSession().getAttribute(SystemParams.APP_JSP_REQUEST_TOKEN_PARAM_NAME), "UTF-8") : ""; 

%>

<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <% if (isReqFromApp){ %>
            <title>管理出诊地址</title>
    <% } %>
    <jsp:include page="../include/doctor_head.jsp"/>
</head>
<body>
<!-- topbar start -->
<!--  对于从app过来的请求，不显示页面的header -->
<% if (!isReqFromApp) { %>
<header class="fixed topbar">
    <a class="back-to-home logo" onclick="backToHome()">返回首页</a>
    <h3 class="tit">管理出诊地址</h3>
</header>
<% } %> 
<!-- topbar end -->

<!-- address manage start -->
<div class="main addr-manage" id="addressList" <% if (isReqFromApp){ %> style="padding-top:0px;" <% } %>></div>
<!-- address manage end -->

<!-- address new start -->
<a class="fixed btn-addr-new" onclick="goto('toAddAddress.htm')">添加出诊地址</a>
<!-- address new end -->
</body>
<script>
    function asynAddressList() {
        var data = {"random":Math.random()*10000};
        sendRequest("asynAddressList.htm", "GET", data, function(result) {
            if(result) {
                var str = new StringBuilder();
                for(var i = 0, len = result.length; i < len; i++) {
                    var address = result[i];
                    var addr_on = "";
                    if(address.isDefault){
                        addr_on = "addr-on";
                    }
                    str.append('<div class="grid addr-column mt-10"><p class="addr">'+address.address+'</p>');
                    str.append('<div class="addr-column-dw clearfix"><span onclick="setDefault(this)" class="addr-default '+addr_on+' fl" address_id="'+address.uuid+'"><i></i>设为默认出诊地址</span>');
                    str.append('<span class="operations fr"><a class="btn-opera btn-opera-edit" onclick="goto(\'toAddAddress.htm?addressId='+address.uuid+'\')"><i class="icon-opera ico-edit"></i>编辑</a>');
                    str.append('<a class="btn-opera btn-opera-del" onclick="delAddress(this,\''+address.uuid+'\')"><i class="icon-opera ico-del"></i>删除</a>');
                    str.append('</span></div></div>');
                }
                $("#addressList").html(str.toString());
            }
        });
    }
    asynAddressList();

    //设置默认地址
    function setDefault(_this) {
        if(!$(_this).hasClass("addr-on")) {
            var addressId = $(_this).attr("address_id");
            var data = {"addressId":addressId};
            sendRequest("setDefaultAddress.htm", "POST", data, function(msg) {
                if(msg) {
                    layer.alert(msg, {
                        title: false,
                        closeBtn: false
                    }, function () {
                        layer.closeAll();
                    });
                } else {
                    $(".addr-on").removeClass("addr-on");
                    $(_this).addClass("addr-on");
                    layer.msg('设置成功', {
                            //icon: 1,
                            time: 1000 //1秒关闭（如果不配置，默认是3秒）
                        }, function(){
                            goto('toVisitArrange.htm?<%=SystemParams.APP_JSP_REQUEST_TOKEN_PARAM_NAME%>=<%=appToken%>');
                        }
                	); 
                }
            });
        }
    }

    //删除地址
    function delAddress(_this, addressId) {
        layer.confirm('确定要删除出诊地址?', {
            title: false,
            closeBtn: false,
            btn: ['取消', '确定']
        }, function(){
            layer.closeAll();
        }, function(){
            var data = {"addressId":addressId};
            sendRequest("deleteAddress.htm", "POST", data, function(msg) {
                if(msg) {
                    layer.alert(msg, {
                        title: false,
                        closeBtn: false
                    }, function () {
                        layer.closeAll();
                    });
                } else {
                    layer.msg('删除成功');
                    $(_this).closest('.addr-column').remove();
                }
            });
        });
    }
</script>
</html>
