<%@ page import="cn.aidee.jdoctor.model.JdBankCardModel" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    JdBankCardModel bankCard = (JdBankCardModel)request.getAttribute("bankCard");
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../include/doctor_head.jsp"/>
</head>
<body>
<!-- topbar start -->
<header class="fixed topbar">
    <a onclick="backToHome()" class="back-to-home logo">返回首页</a>
    <h3 class="tit">银行卡详情</h3>
    <a class="more">更多</a>
</header>
<!-- topbar end -->
<!-- bank card detail start -->
<div class="main bank-card-detail">
    <div class="grid mt-10">
        <p>
            <label for="bank-type">银行</label>
            <input type="text" name="bank-type" id="bank-type" value="<%=bankCard.getBankName()%>" readonly/>
        </p>

        <p>
            <label for="bank-branch">支行</label>
            <input type="text" name="bank-branch" id="bank-branch" value="<%=bankCard.getSubBranch()%>" readonly/>
        </p>

        <p>
            <label for="card-num">卡号</label>
            <input type="text" name="card-num" id="card-num" value="<%=bankCard.getReceiptAccount()%>" readonly/>
        </p>

        <p>
            <label for="cardholder">持卡人</label>
            <input type="text" name="cardholder" id="cardholder" value="<%=bankCard.getReceiptName()%>" readonly/>
        </p>

    </div>
</div>
<!-- bank card detail end -->
<!-- more start -->
<div class="mask"></div>
<div class="popup unbind">
    <div class="popup-con">
        <a class="btn-more btn-unbind">解除绑定</a>
    </div>
    <div class="popup-bottom">
        <a class="btn-more btn-m-cancel">取消</a>
    </div>
</div>
<!-- more end -->
</body>
<script>
    // 银行卡解绑
    $('.more').on('click', function () {
        $('.mask, .unbind').fadeIn();
    });

    $('.btn-unbind').on('click', function () {
        $('.mask, .unbind').fadeOut();
        layer.confirm('确定要解除绑定?', {
            title: false,
            closeBtn: false,
            btn: ['取消', '确定']
        }, function () {
            layer.closeAll();
        }, function () {
            var data = {"cardId":"<%=bankCard.getUuid().toString()%>"};
            sendRequest("deleteBankCard.htm", "POST", data, function(result) {
                if(result) {
                    layer.alert(result, {
                        title: false,
                        closeBtn: false
                    }, function () {
                        layer.closeAll();
                    });
                } else {
                    goto("toBankCardManage.htm");
                }
            });
        })
    });

    $('.btn-m-cancel').on('click', function () {
        $('.mask, .unbind').fadeOut();
    });
</script>
</html>
