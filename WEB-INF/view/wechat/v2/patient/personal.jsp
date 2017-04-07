<%@ page import="cn.aidee.jdoctor.model.JdPatientModel" %>
<%@ page import="cn.com.chengyisheng.sys.constant.WebConstants" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  JdPatientModel patientModel = (JdPatientModel) request.getSession().getAttribute(WebConstants.SESSION_PATIENT);
  Boolean recordLogin = (Boolean) request.getAttribute("recordLogin");
  HttpSession httpSession = request.getSession();
  JdPatientModel patient = (JdPatientModel) httpSession.getAttribute(WebConstants.SESSION_PATIENT);
  if(patient != null){
    response.sendRedirect("/wechat_web/wap_wechat_patient/html/personal.html");
  }
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
  <jsp:include page="../include/head.jsp"/>
</head>
<body>
<!--wrap-->
<div class="wrap">
  <!--mine_header-->
  <header class="mine_header pr">
    <a onclick="goto('toPersonalInfo.htm')" class="minemsg"></a>
    <h1 class="pa"><a onclick="toMain()"></a></h1>
    <section class="mine_name">
      <%=patientModel.getName()%><span class="mine_line">丨</span><%=patientModel.getPhoneNumber()%><i></i>
    </section>
    <section class="mine_hb clearfix">
      <a onclick="toFamilyContact()" class="fl">
        <p class="mine_number" id="familyCount">0</p>
        <p class="mine_title">家庭联系人</p>
      </a>
      <a onclick="goto('toFollowDoctorList.htm')" class="fr">
        <p class="mine_number" id="followCount">0</p>
        <p class="mine_title">关注的医生</p>
      </a>
    </section>
  </header>
  <!--mine_header-->
  <!--mine_content-->
  <div class="content mine_content">
    <!--mine_list-->
    <ul class="list mine_list">
      <a onclick="goto('toOrderList.htm?status=0')">
        <li class="clearfix pr">
          <i class="pa con1"></i><span>我的预约</span><i class="arrow pa"></i>
        </li>
      </a>
    </ul>
    <!--mine_list-->
    <!--mine_nav-->
    <ul class="clearfix mine_nav">
      <a onclick="goto('toOrderList.htm?status=1')" >
        <li class="fl pr" >
          <p class="nav_logo pr"><span class="nav1" ></span><i class="circlenum pa" style="display:none;" id="toPayCount">0</i></p>
          <p class="mnv_f" >待付款</p>
        </li>
      </a>

      <a onclick="goto('toOrderList.htm?status=2')">
        <li class="fl pr">
          <p class="nav_logo pr"><span class="nav2"></span><i class="circlenum pa" style="display:none;" id="toTreatCount">0</i></p>
          <p class="mnv_f">待就诊</p>
        </li>
      </a>
      <a onclick="goto('toOrderList.htm?status=3')">
        <li class="fl pr">
          <p class="nav_logo pr"><span class="nav5"></span><i class="circlenum pa" style="display:none;" id="toConfirmCount">0</i></p>
          <p class="mnv_f">待确认</p>
        </li>
      </a>
      <a onclick="goto('toOrderList.htm?status=4')">
        <li class="fl pr">
          <p class="nav_logo pr"><span class="nav3"></span><i class="circlenum pa" style="display:none;" id="toCommentCount">0</i></p>
          <p class="mnv_f">待评价</p>
        </li>
      </a>

      <a onclick="goto('toOrderList.htm?status=5')">
        <li class="fl pr">
          <p class="nav_logo pr"><span class="nav4"></span><i class="circlenum pa" style="display:none;" id="toShareCount">1</i></p>
          <p class="mnv_f">待分享</p>
        </li>
      </a>
    </ul>
    <!--mine_nav-->
    <!--mine_list-->
    <ul class="list mine_list min_nav_list">
      <a onclick="toFamilyContact('medical')">
        <li class="clearfix pr">
          <i class="pa con2"></i><span>病历管理</span><i class="arrow mine_arrow pa"></i>
        </li>
      </a>
      <a onclick="toFamilyContact('health')">
        <li class="clearfix pr">
          <i class="pa con3"></i><span>健康测量</span><span class="fr navlist_con">血压、血糖、心率</span><i class="arrow  pa"></i>
        </li>
      </a>
      <a onclick="goto('toOperation.htm')">
        <li class="clearfix pr">
          <i class="pa con7"></i><span>住院直通车</span><i class="arrow mine_arrow pa"></i>
        </li>
      </a>
      <a onclick="goto('toNowInvite.htm')" id="weixin" style="display: none;">
        <li class="clearfix pr">
          <i class="pa con8"></i><span>邀请好友</span><span class="fr navlist_con">每位奖￥20,可叠加使用</span><i class="arrow  pa"></i>
        </li>
      </a>
      <a onclick="goto('toMyWallet.htm')">
        <li class="clearfix pr">
          <i class="pa con4"></i><span>钱包</span><span class="fr navlist_con">余额、现金劵</span><i class="arrow  pa"></i>
        </li>
      </a>

      <a onclick="goto('toMessageCenter.htm')">
        <li class="nav_none clearfix pr">
          <i class="pa con5"></i><span>消息</span><i class="arrow  pa"></i>
        </li>
      </a>
    </ul>
    <!--mine_list-->
    <!--mine_list-->
    <ul class="list mine_list min_nav_list">

      <a onclick="goto('toModifyPassword.htm')">
        <li class="nav_none clearfix pr">
          <i class="pa con6"></i><span>设置</span><i class="arrow  pa"></i>
        </li>
      </a>
    </ul>
    <!--mine_list-->
  </div>
  <!--mine_content-->
  <div class="callphone" style="position: inherit;margin-bottom:0.2rem;line-height:0.35rem;">如果您有任何疑问，请拨打客服电话：<br> <a href="tel:400-061-8989">400-061-8989</a></div>
