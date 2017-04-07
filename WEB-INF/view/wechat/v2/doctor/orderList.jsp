<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.com.chengyisheng.sys.constant.SystemParams" %>
<%@ page import="cn.com.chengyisheng.sys.constant.WebConstants" %>
<%@ page import="java.net.URLEncoder" %>
<%
    String status = (String) request.getAttribute("status");
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
            <title>见面咨询</title>
    <% } %>
    <jsp:include page="../include/doctor_head.jsp"/>
</head>
<body>
<!-- topbar start -->
<% if (!isReqFromApp) { %>
<header class="fixed topbar">
    <a href="javascript:void(0);" class="back-to-home logo" onclick="backToHome()">返回首页</a>
    <h3 class="tit">我的预约</h3>
    <a href="javascript:void(0);" class="btn-order-search" bol=true>搜索</a>
</header>
<% } %>
<!-- topbar end -->

<!-- main start -->
<div class="tab my-order" <% if (isReqFromApp){ %> style="padding-top:0px;" <% } %>>
    <!--search_input-->
    <div class="search_input">
        <input type="text" placeholder="请输入关键字搜索" id="searchKey">
    </div>
    <!--search_input-->
    <div class="tab-tit">
        <a id="waitTab" href="javascript:void(0);" class="active">待出诊(<span id="waitCount">0</span>)</a>
        <a id="confirmTab" href="javascript:void(0);">待确认(<span id="confirmCount">0</span>)</a>
        <a id="finishTab" href="javascript:void(0);">已完成(<span id="finishCount">0</span>)</a>
    </div>
    <div class="tab-con">
        <!-- 待出诊 -->
        <div class="order-visit" style="display:block;"></div>
        <!-- 待确认 -->
        <div class="order-confirm"></div>
        <!-- 已完成 -->
        <div class="order-done"></div>
    </div>
</div>
<!-- main end -->
<!-- record order number start -->
<div class="mask"></div>
<div class="popup record-order-num">
    <div class="popup-con">
        <p>
            <label for="order-num">预约号</label>
            <input type="text" id="order-num" placeholder="请输入预约号"/>
        </p>
    </div>
    <div class="popup-bottom">
        <a class="p-btn-cancel">取消</a>
        <a class="p-btn-confirm">确认</a>
    </div>
