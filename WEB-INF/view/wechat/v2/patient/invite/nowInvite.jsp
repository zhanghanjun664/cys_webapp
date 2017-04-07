<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.aidee.jdoctor.model.JdPatientModel" %>
<%
    JdPatientModel patient = (JdPatientModel) request.getAttribute("patient");
    String wxconfig = (String) request.getAttribute("wxconfig");
    String baseUrl = (String) request.getAttribute("base_url");
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../../include/head.jsp"/>
</head>
<body class="bgf">
<!--wrap-->
<div class="wrap">
    <!--nowinv_banner-->
    <div class="nowinv_banner">
        <img src="../../wechat/images/v2/invite_nowpic.jpg" alt="">
    </div>
    <!--nowinv_banner-->

    <!--now_invite_wrap-->
    <div class="now_invite_wrap">
        <p class="nowinvite_font1">邀/请/亲/友/即/领</p>
        <p class="nowinvite_font2">现金券</p>
        <p class="nowinvite_font3">给亲友送<span class="setFont">￥100</span>现金券</p>
        <p class="nowinvite_font4">体验最好的心脑血管名医就诊服务</p>
        <p class="nowinvite_font5">每位亲友领取后</p>
        <p class="nowinvite_font6">您将获得<span class="setFont">￥20</span>邀请券</p>
        <p class="nowinvite_font7">（数量不限，不可累积使用）</p>
        <a href="<%=baseUrl%>weixin/patient/toInvite.htm?patientId=<%= patient.getUuid().toString()%>"></a>
    </div>
    <!--now_invite_wrap-->

    <div class="fixbtn" id="nowsharea">马上邀请</div>

</div>
<!--wrap-->

<div class="share_wrap">
    <div class="share_pic">
    </div>
</div>

</body>
<script src="../../wechat/js/weixin.js" type="text/javascript"></script>
<script type="text/javascript">
    sendPageVisit(Page_Constant.NowInvite);

    var patientId = "<%= patient.getUuid().toString()%>";
    var baserUrl = <%=baseUrl%>;

    var wxconfig=null;
    $.ajax({
        url:'/wxapi/public/wxConfig/patient',
        data:JSON.stringify({
        url:window.location.href
        }),
     dataType:'json',
    contentType: "application/json; charset=utf-8",
    type:'post',
    async:false,
    success:function(s){
    if(s.code===2000){

    wxconfig=s.result;

    }else{
    console.log('get share config fail');
    }
    }
    });


    wx.config({
        debug: false,
        appId: wxconfig.appId,
        timestamp: wxconfig.timestamp,
        nonceStr: wxconfig.nonceStr,
        signature: wxconfig.signature,
        jsApiList: ['checkJsApi', 'onMenuShareTimeline', 'onMenuShareAppMessage']
    });
    wx.ready(function () {
        wx.checkJsApi({
            jsApiList: ['onMenuShareTimeline', 'onMenuShareAppMessage'],
            success: function (res) {
                if (!res.checkResult.onMenuShareTimeline || !res.checkResult.onMenuShareAppMessage) {
                    var msg = '您的微信版本不支持分享接口，请升级后再分享，谢谢支持！';
                    layer.alert(msg, {
                        title: false,
                        closeBtn: false
                    }, function () {
                        layer.closeAll();
                    });
                }
            }
        });
        wx.onMenuShareTimeline({
            title: '极速预约心脑血管名医，我选橙医生',
            desc:'我申请给你发了￥100现金券，来体验最好的心脑血管名医就诊服务吧！',
            link: baserUrl + 'weixin/patient/toInvite.htm?patientId=' + patientId,
            imgUrl: 'http://m.chengyisheng.com.cn/data/static_img/logo.jpg',
            success: function () {
                shareOk();
            }
        });
        wx.onMenuShareAppMessage({
            title: '极速预约心脑血管名医，我选橙医生',
            desc:'我申请给你发了￥100现金券，来体验最好的心脑血管名医就诊服务吧！',
            link: baserUrl + 'weixin/patient/toInvite.htm?patientId=' + patientId,
            imgUrl: 'http://m.chengyisheng.com.cn/data/static_img/logo.jpg',
            type: 'link',
            success: function () {
                shareOk();
            }
        });
    });

    $('#nowsharea').on('click', function (ev) {
        $('.share_wrap').css({'display': 'block'});
    });
    $('.share_wrap').on('click', function (ev) {
        $('.share_wrap').css({'display': 'none'});
    });
    function shareOk() {
        var data = {"patientId": patientId};
        sendRequest("generatePatientQrcode.htm", "POST", data, function (result) {
            if(result){
                layer.alert(result, {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                });
            }else{
                var shareOk= '分享成功！';
                layer.alert(shareOk, {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                });
            }
        });
    }
</script>
</html>
