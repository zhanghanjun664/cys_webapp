<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.aidee.jdoctor.model.JdOrderQueryModel" %>
<%@ page import="java.util.List" %>
<%@ page import="cn.aidee.jdoctor.model.wechat.DoctorDataModel" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
  List<JdOrderQueryModel> orderQueryModelList=(List<JdOrderQueryModel>)request.getAttribute("orderQueryModelList");
  DoctorDataModel doctorDataModel=(DoctorDataModel)request.getAttribute("doctorDataModel");
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

    #mainDiv .navi_ul{width:100%;overflow:hidden;border-bottom:#D8D8D8 0.05em solid;-webkit-border-bottom:#D8D8D8 0.05em solid;}
    #mainDiv .navi_ul li{width:49.83%;float:left;text-align:center;padding:1.1em 0 1.1em 0;background:#FAFAFA;}
    #mainDiv .navi_ul li:nth-child(1){float:left;font-size:1.55em;color:#FB9D3B;border-bottom:#FB9D3B 0.17em solid;-webkit-border-bottom:#FB9D3B 0.17em solid;}
    #mainDiv .navi_ul li:nth-child(2){float:right;font-size:1.55em;color:#000000;}

    #mainDiv .btmul{width:100%;overflow:hidden;padding:0 0 1.5em 0;}
    #mainDiv .btmul .btmul_li{width:100%;float:left;background:#FFFFFF;margin-top:1.2em;}
    #mainDiv .btmul .btmul_li ul{width:100%;overflow:hidden;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li1{width:100%;padding:1.5em 0 1.5em 0;border-bottom:#F1F1F1 0.13em solid;-webkit-border-bottom:#F1F1F1 0.13em solid;float:left;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li1 .btmul_li_ul_li1_sp1{font-size:1.5em;margin-left:3%;float:left;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li1 .btmul_li_ul_li1_sp2{font-size:1.5em;margin-right:3%;float:right;color:#DF0101;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li2{width:100%;padding:1.6em 0 1.6em 0;float:left;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li2 p{width:94%;padding:0.2em 0 0.2em 0;margin-left:3%;font-size:1.55em;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li3{width:100%;padding:1.5em 0 1.5em 0;border-top:#F1F1F1 0.12em solid;-webkit-border-top:#F1F1F1 0.12em solid;float:left;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li3 .btmul_li_ul_li3_sp1{font-size:1.5em;margin-left:3%;float:left;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li3 .btmul_li_ul_li3_sp2{font-size:1.72em;margin-right:3%;float:right;color:#FB9D3B;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li3 .btmul_li_ul_li3_sp3{font-size:1.72em;margin-right:8%;float:right;color:#FB9D3B;}

    #MsgBoxDiv{width:100%;height:100%;position:fixed;left:0;top:0;z-index:1000000;display:none;}
    #MsgBoxDiv ul{width:84%;overflow:hidden;margin-left:8%;background:rgba(0,0,0,0.65);border-radius:0.2em;-webkit-border-radius:0.2em;}
    #MsgBoxDiv ul li{width:100%;overflow:hidden;text-align:center;}
    #MsgBoxDiv ul li:nth-child(1) p{width:100%;text-align:center;font-size:1.75em;color:#FFFFFF;}
    #MsgBoxDiv ul li:nth-child(2){border-top:#FFFFFF 0.04em solid;-webkit-border-top:#FFFFFF 0.04em solid;font-size:1.88em;color:#FFFFFF;}

    #addOrderDiv{width:100%;height:100%;position:absolute;left:0;top:0;z-index:100000;display:none;background:rgba(0,0,0,0.5);}
    #addOrderDiv ul{width:90%;overflow:hidden;margin-left:5%;margin-top:12%;background:#FFFFFF;border-radius:0.15em;-webkit-border-radius:0.15em;}
    #addOrderDiv ul li{float:left;text-align:center;}
    #addOrderDiv ul li:nth-child(1){width:100%;float:left;padding:3.3em 0 2.6em 0;}
    #addOrderDiv ul li:nth-child(1) input{width:90%;border-radius:0.2em;-webkit-border-radius:0.2em;font-size:1.55em;padding:0.1em;border:#E6E6E6 0.11em solid;-webkit-border:#E6E6E6 0.11em solid;}
    #addOrderDiv ul li:nth-child(2){width:49%;float:left;font-size:1.5em;border:#F0F0F0 0.07em solid;-webkit-border:#F0F0F0 0.07em solid;}
    #addOrderDiv ul li:nth-child(3){width:49%;float:right;font-size:1.5em;border:#F0F0F0 0.07em solid;-webkit-border:#F0F0F0 0.07em solid;}

    #cancelDiv{width:100%;height:100%;position:absolute;left:0;top:0;z-index:100000;display:none;background:rgba(0,0,0,0.5);}
    #cancelDiv ul{width:90%;overflow:hidden;margin-left:5%;margin-top:12%;background:#FFFFFF;border-radius:0.15em;-webkit-border-radius:0.15em;}
    #cancelDiv ul li{float:left;text-align:center;}
    #cancelDiv ul li:nth-child(1){width:100%;float:left;padding:3.3em 0 2.6em 0;}
    #cancelDiv ul li:nth-child(1) textarea{width:90%;border-radius:0.2em;-webkit-border-radius:0.2em;font-size:1.55em;padding:0.1em;border:#E6E6E6 0.11em solid;-webkit-border:#E6E6E6 0.11em solid;}
    #cancelDiv ul li:nth-child(2){width:49%;float:left;font-size:1.5em;border:#F0F0F0 0.07em solid;-webkit-border:#F0F0F0 0.07em solid;}
    #cancelDiv ul li:nth-child(3){width:49%;float:right;font-size:1.5em;border:#F0F0F0 0.07em solid;-webkit-border:#F0F0F0 0.07em solid;}

  </style>
