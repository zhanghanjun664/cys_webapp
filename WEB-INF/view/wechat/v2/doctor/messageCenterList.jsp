<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../include/doctor_head.jsp"/>
    <style>
        *{margin:0px;padding:0px;}
        ul, li{
            margin: 0;
            padding: 0;
            border: 0;
            outline: 0;
            list-style:none;
        }
        p{ margin:0px; padding:0px;}
        a{ text-decoration:none;}
        html,body{width:100%;height:100%;margin:0;padding:0;font-size:100%;background:#F2F2F2;}
        a{color:#000000;-webkit-tap-highlight-color: transparent;}
        img,li,div{-webkit-tap-highlight-color:transparent;}
        #mainDiv{width:100%;display:none;padding-bottom:3em;}
        #mainDiv .btmul{width:100%;overflow:hidden;padding:0 0 1.5em 0;}
        #mainDiv .btmul .btmul_li{width:100%;float:left;margin-top:5%;background:#FFFFFF;}
        #mainDiv .btmul .btmul_li ul{width:100%;overflow:hidden;}
        #mainDiv .btmul .btmul_li ul li{width:100%;float:left;padding:0.5em 0 0 0;}
        #mainDiv .btmul .btmul_li ul .cont_li1_sp1{font-size:1em;color:#000000;margin-left:3%;}
        #mainDiv .btmul .btmul_li ul .cont_li1_sp2{font-size:1em;color:#FB9D3B;}
        #mainDiv .btmul .btmul_li ul .cont_li2_sp1{font-size:1em;color:#000000;margin-left:3%;}
        #mainDiv .btmul .btmul_li ul .cont_li2_sp2{font-size:1em;color:#000000;margin-left:1%;}
        #mainDiv .btmul .btmul_li ul .cont_li2_sp3{font-size:1em;color:#000000;margin-left:1%;}
        #mainDiv .btmul .btmul_li ul .cont_li2{border-bottom:#E6E6E6 0.15em solid;-webkit-border-bottom:#E6E6E6 0.1em solid;}
        #mainDiv .btmul .btmul_li ul .cont_li3{padding:0.3em 0 0.3em 0;}
        #mainDiv .btmul .btmul_li ul .cont_li3_sp1{margin-left:3%;font-size:1em;color:#000000;padding:0.3em 0 0.3em 0;}
        #mainDiv .btmul .btmul_li ul .cont_li4{padding:0.2em 0 0.2em 0;}
        #mainDiv .btmul .btmul_li ul .cont_li4_p1{margin-left:3%;font-size:1em;color:#000000;}
    </style>
</head>
<body>
<div id="mainDiv">
    <!-- topbar start -->
    <header class="fixed topbar">
        <a onclick="backToHome()" class="back-to-home logo">返回首页</a>
        <h3 class="tit">消息中心</h3>
    </header>
    <!-- topbar end -->
    <ul class="btmul" id="messageList"></ul>
</div>
</body>
<script>
    var mw = $(window).width();
    var mh = $(window).height();
    $('#mainDiv').width(mw);
    $('.btmul').width(mw).css("margin-top","30px");
    $('.btmul_li').width(mw);
    $('#mainDiv').show();

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
                    str.append('<li class="btmul_li"><ul>');
                    str.append('<li class="cont_li3"><span class="cont_li3_sp1">'+message.createDate+'</span></li>');
                    str.append('<li class="cont_li4"><p class="cont_li4_p1">'+message.content+'</p></li></ul></li>');
                }
                $("#messageList").append(str.toString());
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
            if($(document).height() - 20 <= totalheight) {
                asynMessageList();
            }
        }
    });
    /*************************** end 滚动到底部自动加载消息列表 ***************************/
</script>
</html>
