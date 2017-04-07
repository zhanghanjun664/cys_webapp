<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<meta charset="utf-8">
<meta http-equiv="Content-Type" content="application/xhtml+xml;charset=UTF-8">
<meta http-equiv="Cache-Control" content="no-cache,no-store,must-revalidate">
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="expires" content="0">
<meta content="telephone=no, address=no" name="format-detection">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="format-detection" content="telephone=no">
<title>极速预约心脑血管名医</title>
<link href="/wechat/css/patient_v2/base.css" rel="stylesheet">
<link href="/wechat/css/patient_v2/layer_skin_extend.css" rel="stylesheet">
<link href="/wechat/css/patient_v2/style.css" rel="stylesheet">
<link href="/wechat/css/patient_v2/swiper.min.css" rel="stylesheet">
<script src="/wechat/js/patient_v2/jquery.js" type="text/javascript"></script>
<script src="/wechat/js/patient_v2/iscroll.js"></script>
<script src="/wechat/js/patient_v2/layer/layer.js"></script>
<script src="/wechat/js/patient_v2/layer/extend/layer.ext.js"></script>
<script src="/wechat/js/patient_v2/alert.js"></script>
<script src="/wechat/js/patient_v2/public.js"></script>
<script src="/wechat/js/patient_v2/home.js"></script>
<script src="/wechat/js/md5.js"></script>
<script src="/wechat/js/swiper.min.js"></script>
<script>
    (function(){
        function is_weixn(){
            var ua = navigator.userAgent.toLowerCase();
            if(ua.match(/MicroMessenger/i)=="micromessenger") {
                return true;
            } else {
                return false;
            }
        }
        if(is_weixn()){
            $(".is_weixin_display").show();
        }else{
            $(".is_weixin_display").hide();
        }
    })();
    if(window.location.hostname==="m.chengyisheng.com.cn"){
        var _hmt = _hmt || [];
        (function() {
            var hm = document.createElement("script");
            hm.src = "//hm.baidu.com/hm.js?3982cef2740af79737101d78ab7ad6f8";
            var s = document.getElementsByTagName("script")[0];
            s.parentNode.insertBefore(hm, s);
        })();
    }
</script>