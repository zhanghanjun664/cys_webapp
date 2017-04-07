<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.aidee.jdoctor.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
  JdDoctorModel doctorModel=(JdDoctorModel)request.getAttribute("doctorModel");
  JdTitleModel titleModel=(JdTitleModel)request.getAttribute("titleModel");
  JdDepartmentModel departmentModel=(JdDepartmentModel)request.getAttribute("departmentModel");
  JdHospitalModel hospitalModel=(JdHospitalModel)request.getAttribute("hospitalModel");
  List<JdSickQueryModel> sickQueryModelList=(List<JdSickQueryModel>)request.getAttribute("sickQueryModelList");
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
    #mainDiv .top_ul li:nth-child(1){width:14.5%;height:100%;background:url(../../wechat/images/larrow.png) center left no-repeat;background-size:auto 55%;}
    #mainDiv .top_ul li:nth-child(2){width:70%;height:100%;font-size:2em;color:#FFFFFF;}
    #mainDiv .top_ul li:nth-child(3){width:15%;height:100%;float:right;}
    #mainDiv .top_ul li:nth-child(3) a{font-size:1.6em;color:#FFFFFF;}

    #mainDiv .mainul1{width:100%;overflow:hidden;padding:1.3em 0 0.8em 0;background:#FFFFFF;}
    #mainDiv .mainul1 .mainul1_li1{width:90%;margin-left:5%;padding:0.5em 0.3em 0.5em 0.3em;border-radius:5em;-webkit-border-radius:5em;background:url(../../wechat/images/icon16.png) center left no-repeat #F2F2F2;background-size:auto 43%;background-position:1.2%;border:#E6E6E6 0.11em solid;}
    #mainDiv .mainul1 li input[type="text"]{width:85%;font-size:1.58em;color:#000000;background:transparent;border:0;-webkit-border:0;margin-left:7%;float:left;}

    #mainDiv .btmul{width:100%;overflow:hidden;}
    #mainDiv .btmul .btmul_li{width:100%;float:left;background:#FFFFFF;}
    #mainDiv .btmul .btmul_li ul{width:100%;overflow:hidden;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li0{width:100%;overflow:hidden;float:left;padding:1.2em 0 1.2em 0;background:#F2F2F2;text-align:center;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li0 img{width:93%;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li1{width:100%;border-bottom:#F1F1F1 0.125em solid;-webkit-border-bottom:#F1F1F1 0.125em solid;padding:1.6em 0 1.6em 0;float:left;background: center right no-repeat #FFFFFF;background-size:auto 58%;float:left;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li1 span:nth-child(1){margin-left:2%;font-size:1.55em;float:left;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li1 span:nth-child(2){margin-right:6%;font-size:1.5em;color:#A4A4A4;float:right;}
    #mainDiv .btmul .btmul_li ul li:nth-child(1){padding:0.6em 0 0.6em 0;}
    #mainDiv .btmul .btmul_li ul li:nth-child(1) span{margin-top:1.2em;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li1 img{height:95%;margin-right:7%;float:right;}

    #mainDiv .introul{width:100%;overflow:hidden;}
    #mainDiv .introul li{width:100%;float:left;}
    #mainDiv .introul .introul_li0{padding:0.7em 0 0.7em 0;}
    #mainDiv .introul .introul_li0 span{font-size:1.55em;margin-left:2%;}
    #mainDiv .introul .introul_li1{padding:1.2em 0 1.2em 0;background: center right no-repeat #FFFFFF;background-size:8% auto;}
    #mainDiv .introul .introul_li1 p{width:90%;font-size:1.51em;margin-left:2%;}

    #mainDiv .certificateul{width:100%;overflow:hidden;padding-bottom:1.5em;}
    #mainDiv .certificateul li{width:100%;float:left;}
    #mainDiv .certificateul .certificateul_li0{padding:0.7em 0 0.7em 0;}
    #mainDiv .certificateul .certificateul_li0 span{font-size:1.55em;margin-left:2%;}
    #mainDiv .certificateul .certificateul_li1{padding:1.2em 0 1.2em 0;background: center right no-repeat #FFFFFF;background-size:8% auto;}
    #mainDiv .certificateul .certificateul_li1 img{margin-top:0.6em;margin-left:2%;margin-right:2%;}

    #MsgBoxDiv{width:100%;height:100%;position:fixed;left:0;top:0;z-index:1000000;display:none;}
    #MsgBoxDiv ul{width:84%;overflow:hidden;margin-left:8%;background:rgba(0,0,0,0.65);border-radius:0.2em;-webkit-border-radius:0.2em;}
    #MsgBoxDiv ul li{width:100%;overflow:hidden;text-align:center;}
    #MsgBoxDiv ul li:nth-child(1) p{width:100%;text-align:center;font-size:1.75em;color:#FFFFFF;}
    #MsgBoxDiv ul li:nth-child(2){border-top:#FFFFFF 0.04em solid;-webkit-border-top:#FFFFFF 0.04em solid;font-size:1.88em;color:#FFFFFF;}

    #editNameDiv{width:100%;position:absolute;left:0;top:0;z-index:100000;display:none;background:rgba(0,0,0,0.5);}
    #editNameDiv ul{width:90%;overflow:hidden;margin-left:5%;margin-top:5%;background:#FFFFFF;border-radius:0.15em;-webkit-border-radius:0.15em;}
    #editNameDiv ul li{float:left;text-align:center;}
    #editNameDiv ul li:nth-child(1){width:100%;float:left;padding:3.3em 0 2.6em 0;}
    #editNameDiv ul li:nth-child(1) input{width:90%;border-radius:0.2em;-webkit-border-radius:0.2em;font-size:1.55em;padding:0.1em;border:#E6E6E6 0.11em solid;-webkit-border:#E6E6E6 0.11em solid;}
    #editNameDiv ul li:nth-child(2){width:49.7%;float:left;font-size:1.5em;border:#F0F0F0 0.07em solid;-webkit-border:#F0F0F0 0.07em solid;}
    #editNameDiv ul li:nth-child(3){width:49.7%;float:right;font-size:1.5em;border:#F0F0F0 0.07em solid;-webkit-border:#F0F0F0 0.07em solid;}

    #editJobCodeDiv{width:100%;position:absolute;left:0;top:0;z-index:100000;display:none;background:rgba(0,0,0,0.5);}
    #editJobCodeDiv ul{width:90%;overflow:hidden;margin-left:5%;margin-top:5%;background:#FFFFFF;border-radius:0.15em;-webkit-border-radius:0.15em;}
    #editJobCodeDiv ul li{float:left;text-align:center;}
    #editJobCodeDiv ul li:nth-child(1){width:100%;float:left;padding:3.3em 0 2.6em 0;}
    #editJobCodeDiv ul li:nth-child(1) input{width:90%;border-radius:0.2em;-webkit-border-radius:0.2em;font-size:1.55em;padding:0.1em;border:#E6E6E6 0.11em solid;-webkit-border:#E6E6E6 0.11em solid;}
    #editJobCodeDiv ul li:nth-child(2){width:49.7%;float:left;font-size:1.5em;border:#F0F0F0 0.07em solid;-webkit-border:#F0F0F0 0.07em solid;}
    #editJobCodeDiv ul li:nth-child(3){width:49.7%;float:right;font-size:1.5em;border:#F0F0F0 0.07em solid;-webkit-border:#F0F0F0 0.07em solid;}

    #SpecialtyDiv{width:100%;height:100%;position:absolute;left:0;top:0;z-index:1000000;display:none;background:#F2F2F2;overflow-y:auto;}
    #SpecialtyDiv .SpecialtyDiv_ul1{width:100%;overflow:hidden;}
    #SpecialtyDiv .SpecialtyDiv_ul1 li{width:100%;float:left;}
    #SpecialtyDiv .SpecialtyDiv_ul1 li:nth-child(1){width:100%;background:#FB9D3B;text-align:center;font-size:2em;color:#FFFFFF;}
    #SpecialtyDiv .SpecialtyDiv_ul1 .SpecialtyDiv_ul1_li1{width:100%;background:url(../../wechat/images/icon11.png) center right no-repeat #FFFFFF;padding:1.65em 0 1.65em 0;border-bottom:#E6E6E6 0.12em solid;-webkit-border-bottom:#E6E6E6 0.12em solid;}
    #SpecialtyDiv .SpecialtyDiv_ul1 .SpecialtyDiv_ul1_li1 span{margin-left:2%;font-size:1.6em;color:#000000;}
    #SpecialtyDiv .SpecialtyDiv_ul2{width:90%;overflow:hidden;margin-top:8%;margin-left:5%;padding-bottom:4em;}
    #SpecialtyDiv .SpecialtyDiv_ul2 li{width:100%;float:left;}
    #SpecialtyDiv .SpecialtyDiv_ul2 li:nth-child(1){width:40%;background:#FB9D3B; border-radius:0.2em;-webkit-border-radius:0.2em;text-align:center;font-size:1.6em;color:#FFFFFF;float:left;}
    #SpecialtyDiv .SpecialtyDiv_ul2 li:nth-child(2){width:40%;background:#FB9D3B; border-radius:0.2em;-webkit-border-radius:0.2em;text-align:center;font-size:1.6em;color:#FFFFFF;float:right;}

    #JobDiv{width:100%;height:100%;position:absolute;left:0;top:0;z-index:1000000;display:none;background:#F2F2F2;overflow-y:auto;}
    #JobDiv .JobDiv_ul1{width:100%;overflow:hidden;}
    #JobDiv .JobDiv_ul1 li{width:100%;float:left;}
    #JobDiv .JobDiv_ul1 li:nth-child(1){width:100%;background:#FB9D3B;text-align:center;font-size:2em;color:#FFFFFF;}
    #JobDiv .JobDiv_ul1 .JobDiv_ul1_li1{width:100%;background:url(../../wechat/images/icon11.png) center right no-repeat #FFFFFF;padding:1.65em 0 1.65em 0;border-bottom:#E6E6E6 0.12em solid;-webkit-border-bottom:#E6E6E6 0.12em solid;}
    #JobDiv .JobDiv_ul1 .JobDiv_ul1_li1 span{margin-left:2%;font-size:1.6em;color:#000000;}
    #JobDiv .JobDiv_ul2{width:90%;overflow:hidden;margin-top:8%;margin-left:5%;padding-bottom:4em;}
    #JobDiv .JobDiv_ul2 li{width:100%;float:left;}
    #JobDiv .JobDiv_ul2 li:nth-child(1){width:40%;background:#FB9D3B; border-radius:0.2em;-webkit-border-radius:0.2em;text-align:center;font-size:1.6em;color:#FFFFFF;float:left;}
    #JobDiv .JobDiv_ul2 li:nth-child(2){width:40%;background:#FB9D3B; border-radius:0.2em;-webkit-border-radius:0.2em;text-align:center;font-size:1.6em;color:#FFFFFF;float:right;}

    #StartTimeDiv{width:100%;height:100%;position:absolute;left:0;top:0;z-index:1000000;display:none;background:#F2F2F2;overflow-y:auto;}
    #StartTimeDiv .StartTimeDiv_ul1{width:100%;overflow:hidden;}
    #StartTimeDiv .StartTimeDiv_ul1 li{width:100%;float:left;}
    #StartTimeDiv .StartTimeDiv_ul1 li:nth-child(1){width:100%;background:#FB9D3B;text-align:center;font-size:2em;color:#FFFFFF;}
    #StartTimeDiv .StartTimeDiv_ul1 .StartTimeDiv_ul1_li1{background:#FFFFFF;padding:1.65em 0 1.65em 0;text-align:center;}
    #StartTimeDiv .StartTimeDiv_ul1 .StartTimeDiv_ul1_li1 select{width:70%;height:90%;font-size:1.6em;color:#000000;text-align:center;}
    #StartTimeDiv .StartTimeDiv_ul1 .StartTimeDiv_ul1_li1 span{font-size:1.6em;color:#000000;text-align:center;}
    #StartTimeDiv .StartTimeDiv_ul2{width:90%;overflow:hidden;margin-top:8%;margin-left:5%;padding-bottom:4em;}
    #StartTimeDiv .StartTimeDiv_ul2 li{width:100%;float:left;}
    #StartTimeDiv .StartTimeDiv_ul2 li:nth-child(1){width:40%;background:#FB9D3B; border-radius:0.2em;-webkit-border-radius:0.2em;text-align:center;font-size:1.6em;color:#FFFFFF;float:left;}
    #StartTimeDiv .StartTimeDiv_ul2 li:nth-child(2){width:40%;background:#FB9D3B; border-radius:0.2em;-webkit-border-radius:0.2em;text-align:center;font-size:1.6em;color:#FFFFFF;float:right;}

    #HospitalDiv{width:100%;height:100%;position:absolute;left:0;top:0;z-index:1000000;display:none;background:#F2F2F2;overflow-y:auto;}
    #HospitalDiv .HospitalDiv_ul1{width:100%;overflow:hidden;}
    #HospitalDiv .HospitalDiv_ul1 li{width:100%;float:left;}
    #HospitalDiv .HospitalDiv_ul1 li:nth-child(1){width:100%;background:#FB9D3B;text-align:center;font-size:2em;color:#FFFFFF;}
    #HospitalDiv .HospitalDiv_ul1 .HospitalDiv_ul1_li1{background:#FFFFFF;padding:1.65em 0 1.65em 0;text-align:center;}
    #HospitalDiv .HospitalDiv_ul1 .HospitalDiv_ul1_li1 select{width:70%;height:90%;font-size:1.6em;color:#000000;text-align:center;}
    #HospitalDiv .HospitalDiv_ul2{width:100%;overflow:hidden;margin-top:8%;position:fixed;left:0;bottom:0;}
    #HospitalDiv .HospitalDiv_ul2 li{width:100%;float:left;}
    #HospitalDiv .HospitalDiv_ul2 li:nth-child(1){width:40%;background:#FB9D3B;text-align:center;font-size:1.6em;color:#FFFFFF;float:left;}
    #HospitalDiv .HospitalDiv_ul3{width:100%;overflow:hidden;margin-top:1%;}
    #HospitalDiv .HospitalDiv_ul3 li{width:100%;background:#FFFFFF;padding:1.2em 0 1.2em 0;float:left;border-bottom:#F2F2F2 0.11em solid;-webkit-border-bottom:#F2F2F2 0.11em solid;}
    #HospitalDiv .HospitalDiv_ul3 li .HospitalDiv_ul3_li_p1{width:96%;margin-left:2%;font-size:1.6em;color:#FB9D3B;text-align:left;padding-bottom:0.3em;}
    #HospitalDiv .HospitalDiv_ul3 li .HospitalDiv_ul3_li_p2{width:96%;margin-left:2%;font-size:1.5em;color:#A4A4A4;text-align:left;}

    #RoomDiv{width:100%;height:100%;position:absolute;left:0;top:0;z-index:1000000;display:none;background:#F2F2F2;overflow-y:auto;}
    #RoomDiv .RoomDiv_ul1{width:100%;overflow:hidden;}
    #RoomDiv .RoomDiv_ul1 li{width:100%;float:left;}
    #RoomDiv .RoomDiv_ul1 li:nth-child(1){width:100%;background:#FB9D3B;text-align:center;font-size:2em;color:#FFFFFF;}
    #RoomDiv .RoomDiv_ul1 .RoomDiv_ul1_li1{width:100%;background:url(../../wechat/images/icon11.png) center right no-repeat #FFFFFF;padding:1.65em 0 1.65em 0;border-bottom:#E6E6E6 0.12em solid;-webkit-border-bottom:#E6E6E6 0.12em solid;}
    #RoomDiv .RoomDiv_ul1 .RoomDiv_ul1_li1 span{margin-left:2%;font-size:1.6em;color:#000000;}
    #RoomDiv .RoomDiv_ul2{width:90%;overflow:hidden;margin-top:8%;margin-left:5%;padding-bottom:4em;}
    #RoomDiv .RoomDiv_ul2 li{width:100%;float:left;}
    #RoomDiv .RoomDiv_ul2 li:nth-child(1){width:40%;background:#FB9D3B; border-radius:0.2em;-webkit-border-radius:0.2em;text-align:center;font-size:1.6em;color:#FFFFFF;float:left;}
    #RoomDiv .RoomDiv_ul2 li:nth-child(2){width:40%;background:#FB9D3B; border-radius:0.2em;-webkit-border-radius:0.2em;text-align:center;font-size:1.6em;color:#FFFFFF;float:right;}

  </style>
