<%@ page import="cn.com.chengyisheng.service.wechat.type.WechatUser" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String resultMsg = (String)request.getAttribute("result");
	Boolean isCanDraw = (Boolean)request.getAttribute("isCanDraw");
	WechatUser userObject = (WechatUser)request.getAttribute("userObject");
	String money = (String)request.getAttribute("money");
	String doctroId = (String)request.getAttribute("doctroId");
	request.setAttribute("result",resultMsg);
	request.setAttribute("isCanDraw",isCanDraw);
	request.setAttribute("userObject",userObject);
	request.setAttribute("money",money);
	request.setAttribute("doctroId",doctroId == null ? "" : doctroId);
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
	<jsp:include page="../../include/head.jsp"/>
</head>
<body class="bgf">
	<!--wrap-->
		<div class="wrap">
			<%--旧的活动样式--%>

			<!--receive_cash-->
				<div class="receive_cash">
					您有一张<span>￥<%=request.getAttribute("money")%></span>的现金券
				</div>
			<!--receive_cash-->

			<!--receive_header-->
				<div class="receive_header" style="background:url('<%=((WechatUser) request.getAttribute("userObject")).getHeadimgurl()%>') center center no-repeat;background-size:cover;"></div>
			<!--receive_header-->

			<!--receive_name-->
				<div class="receive_name"><%=((WechatUser) request.getAttribute("userObject")).getNickname()%></div>
			<!--receive_name-->

			<%--旧的活动样式--%>

			<%--新的活动样式--%>
				<%--<div class="receive_banner">--%>
						<%--<img src="/wechat/images/v2/receive_banner.jpg" alt="">--%>
				<%--</div>--%>
				<%--<div class="receive_header_title">您将获得最高<span>￥20</span>微信红包和<span>￥<%=request.getAttribute("money")%></span>现金卷</div>--%>
			<%--新的活动样式--%>

			<!--receive_title-->
				<div class="receive_title">输入手机号码领取现金券</div>
			<!--receive_title-->
			
			<!--receive_list-->
			<ul class="receive_list">
				<li>
					<input type="number" placeholder="请输入手机号码" maxlength="11"  id="receive_phone">
					<div class="receive_condown" bol="true" id="receive_sendcode">获取验证码</div>
				</li>
				<li>
					<input type="number" placeholder="请输入验证码" maxlength="4" id="recive_code">
					
				</li>
			</ul>
			<!--receive_list-->

			<div class="fixbtn" id="nowreceive">马上领取</div>
		</div>
	<!--wrap-->
</body>
<script type="text/javascript">
	sendPageVisit(Page_Constant.DrawCoupon);

	$('#nowreceive').on('click',function(ev){
		if(checknull('#receive_phone')==false){
			layer.alert('请输入手机号码!', {
				title: false,
				closeBtn: false
			}, function(){
				layer.closeAll();
				$('#receive_phone').focus();
			});
			return;
		}
		if (checkregular('#receive_phone','1')==false) {
			layer.alert("请输入正确的11位数手机号!", {
				title: false,
				closeBtn: false
			}, function(){
				layer.closeAll();
				$('#receive_phone').focus();
			});
			return;
		}
		if(checknull('#recive_code')==false){
			layer.alert('请输入验证码!', {
				title: false,
				closeBtn: false
			}, function(){
				layer.closeAll();
				$('#recive_code').focus();
			});
			return;
		}
		var phone_number = $('#receive_phone').val();
		var validateCode = $('#recive_code').val();
		var data = {"phoneNumber": phone_number, "code": validateCode};
		var goToResister = false;
		sendRequest("verifyCode.htm", "POST", data, function (msg) {
			if(msg) {
				layer.alert(msg, {
					title: false,
					closeBtn: false
				}, function () {
					layer.closeAll();
					verifyCode.focus();
				});
				goToResister = false;
			} else{
				goToResister = true;
			}
		}, function() {
			goToResister = false;
		},false);
		if(goToResister){
			var phone_reg = $('#receive_phone').val();
			var validateCode_reg = $('#recive_code').val();
			var registerData = {"phoneNumber": phone_reg, "code": validateCode_reg,"doctroId":'<%=doctroId%>'};
			sendRequest("getCoupon.htm", "POST", registerData, function (msg) {
				var msgObj = $.parseJSON(msg);
				if(msgObj.result != 'ok') {
					layer.alert(msgObj.result, {
						title: false,
						closeBtn: false
					}, function () {
						layer.closeAll();
						verifyCode.focus();
					});
				} else {
					goto(msgObj.url);
				}
			});
		}
	});

	function countcode(){
		$('#receive_sendcode').attr('bol','false');
		var timer=null;
		var _time=61;
		timer=setInterval(function(){
			_time--;
			$('#receive_sendcode').css({'background':'#C7C8C9'});
			$('#receive_sendcode').html('重新发送'+ _time +'s');

			if (_time==0) {
				clearInterval(timer);
				$('#receive_sendcode').css({'background':'#ff8101'});
				$('#receive_sendcode').html('获取验证码');
				$('#receive_sendcode').attr('bol','true');
			};
		},1000);
	}

	$('#receive_sendcode').on('click',function(ev){
		if ($(this).attr('bol')=="false") {
			return false;
		};
		if(checknull('#receive_phone')==false){
			layer.alert('请输入手机号码!', {
				title: false,
				closeBtn: false
			}, function(){
				layer.closeAll();
				$('#receive_phone').focus();
			});
			return;
		};
		if (checkregular('#receive_phone','1')==false) {
			layer.alert("请输入正确的11位数手机号!", {
				title: false,
				closeBtn: false
			}, function(){
				layer.closeAll();
				$('#receive_phone').focus();
			});
			return;
		}
		var phone_number = $('#receive_phone').val();
		sendRequest("getRegisterVerifyCode.htm?phoneNumber="+phone_number, "GET", function (msg) {
			if(msg) {
				if (msg.indexOf('已注册') > -1) {
					layer.confirm(msg, {
						title: false,
						closeBtn: false,
						btn: ['登陆', '确定']
					}, function () {
						window.location.href = 'toLogin.htm';
					}, function () {
						layer.closeAll();
					})
				} else {
					layer.alert(msg, {
						title: false,
						closeBtn: false
					}, function () {
						layer.closeAll();
					});
				}
				codeFlag = false;
			} else {
				countcode();
			}
		}, function() {
			codeFlag = false;
		});
	});
</script>
</html>