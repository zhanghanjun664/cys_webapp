<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../include/doctor_head.jsp"/>
</head>
<body>
<!-- topbar start -->
<header class="fixed topbar">
    <a onclick="backToHome()" class="back-to-home logo">返回首页</a>
    <h3 class="tit">转账记录</h3>
</header>
<!-- topbar end -->
<!-- transfer record start -->
<div class="main transfer-record">
    <div class="grid mt-10" id="historyList"></div>
</div>
<!-- transfer record end -->
</body>
<script>
    /*************************** start 转账记录列表 ***************************/
    var pageIndex1 = 1;
    var loadEnd1 = false;
    function asynWithdrawlHistoryByPaging() {
        var data = {"pageIndex":pageIndex1, "random":Math.random()*10000};
        sendRequest("asynWithdrawlHistoryByPaging.htm", "GET", data, function(resultPage) {
            if(resultPage) {
                var str = new StringBuilder();
                for(var i = 0, len = resultPage.result.length; i < len; i++) {
                    var record = resultPage.result[i];
                    var isin = false;
                    str.append('<dl><dt><h3>');
                    if(record.type == "DOCTOR_WITHDRAWL") {
                        str.append('提现');
                    } else if(record.type == "DOCTOR_DIAGNOSE") {
                        str.append('诊金');
                        isin = true;
                    } else if(record.type == "RECOMMEND") {
                        str.append('推荐奖金');
                        isin = true;
                    }
                    str.append('</h3><i>'+record.createDate+'</i></dt>');
                    if(isin) {
                        str.append('<dd class="in">\+'+record.amount+'元</dd></dl>');
                    } else {
                        str.append('<dd>-'+record.amount+'元</dd></dl>');
                    }
                }
                $("#historyList").append(str.toString());
                if(pageIndex1 >= resultPage.totalPage) {
                    loadEnd1 = true;
                } else {
                    pageIndex1++;
                }
            }
        });
    }
    asynWithdrawlHistoryByPaging();
    /*************************** end 转账记录列表 ***************************/

    /*************************** start 滚动到底部自动加载转账记录列表 ***************************/
    var totalheight;
    $(window).scroll(function () {
        if(!loadEnd1) {
            totalheight = parseFloat($(window).height()) + parseFloat($(window).scrollTop());
            if($(document).height() - 20 <= totalheight) {
                asynWithdrawlHistoryByPaging();
            }
        }
    });
    /*************************** end 滚动到底部自动加载转账记录列表 ***************************/
</script>
</html>
