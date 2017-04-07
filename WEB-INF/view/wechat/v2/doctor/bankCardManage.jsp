<%@ page import="cn.aidee.jdoctor.model.JdBankCardQueryModel" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<JdBankCardQueryModel> bankCardList = (List<JdBankCardQueryModel>)request.getAttribute("bankCardList");
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
    <h3 class="tit">银行卡</h3>
</header>
<!-- topbar end -->
<!-- bank card start -->
<div class="main bank-card">
    <%
        if(bankCardList != null) {
            for(JdBankCardQueryModel bankCard : bankCardList) {
    %>
            <div class="grid mt-10">
                <a onclick="goto('toBankCardDetail.htm?id=<%=bankCard.getUuid().toString()%>')">
                    <dl>
                        <dt>
                            <img src="../../wechat/images/v2/bank_icbc.jpg" width="45" height="45" />
                        </dt>
                        <dd>
                            <h3><%=bankCard.getBankName()%></h3>

                            <p>尾号<%=bankCard.getReceiptAccount().substring(bankCard.getReceiptAccount().length()-4, bankCard.getReceiptAccount().length())%> 储蓄卡</p>
                        </dd>
                    </dl>
                </a>
            </div>
    <%
            }
        }
    %>
    <div class="grid mt-10">
        <a onclick="goto('toAddBankCard.htm?from=cardManage')" class="btn-card-new"><i class="icon-plus"></i>添加银行卡</a>
    </div>
</div>
<!-- bank card end -->
</body>
</html>