</div>
<!--wrap-->
</body>
<script>
  function is_weixn(){
    var ua = navigator.userAgent.toLowerCase();
    if(ua.match(/MicroMessenger/i)=="micromessenger") {
      return true;
    } else {
      return false;
    }
  }
  if(is_weixn()){
    $("#weixin").show();
  }else{
    $("#weixin").hide();
  }
  var recordLogin = <%=recordLogin%>;
  if(recordLogin) {
    sendPageVisit(Page_Constant.Mine, true);
  } else {
    sendPageVisit(Page_Constant.Mine);
  }

  var url = "asynUserData.htm?random="+Math.random()*10000;
  var data ="";
  sendRequest(url, "GET", data, function (result) {
      var waitToPay = result.waitToPay+result.plusWaitToPay;
      $("#familyCount").html(result.contactCount);
      $("#followCount").html(result.concernCount);
      $("#toPayCount").html(waitToPay);
      $("#toConfirmCount").html(result.waitToConfirm);
      $("#toTreatCount").html(result.waitToDiagnose);
      $("#toCommentCount").html(result.waitToComment);
      $("#toShareCount").html(result.waitToShare);
      if(waitToPay > 0) $("#toPayCount").css("display", "");
      if(result.waitToDiagnose > 0) $("#toTreatCount").css("display", "");
      if(result.waitToConfirm > 0) $("#toConfirmCount").css("display", "");
      if(result.waitToComment > 0) $("#toCommentCount").css("display", "");
      if(result.waitToShare > 0) $("#toShareCount").css("display", "");
  });

  function toFamilyContact(type) {
    if(type) {
      if(type == "medical") {
        sendPageVisit(Page_Constant.MedicalManagement);
      } else if(type == "health") {
        sendPageVisit(Page_Constant.HealthMeasurment);
      }
      goto("toFamilyContact.htm?type="+type)
    } else {
      sendPageVisit(Page_Constant.FamilyContact);
      goto("toFamilyContact.htm")
    }
  }
</script>
</html>