</head>
<body>
<div id="mainDiv">
  <ul class="top_ul">
    <a href="javascript:window.location.href='uInfo.htm';"><li></li></a>
    <li>我的资料</li>
    <li><a onClick="editMyInfo();">编辑</a></li>
  </ul>
  <ul class="btmul">
    <li class="btmul_li">
      <ul class="btmul_li_ul">
        <li class="btmul_li_ul_li1">
          <span class="btmul_li_ul_li1_sp1">头像</span>
          <img id="head_img" src="<%=doctorModel.getHeadPic()%>"/>
        </li>
        <li class="btmul_li_ul_li1">
          <span class="btmul_li_ul_li1_sp1">姓名</span>
          <span class="name_sp"><%=doctorModel.getName()%></span>
        </li>
        <li class="btmul_li_ul_li1">
          <span class="btmul_li_ul_li1_sp1">医生执业证号</span>
          <span class="name_sp"><%=doctorModel.getCertificateNumber()==null?"":doctorModel.getCertificateNumber()%></span>
        </li>
        <li class="btmul_li_ul_li1">
          <span class="btmul_li_ul_li1_sp1">职称</span>
          <span class="job_sp"><%=titleModel!=null?titleModel.getName():""%></span>
        </li>
        <li class="btmul_li_ul_li1">
          <span class="btmul_li_ul_li1_sp1">专长</span>
          <span class="specialty_sp">
            <%
              StringBuilder specSB=new StringBuilder();
              if(sickQueryModelList!=null) {
                for (int i = 0; i < sickQueryModelList.size(); i++) {
                  if (i > 0) {
                    specSB.append(" ");
                  }
                  JdSickQueryModel jdSickQueryModel = sickQueryModelList.get(i);
                  specSB.append(jdSickQueryModel.getName());
                }
              }
              out.print(specSB.toString());
            %>
          </span>
        </li>
        <li class="btmul_li_ul_li1">
          <span class="btmul_li_ul_li1_sp1">从业时间</span>
          <span class="starttime_sp">
            <%
              if(doctorModel.getStartDate()!=null){
                out.print(new SimpleDateFormat("yyyy-MM-dd").format(doctorModel.getStartDate()));
              }
            %>
          </span>
        </li>
        <li class="btmul_li_ul_li1">
          <span class="btmul_li_ul_li1_sp1">科室</span>
          <span class="room_sp"><%=departmentModel!=null?departmentModel.getName():""%></span>
        </li>
        <li class="btmul_li_ul_li1">
          <span class="btmul_li_ul_li1_sp1">所在医院</span>
          <span class="hospital_sp"><%=hospitalModel!=null?hospitalModel.getName():""%></span>
        </li>
      </ul>
    </li>
  </ul>
  <ul class="introul">
    <li class="introul_li0"><span>医生简介</span></li>
    <li class="introul_li1">
      <p class="introul_li1_p">
        <%=doctorModel.getDescription()==null?"":doctorModel.getDescription()%>
      </p>
    </li>
  </ul>
  <ul class="certificateul">
    <li class="certificateul_li0"><span>证书</span></li>
    <li class="certificateul_li1">
      <img src='<%=doctorModel!=null?doctorModel.getCertificateImage():""%>'/>
    </li>
  </ul>
