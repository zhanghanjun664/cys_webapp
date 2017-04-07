<%@ page import="cn.aidee.jdoctor.model.JdBankCardModel" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  JdBankCardModel jdBankCardModel=(JdBankCardModel)request.getAttribute("jdBankCardModel");
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

    #mainDiv .cardul{width:100%;overflow:hidden;}
    #mainDiv .cardul li{width:100%;float:left;margin-bottom:0.2em;padding:1.8em 0 1.8em 0;background:#FFFFFF;}
    #mainDiv .cardul li span{font-size:1.6em;margin-left:3%;float:left;}
    #mainDiv .cardul li input{font-size:1.6em;margin-right:3%;float:right;background:transparent;border:0;text-align:right;}

    #mainDiv .btn_ul{width:90%;margin-left:5%;overflow:hidden;margin-top:15%;}
    #mainDiv .btn_ul li{width:40%;font-size:1.6em;color:#FFFFFF;border-radius:0.3em;-webkit-border-radius:0.3em;text-align:center;}
    #mainDiv .btn_ul li:nth-child(1){float:left;background:#088A29;}

    .bank_ul{width:100%;overflow-y:auto;background:#F0F0F0;position:absolute;left:0;top:0;z-index:1000000;display:none;}
    .bank_ul li{width:100%;overflow-y:auto;background:#FFFFFF;padding:1.5em 0 1.5em 0;margin-bottom:0.14em;text-align:center;}
    .bank_ul li span{color:#000000;font-size:1.6em;}

    #MsgBoxDiv{width:100%;height:100%;position:fixed;left:0;top:0;z-index:1000000;display:none;}
    #MsgBoxDiv ul{width:84%;overflow:hidden;margin-left:8%;background:rgba(0,0,0,0.65);border-radius:0.2em;-webkit-border-radius:0.2em;}
    #MsgBoxDiv ul li{width:100%;overflow:hidden;text-align:center;}
    #MsgBoxDiv ul li:nth-child(1) p{width:100%;text-align:center;font-size:1.75em;color:#FFFFFF;}
    #MsgBoxDiv ul li:nth-child(2){border-top:#FFFFFF 0.04em solid;-webkit-border-top:#FFFFFF 0.04em solid;font-size:1.88em;color:#FFFFFF;}

    #ConfirmDiv{width:100%;height:100%;position:fixed;left:0;top:0;z-index:1000000;display:none;}
    #ConfirmDiv ul{width:84%;overflow:hidden;margin-left:8%;background:rgba(0,0,0,0.65);border-radius:0.2em;-webkit-border-radius:0.2em;}
    #ConfirmDiv ul li{float:left;}
    #ConfirmDiv ul li:nth-child(1){width:100%;overflow:hidden;text-align:center;}
    #ConfirmDiv ul li{width:50%;overflow:hidden;text-align:center;}
    #ConfirmDiv ul li:nth-child(1) p{width:100%;text-align:center;font-size:1.75em;color:#FFFFFF;}
    #ConfirmDiv ul li:nth-child(2){border-top:#FFFFFF 0.04em solid;-webkit-border-top:#FFFFFF 0.04em solid;font-size:1.88em;color:#FFFFFF;border-right:#FFFFFF 0.04em solid;-webkit-border-right:#FFFFFF 0.04em solid;font-size:1.88em;color:#FFFFFF;}
    #ConfirmDiv ul li:nth-child(3){border-top:#FFFFFF 0.04em solid;-webkit-border-top:#FFFFFF 0.04em solid;font-size:1.88em;color:#FFFFFF;}
  </style>
</head>
<body>
<div id="mainDiv">
  <ul class="top_ul">
    <a href="javascript:history.back();"><li></li></a>
    <li>添加银行卡</li>
    <li></li>
  </ul>
  <ul class="cardul">
    <li onClick="showBacks();"><span>银行</span><input type="text" id="bank" value="<%=jdBankCardModel!=null?jdBankCardModel.getBankName():""%>" readonly="readonly "/></li>
    <li><span>支行</span><input type="text" id="bank_branch" value="<%=jdBankCardModel!=null?jdBankCardModel.getSubBranch():""%>" size="50"/></li>
    <li><span>卡号</span><input type="text" value="<%=jdBankCardModel!=null?jdBankCardModel.getReceiptAccount():""%>" id="card_number" value=""/></li>
    <li><span>持卡人</span><input type="text" value="<%=jdBankCardModel!=null?jdBankCardModel.getReceiptName():""%>" id="card_user" value=""/></li>
  </ul>
  <ul class="btn_ul">
    <li onclick="saveBank()">保存</li>
  </ul>
</div>
<ul class="bank_ul">
  <li onClick="chooseBank(this,233);"><span>工商银行</span></li>
  <li onClick="chooseBank(this,233);"><span>中国银行</span></li>
  <li onClick="chooseBank(this,233);"><span>建设银行</span></li>
  <li onClick="chooseBank(this,233);"><span>农业银行</span></li>
  <li onClick="chooseBank(this,233);"><span>交通银行</span></li>
  <li onClick="chooseBank(this,233);"><span>招商银行</span></li>
  <li onClick="chooseBank(this,233);"><span>民生银行</span></li>
  <li onClick="chooseBank(this,233);"><span>光大银行</span></li>
  <li onClick="chooseBank(this,233);"><span>华夏银行</span></li>
  <li onClick="chooseBank(this,233);"><span>中信银行</span></li>
</ul>
<div id="ConfirmDiv">
  <ul>
    <li><p id="confirmcontp"></p></li>
    <li onClick="ConfirmOpt.callback();">确定</li>
    <li onClick="ConfirmOpt.hideConfirm();">取消</li>
  </ul>
</div>
<div id="MsgBoxDiv">
  <ul>
    <li><p id="msgcontp"></p></li>
    <li id="btnli" onClick="MsgOpt.hideMsgBox();"></li>
  </ul>
</div>
</body>
</html>
<script>
  var mw = $(window).width();
  var mh0 = $(window).height();
  var mh = 1136*mw/640;
  window.onload = function(){
    $('#mainDiv').width(mw);
    $('.top_ul').width(mw).height(mh*0.07);
    $('.top_ul li').height(mh*0.07);
    $('.top_ul li').css('line-height',mh*0.07+'px');

    $('.cardul').width(mw);
    //$('.cardul li').width(mw).height(mh*0.08);
    //$('.cardul li').css('line-height',mh*0.08+'px');

    $('.btn_ul').width(mw*0.9);
    $('.btn_ul li').width(mw*0.9).height(mh*0.07);
    $('.btn_ul li').css('line-height',mh*0.07+'px');

    $('#mainDiv').show();
    $('#MsgBoxDiv').width(mw).height(mh);
    $('#MsgBoxDiv ul').width(mw*0.84).height(mh*0.26);
    $('#MsgBoxDiv ul li').eq(0).width(mw*0.84).height(mh*0.26*0.73);
    $('#MsgBoxDiv ul li').eq(1).width(mw*0.84).height(mh*0.26*0.27);
    $('#MsgBoxDiv ul li').eq(1).css('line-height',mh*0.26*0.27+'px');
    $('#msgcontp').css('margin-top',mh*0.26*0.3);
    $('#MsgBoxDiv ul').css('margin-top',mh*0.15);

    $('#ConfirmDiv').width(mw).height(mh);
    $('#ConfirmDiv ul').width(mw*0.84).height(mh*0.26);
    $('#ConfirmDiv ul li').eq(0).width(mw*0.84).height(mh*0.26*0.73);
    $('#ConfirmDiv ul li').eq(1).width(mw*0.84*0.493).height(mh*0.26*0.27);
    $('#ConfirmDiv ul li').eq(1).css('line-height',mh*0.26*0.27+'px');
    $('#ConfirmDiv ul li').eq(2).width(mw*0.84*0.5).height(mh*0.26*0.27);
    $('#ConfirmDiv ul li').eq(2).css('line-height',mh*0.26*0.27+'px');
    $('#confirmcontp').css('margin-top',mh*0.26*0.3);
    $('#ConfirmDiv ul').css('margin-top',mh*0.15);

  }
  var bankflag = false;
  function showBacks(){
    if(bankflag){
      bankflag = false;
      $('.bank_ul').hide();
    }else{
      bankflag = true;
      $('.bank_ul').show();
    }
  }
  var bankid = null;
  function chooseBank(ob,bid){
    bankid = bid;
    var bank_name = $(ob).find('span').text();
    $('#bank').val(bank_name);
    bankflag = false;
    $('.bank_ul').hide();
  }
  function saveBank(){
    var bank=$.trim($('#bank').val());
    var bank_branch= $.trim($('#bank_branch').val());
    var card_number = $.trim($('#card_number').val());
    var card_user = $.trim($('#card_user').val());
    if(bank.length==0){
      var msg = '请填写银行信息';
      var btnword = '确定';
      MsgOpt.showMsgBox(msg, btnword);
      return;
    }

    if(bank_branch.length==0){
      var msg = '请填写支行信息';
      var btnword = '确定';
      MsgOpt.showMsgBox(msg, btnword);
      return;
    }

    if(card_number.length==0){
      var msg = '请填写银行卡信息';
      var btnword = '确定';
      MsgOpt.showMsgBox(msg, btnword);
      return;
    }

    if(card_user.length==0){
      var msg = '请填写持卡人信息';
      var btnword = '确定';
      MsgOpt.showMsgBox(msg, btnword);
      return;
    }
    var data="bank="+bank+"&bank_branch="+bank_branch+"&card_number="+card_number+"&card_user="+card_user;
    $.ajax({
      type:'POST',
      url:'insertCard.htm',
      data:data,
      dataType:'json',
      success:function(msg){
        if(msg.result==3){
          window.location.href="toLogin.htm";
        }else {
          MsgOpt.showMsgBox("保存成功", "确定", "mymoney.htm");
        }
      },
      timeout: 10000,
      error:function(){
        var msg = '获取数据失败，请检查网络';
        var btnword = '确定';
        MsgOpt.showMsgBox(msg, btnword);
        return;
      }
    });
  }



  //跳转连接
  function jump(num){
    if(num==1){
      window.location.href = 'xxx?openid='+openid;
    }
    if(num==2){
      window.location.href = 'xxx?openid='+openid;
    }
  }
  //确认弹窗类
  var ConfirmOpt = {
    showConfirm:function(msg){
      var mythis = this;
      $('#confirmcontp').html(msg);
      $('#ConfirmDiv').fadeIn(200);
    },
    hideConfirm:function(){
      var mythis = this;
      $('#ConfirmDiv').fadeOut(400);
      $('#confirmcontp').html('');
    },
    callback:function(){
      window.location.href = '';
    }
  };

  //消息弹窗类
  var MsgOpt = {
    msgt:null,
    href:null,
    showMsgBox:function(msg, btnword,href){
      var mythis = this;
      mythis.href = href;
      $('#msgcontp').html(msg);
      $('#btnli').html(btnword);
      $('#MsgBoxDiv').fadeIn(200);
      mythis.msgt = setTimeout(function(){MsgOpt.hideMsgBox();},5000);
    },
    hideMsgBox:function(){
      var mythis = this;
      clearTimeout(mythis.msgt);
      $('#MsgBoxDiv').fadeOut(400);
      $('#msgcontp').html('');
      $('#btnli').html('');
      if(mythis.href)
        window.location.href = mythis.href;
    }
  };


</script>