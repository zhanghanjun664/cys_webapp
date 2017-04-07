<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.aidee.jdoctor.model.JdDoctorQueryModel" %>
<%@ page import="cn.aidee.jdoctor.wechat.WechatUtils" %>
<%@ page import="cn.aidee.jdoctor.model.JdPatientModel" %>
<%@ page import="cn.com.chengyisheng.sys.constant.WebConstants" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="cn.aidee.jdoctor.model.AvailableTimeModel" %>
<%@ page import="cn.aidee.framework.base.utils.DateUtils" %>
<%
  String openId = (String)request.getSession().getAttribute(WebConstants.SESSION_OPENID);
  JdPatientModel patient = (JdPatientModel)request.getAttribute("patient");
  int waitToPay = (Integer)request.getAttribute("waitToPay");
  JdDoctorQueryModel doctorQueryModel=(JdDoctorQueryModel)request.getAttribute("doctorQueryModel");
  String orderTip = (String)request.getAttribute("orderTip");
  String address = (String)request.getAttribute("address");
  String exceed = (String)request.getAttribute("exceed");
  AvailableTimeModel availableTime =(AvailableTimeModel)request.getAttribute("availableTime");
%>
<!DOCTYPE html>
<html>
<head>
  <jsp:include page="../include/head.jsp" />
  <style>
    html,body{width:100%;height:100%;margin:0;padding:0;font-size:100%;background:#F2F2F2;}
    a{color:#000000;-webkit-tap-highlight-color: transparent;}
    img,li,div{-webkit-tap-highlight-color:transparent;}
    #mainDiv{width:100%;display:none;}
    #mainDiv .top_ul{width:100%;background:#FB9D3B;overflow:hidden;}
    #mainDiv .top_ul li{text-align:center;float:left;}
    #mainDiv .top_ul li:nth-child(1){width:11.5%;height:100%;background:url(../../wechat/images/larrow.png) center left no-repeat;background-size:70% auto;}
    #mainDiv .top_ul li:nth-child(2){width:76%;height:100%;font-size:2em;color:#FFFFFF;}
    #mainDiv .top_ul li:nth-child(3){width:12%;height:100%;}
    #mainDiv .top_ul li:nth-child(3) a{font-size:1.6em;color:#FFFFFF;}

    #mainDiv .btmul{width:100%;overflow:hidden;padding:0 0 0.06em 0;background:#F2F2F2;}
    #mainDiv .btmul .btmul_li{width:100%;float:left;margin-bottom:0.1em;border-bottom:#F2F2F2 0.12em solid;-webkit-border-bottom:#F2F2F2 0.12em solid;padding:1.5em 0 1.5em 0;background:#FFFFFF;}
    #mainDiv .btmul .btmul_li .btmul_li_ul1{width:20%;overflow:hidden;float:left;margin-left:3%;}
    #mainDiv .btmul .btmul_li .btmul_li_ul1 .btmul_li_ul1_li1{width:100%;float:left;}
    #mainDiv .btmul .btmul_li .btmul_li_ul1 .btmul_li_ul1_li1 img{width:100%;border-radius:50%;-webkit-border-radius:50%;}
    #mainDiv .btmul .btmul_li .btmul_li_ul1 .btmul_li_ul1_li2{width:100%;float:left;}
    #mainDiv .btmul .btmul_li .btmul_li_ul2{width:73%;margin-left:3%;overflow:hidden;float:left;}
    #mainDiv .btmul .btmul_li .btmul_li_ul2 .btmul_li_ul2_li1{width:100%;padding-bottom:0.35em;}
    #mainDiv .btmul .btmul_li .btmul_li_ul2 .btmul_li_ul2_li1 .btmul_li_ul2_li1_sp1{font-size:1.65em;color:#000000;}
    #mainDiv .btmul .btmul_li .btmul_li_ul2 .btmul_li_ul2_li1 .btmul_li_ul2_li1_sp2{font-size:1.55em;color:#FB9D3B;}

    #mainDiv .btmul .btmul_li .btmul_li_ul2 .btmul_li_ul2_li2{width:100%;padding-bottom:0.35em;}
    #mainDiv .btmul .btmul_li .btmul_li_ul2 .btmul_li_ul2_li2 .df_sp{font-size:1.5em;color:#000000;}
    #mainDiv .btmul .btmul_li .btmul_li_ul2 .btmul_li_ul2_li2 .hospital_sp{font-size:1.5em;color:#000000;}
    #mainDiv .btmul .btmul_li .btmul_li_ul2 .btmul_li_ul2_li2 .room_sp{font-size:1.5em;color:#A4A4A4;}
    #mainDiv .btmul .btmul_li .btmul_li_ul2 .btmul_li_ul2_li2 .goodat_sp{font-size:1.5em;color:#A4A4A4;}
    #mainDiv .btmul .btmul_li .btmul_li_ul2 .btmul_li_ul2_li2 .number_sp{font-size:1.5em;color:#A4A4A4;}

    #mainDiv .dateul{width:100%;overflow:hidden;padding:0.6em 0 0.6em 0;background:#FFFFFF;}
    #mainDiv .dateul li{width:100%;float:left;padding:0.3em 0 0.3em 0;}
    #mainDiv .dateul li .title_sp1{margin-left:2%;font-size:1.5em;color:#000000;float:left;}
    #mainDiv .dateul li .cont_sp1{font-size:1.5em;color:#BDB2BD;float:left;}
    #mainDiv .dateul li .title_sp2{margin-left:2%;font-size:1.5em;color:#000000;float:left;}
    #mainDiv .dateul li .cont_sp2{font-size:1.5em;color:#BDB2BD;float:left;}

    #mainDiv .fillul{width:100%;overflow:hidden;padding:0.6em 0 0 0;background:#F2F2F2;}
    #mainDiv .fillul .fillul_li0{width:100%;overflow:hidden;padding:0.4em 0 0.4em 0;background:#F2F2F2;}
    #mainDiv .fillul .fillul_li0 span{margin-left:2%;font-size:1.55em;color:#000000;}
    #mainDiv .fillul .fillul_li1{width:100%;padding:0.33em 0 0.33em 0;background:#FFFFFF;text-align:center;}
    #mainDiv .fillul li:nth-child(2){padding-top:1em;}
    #mainDiv .fillul .fillul_li1 input[type="text"]{width:90%;border-radius:0.3em;-webkit-border-radius:0.3em;background:transparent;border:#D8D8D8 0.08em solid;-webkit-border:#D8D8D8 0.08em solid;font-size:1.5em;color:#000000;padding:0.15em;}
    #mainDiv .fillul .fillul_li2{width:94%;margin-left:3%; padding:1em 0 3em 0;background:#FFFFFF;text-align:center;font-size:1.5em;background:#F2F2F2;}
    #mainDiv .fillul .fillul_li2 span{color:#2882D8;}
    #mainDiv .fillul .fillul_li3{width:100%;background:#FFFFFF;}
    #mainDiv .fillul .fillul_li3 .fillul_li3_div1{width:70%;background:#FFFFFF;float:left;}
    #mainDiv .fillul .fillul_li3 .fillul_li3_div1 span{margin-left:3.5%;font-size:1.6em;float:left;}
    #mainDiv .fillul .fillul_li3 .fillul_li3_div2{width:30%;background:#FB9D3B;color:#FFFFFF;font-size:1.6em;text-align:center;float:right;}
    #mainDiv .fillul_li1 .getCodeDiv {border-radius: 0.2em;-webkit-border-radius: 0.2em;text-align: center;font-size: 1.5em;margin-right: 1.5em;margin-top: 0.2em;color: #FFFFFF;background: #2882D8;float: right;}

    #MsgBoxDiv{width:100%;height:100%;position:fixed;left:0;top:0;z-index:1000000;display:none;}
    #MsgBoxDiv ul{width:84%;overflow:hidden;margin-left:8%;background:rgba(0,0,0,0.65);border-radius:0.2em;-webkit-border-radius:0.2em;}
    #MsgBoxDiv ul li{width:100%;overflow:hidden;text-align:center;}
    #MsgBoxDiv ul li:nth-child(1) p{width:100%;text-align:center;font-size:1.75em;color:#FFFFFF;}
    #MsgBoxDiv ul li:nth-child(2){border-top:#FFFFFF 0.04em solid;-webkit-border-top:#FFFFFF 0.04em solid;font-size:1.88em;color:#FFFFFF;}

    #ruleul{width:100%;overflow:hidden;padding:1.8em 0 1em 0;position:absolute;left:0;top:0;z-index:100000;display:none;background:#FFFFFF;}
    #ruleul li{float:left;}
    #ruleul .ruleul_li0{width:100%;font-size:1.8em;font-weight:bold;text-align:center;margin-bottom:1em;}
    #ruleul .ruleul_li1{width:100%;}
    #ruleul .ruleul_li1 p{width:94%;margin-left:3%;font-size:1.55em;margin-bottom:1.5em;}
    #ruleul .ruleul_li2{width:60%;margin-left:20%;border-radius:0.5em;-webkit-border-radius:0.5em;border:#BDBDBD 0.1em solid;-webkit-border:#BDBDBD 0.1em solid;text-align:center;font-size:1.55em;margin-top:1.5em;}
  </style>
</head>
<body>
<div id="mainDiv">
  <ul class="top_ul">
    <a href="javascript:history.back();"><li></li></a>
    <li>订单填写</li>
    <li><a href="main.htm">首页</a></li>
  </ul>
  <ul class="btmul">
    <li class="btmul_li">
      <ul class="btmul_li_ul1">
        <li class="btmul_li_ul1_li1"><img src="<%=doctorQueryModel.getHeadPic()%>"/></li>
      </ul>
      <ul class="btmul_li_ul2">
        <li class="btmul_li_ul2_li1">
          <span class="btmul_li_ul2_li1_sp1"><%=doctorQueryModel.getName()%></span>
          <span class="btmul_li_ul2_li1_sp2"><%=doctorQueryModel.getTitle()%></span>
        </li>
        <li class="btmul_li_ul2_li2"><span class="hospital_sp"><%=doctorQueryModel.getHospital()%></span></li>
        <li class="btmul_li_ul2_li2"><span class="df_sp">科室：</span><span class="room_sp"><%=doctorQueryModel.getDepartment()%></span></li>
        <li class="btmul_li_ul2_li2"><span class="df_sp">擅长：</span><span class="goodat_sp"><%=WechatUtils.showDoctorSkills(doctorQueryModel.getDoctorSelectSkills())%></span></li>
        <li class="btmul_li_ul2_li2"><span class="df_sp">人气：</span><span class="number_sp"><%=doctorQueryModel.getPopularity()%></span></li>
      </ul>
    </li>
  </ul>
  <ul class="dateul">
    <li>
      <span class="title_sp1">预约时间: </span>
      <span class="cont_sp1"><%=DateUtils.format(availableTime.getDateTime(),"yyyy-MM-dd HH:mm")%>&nbsp;&nbsp;<%=DateUtils.getWeekOfDate(availableTime.getDateTime())%></span>
    </li>
    <li>
      <span class="title_sp2">就诊地址: </span>
      <span class="cont_sp2"><%=address%></span>
    </li>
  </ul>
  <ul class="fillul">
    <li class="fillul_li0"><span>患者信息</span></li>
    <%
      if(patient != null) {
    %>
    <li class="fillul_li1"><input id="phone" type="text" value="<%=patient.getPhoneNumber()%>" placeholder="请输入手机号码（必填）"/></li>
    <%
      } else {
    %>
    <li class="fillul_li1"><input id="phone" type="text" placeholder="请输入手机号码（必填）"/></li>
    <li class="fillul_li1">
      <input id="code" type="text" placeholder="请输入验证码（必填）"/>
      <div class="getCodeDiv" onClick="getCode();">获取验证码</div>
    </li>
    <%
      }
    %>
    <li class="fillul_li1"><input id="name" type="text" placeholder="请输入患者姓名（必填）" maxlength="60"/></li>
    <li class="fillul_li1"><input id="idCard" type="text" placeholder="请输入患者身份证号（必填）" maxlength="18" onkeyup="idCardChange()" /></li>
    <li class="fillul_li1"><input id="age" type="text" placeholder="患者年龄" disabled/></li>
    <li class="fillul_li1"><input id="gender" type="text" placeholder="患者性别" disabled/></li>
    <li class="fillul_li1"><input id="desc" type="text" placeholder="请简要描述病情（必填）" maxlength="250"/></li>
    <%
      if(patient == null) {
    %>
    <li class="fillul_li1"><input id="invite_code" type="text" placeholder="请输入邀请码（选填）"/></li>
    <%
      }
    %>
    <li class="fillul_li2"><font style="font-weight:bold;">服务须知:</font>为保障预约真实有效，需预存<%=doctorQueryModel.getDeposit().setScale(0, BigDecimal.ROUND_HALF_UP)%>元保证金，完成评价后全额归还。<span onClick="showRule();">预约须知</span></li>
    <li class="fillul_li3">
      <%
        if(exceed == null) {
          BigDecimal price = doctorQueryModel.getConsultationFee().subtract(doctorQueryModel.getSubsidy()).setScale(0);
          if(price.intValue() == 0) {
      %>
        <div class="fillul_li3_div1"><span>服务费：<font style="color:#FB9D3B;">免费</font></span></div>
      <%
          } else {
      %>
        <div class="fillul_li3_div1"><span>服务费：<font style="color:#FB9D3B;"><%=price%></font>元</span></div>
      <%
          }
        } else {
      %>
        <div class="fillul_li3_div1"><span>服务费：<font style="color:#FB9D3B;"><%=doctorQueryModel.getConsultationFee()%></font>元</span></div>
      <%
        }
      %>
      <div class="fillul_li3_div2" onClick="topay();">去支付</div>
    </li>
  </ul>
</div>
<div id="MsgBoxDiv">
  <ul>
    <li><p id="msgcontp"></p></li>
    <li id="btnli" onClick="MsgOpt.hideMsgBox();"></li>
  </ul>
</div>
<ul id="ruleul">
  <li class="ruleul_li0">预约须知</li>
  <li class="ruleul_li1">
    <%
        String[] tips = orderTip.split("\n");
        for(String tip : tips) {
          out.println("<p>"+tip+"</p>");
        }
    %>
  </li>
  <li class="ruleul_li2" onClick="hideRule();">我知道了</li>
</ul>
</body>
</html>
<script>
  var mw = $(window).width();
  var mh0 = $(window).height();
  var mh = 1136*mw/640;
  var waitToPay = <%=waitToPay%>;
  var tip = "您有未支付订单，请先支付或取消未支付的订单后，再提交新订单。现在跳转未支付订单列表？";
  //验证身份证号
  var idCardFlag = false;
  function idCardChange(){
    var idCard = $('#idCard').val();
    if(idCard.length == 15 || idCard.length == 18) {
      sendRequest("validateIdCard.htm?idCard="+idCard,"GET",function(result){
        if(result){
          idCardFlag = true;
          var ageGender = result.split(";");
          $("#age").val(ageGender[0]+"岁");
          $("#gender").val(ageGender[1]=="M"?"男":"女");
        }
      });
    } else {
      idCardFlag = false;
      $("#age").val("");
      $("#gender").val("");
    }
  }
  window.onload = function(){
    //身份证输入框粘贴事件
    $('#idCard').bind("paste", function(e){
      var pastedText = undefined;
      if (window.clipboardData && window.clipboardData.getData) {
        pastedText = window.clipboardData.getData('Text');
      } else {
        pastedText = e.originalEvent.clipboardData.getData('Text');
      }
      var oldVal = $('#idCard').val();
      $('#idCard').val(oldVal+pastedText);
      idCardChange();
    });
    $('#mainDiv').width(mw);
    $('.top_ul').width(mw).height(mh*0.07);
    $('.top_ul li').height(mh*0.07);
    $('.top_ul li').css('line-height',mh*0.07+'px');

    $('.btmul').width(mw);
    $('.btmul_li').width(mw);
    $('.btmul_li_ul1_li1').width(mw);
    $('.btmul_li_ul1_li1 img').width(mw*0.2).height(mw*0.2);

    $('.fillul_li1').width(mw);
    $('.fillul_li1 input').width(mw*0.9).height(mh*0.059);
    $('#code').width(mw*0.5).height(mh*0.059);
    $('.getCodeDiv').width(mw*0.35).height(mh*0.059).css('line-height', mh * 0.056 + 'px');

    $('.fillul_li3_div1').width(mw*0.7).height(mh*0.072);
    $('.fillul_li3_div2').width(mw*0.3).height(mh*0.072);
    $('.fillul_li3_div1').css('line-height',mh*0.072+'px');
    $('.fillul_li3_div2').css('line-height',mh*0.072+'px');

    $('#mainDiv').show();
    $('#MsgBoxDiv').width(mw).height(mh);
    $('#MsgBoxDiv ul').width(mw*0.84).height(mh*0.26);
    $('#MsgBoxDiv ul li').eq(0).width(mw*0.84).height(mh*0.26*0.73);
    $('#MsgBoxDiv ul li').eq(1).width(mw*0.84).height(mh*0.26*0.27);
    $('#MsgBoxDiv ul li').eq(1).css('line-height',mh*0.26*0.27+'px');
    $('#msgcontp').css('margin-top',mh*0.26*0.3);
    $('#MsgBoxDiv ul').css('margin-top',mh*0.15);

    $('#ruleul').width(mw).height(mh*0.9);
    $('#ruleul').css({left:0,top:mh*0.075});
    $('.ruleul_li2').width(mw*0.6).height(mh*0.06);
    $('.ruleul_li2').css('line-height',mh*0.06+'px');
  }

  function changeCodeBtn() {
    $('.getCodeDiv').css('background-color', '#98D6FF');
    $('.getCodeDiv').html('重新获取(' + times + ')');
    recordtime();
  }
  var times = 59;
  var t = null;
  function recordtime() {
    if (times <= 1) {
      $('.getCodeDiv').css('background-color', '#2882D8');
      $('.getCodeDiv').html('获取验证码');
      times = 59;
      clearTimeout(t);
      codeflag = false;
      return;
    }
    times -= 1;
    $('.getCodeDiv').html('重新获取(' + times + ')');
    t = setTimeout(function () {
      recordtime();
    }, 1000);
  }

  var codeflag = false;
  function getCode() {
    if (codeflag) {
      return;
    }
    codeflag = true;
    var phone = $.trim($('#phone').val());
    if (phone.length <= 0) {
      var msg = '请填写手机号';
      var btnword = '确定';
      MsgOpt.showMsgBox(msg, btnword);
      codeflag = false;
      return;
    }
    if (!checkphone(phone)) {
      var msg = '手机号码格式错误';
      var btnword = '确定';
      MsgOpt.showMsgBox(msg, btnword);
      codeflag = false;
      return;
    }
    changeCodeBtn();
    var url = 'getRegisterVerifyCode.htm?phoneNumber=' + phone;
    $.ajax({
      type: 'GET',
      url: url,
      success: function (result) {
        if (result) {
          var btnword = '确定';
          MsgOpt.showMsgBox(result, btnword);
          $('.getCodeDiv').css('background-color', '#2882D8');
          $('.getCodeDiv').html('获取验证码');
          times = 59;
          clearTimeout(t);
          codeflag = false;
          return;
        }
      },
      timeout: 10000,
      error: function (result) {
        $('.getCodeDiv').css('background-color', '#2882D8');
        $('.getCodeDiv').html('获取验证码');
        times = 59;
        clearTimeout(t);
        codeflag = false;
        return;
      }
    });
  }

  //去支付
  var topayflag = false;
  function topay(){
    if(topayflag){
      return;
    }
    topayflag = true;
    var phone = $('#phone').val();
    var name = $('#name').val();
    var idCard = $('#idCard').val();
    var desc = $('#desc').val();
    var invite_code = $('#invite_code').val();
    if(!checkphone(phone)){
      var msg = '手机号码格式错误';
      var btnword = '确定';
      MsgOpt.showMsgBox(msg, btnword);
      topayflag = false;
      return;
    }
    if(name.length<=0){
      var msg = '请填写姓名';
      var btnword = '确定';
      MsgOpt.showMsgBox(msg, btnword);
      topayflag = false;
      return;
    }
    if(!idCardFlag && idCard.length != 15 && idCard.length != 18){
      var msg = '身份证号不正确';
      var btnword = '确定';
      MsgOpt.showMsgBox(msg, btnword);
      topayflag = false;
      return;
    }
    if(desc.length<=0){
      var msg = '请填写病情描述';
      var btnword = '确定';
      MsgOpt.showMsgBox(msg, btnword);
      topayflag = false;
      return;
    }
    var patient = '<%=patient%>';
    if(patient == "null") {
      var openid = '<%=openId%>';
      if(openid == "null") {
        var msg = '当前页面已过期，请重新从公众号页面进入！';
        var btnword = '确定';
        topayflag = false;
        MsgOpt.showMsgBox(msg, btnword);
        return;
      }
      var code = $.trim($('#code').val());
      if(code.length == 0){
        var msg = '请填写验证码';
        var btnword = '确定';
        MsgOpt.showMsgBox(msg, btnword);
        topayflag = false;
        return;
      }
      var url = 'verifyCode.htm';
      var data = {'phoneNumber': phone, 'code': code};
      $.ajax({
        type: 'POST',
        url: url,
        data: data,
        success: function (msg) {
          if (msg) {
            var btnword = '确定';
            MsgOpt.showMsgBox(msg, btnword);
            topayflag = false;
            return;
          } else {
            var data ='phone='+phone+'&name='+name+'&idCard='+idCard+'&desc='+desc+'&invite_code='+invite_code+
                  "&jd_doctor_id="+'<%=doctorQueryModel.getUuid()%>'+"&time_id=<%=availableTime.getUuid()%>";
            $.ajax({
              type:'POST',
              url:'submitOrder.htm',
              data:data,
              success:function(msg){
                var msged = eval('('+msg+')');
                if(msged['result']==1){
                  var orderID = msged['jd_order_id'];
                  window.location.href ="payOrder.htm?jd_order_id="+orderID;
                } else if(msged['result']==0){
                  var msg = '下单慢了，医生该时间段已被预约！';
                  var btnword = '确定';
                  topayflag = false;
                  MsgOpt.showMsgBox(msg, btnword);
                } else if(msged['result']==-1){
                  var msg = '离预约时间不足40分钟，预约失败！';
                  var btnword = '确定';
                  topayflag = false;
                  MsgOpt.showMsgBox(msg, btnword);
                } else if(msged['result']==2) {
                  var msg = '当前页面已过期，请重新从公众号页面进入！';
                  var btnword = '确定';
                  topayflag = false;
                  MsgOpt.showMsgBox(msg, btnword);
                } else if(msged['result']==3) {
                  var msg = '您已注册，请重新从公众号页面进入！';
                  var btnword = '确定';
                  topayflag = false;
                  MsgOpt.showMsgBox(msg, btnword);
                } else if(msged['result']==4) {
                  var msg = '身份证号不正确！';
                  var btnword = '确定';
                  topayflag = false;
                  MsgOpt.showMsgBox(msg, btnword);
                } else if(msged['result']==500) {
                  var msg = '医生该时间段已被预约或取消！';
                  var btnword = '确定';
                  topayflag = false;
                  MsgOpt.showMsgBox(msg, btnword);
                }
              },
              timeout: 15000,
              error:function(){
                var msg = '上传数据失败，请检查网络';
                var btnword = '确定';
                MsgOpt.showMsgBox(msg, btnword);
                topayflag = false;
                return;
              }
            });
          }
        },
        timeout: 10000,
        error: function () {
          var msg = '验证码错误或超时';
          var btnword = '确定';
          MsgOpt.showMsgBox(msg, btnword);
          topayflag = false;
          return;
        }
      });
    } else {
      if(waitToPay > 0) {
        if(confirm(tip)) {
          window.location.href = "toOrderList.htm?status=1";
        }
        topayflag = false;
        return;
      }
      var data ='phone='+phone+'&name='+name+'&idCard='+idCard+'&desc='+desc+
              "&jd_doctor_id="+'<%=doctorQueryModel.getUuid()%>'+"&time_id=<%=availableTime.getUuid()%>";
      $.ajax({
        type:'POST',
        url:'submitOrder.htm',
        data:data,
        success:function(msg){
          var msged = eval('('+msg+')');
          if(msged['result']==1){
            var orderID = msged['jd_order_id'];
            window.location.href ="payOrder.htm?jd_order_id="+orderID;
          } else if(msged['result']==0){
            var msg = '下单慢了，医生该时间段已被预约！';
            var btnword = '确定';
            topayflag = false;
            MsgOpt.showMsgBox(msg, btnword);
          } else if(msged['result']==-1){
            var msg = '离预约时间不足40分钟，预约失败！';
            var btnword = '确定';
            topayflag = false;
            MsgOpt.showMsgBox(msg, btnword);
          } else if(msged['result']==2) {
            var msg = '当前页面已过期，请重新从公众号页面进入！';
            var btnword = '确定';
            topayflag = false;
            MsgOpt.showMsgBox(msg, btnword);
          } else if(msged['result']==4) {
            var msg = '身份证号不正确！';
            var btnword = '确定';
            topayflag = false;
            MsgOpt.showMsgBox(msg, btnword);
          } else if(msged['result']==500) {
            var msg = '医生该时间段已被预约或取消！';
            var btnword = '确定';
            topayflag = false;
            MsgOpt.showMsgBox(msg, btnword);
          }
        },
        timeout: 10000,
        error:function(){
          var msg = '上传数据失败，请检查网络';
          var btnword = '确定';
          topayflag = false;
          MsgOpt.showMsgBox(msg, btnword);
          return;
        }
      });
    }
  }

  function showRule(){
    $('#ruleul').show();
  }
  function hideRule(){
    $('#ruleul').hide();
  }

  function checkphone(mobile){
    var myreg = /^[1][34578]\d{9}$/;
    if(myreg.test(mobile)){
      return true;
    }
  }
</script>