</div>
<div id="editNameDiv">
  <ul>
    <li><input type="text" id="name_input" placeholder="请输入姓名" Maxlength="30"/></li>
    <li onClick="cancelbtn(1);">取消</li>
    <li onClick="submit1();">确定</li>
  </ul>
</div>
<div id="editJobCodeDiv">
  <ul>
    <li><input type="text" id="jobCode_input" placeholder="请输入医生执业号" Maxlength="80"/></li>
    <li onClick="cancelbtn(2);">取消</li>
    <li onClick="submit2();">确定</li>
  </ul>
</div>
<div id="JobDiv">
  <ul class="JobDiv_ul1">
    <li class="JobDiv_ul1_li0">职称</li>
    <li class="JobDiv_ul1_li1" alt="0" onClick="choose1(12,this);"><span>住院医师</span></li>
    <li class="JobDiv_ul1_li1" alt="0" onClick="choose1(12,this);"><span>主治医师</span></li>
    <li class="JobDiv_ul1_li1" alt="0" onClick="choose1(12,this);"><span>副主任医师</span></li>
    <li class="JobDiv_ul1_li1" alt="0" onClick="choose1(12,this);"><span>主任医师</span></li>
  </ul>
  <ul class="JobDiv_ul2">
    <li onClick="tocancel1();">取消</li>
    <li onClick="tosure1();">确定</li>
  </ul>
