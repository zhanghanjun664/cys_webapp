<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.aidee.framework.base.utils.DateUtils" %>
<%@ page import="cn.aidee.jdoctor.model.JdCouponQueryModel" %>
<%@ page import="java.util.List" %>
<%
    List<JdCouponQueryModel> couponList = (List<JdCouponQueryModel>) request.getAttribute("couponList");
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../include/head.jsp"/>
</head>
<body>
<!--wrap-->
<div class="wrap pr" id="cashroll_wrap">
    <!--header-->
    <header class="header pr">
        <h1 class="logo pa">
            <a onclick="toMain()"></a>
        </h1>
        <h2>现金券</h2>
        <span class="edit pa rollrules" id="userules">使用规则</span>
    </header>
    <!--header-->

    <!--content-->
    <div class="content cash_wrap">
        <ul id="cashCouponList">
            <%
                for(JdCouponQueryModel coupon : couponList) {
            %>
                <li>
                    <a class="pr">
                        <span class="pa cash_price"><i>￥</i><%=coupon.getValue().setScale(0).toString()%></span>
                        <span class="pa cash_data">
                            <p>兑换码：<span><%=coupon.getCode()%></span></p>
                            <p>有效期至：<%=DateUtils.format(coupon.getExpiredDate(), "yyyy-MM-dd")%></p>
                            <p><%= "Y".equals(coupon.getSuperposition()) ? "可叠加使用" : "不可叠加使用"%></p>
                        </span>
                        <span onclick="javascript:window.location.href ='/wechat_web/wap_wechat_patient/html/hospital.html?type=hospital';" class="use_cash pa">去使用</span>
                    </a>
                </li>
            <%
                }
            %>
        </ul>
    </div>
    <!--content-->

    <!--addcash-->
    <footer class="addcash" id="addcash">添加现金劵</footer>
    <!--addcash-->
</div>
<!--wrap-->

<div class="mustknow_wrap" id="cashroll_rules">
    <header class="closeheader pr">
        <a href="javascript:void(0)" class="pa close rules_close"></a>
        <h2>使用规则</h2>
    </header>
    <div class="roll_content">
        <p><i>1.</i><b>现金券、邀请券需要在有限期内使用。</b></p>

        <p><i>2.</i><b>现金券、邀请券不可同时使用。</b></p>

        <p><i>3.</i><b>现金券、邀请券只能用于抵扣诊金，不能抵扣保证金，不可提现，不找退。</b></p>

        <p><i>4.</i><b>见医生前取消订单，现金券、邀请券全额返回，患者端爽约，扣除现金券、邀请券。</b></p>

        <p><i>5.</i><b>现金券抵扣额度根据医生级别而定：</b></p>

        <p>
            <small>（1）主任医师最多抵扣300元</small>
        </p>
        <p>
            <small>（2）副主任医师最多抵扣150元</small>
        </p>
        <p>
            <small>（3）主治医师最多抵扣50元</small>
        </p>

        <p><i>6.</i><b>邀请券抵扣额度根据医生级别而定：</b></p>

        <p>
            <small>（1）主任医师最多抵扣5张</small>
        </p>
        <p>
            <small>（2）副主任医师最多抵扣3张</small>
        </p>
        <p>
            <small>（3）主治医师最多抵扣1张</small>
        </p>
        <div class="iknow rules_close">我知道了</div>
    </div>
</div>
</body>
<script>
    sendPageVisit(Page_Constant.CashCoupon);

    $('#userules').on('click',function(ev){
        $('#cashroll_wrap').css({'display':'none'});
        $('#cashroll_rules').css({'display':'block'});
    });
    $('.rules_close').on('click',function(ev){
        $('#cashroll_wrap').css({'display':'block'});
        $('#cashroll_rules').css({'display':'none'});
    });

    var addFlag = false;
    $('#addcash').on('click',function(ev){
        var a1=new Attribute({
            number:'4',
            placeholder:'请输入兑换码',
            leftfn:function(){
            },
            rightfn:function(){
                var cashCouponNum = $.trim(this.getData());
                if(cashCouponNum.length === 0) {
                    layer.alert("请输入现金券兑换码", {
                        title: false,
                        closeBtn: false
                    }, function () {
                        layer.closeAll();
                    });
                    return;
                }
                if(addFlag)
                    return;
                addFlag = true;
                var data = {"code" : cashCouponNum};
                sendRequest("addCoupon.htm", "POST", data, function(result) {
                    if(result.result != 0) {
                        layer.alert(result.description, {
                            title: false,
                            closeBtn: false
                        }, function () {
                            layer.closeAll();
                        });
                    } else {
                        var str = new StringBuilder();
                        str.append('<li><a class="pr"><span class="pa cash_price"><i>￥</i>'+result.couponModel.value +'</span>');
                        str.append('<span class="pa cash_data"><p>兑换码：<span>'+result.couponModel.code+'</span></p>');
                        str.append('<p>有效期至：'+result.couponModel.expiredDate+'</p></span>');
                        str.append('<span onclick="toMain()" class="use_cash pa">去使用</span></a></li>');
                        $("#cashCouponList").append(str.toString());
                    }
                    addFlag = false;
                }, function() {
                    addFlag = false;
                });
            }
        });
    });
</script>
</html>