</head>
<body>
<div id="mainDiv">
  <ul class="top_ul">
    <a href="main.htm"><li></li></a>
    <li>我的订单</li>
    <li></li>
  </ul>
  <ul class="navi_ul">
    <li class="navi_ul_li1">待出诊<span style="color:#DF0101;">(<%=doctorDataModel.getNoTreat()%>)</span></li>
    <li class="navi_ul_li2" onClick="window.location.href='treatedOrder.htm'">已出诊<span style="color:#DF0101;">(<%=doctorDataModel.getTreated()%>)</span></li>
  </ul>
  <ul class="btmul">
    <%
      if(orderQueryModelList!=null){
      for(int i=0;i<orderQueryModelList.size();i++){
        JdOrderQueryModel orderQueryModel=orderQueryModelList.get(i);
    %>
    <li class="btmul_li" id="order_<%=orderQueryModel.getUuid()%>">
      <ul class="btmul_li_ul">
        <li class="btmul_li_ul_li1">
          <span class="btmul_li_ul_li1_sp1"><%=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(orderQueryModel.getAppointmentTime())%></span>
          <span class="btmul_li_ul_li1_sp2">待出诊</span>
        </li>
        <li class="btmul_li_ul_li2" onClick="jump('<%=orderQueryModel.getUuid()%>');">
          <p class="btmul_li_ul_li2_p1">患者姓名：<font style="color:#A4A4A4;"><%=orderQueryModel.getName()%></font></p>
          <p class="btmul_li_ul_li2_p2">联系手机：<font style="color:#A4A4A4;"><%=orderQueryModel.getPhoneNumber()%></font></p>
          <p class="btmul_li_ul_li2_p3">患者年龄：<font style="color:#A4A4A4;"><%=orderQueryModel.getAge()%></font></p>
          <p class="btmul_li_ul_li2_p4">病情描述：<font style="color:#A4A4A4;"><%=orderQueryModel.getSickDescription()%></font></p>
          <p class="btmul_li_ul_li2_p5"><font style="color:#DF0101;">提示：出诊后，请记录预约号获取诊金！</font></p>
        </li>
        <li class="btmul_li_ul_li3">
          <span class="btmul_li_ul_li3_sp1">诊金：<font style="color:#FB9D3B;"><%=orderQueryModel.getConsultationFee()%></font></span>
          <span class="btmul_li_ul_li3_sp2" onClick="addOrderDialog('<%=orderQueryModel.getUuid()%>');">记录预约号</span>
          <span class="btmul_li_ul_li3_sp3" onClick="cancelOrderDialog('<%=orderQueryModel.getUuid()%>');">取消出诊</span>
        </li>
      </ul>
    </li>
    <%
        }
      }
    %>
  </ul>
</div>
<div id="addOrderDiv">
  <ul>
    <li><input type="text" id="addOrder_input" placeholder="请输入预约号" Maxlength="30"/></li>
    <li onClick="cancelbtn(1);">取消</li>
    <li onClick="submit1();">确定</li>
  </ul>