</div>
<!-- record order number end -->
</body>
<script>

    window.sessionStorage.removeItem('order_detail');
    window.sessionStorage.removeItem('diagnosis_result');
    window.sessionStorage.removeItem('diagnosis_data');
    window.sessionStorage.removeItem('reservation_number');

    // tab
    function clickOrderTab(tab, con) {
        $(tab).each(function (i) {
            $(this).click(function () {
                $(this).addClass("active").siblings(tab).removeClass("active");
                $(con).eq(i).show().siblings(con).hide();
                currentTab = $(this).attr("id");
                return false;
            })
        })
    }
    var currentTab = "waitTab";
    clickOrderTab('.tab-tit a', '.tab-con > div');

    // 初始化打开
    var status = "<%=status%>";
    if(status === "2") {
        $("#confirmTab").click();
    } else if(status === "3") {
        $("#finishTab").click();
    }

    // 搜索框
    $('.btn-order-search').on('click',function(ev){
        if ($(this).attr('bol')=="true") {
            $('.search_input').css({'display':'block'});
            $(this).attr('bol',"false");
        } else if ($(this).attr('bol')=="false") {
            $('.search_input').css({'display':'none'});
            $(this).attr('bol',"true");
        }
    });
    //回车触发关键字搜索
    var searchKey = "";
    document.onkeydown = function (event) {
        if (event.keyCode == 13) {
            event.preventDefault();
            searchKey = trim($('#searchKey').val());
            asynNotreatOrderList(true);
            asynNoconfirmOrderList(true);
            asynTreatedOrderList(true);
        }
    };
    /*************************** start 待出诊列表 ***************************/
    var pageIndex1 = 1;
    var loadEnd1 = false;
    function asynNotreatOrderList(refresh) {
        if(refresh) {
            $(".order-visit").html("");
            pageIndex1 = 1;
            loadEnd1 = false;
        }
        var data = {"pageIndex":pageIndex1, "status":1, "searchKey":searchKey, "random":Math.random()*10000};
        sendRequest("asynOrdertListByPaging.htm", "GET", data, function(resultPage) {
            if(resultPage) {
                if(pageIndex1 == 1) {
                    $("#waitCount").html(resultPage.totalCount);
                }
                var str = new StringBuilder();
                for(var i = 0, len = resultPage.result.length; i < len; i++) {
                    var order = resultPage.result[i];
                    var mt = " mt-10";
                    if(pageIndex1 == 1 && i == 0) {
                        mt = "";
                    }
                    str.append('<div class="grid'+mt+'" onclick="toOrderDetail(1,\''+order.uuid+'\')"><div class="order-column"><div class="clearfix"><i class="order-time fl">');
                    str.append(order.oppointmentTimeStart + '</i><em class="order-status status-visit fr">待出诊</em></div><p>');
                    str.append(order.appointmentAddress + '</p></div><div class="order-column"><p><label>患者姓名</label>'+order.name+'('+order.age+'岁)</p>');
                    str.append('<p><label>病情描述</label>'+order.sickDescription+'</p></div>');
                    str.append('<div class="order-column"><p><label>咨询费</label>￥'+order.consultationFee+'</p></div></div>');
                }
                $(".order-visit").append(str.toString());
                if(pageIndex1 >= resultPage.totalPage) {
                    loadEnd1 = true;
                } else {
                    pageIndex1++;
                }
            }
        });
    }
    asynNotreatOrderList(false);
    /*************************** end 待出诊列表 ***************************/

    /*************************** start 待确认列表 ***************************/
    var Json=[];

    var pageIndex2 = 1;
    var loadEnd2 = false;
    function asynNoconfirmOrderList(refresh) {
        if(refresh) {
            $(".order-confirm").html("");
            pageIndex2 = 1;
            loadEnd2 = false;
        }
        var data = {"pageIndex":pageIndex2, "status":2, "searchKey":searchKey, "random":Math.random()*10000};
        sendRequest("asynOrdertListByPaging.htm", "GET", data, function(resultPage) {
            if(resultPage) {
                if(pageIndex2 == 1) {
                    $("#confirmCount").html(resultPage.totalCount);
                }
                var str = new StringBuilder();
                for(var i = 0, len = resultPage.result.length; i < len; i++) {
                    var order = resultPage.result[i];
                    var mt = " mt-10";
                    if(pageIndex2 == 1 && i == 0)
                        mt = "";
                        var content={
                                'uuid':order.uuid,
                                'oppointmentTimeStart':order.oppointmentTimeStart,
                                'name':order.name,
                                'age':order.age,
                                'fee':order.consultationFee,
                                'sickDescription':order.sickDescription,
                                'appointmentAddress':order.appointmentAddress
                        };

                        Json.push(content);
                        <%--var json_object= JSON.stringify(content);--%>

                        <%--console.log(json_object);--%>


                    str.append('<div class="grid'+mt+'" onclick="toOrderDetail(2,\''+order.uuid+'\')" ><div class="order-column"><div class="clearfix"><i class="order-time fl">');
                    str.append(order.oppointmentTimeStart + '</i><em class="order-status status-confirm fr">待确认</em></div><p>');
                    str.append(order.appointmentAddress + '</p></div><div class="order-column"><p><label>患者姓名</label>'+order.name+'('+order.age+'岁)</p>');
                    str.append('<p><label>病情描述</label>'+order.sickDescription+'</p></div><div class="order-column"><p class="clearfix"><span><label>咨询费</label>￥');
                    str.append(order.consultationFee+'</span><a href="javascript:void(0);" class="btn-record"   onclick="recordNumber(event, \''+order.uuid+'\',this)">记录预约号</a></p></div></div>');
                }
                $(".order-confirm").append(str.toString());
                if(pageIndex2 >= resultPage.totalPage) {
                    loadEnd2 = true;
                } else {
                    pageIndex2++;
                }
            }
        });
    }
    asynNoconfirmOrderList(false);
    /*************************** end 待确认列表 ***************************/

    /*************************** start 已出诊列表 ***************************/
    var pageIndex3 = 1;
    var loadEnd3 = false;
    function asynTreatedOrderList(refresh) {
        if(refresh) {
            $(".order-done").html("");
            pageIndex3 = 1;
            loadEnd3 = false;
        }
        var data = {"pageIndex":pageIndex3, "status":3, "searchKey":searchKey, "random":Math.random()*10000};
        sendRequest("asynOrdertListByPaging.htm", "GET", data, function(resultPage) {
            if(resultPage) {
                if(pageIndex3 == 1) {
                    $("#finishCount").html(resultPage.totalCount);
                }
                var str = new StringBuilder();
                for(var i = 0, len = resultPage.result.length; i < len; i++) {
                    var order = resultPage.result[i];
                    var mt = " mt-10";
                    if(pageIndex3 == 1 && i == 0) {
                        mt = "";
                    }
                    str.append('<div class="grid'+mt+'" onclick="toOrderDetail(3,\''+order.uuid+'\')"><div class="order-column"><div class="clearfix"><i class="order-time fl">');
                    str.append(order.oppointmentTimeStart + '</i><em class="order-status status-done fr">已完成</em></div><p>');
                    str.append(order.appointmentAddress + '</p></div><div class="order-column"><p><label>患者姓名</label>'+order.name+'('+order.age+'岁)</p>');
                    str.append('<p><label>病情描述</label>'+order.sickDescription+'</p></div>');
                    str.append('<div class="order-column"><p><label>咨询费</label>￥'+order.consultationFee+'</p></div></div>');
                }
                $(".order-done").append(str.toString());
                if(pageIndex3 >= resultPage.totalPage) {
                    loadEnd3 = true;
                } else {
                    pageIndex3++;
                }
            }
        });
    }
    asynTreatedOrderList(false);
    /*************************** end 已出诊列表 ***************************/

    /*************************** start 滚动到底部自动加载预约列表 ***************************/
    var totalheight;
    $(window).scroll(function () {
        if(currentTab == "waitTab" && !loadEnd1) { //待出诊
            totalheight = parseFloat($(window).height()) + parseFloat($(window).scrollTop());
            if($(document).height() - 20 <= totalheight) {
                asynNotreatOrderList(false);
            }
        } else if(currentTab == "confirmTab" && !loadEnd2) { //待确认
            totalheight = parseFloat($(window).height()) + parseFloat($(window).scrollTop());
            if($(document).height() - 20 <= totalheight) {
                asynNoconfirmOrderList(false);
            }
        } else if(currentTab == "finishTab" && !loadEnd3) { //已出诊
            totalheight = parseFloat($(window).height()) + parseFloat($(window).scrollTop());
            if($(document).height() - 20 <= totalheight) {
                asynTreatedOrderList(false);
            }
        }
    });

    //获取token
    function getToken(name){
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
        var r = window.location.search.substr(1).match(reg);
        if (r !== null) {
            return decodeURIComponent(r[2]);
        } else {
            return null;
        }
    }

    var token=getToken('token');

    // 记录预约号
    var selectOrderId;
    function recordNumber(e, orderId,_this) {
        e.stopPropagation();
        selectOrderId = orderId;

        if(token===null){
            $('.mask, .record-order-num').fadeIn();
        }else{

                for(var i=0;i<Json.length;i++){
                        if(Json[i].uuid===orderId){

                                window.sessionStorage.setItem('order_detail', JSON.stringify(Json[i]));
                        }
                }

        window.location.href='/app_web/app_doctor_web/view/inputDiagnosis.html?token='+token;


        }

    }
    var submitFlag = false;
    $('.p-btn-confirm').on('click', function () {
        if(submitFlag)
            return;
        submitFlag = true;

        var orderNumVal = trim($('#order-num').val());
        if(orderNumVal.length < 1) {
            $('.mask, .record-order-num').fadeOut();
            layer.alert('请输入正确的预约号', {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('.mask, .record-order-num').fadeIn();
                $('#order-num').focus();
            });
            submitFlag = false;
            return;
        }
        var data = {"orderId" : selectOrderId, "orderNumber" : orderNumVal};
        sendRequest("recordOrderNumber.htm", "POST", data, function(result) {
            if(result) {
                $('.mask, .record-order-num').fadeOut();
                layer.alert(result, {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                    $('.mask, .record-order-num').fadeIn();
                    $('#order-num').focus();
                });
            } else {
                layer.alert('录入成功', {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                });
                $('#order-num').val("");
                $('.mask, .record-order-num').fadeOut();
                asynNoconfirmOrderList(true);
                asynTreatedOrderList(true);
            }
            submitFlag = false;
        }, function() {
            submitFlag = false;
        });
    });
    $('.p-btn-cancel, .mask').on('click', function () {
        $('.mask, .record-order-num').fadeOut();
        $('#order-num').val("");
    });

    // 跳转预约详情
    function toOrderDetail(status, orderId) {
        window.location.href = "toOrderDetail.htm?orderId="+orderId+"&status="+status+"&<%=SystemParams.APP_JSP_REQUEST_TOKEN_PARAM_NAME%>=<%=appToken%>";
    }
</script>
</html>