</div>
<div id="SpecialtyDiv">
  <ul class="SpecialtyDiv_ul1">
    <li class="SpecialtyDiv_ul1_li0">专长</li>
    <li class="SpecialtyDiv_ul1_li1" alt="0" onClick="choose2(12,this);"><span>感冒</span></li>
    <li class="SpecialtyDiv_ul1_li1" alt="0" onClick="choose2(12,this);"><span>发烧</span></li>
    <li class="SpecialtyDiv_ul1_li1" alt="0" onClick="choose2(12,this);"><span>手足</span></li>
  </ul>
  <ul class="SpecialtyDiv_ul2">
    <li onClick="tocancel2();">取消</li>
    <li onClick="tosure2();">确定</li>
  </ul>
</div>
<div id="StartTimeDiv">
  <ul class="StartTimeDiv_ul1">
    <li class="StartTimeDiv_ul1_li0">从业时间</li>
    <li class="StartTimeDiv_ul1_li1">
      <select id="year">
      </select><span>年</span>
    </li>
    <li class="StartTimeDiv_ul1_li1">
      <select id="month">
      </select><span>月</span>
    </li>
    <li class="StartTimeDiv_ul1_li1">
      <select id="day">
      </select><span>日</span>
    </li>
  </ul>
  <ul class="StartTimeDiv_ul2">
    <li onClick="tocancel3();">取消</li>
    <li onClick="tosure3();">确定</li>
  </ul>