</div>
<div id="cancelDiv">
  <ul>
    <li><textarea id="cancel_input" placeholder="请输入取消出诊原因" Maxlength="300"></textarea></li>
    <li onClick="cancelbtn(2);">取消</li>
    <li onClick="submit2();">确定</li>
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

    $('.btmul').width(mw);

    $('#mainDiv').show();
    $('#MsgBoxDiv').width(mw).height(mh);
    $('#MsgBoxDiv ul').width(mw*0.84).height(mh*0.26);
    $('#MsgBoxDiv ul li').eq(0).width(mw*0.84).height(mh*0.26*0.73);
    $('#MsgBoxDiv ul li').eq(1).width(mw*0.84).height(mh*0.26*0.27);
    $('#MsgBoxDiv ul li').eq(1).css('line-height',mh*0.26*0.27+'px');
    $('#msgcontp').css('margin-top',mh*0.26*0.3);
    $('#MsgBoxDiv ul').css('margin-top',mh*0.15);

    $('#addOrderDiv').width(mw).height(mh);
    $('#addOrderDiv li input').height(mh*0.065);
    $('#addOrderDiv li').eq(1).height(mh*0.065);
    $('#addOrderDiv li').eq(2).height(mh*0.065);
    $('#addOrderDiv li').eq(1).css('line-height',mh*0.069+'px');
    $('#addOrderDiv li').eq(2).css('line-height',mh*0.069+'px');
    $('#addOrderDiv ul').css('margin-top',mh*0.12);

    $('#cancelDiv').width(mw).height(mh);
    $('#cancelDiv li textarea').height(mh*0.11);
    $('#cancelDiv li').eq(1).height(mh*0.065);
    $('#cancelDiv li').eq(2).height(mh*0.065);
    $('#cancelDiv li').eq(1).css('line-height',mh*0.069+'px');
    $('#cancelDiv li').eq(2).css('line-height',mh*0.069+'px');
    $('#cancelDiv ul').css('margin-top',mh*0.12);
  }

  var orderUUID;
  function addOrderDialog(orderID){
    orderUUID=orderID;
    $('#addOrderDiv').show();
  }
  function cancelOrderDialog(orderID){
    orderUUID=orderID;
    $('#cancelDiv').show();
  }
  function cancelbtn(num){
    if(num==1){
      $('#addOrder_input').val('');
      $('#addOrderDiv').hide();
      return;
    }
    if(num==2){
      $('#cancel_input').val('');
      $('#cancelDiv').hide();
      return;
    }
  }

  //记录预约号
  var subflag1 = false;
  function submit1(){
    if(subflag1){
      return;
    }
    subflag1 = true;
    var addOrder_input = $('#addOrder_input').val();
    if(addOrder_input==null ||addOrder_input.length==0){
      MsgOpt.showMsgBox("请输入预约号","确定");
      subflag1=false;
      return;
    }
    var data="orderNo="+addOrder_input+"&orderUUID="+orderUUID;
    $.ajax({
      type:'POST',
      url:"recordOrderNo.htm",
      data:data,
      dataType:'json',
      success:function(msg){
        if(msg.result==1){
          MsgOpt.showMsgBox("提交成功","确定");
          $("#order_"+orderUUID).empty();
          $('#addOrder_input').val('');
          $('#addOrderDiv').hide();
          var text=$(".navi_ul_li1 span").text();
          text=text.substring(1,text.length-1);
          text=parseInt(text)-1;
          $(".navi_ul_li1 span").text("("+text+")");
        }else if(msg.result==3){
          window.location.href="toLogin.htm";
        }else{
          MsgOpt.showMsgBox(msg.msg,"确定");
        }
        subflag1=false;
      },
      timeout: 10000,
      error:function(){
        MsgOpt.showMsgBox("出错","确定");
        subflag1=false;
      }
    });
  }
  //取消出诊
  var subflag2 = false;
  function submit2(){
    if(subflag2){
      return;
    }
    subflag2 = true;
    var cancel_input = $('#cancel_input').val();
    var data="cancelReason="+cancel_input+"&orderUUID="+orderUUID;
    if(cancel_input==null || cancel_input.length==0){
      MsgOpt.showMsgBox("取消原因不能为空","确定");
      subflag2=false;
      return;
    }
    $.ajax({
      type:'POST',
      url:"cancelOrder.htm",
      data:data,
      dataType:'json',
      success:function(msg){
        if(msg.result==1){
          MsgOpt.showMsgBox("提交成功","确定");
          $("#order_"+orderUUID).empty();
          $('#cancel_input').val('');
          $('#cancelDiv').hide();
          var text=$(".navi_ul_li1 span").text();
          text=text.substring(1,text.length-1);
          text=parseInt(text)-1;
          $(".navi_ul_li1 span").text("("+text+")");
        }else if(msg.result==3){
          window.location.href="toLogin.htm";
        }else{
          MsgOpt.showMsgBox(msg.msg,"确定");
        }
        subflag2=false;
      },
      timeout: 10000,
      error:function(){
        MsgOpt.showMsgBox("出错","确定");
        subflag2=false;
      }
    });
  }

  function jump(orderID){
    window.location.href = 'notreatOrderDetail.htm?orderUUID='+orderID;
  }

  //消息弹窗类
  var MsgOpt = {
    msgt:null,
    showMsgBox:function(msg, btnword){
      var mythis = this;
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
    }
  };


</script>