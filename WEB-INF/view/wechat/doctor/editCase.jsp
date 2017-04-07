<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.aidee.jdoctor.model.JdSickCategaryQueryModel" %>
<%@ page import="java.util.List" %>
<%@ page import="cn.aidee.jdoctor.model.JdCaseHistoryModel" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
  JdCaseHistoryModel caseHistoryModel=(JdCaseHistoryModel)request.getAttribute("caseHistoryModel");
  JdSickCategaryQueryModel sickCategaryQueryModel=(JdSickCategaryQueryModel)request.getAttribute("sickCategaryQueryModel");
  List<JdSickCategaryQueryModel> sickCategaryQueryModelList=(List<JdSickCategaryQueryModel>)request.getAttribute("sickCategaryQueryModelList");
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
    #mainDiv .btmul .btmul_li{width:100%;float:left;background:#FFFFFF;}
    #mainDiv .btmul .btmul_li ul{width:100%;overflow:hidden;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li1{width:100%;padding:0.8em 0 0.8em 0;border-bottom:#F1F1F1 0.13em solid;-webkit-border-bottom:#F1F1F1 0.13em solid;float:left;background:#F2F2F2;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li1 .btmul_li_ul_li1_sp1{font-size:1.5em;margin-left:3%;float:left;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li1 .btmul_li_ul_li1_sp2{font-size:1.5em;margin-right:3%;float:right;color:#2882D8;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li2{width:100%;border-bottom:#F1F1F1 0.125em solid;-webkit-border-bottom:#F1F1F1 0.125em solid;padding:1.5em 0 1.5em 0;float:left;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li2 p{width:94%;padding:0.2em 0 0.2em 0;margin-left:3%;font-size:1.55em;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li3{width:100%;border-bottom:#F1F1F1 0.125em solid;-webkit-border-bottom:#F1F1F1 0.125em solid;padding:1.5em 0 1.5em 0;float:left;background:url(../../wechat/images/icon6.png) center right no-repeat #FFFFFF;background-size:auto 58%;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li3 p{width:94%;padding:0.2em 0 0.2em 0;margin-left:3%;font-size:1.55em;}

    .saveul{width:90%;margin-left:5%;overflow:hidden;margin-top:10%;}
    .saveul li{width:40%;float:left;border-radius:0.2em;-webkit-border-radius:0.2em;text-align:center;font-size:1.7em;color:#FFFFFF;background:#FB9D3B;}
    .saveul li:nth-child(1){float:left;background:#D8D8D8;}
    .saveul li:nth-child(2){float:right;}

    #MsgBoxDiv{width:100%;height:100%;position:fixed;left:0;top:0;z-index:1000000;display:none;}
    #MsgBoxDiv ul{width:84%;overflow:hidden;margin-left:8%;background:rgba(0,0,0,0.65);border-radius:0.2em;-webkit-border-radius:0.2em;}
    #MsgBoxDiv ul li{width:100%;overflow:hidden;text-align:center;}
    #MsgBoxDiv ul li:nth-child(1) p{width:100%;text-align:center;font-size:1.75em;color:#FFFFFF;}
    #MsgBoxDiv ul li:nth-child(2){border-top:#FFFFFF 0.04em solid;-webkit-border-top:#FFFFFF 0.04em solid;font-size:1.88em;color:#FFFFFF;}

    #classifyDiv{width:100%;height:100%;position:absolute;left:0;top:0;z-index:100000;display:none;background:#F2F2F2;overflow-y:auto;}
    #classifyDiv .classifyDiv_ul1{width:100%;overflow:hidden;}
    #classifyDiv .classifyDiv_ul1 li{width:100%;float:left;}
    #classifyDiv .classifyDiv_ul1 li:nth-child(1){width:100%;background:#FB9D3B;text-align:center;font-size:2em;color:#FFFFFF;}
    #classifyDiv .classifyDiv_ul1 .classifyDiv_ul1_li1{width:100%;background:url(../../wechat/images/icon11.png) center right no-repeat #FFFFFF;padding:1.65em 0 1.65em 0;border-bottom:#E6E6E6 0.12em solid;-webkit-border-bottom:#E6E6E6 0.12em solid;}
    #classifyDiv .classifyDiv_ul1 .classifyDiv_ul1_li1 span{margin-left:2%;font-size:1.6em;color:#000000;}
    #classifyDiv .classifyDiv_ul2{width:90%;overflow:hidden;margin-top:8%;margin-left:5%;padding-bottom:4em;}
    #classifyDiv .classifyDiv_ul2 li{width:100%;float:left;}
    #classifyDiv .classifyDiv_ul2 li:nth-child(1){width:40%;background:#FB9D3B; border-radius:0.2em;-webkit-border-radius:0.2em;text-align:center;font-size:1.6em;color:#FFFFFF;float:left;}
    #classifyDiv .classifyDiv_ul2 li:nth-child(2){width:40%;background:#FB9D3B; border-radius:0.2em;-webkit-border-radius:0.2em;text-align:center;font-size:1.6em;color:#FFFFFF;float:right;}

    #situationDiv{width:100%;height:100%;position:fixed;left:0;top:0;z-index:100000;display:none;background:#F2F2F2;overflow-y:auto;}
    #situationDiv .situationDiv_ul1{width:100%;overflow:hidden;}
    #situationDiv .situationDiv_ul1 li{width:100%;float:left;}
    #situationDiv .situationDiv_ul1 li:nth-child(1){width:100%;background:#FB9D3B;text-align:center;font-size:2em;color:#FFFFFF;}
    #situationDiv .situationDiv_ul1 .situationDiv_ul1_li1{width:100%;background:#F2F2F2;padding:0.65em 0 0.65em 0;}
    #situationDiv .situationDiv_ul1 .situationDiv_ul1_li1 span{margin-left:2%;font-size:1.6em;color:#000000;}
    #situationDiv .situationDiv_ul1 .situationDiv_ul1_li2{width:100%;background:#F2F2F2;padding:0.65em 0 0 0;}
    #situationDiv .situationDiv_ul1 .situationDiv_ul1_li2 textarea{width:956%;margin-left:2%;font-size:1.6em;color:#000000;border:#E6E6E6 0.1em solid;-webkit-border:#E6E6E6 0.1em solid;}

    #situationDiv .situationDiv_ul2{width:90%;overflow:hidden;margin-top:8%;margin-left:5%;padding-bottom:4em;}
    #situationDiv .situationDiv_ul2 li{width:100%;float:left;}
    #situationDiv .situationDiv_ul2 li:nth-child(1){width:40%;background:#FB9D3B; border-radius:0.2em;-webkit-border-radius:0.2em;text-align:center;font-size:1.6em;color:#FFFFFF;float:left;}
    #situationDiv .situationDiv_ul2 li:nth-child(2){width:40%;background:#FB9D3B; border-radius:0.2em;-webkit-border-radius:0.2em;text-align:center;font-size:1.6em;color:#FFFFFF;float:right;}

  </style>
</head>
<body>
<div id="mainDiv">
  <ul class="top_ul">
    <a href="javascript:history.back();"><li></li></a>
    <li><%=caseHistoryModel.getName()%>病例</li>
    <li><a href="uInfo.htm">首页</a></li>
  </ul>
  <ul class="btmul">
    <li class="btmul_li">
      <ul class="btmul_li_ul">
        <li class="btmul_li_ul_li1">
          <span class="btmul_li_ul_li1_sp1">患者基本信息</span>
        </li>
        <li class="btmul_li_ul_li2">
          <p class="btmul_li_ul_li2_p1">患者姓名：<font style="color:#A4A4A4;"><%=caseHistoryModel.getName()%></font></p>
        </li>
        <li class="btmul_li_ul_li2">
          <p class="btmul_li_ul_li2_p2">患者年龄：<font style="color:#A4A4A4;"><%=caseHistoryModel.getAge()%></font></p>
        </li>
        <li class="btmul_li_ul_li2">
          <p class="btmul_li_ul_li2_p3">联系手机：<font style="color:#A4A4A4;"><%=caseHistoryModel.getMobile()%></font></p>
        </li>
        <li class="btmul_li_ul_li1">
          <span class="btmul_li_ul_li1_sp1">诊断情况</span>
        </li>
        <li class="btmul_li_ul_li2">
          <p class="btmul_li_ul_li2_p1">诊断时间：<font style="color:#A4A4A4;"><%=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(caseHistoryModel.getDiagnoseDate())%></font></p>
        </li>
        <li class="btmul_li_ul_li3" onClick="show1();">
          <p class="btmul_li_ul_li3_p2">病情类别</p>
          <p id="jd_sickcategory_label"><%=sickCategaryQueryModel.getName()%></p>
          </li>
        <li class="btmul_li_ul_li3" onClick="show2();">
          <p class="btmul_li_ul_li3_p3">诊断情况</p>
          <p id="description"><%=caseHistoryModel.getDescription()%></p>
        </li>
      </ul>
    </li>
  </ul>
  <ul class="saveul">
    <li onClick="deleteCase();">删除</li>
    <li onClick="saveCase();">保存</li>
  </ul>
</div>
<div id="classifyDiv">
  <ul class="classifyDiv_ul1">
    <li class="classifyDiv_ul1_li0">病情类型</li>
    <%
      for(int i=0;i<sickCategaryQueryModelList.size();i++){
        JdSickCategaryQueryModel model=sickCategaryQueryModelList.get(i);
    %>
    <li class="classifyDiv_ul1_li1" alt="0" onClick="choose1('<%=model.getUuid()%>',this);"><span>
      <%=model.getName()%></span></li>
    <%
      }
    %>
  </ul>
  <ul class="classifyDiv_ul2">
    <li onClick="tocancel1();">取消</li>
    <li onClick="tosure1();">确定</li>
  </ul>
</div>
<div id="situationDiv">
  <ul class="situationDiv_ul1">
    <li class="situationDiv_ul1_li0">诊断情况</li>
    <li class="situationDiv_ul1_li1"><span>请填写诊断情况</span></li>
    <li class="situationDiv_ul1_li2"><textarea id="situation_input"><%=caseHistoryModel.getDescription()%></textarea></li>
  </ul>
  <ul class="situationDiv_ul2">
    <li onClick="tocancel2();">取消</li>
    <li onClick="tosure2();">确定</li>
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

    $('.saveul').width(mw*0.9).height(mh*0.07);
    $('.saveul li').width(mw*0.4).height(mh*0.07);
    $('.saveul li').css('line-height',mh*0.07+'px');

    $('#mainDiv').show();
    $('#MsgBoxDiv').width(mw).height(mh);
    $('#MsgBoxDiv ul').width(mw*0.84).height(mh*0.26);
    $('#MsgBoxDiv ul li').eq(0).width(mw*0.84).height(mh*0.26*0.73);
    $('#MsgBoxDiv ul li').eq(1).width(mw*0.84).height(mh*0.26*0.27);
    $('#MsgBoxDiv ul li').eq(1).css('line-height',mh*0.26*0.27+'px');
    $('#msgcontp').css('margin-top',mh*0.26*0.3);
    $('#MsgBoxDiv ul').css('margin-top',mh*0.15);

    $('#classifyDiv').width(mw).height(mh0);
    $('.classifyDiv_ul1').width(mw);
    $('.classifyDiv_ul1_li0').width(mw).height(mh*0.07);
    $('.classifyDiv_ul1_li0').css('line-height',mh*0.07+'px');
    $('.classifyDiv_ul2').width(mw*0.9);
    $('.classifyDiv_ul2 li').width(mw*0.9*0.4).height(mh*0.065);
    $('.classifyDiv_ul2 li').css('line-height',mh*0.065+'px');

    $('#situationDiv').width(mw).height(mh0);
    $('.situationDiv_ul1').width(mw);
    $('.situationDiv_ul1_li0').width(mw).height(mh*0.07);
    $('.situationDiv_ul1_li0').css('line-height',mh*0.07+'px');
    $('.situationDiv_ul2').width(mw*0.9);
    $('.situationDiv_ul2 li').width(mw*0.9*0.4).height(mh*0.065);
    $('.situationDiv_ul2 li').css('line-height',mh*0.065+'px');
    $('#situation_input').width(mw*0.96).height(mh*0.25);
  }

  function deleteCase(){
    if(confirm('是否删除该病例？删除以后不可恢复！')){
      data="jd_casehistory_id=<%=caseHistoryModel.getUuid()%>";
      $.ajax({
        type: 'POST',
        url: 'deleteCase.htm',
        dataType: 'json',
        data:data,
        success: function (msg) {
          if(msg.result==1){
            alert("病例删除成功");
            window.location.href="treatedOrder.htm";
          }else if(msg.result==3){
            window.location.href="toLogin.htm";
          }else{
            MsgOpt.showMsgBox("病例删除失败","确定");
          }
        },
        timeout: 10000,
        error: function () {
          var msg = '病例删除失败，请检查网络';
          var btnword = '确定';
          MsgOpt.showMsgBox(msg, btnword);
          return;
        }
      });
    }
  }

  function saveCase(){
    var description=$("#description").html();
    if(description==null ||description.length==0){
      MsgOpt.showMsgBox("请填写诊断情况","确定");
      return;
    }

    data="sickcategory_id="+sickcategory_id+"&description="+description+"&jd_casehistory_id=<%=caseHistoryModel.getUuid()%>";
    $.ajax({
      type: 'POST',
      url: 'updateCase.htm',
      dataType: 'json',
      data:data,
      success: function (msg) {
        if(msg.result==1){
          MsgOpt.showMsgBox("病例更新成功","确定");
        }else if(msg.result==3){
          window.location.href="toLogin.htm";
        }else{
          MsgOpt.showMsgBox("病例更新失败","确定");
        }
      },
      error: function () {
        var msg = '病例更新失败，请检查网络';
        var btnword = '确定';
        MsgOpt.showMsgBox(msg, btnword);
        return;
      }
    });

  }

  function show1(){
    $('#classifyDiv').show();
  }

  function show2(){
    $('#situationDiv').show();
  }

  var sickcategory_id='<%=caseHistoryModel.getJdSickCategaryId()%>';
  var sickcategory_name;
  function choose1(num,ob){
    var alt = $(ob).attr('alt');
    if(alt==0){
      $(ob).css('background-image','url(../../wechat/images/icon10.png)');
      $(ob).find('span').css('color','#FB9D3B');
      $(ob).attr('alt',1);
    }else{
      $(ob).css('background-image','url(../../wechat/images/icon11.png)');
      $(ob).find('span').css('color','#000000');
      $(ob).attr('alt',0);
    }
    sickcategory_id=num;
    sickcategory_name=$(ob).find("span").html();
    $("#jd_sickcategory_label").html(sickcategory_name);
    $('#classifyDiv').hide();
  }

  function tocancel1(){
    $('#classifyDiv').hide();
  }

  function tosure1(){

  }

  function tocancel2(){
    $('#situationDiv').hide();
  }

  function tosure2(){
    var value=$("#situation_input").val();
    $("#description").html(value);
    $('#situationDiv').hide();
  }

  function jump(orderID){
    window.location.href = '你的域名?orderID='+orderID;
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