</div>
<div id="RoomDiv">
  <ul class="RoomDiv_ul1">
    <li class="RoomDiv_ul1_li0">科室</li>
    <li class="RoomDiv_ul1_li1" alt="0" onClick="choose3(12,this);"><span>心内科</span></li>
    <li class="RoomDiv_ul1_li1" alt="0" onClick="choose3(12,this);"><span>心外科</span></li>
  </ul>
  <ul class="RoomDiv_ul2">
    <li onClick="tocancel4();">取消</li>
    <li onClick="tosure4();">确定</li>
  </ul>
</div>
<div id="HospitalDiv">
  <ul class="HospitalDiv_ul1">
    <li class="HospitalDiv_ul1_li0">所在医院</li>
    <li class="HospitalDiv_ul1_li1">
      <select id="province">
        <option value="广东省">广东省</option>
        <option value="湖南省">湖南省</option>
      </select>
    </li>
    <li class="HospitalDiv_ul1_li1">
      <select id="city">
        <option value="广州市">广州市</option>
        <option value="佛山市">佛山市</option>
      </select>
    </li>
    <li class="HospitalDiv_ul1_li1">
      <select id="district">
        <option value="海珠区">海珠区</option>
        <option value="天河区">天河区</option>
      </select>
    </li>
  </ul>
  <ul class="HospitalDiv_ul3">

  </ul>
  <ul class="HospitalDiv_ul2">
    <li onClick="tocancel5();">取消</li>
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

    $('.mainul1').width(mw);
    $('.mainul1_li1').width(mw*0.9).height(mh*0.05);
    $('.mainul1_li1 input').width(mw*0.9*0.85).height(mh*0.05);

    $('.btmul').width(mw);
    $('.btmul_li_ul_li1 img').height(mh*0.065);

    $('.certificateul_li1 img').height(mh*0.085);

    $('#mainDiv').show();
    $('#MsgBoxDiv').width(mw).height(mh);
    $('#MsgBoxDiv ul').width(mw*0.84).height(mh*0.26);
    $('#MsgBoxDiv ul li').eq(0).width(mw*0.84).height(mh*0.26*0.73);
    $('#MsgBoxDiv ul li').eq(1).width(mw*0.84).height(mh*0.26*0.27);
    $('#MsgBoxDiv ul li').eq(1).css('line-height',mh*0.26*0.27+'px');
    $('#msgcontp').css('margin-top',mh*0.26*0.3);
    $('#MsgBoxDiv ul').css('margin-top',mh*0.15);

    $('#editNameDiv').width(mw).height(mh);
    $('#editNameDiv li input').height(mh*0.065);
    $('#editNameDiv li').eq(1).height(mh*0.065);
    $('#editNameDiv li').eq(2).height(mh*0.065);
    $('#editNameDiv li').eq(1).css('line-height',mh*0.069+'px');
    $('#editNameDiv li').eq(2).css('line-height',mh*0.069+'px');
    $('#editNameDiv ul').css('margin-top',mh*0.08);

    $('#editJobCodeDiv').width(mw).height(mh);
    $('#editJobCodeDiv li input').height(mh*0.065);
    $('#editJobCodeDiv li').eq(1).height(mh*0.065);
    $('#editJobCodeDiv li').eq(2).height(mh*0.065);
    $('#editJobCodeDiv li').eq(1).css('line-height',mh*0.069+'px');
    $('#editJobCodeDiv li').eq(2).css('line-height',mh*0.069+'px');
    $('#editJobCodeDiv ul').css('margin-top',mh*0.08);

    $('#SpecialtyDiv').width(mw).height(mh);
    $('.SpecialtyDiv_ul1').width(mw);
    $('.SpecialtyDiv_ul1_li0').width(mw).height(mh*0.07);
    $('.SpecialtyDiv_ul1_li0').css('line-height',mh*0.07+'px');
    $('.SpecialtyDiv_ul2').width(mw*0.9);
    $('.SpecialtyDiv_ul2 li').width(mw*0.9*0.4).height(mh*0.065);
    $('.SpecialtyDiv_ul2 li').css('line-height',mh*0.065+'px');

    $('#JobDiv').width(mw).height(mh);
    $('.JobDiv_ul1').width(mw);
    $('.JobDiv_ul1_li0').width(mw).height(mh*0.07);
    $('.JobDiv_ul1_li0').css('line-height',mh*0.07+'px');
    $('.JobDiv_ul2').width(mw*0.9);
    $('.JobDiv_ul2 li').width(mw*0.9*0.4).height(mh*0.065);
    $('.JobDiv_ul2 li').css('line-height',mh*0.065+'px');

    $('#StartTimeDiv').width(mw).height(mh);
    $('.StartTimeDiv_ul1').width(mw);
    $('.StartTimeDiv_ul1_li1').width(mw/3).height(mh*0.06);
    $('.StartTimeDiv_ul1_li0').width(mw).height(mh*0.07);
    $('.StartTimeDiv_ul1_li0').css('line-height',mh*0.07+'px');
    $('.StartTimeDiv_ul2').width(mw*0.9);
    $('.StartTimeDiv_ul2 li').width(mw*0.9*0.4).height(mh*0.065);
    $('.StartTimeDiv_ul2 li').css('line-height',mh*0.065+'px');

    $('#HospitalDiv').width(mw).height(mh);
    $('.HospitalDiv_ul1').width(mw);
    $('.HospitalDiv_ul1_li1').width(mw/3).height(mh*0.06);
    $('.HospitalDiv_ul1_li0').width(mw).height(mh*0.07);
    $('.HospitalDiv_ul1_li0').css('line-height',mh*0.07+'px');
    $('.HospitalDiv_ul2').width(mw);
    $('.HospitalDiv_ul2 li').width(mw).height(mh*0.07);
    $('.HospitalDiv_ul2 li').css('line-height',mh*0.07+'px');

    $('#RoomDiv').width(mw).height(mh);
    $('.RoomDiv_ul1').width(mw);
    $('.RoomDiv_ul1_li0').width(mw).height(mh*0.07);
    $('.RoomDiv_ul1_li0').css('line-height',mh*0.07+'px');
    $('.RoomDiv_ul2').width(mw*0.9);
    $('.RoomDiv_ul2 li').width(mw*0.9*0.4).height(mh*0.065);
    $('.RoomDiv_ul2 li').css('line-height',mh*0.065+'px');

  }

  function editHead(){

  }
  function editName(){
    $('#editNameDiv').show();
  }
  function editJobCode(){
    $('#editJobCodeDiv').show();
  }
  function editJob(){
    $('#JobDiv').show();
  }
  function editSpecialty(){
    $('#SpecialtyDiv').show();
  }
  function editStartTime(){
    $('#StartTimeDiv').show();
  }
  function editRoom(){
    $('#RoomDiv').show();
  }
  function editHospital(){
    $('#HospitalDiv').show();
  }

  function cancelbtn(num){
    if(num==1){
      $('#name_input').val('');
      $('#editNameDiv').hide();
      return;
    }
    if(num==2){
      $('#jobCode_input').val('');
      $('#editJobCodeDiv').hide();
      return;
    }
  }
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
  }
  function choose2(num,ob){
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
  }
  function choose3(num,ob){
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
  }

  function tocancel1(){
    $('#JobDiv').hide();
  }
  function tosure1(){

  }
  function tocancel2(){
    $('#SpecialtyDiv').hide();
  }
  function tosure2(){

  }
  function tocancel3(){
    $('#StartTimeDiv').hide();
  }
  function tosure3(){

  }
  function tocancel4(){
    $('#RoomDiv').hide();
  }
  function tosure4(){

  }
  function tocancel5(){
    $('#HospitalDiv').hide();
  }

  var subflag1 = false;
  function submit1(){
    if(subflag1){
      return;
    }
    subflag1 = true;
    var addOrder_input = $('#addOrder_input').val();

  }

  var subflag2 = false;
  function submit2(){
    if(subflag2){
      return;
    }
    subflag2 = true;
    var cancel_input = $('#cancel_input').val();
  }
  function addPic(){
    var htmls0 = '<img src="../../wechat/images/2.jpg"/>';
    $('.certificateul_li1').prepend(htmls0);
    $('.certificateul_li1 img').eq(0).height(mh*0.085);
  }
  function jump(caseID){
    window.location.href = '你的域名?caseID='+caseID;
  }

  function editStarttime(){

  }

  function editMyInfo(){
    window.location.href="editMyInfo.htm";
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

  function isLeapYear(year){
    var pYear = year;
    if(!isNaN(parseInt(pYear))){
      if((pYear%4==0 && pYear%100!=0)||(pYear%100==0 && pYear%400==0)){
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }
</script>