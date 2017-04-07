<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../../include/head.jsp"/>
</head>
<body>
<!--wrap-->
<div class="wrap">
    <!--header-->
    <header class="header pr">
        <h1 class="logo pa">
            <a onclick="toMain()"></a>
        </h1>
        <h2>预约记录</h2>
    </header>
    <!--header-->
    <!--content-->
    <div class="content" id="orderList"></div>
    <!--content-->
</div>
<!--wrap-->
</body>
<script>
    sendPageVisit(Page_Constant.OperationOrderList);

    var pageIndex1 = 1;
    var loadEnd1 = false;
    var inited = false;
    function asynOperationOrderList() {
        if(loadEnd1) return;
        var data = {"pageIndex":pageIndex1, "random":Math.random()*10000};
        sendRequest("asynOperationOrderList.htm", "GET", data, function(resultPage) {
            inited = true;
            if(resultPage) {
                var str = new StringBuilder();
                for(var i = 0, len = resultPage.result.length; i < len; i++) {
                    var order = resultPage.result[i];
                    str.append('<ul class="operre_list pr"><a onclick="goto(\'toFillOperationOrder.htm?id='+order.uuid+'\')">');
                    str.append('<li class="opername">'+order.name+'</li><li class="operc">'+order.idCard+'</li>');
                    str.append('<li class="operc">'+order.phoneNumber+'</li></a>');
                    switch (order.status){
                        case 'WAITTO_COMFIRM':
                        case 'APPLYING':
                        case 'WAITTO_PAY':
                        case 'WAITTO_DIAGNOSE':
                            str.append('<span class="arrow" style="width:auto;color: #fe9627;font-size: 16px;background:none;">提交成功</span></ul>');
                            break;
                        case 'FINISHED':
                            str.append('<span class="arrow" style="width:auto;color: #3598f3;font-size: 16px;background:none;">订单完成</span></ul>');
                            break;
                        case 'CANCELED':
                            str.append('<span class="arrow" style="width:auto;color: #999999;font-size: 16px;background:none;">订单取消</span></ul>');
                            break;
                    }
                    str.append('</ul>');
                }
                $("#orderList").append(str.toString());
                if(pageIndex1 >= resultPage.totalPage) {
                    loadEnd1 = true;
                } else {
                    pageIndex1++;
                }
            }
        });
    }
    asynOperationOrderList();

    /*************************** start 滚动到底部自动加载消息列表 ***************************/
    var totalheight;
    $(window).scroll(function () {
        if(!loadEnd1 && inited) {
            totalheight = parseFloat($(window).height()) + parseFloat($(window).scrollTop());
            if($(document).height() <= totalheight) {
                asynOperationOrderList();
            }
        }
    });
    /*************************** end 滚动到底部自动加载消息列表 ***************************/
</script>
</html>
