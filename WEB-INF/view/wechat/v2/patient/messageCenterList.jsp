<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../include/head.jsp"/>
</head>
<body>
<!--wrap-->
<div class="wrap">
    <!--header-->
    <header class="header pr">
        <h1 class="logo pa">
            <a onclick="toMain()"></a>
        </h1>
        <h2>消息中心</h2>
    </header>
    <!--header-->

    <!--content-->
    <div class="content">
        <ul class="mescenter"></ul>
    </div>
    <!--content-->
</div>
<!--wrap-->
</body>
<script>
    sendPageVisit(Page_Constant.Message);

    var pageIndex1 = 1;
    var loadEnd1 = false;
    var inited = false;
    function asynMessageList() {
        if(loadEnd1) return;
        var data = {"pageIndex":pageIndex1, "random":Math.random()*10000};
        sendRequest("asynMessageListByPaging.htm", "GET", data, function(resultPage) {
            inited = true;
            if(resultPage) {
                var str = new StringBuilder();
                for(var i = 0, len = resultPage.result.length; i < len; i++) {
                    var message = resultPage.result[i];
                    str.append('<li>');
                    if(message.orderNumber) {
                        str.append('<p class="megnumber"><b>预约号:</b><span>'+message.orderNumber+'</span></p>');
                        str.append('<p><b>预约时间:</b><span>'+message.oppointmentDate+'<span></p>');
                        str.append('<p class="meg_line"><b>家庭联系人:</b><span>'+message.name+'</span></p>');
                    }
                    str.append('<p><b>消息时间:</b>'+message.createDate+'</p>');
                    str.append('<p><b>消息内容:</b></p>');
                    str.append('<p class="megcontent">'+message.content+'</p></li>');
                }
                $(".mescenter").append(str.toString());
                if(pageIndex1 >= resultPage.totalPage) {
                    loadEnd1 = true;
                } else {
                    pageIndex1++;
                }
            }
        });
    }
    asynMessageList();

    /*************************** start 滚动到底部自动加载消息列表 ***************************/
    var totalheight;
    $(window).scroll(function () {
        if(!loadEnd1 && inited) {
            totalheight = parseFloat($(window).height()) + parseFloat($(window).scrollTop());
            if($(document).height() <= totalheight) {
                asynMessageList();
            }
        }
    });
    /*************************** end 滚动到底部自动加载消息列表 ***************************/
</script>
</html>
