<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="cn.aidee.jdoctor.model.JdDoctorQueryModel" %>
<%@ page import="cn.aidee.jdoctor.wechat.WechatUtils" %>
<%
  List<JdDoctorQueryModel> doctorQueryModelList=(List<JdDoctorQueryModel>)request.getAttribute("doctorQueryModelList");
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
    #mainDiv .top_ul li:nth-child(1){width:22.5%;height:100%;background:url(../../wechat/images/larrow.png) center left no-repeat;background-size:auto 60%;}
    #mainDiv .top_ul li:nth-child(2){width:62%;height:100%;font-size:2em;color:#FFFFFF;}
    #mainDiv .top_ul li:nth-child(3){width:10%;height:100%;}
    #mainDiv .top_ul li:nth-child(3) a{font-size:1.55em;color:#FFFFFF;}

    #mainDiv .mainul3{width:100%;overflow:hidden;padding:0 0 1.3em 0;background:#F2F2F2;}
    #mainDiv .mainul3 .mainul3_li1{width:100%;background:#FFFFFF;float:left;padding:1.6em 0 1.6em 0;border-bottom:#F2F2F2 0.15em solid;-webkit-border-bottom:#F2F2F2 0.15em solid;}
    #mainDiv .mainul3 .mainul3_li1 img{width:15%;height:15%;margin-left:3%;float:left;border-radius:50%;-webkit-border-radius:50%;}
    #mainDiv .mainul3 .mainul3_li1 ul{width:74%;float:right;overflow:hidden;}
    #mainDiv .mainul3 .mainul3_li1 ul li{width:100%;float:left;margin-bottom:0.12em;}
    #mainDiv .mainul3 .mainul3_li1 ul li .cont_div1{float:left;font-size:1.6em;}
    #mainDiv .mainul3 .mainul3_li1 ul li .cont_div1 .jobsp{color:#FA9D3E;}
    #mainDiv .mainul3 .mainul3_li1 ul li .cont_div2{float:right;text-align:center;font-size:1.58em; color:#2882D8;margin-right:3%;}
    #mainDiv .mainul3 .mainul3_li1 ul .mainul3_li1_ul_li1{font-size:1.5em;margin-top: 0.4em;}
    #mainDiv .mainul3 .mainul3_li1 ul .mainul3_li1_ul_li2{font-size:1.5em;}
    #mainDiv .mainul3 .mainul3_li1 ul .mainul3_li1_ul_li2 span{color:#6E6E6E;}
    #mainDiv .mainul3 .mainul3_li1 ul .mainul3_li1_ul_li3{font-size:1.5em;}
    #mainDiv .mainul3 .mainul3_li1 ul .mainul3_li1_ul_li3 span{color:#6E6E6E;}
    #mainDiv .mainul3 .mainul3_li1 ul .mainul3_li1_ul_li4{font-size:1.5em;}
    #mainDiv .mainul3 .mainul3_li1 ul .mainul3_li1_ul_li4 span{color:#6E6E6E;}
  </style>
</head>
<body>
<div id="mainDiv">
  <ul class="top_ul">
    <a href="javascript:history.back();"><li></li></a>
    <li>我的关注</li>
    <li><a href="main.htm">首页</a></li>
  </ul>
  <ul class="mainul3">
    <%
      if(doctorQueryModelList!=null){
        for(int i=0;i<doctorQueryModelList.size();i++){
          JdDoctorQueryModel jdDoctorQueryModel=doctorQueryModelList.get(i);
    %>
    <li class="mainul3_li1" onClick="jump('<%=jdDoctorQueryModel.getUuid()%>');">
      <img src="<%=jdDoctorQueryModel.getHeadPic()%>"/>
      <ul>
        <li>
          <div class="cont_div1">
            <span class="namesp"><%=jdDoctorQueryModel.getName()%></span>
            <span class="jobsp"><%=jdDoctorQueryModel.getTitle()%></span>
          </div>
          <div class="cont_div2"><%=jdDoctorQueryModel.getAvailable()%></div>
        </li>
        <li class="mainul3_li1_ul_li1"><%=jdDoctorQueryModel.getHospital()%></li>
        <li class="mainul3_li1_ul_li2">科室：<span><%=jdDoctorQueryModel.getDepartment()%></span></li>
        <li class="mainul3_li1_ul_li3">擅长：<span><%=WechatUtils.showDoctorSkills(jdDoctorQueryModel.getDoctorSelectSkills())%></span></li>
        <li class="mainul3_li1_ul_li4">人气：<span><%=jdDoctorQueryModel.getPopularity()%></span></li>
      </ul>
    </li>
    <%
        }
      }
    %>
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

    $('.mainul3').width(mw);
    $('.mainul3_li1').width(mw);
    $('.mainul3_li1 img').width(mw*0.2).height(mw*0.2);

    $('#mainDiv').show();
    $('#MsgBoxDiv').width(mw).height(mh);
    $('#MsgBoxDiv ul').width(mw*0.84).height(mh*0.26);
    $('#MsgBoxDiv ul li').eq(0).width(mw*0.84).height(mh*0.26*0.73);
    $('#MsgBoxDiv ul li').eq(1).width(mw*0.84).height(mh*0.26*0.27);
    $('#MsgBoxDiv ul li').eq(1).css('line-height',mh*0.26*0.27+'px');
    $('#msgcontp').css('margin-top',mh*0.26*0.3);
    $('#MsgBoxDiv ul').css('margin-top',mh*0.16);
  }

  //跳转页面
  function jump(ID){
    window.location.href ='doctor.htm?jd_doctor_id='+ID;
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