<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="cn.aidee.jdoctor.model.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
  List<JdTitleQueryModel> titleQueryModelList=(List<JdTitleQueryModel>)request.getAttribute("titleQueryModelList");
  List<JdDepartmentQueryModel> departmentQueryModelList=(List<JdDepartmentQueryModel>)request.getAttribute("departmentQueryModelList");
  List<JdDistrictQueryModel> districtQueryModelList=(List<JdDistrictQueryModel>)request.getAttribute("districtQueryModelList");
  List<JdSickQueryModel> sickQueryModelList=(List<JdSickQueryModel>)request.getAttribute("sickQueryModelList");
  List<JdSickQueryModel> specSickQueryModelList=(List<JdSickQueryModel>)request.getAttribute("specSickQueryModelList");
  JdDoctorModel doctorModel=(JdDoctorModel)request.getAttribute("doctorModel");
  JdTitleModel titleModel=(JdTitleModel)request.getAttribute("titleModel");
  JdDepartmentModel departmentModel=(JdDepartmentModel)request.getAttribute("departmentModel");
  JdHospitalModel hospitalModel=(JdHospitalModel)request.getAttribute("hospitalModel");
  JdDistrictModel districtModel=(JdDistrictModel)request.getAttribute("districtModel");
  String wxconfig = (String)request.getAttribute("wxconfig");
%>
<!DOCTYPE html>
<html>
<head>
  <jsp:include page="../include/head.jsp" />
  <script src="../../wechat/js/jquery.calendar.js"></script>
  <script src="../../wechat/js/ajaxfileupload.js"></script>
  <script src="../../wechat/js/weixin.js" type="text/javascript"></script>
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

    #mainDiv .btmul{width:100%;overflow:hidden;padding:0 0 1.5em 0;}
    #mainDiv .btmul .btmul_li{width:100%;float:left;background:#FFFFFF;}
    #mainDiv .btmul .btmul_li ul{width:100%;overflow:hidden;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li0{width:100%;overflow:hidden;float:left;padding:1.2em 0 1.2em 0;background:#F2F2F2;text-align:center;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li0 img{width:93%;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li1{width:100%;border-bottom:#F1F1F1 0.125em solid;-webkit-border-bottom:#F1F1F1 0.125em solid;padding:1.6em 0 1.6em 0;float:left;background:url(../../wechat/images/icon6.png) center right no-repeat #FFFFFF;background-size:auto 58%;float:left;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li1 p:nth-child(1){float:left;padding:0.2em 0 0.2em 0;margin-left:2%;font-size:1.55em;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li1 p:nth-child(2){float:right;padding:0.2em 0 0.2em 0;padding-right:50px;margin-left:2%;font-size:1.55em;}

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
    #editNameDiv ul li:nth-child(2){width:49%;float:left;font-size:1.5em;border:#F0F0F0 0.07em solid;-webkit-border:#F0F0F0 0.07em solid;}
    #editNameDiv ul li:nth-child(3){width:49%;float:right;font-size:1.5em;border:#F0F0F0 0.07em solid;-webkit-border:#F0F0F0 0.07em solid;}

    #editJobCodeDiv{width:100%;position:absolute;left:0;top:0;z-index:100000;display:none;background:rgba(0,0,0,0.5);}
    #editJobCodeDiv ul{width:90%;overflow:hidden;margin-left:5%;margin-top:5%;background:#FFFFFF;border-radius:0.15em;-webkit-border-radius:0.15em;}
    #editJobCodeDiv ul li{float:left;text-align:center;}
    #editJobCodeDiv ul li:nth-child(1){width:100%;float:left;padding:3.3em 0 2.6em 0;}
    #editJobCodeDiv ul li:nth-child(1) input{width:90%;border-radius:0.2em;-webkit-border-radius:0.2em;font-size:1.55em;padding:0.1em;border:#E6E6E6 0.11em solid;-webkit-border:#E6E6E6 0.11em solid;}
    #editJobCodeDiv ul li:nth-child(2){width:49%;float:left;font-size:1.5em;border:#F0F0F0 0.07em solid;-webkit-border:#F0F0F0 0.07em solid;}
    #editJobCodeDiv ul li:nth-child(3){width:49%;float:right;font-size:1.5em;border:#F0F0F0 0.07em solid;-webkit-border:#F0F0F0 0.07em solid;}

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

    #UploadImageDiv{width:100%;height:100%;position:absolute;left:0;top:0;z-index:1000000;display:none;background:#F2F2F2;overflow-y:auto;}

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
    #HospitalDiv .HospitalDiv_ul1{width:100%;overflow:hidden;background:#FB9D3B;}
    #HospitalDiv .HospitalDiv_ul1 li{height:100%;float:left;}
    #HospitalDiv .HospitalDiv_ul1 .HospitalDiv_ul1_li0{width:50%;text-align:center;font-size:2em;color:#FFFFFF;}
    #HospitalDiv .HospitalDiv_ul1 .HospitalDiv_ul1_li{width:25%;font-size:1.6em;color:#FFFFFF;text-align:center;}

    #HospitalDiv .cityul{width:100%;overflow:hidden;position:absolute;left:0;top:0;z-index:1000000;display:none;}
    #HospitalDiv .cityul li{width:33%;float:left;font-size:1.55em;color:#000000;padding:1.75em 0 1.75em 0;text-align:center;background:#FFFFFF;}

    #HospitalDiv .HospitalDiv_ul2{width:100%;overflow:hidden;margin-top:8%;position:fixed;left:0;bottom:0;}
    #HospitalDiv .HospitalDiv_ul2 li{width:100%;float:left;}
    #HospitalDiv .HospitalDiv_ul2 li:nth-child(1){width:40%;background:#FB9D3B;text-align:center;font-size:1.6em;color:#FFFFFF;float:left;}
    #HospitalDiv .HospitalDiv_ul3{width:100%;overflow:hidden;margin-top:1%;margin-bottom: 80px;}
    #HospitalDiv .HospitalDiv_ul3 li{width:100%;background:#FFFFFF;padding:1.2em 0 4.5em 0;float:left;border-bottom:#F2F2F2 0.11em solid;-webkit-border-bottom:#F2F2F2 0.11em solid;}
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
    <a href="javascript:history.back();"><li></li></a>
    <li>填写个人信息</li>
    <li><a onClick="next();">下一步</a></li>
  </ul>
  <ul class="btmul">
    <li class="btmul_li">
      <ul class="btmul_li_ul">
        <li class="btmul_li_ul_li0">

        </li>
        <li class="btmul_li_ul_li1" onClick="editHead();">
          <p>头像<font style="color:#A4A4A4;"></font></p>
          <p><img src='<%=doctorModel!=null?doctorModel.getHeadPic():""%>' id="infoImage" style="width:48px;height:48px;"/></p>
        </li>
        <li class="btmul_li_ul_li1" onClick="editName();">
          <p class="btmul_li_ul_li1_p1">姓名</p>
          <p class="btmul_li_ul_li1_p1" id="name_input_label"><%=doctorModel!=null?doctorModel.getName():""%></p>
        </li>
        <li class="btmul_li_ul_li1" onClick="editJobCode();">
          <p class="btmul_li_ul_li1_p1">医生执业证号</p>
          <p class="btmul_li_ul_li1_p1" id="jobCode_input_label"><%=doctorModel!=null &&doctorModel.getCertificateNumber()!=null?doctorModel.getCertificateNumber():""%></p>
        </li>
        <li class="btmul_li_ul_li1" onClick="editJob();">
          <p class="btmul_li_ul_li1_p1">职称</p>
          <p class="btmul_li_ul_li1_p1" id="title_label"><%=titleModel!=null?titleModel.getName():""%></p>
        </li>
        <li class="btmul_li_ul_li1" onClick="editSpecialty();">
          <p class="btmul_li_ul_li1_p1">专长</p>
          <p class="btmul_li_ul_li1_p1" id="Spec_label">
            <%
              StringBuilder specSB=new StringBuilder();
              for(int i=0;i<specSickQueryModelList.size();i++){
                if(i>0){
                  specSB.append(" ");
                }
                specSB.append(specSickQueryModelList.get(i).getName());
              }
              out.print(specSB.toString());
            %>
          </p>
        </li>
        <li class="btmul_li_ul_li1" onClick="editStartTime();">
          <p class="btmul_li_ul_li1_p1">从业时间</p>
          <p class="btmul_li_ul_li1_p1" id="starttime_label"><%=doctorModel.getStartDate()==null?"":new SimpleDateFormat("yyyy-MM").format(doctorModel.getStartDate())%></p>
        </li>
        <li class="btmul_li_ul_li1" onClick="editRoom();">
          <p class="btmul_li_ul_li1_p1">科室</p>
          <p class="btmul_li_ul_li1_p1" id="department_label"><%=departmentModel!=null?departmentModel.getName():""%></p>
        </li>
        <li class="btmul_li_ul_li1" onClick="editHospital();">
          <p class="btmul_li_ul_li1_p1">所在医院</p>
          <p class="btmul_li_ul_li1_p1" id="hospital_label"><%=hospitalModel!=null?hospitalModel.getName():""%></p>
        </li>
      </ul>
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
    <%
      for(int i=0;i<titleQueryModelList.size();i++){
        JdTitleQueryModel jdTitleQueryModel=titleQueryModelList.get(i);
    %>
    <li class="JobDiv_ul1_li1" alt="0" onClick="choose1('<%=jdTitleQueryModel.getUuid()%>',this);">
      <span><%=jdTitleQueryModel.getName()%></span></li>
    <%
      }
    %>
  </ul>
  <ul class="JobDiv_ul2">
    <li onClick="tocancel1();">取消</li>
    <li onClick="tosure1();">确定</li>
  </ul>
</div>
<div id="SpecialtyDiv">
  <ul class="SpecialtyDiv_ul1">
    <li class="SpecialtyDiv_ul1_li0">专长</li>
    <%
      for(int i=0;i<sickQueryModelList.size();i++){
        JdSickQueryModel sickQueryModel=sickQueryModelList.get(i);
    %>
    <li class="SpecialtyDiv_ul1_li1" alt="0" onClick="choose2('<%=sickQueryModel.getUuid()%>',this);"><span><%=sickQueryModel.getName()%></span></li>
    <%
      }
    %>
  </ul>
  <ul class="SpecialtyDiv_ul2">
    <li onClick="tocancel2();">取消</li>
    <li onClick="tosure2();">确定</li>
  </ul>
</div>
<div id="UploadImageDiv">
  <form method="post" enctype="multipart/form-data" action="uploadInfoImage.htm">
      <input type="file" name="image" id="image" style="width:100px;height:50px;"/>
      <input type="button" value="上传" style="width:100px;height:50px;" onclick="ajaxFileUpload();"/>
      <input type="button" onclick="$('#UploadImageDiv').hide()" value="关闭" style="width:100px;height:50px;">
  </form>
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
  </ul>
  <ul class="StartTimeDiv_ul2">
    <li onClick="tocancel3();">取消</li>
    <li onClick="tosure3();">确定</li>
  </ul>
</div>
<div id="RoomDiv">
  <ul class="RoomDiv_ul1">
    <li class="RoomDiv_ul1_li0">科室</li>
    <%
      for(int i=0;i<departmentQueryModelList.size();i++){
        JdDepartmentQueryModel departmentQueryModel=departmentQueryModelList.get(i);
    %>
    <li class="RoomDiv_ul1_li1" alt="0" onClick="choose3('<%=departmentQueryModel.getUuid()%>',this);">
      <span><%=departmentQueryModel.getName()%></span></li>
    <%
      }
    %>
  </ul>
  <ul class="RoomDiv_ul2">
    <li onClick="tocancel4();">取消</li>
    <li onClick="tosure4();">确定</li>
  </ul>
</div>
<div id="HospitalDiv">
  <ul class="HospitalDiv_ul1">
    <li class="HospitalDiv_ul1_li"></li>
    <li class="HospitalDiv_ul1_li0">所在医院</li>
    <li class="HospitalDiv_ul1_li" id="chooseCityName" onClick="chooseCity();">
      <%
        if(districtModel!=null){
          out.print(districtModel.getName()+" v");
        }else{
          out.print(districtQueryModelList.get(0).getName()+" v");
        }
      %>
    </li>
  </ul>

  <ul class="cityul">
    <%
      for(int i=0;i<districtQueryModelList.size();i++){
        JdDistrictQueryModel  districtQueryModel=districtQueryModelList.get(i);
        out.print("<li onClick=\"searchByCity("+i+",'");
        out.print(districtQueryModel.getUuid());
        out.print("','"+districtQueryModel.getName()+"')\" ");
        if(districtModel!=null){
          if(districtModel.getUuid().equals(districtQueryModel.getUuid())) {
            out.print("style='color:#DF0101;'");
          }
        }else if(i==0){
          out.print("style='color:#DF0101;'");
        }
        out.print(">");
    %>
     <%=districtQueryModel.getName()%></li>
    <%
      }
    %>
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
  window.onload = function() {
    $('#mainDiv').width(mw);
    $('.top_ul').width(mw).height(mh * 0.07);
    $('.top_ul li').height(mh * 0.07);
    $('.top_ul li').css('line-height', mh * 0.07 + 'px');

    $('.mainul1').width(mw);
    $('.mainul1_li1').width(mw * 0.9).height(mh * 0.05);
    $('.mainul1_li1 input').width(mw * 0.9 * 0.85).height(mh * 0.05);

    $('.btmul').width(mw);

    $('#mainDiv').show();
    $('#MsgBoxDiv').width(mw).height(mh);
    $('#MsgBoxDiv ul').width(mw * 0.84).height(mh * 0.26);
    $('#MsgBoxDiv ul li').eq(0).width(mw * 0.84).height(mh * 0.26 * 0.73);
    $('#MsgBoxDiv ul li').eq(1).width(mw * 0.84).height(mh * 0.26 * 0.27);
    $('#MsgBoxDiv ul li').eq(1).css('line-height', mh * 0.26 * 0.27 + 'px');
    $('#msgcontp').css('margin-top', mh * 0.26 * 0.3);
    $('#MsgBoxDiv ul').css('margin-top', mh * 0.15);

    $('#editNameDiv').width(mw).height(mh);
    $('#editNameDiv li input').height(mh * 0.065);
    $('#editNameDiv li').eq(1).height(mh * 0.065);
    $('#editNameDiv li').eq(2).height(mh * 0.065);
    $('#editNameDiv li').eq(1).css('line-height', mh * 0.069 + 'px');
    $('#editNameDiv li').eq(2).css('line-height', mh * 0.069 + 'px');
    $('#editNameDiv ul').css('margin-top', mh * 0.08);

    $('#editJobCodeDiv').width(mw).height(mh);
    $('#editJobCodeDiv li input').height(mh * 0.065);
    $('#editJobCodeDiv li').eq(1).height(mh * 0.065);
    $('#editJobCodeDiv li').eq(2).height(mh * 0.065);
    $('#editJobCodeDiv li').eq(1).css('line-height', mh * 0.069 + 'px');
    $('#editJobCodeDiv li').eq(2).css('line-height', mh * 0.069 + 'px');
    $('#editJobCodeDiv ul').css('margin-top', mh * 0.08);

    $('#SpecialtyDiv').width(mw).height(mh);
    $('.SpecialtyDiv_ul1').width(mw);
    $('.SpecialtyDiv_ul1_li0').width(mw).height(mh * 0.07);
    $('.SpecialtyDiv_ul1_li0').css('line-height', mh * 0.07 + 'px');
    $('.SpecialtyDiv_ul2').width(mw * 0.9);
    $('.SpecialtyDiv_ul2 li').width(mw * 0.9 * 0.4).height(mh * 0.065);
    $('.SpecialtyDiv_ul2 li').css('line-height', mh * 0.065 + 'px');

    $('#JobDiv').width(mw).height(mh);
    $('.JobDiv_ul1').width(mw);
    $('.JobDiv_ul1_li0').width(mw).height(mh * 0.07);
    $('.JobDiv_ul1_li0').css('line-height', mh * 0.07 + 'px');
    $('.JobDiv_ul2').width(mw * 0.9);
    $('.JobDiv_ul2 li').width(mw * 0.9 * 0.4).height(mh * 0.065);
    $('.JobDiv_ul2 li').css('line-height', mh * 0.065 + 'px');

    $('#StartTimeDiv').width(mw).height(mh);
    $('.StartTimeDiv_ul1').width(mw);
    $('.StartTimeDiv_ul1_li1').width(mw / 3).height(mh * 0.06);
    $('.StartTimeDiv_ul1_li0').width(mw).height(mh * 0.07);
    $('.StartTimeDiv_ul1_li0').css('line-height', mh * 0.07 + 'px');
    $('.StartTimeDiv_ul2').width(mw * 0.9);
    $('.StartTimeDiv_ul2 li').width(mw * 0.9 * 0.4).height(mh * 0.065);
    $('.StartTimeDiv_ul2 li').css('line-height', mh * 0.065 + 'px');

    $('#HospitalDiv').width(mw).height(mh);
    $('.HospitalDiv_ul1').width(mw);
    $('.HospitalDiv_ul1_li').width(mw*0.25).height(mh*0.07);
    $('.HospitalDiv_ul1_li0').width(mw*0.5).height(mh*0.07);
    $('.HospitalDiv_ul1_li0').css('line-height',mh*0.07+'px');
    $('.HospitalDiv_ul1_li').css('line-height',mh*0.07+'px');
    $('.HospitalDiv_ul2').width(mw);
    $('.HospitalDiv_ul2 li').width(mw).height(mh*0.07);
    $('.HospitalDiv_ul2 li').css('line-height',mh*0.07+'px');
    $('.cityul').css({left:0,top:mh*0.07});

    $('#RoomDiv').width(mw).height(mh);
    $('.RoomDiv_ul1').width(mw);
    $('.RoomDiv_ul1_li0').width(mw).height(mh * 0.07);
    $('.RoomDiv_ul1_li0').css('line-height', mh * 0.07 + 'px');
    $('.RoomDiv_ul2').width(mw * 0.9);
    $('.RoomDiv_ul2 li').width(mw * 0.9 * 0.4).height(mh * 0.065);
    $('.RoomDiv_ul2 li').css('line-height', mh * 0.065 + 'px');

    var wxconfig = <%=wxconfig%>;
    wx.config({
      debug: false,
      appId: wxconfig.appId,
      timestamp: wxconfig.timestamp,
      nonceStr: wxconfig.nonceStr,
      signature: wxconfig.signature,
      jsApiList: ['chooseImage','uploadImage']
    });

    $("#province").change(function () {
      var value = $("#province").val();
      district_id=value;
      $.ajax({
        type: 'GET',
        url: '../../rest/jdHospital/search?jd_district_id=' + value,
        dataType: 'json',
        success: function (msg) {
          // var msged = eval('('+msg+')');
          var list = msg.hospitalList;
          var hospitalDiv = $(".HospitalDiv_ul3");
          $(".HospitalDiv_ul3_li").each(function () {
            $(this).remove();
          });
          for (var i = 0; i < list.length; i++) {
            var hospital = list[i];
            var html = "<li class='HospitalDiv_ul3_li' onclick=\"hospitalchoose" +
                    "('" +hospital.uuid+"','"+hospital.name+"'"+
                    ")\"><p class='HospitalDiv_ul3_li_p1'>"+hospital.name+
                    "<font style='color:#2882D8;'></font></p>";
            html=html+"<p class='HospitalDiv_ul3_li_p2'>"+hospital.address+"</p></li>"
            hospitalDiv.append(html);
          }
        },
        timeout: 10000,
        error: function () {
          var msg = '查询失败，请检查网络';
          var btnword = '确定';
          MsgOpt.showMsgBox(msg, btnword);
          return;
        }
      });
    });
  }


  function searchByCity(num,districtUUID,districtName){
    $(".cityul li").attr("style","");
    $(".cityul li").eq(num).attr("style","color:#DF0101;");
    district_id=districtUUID;
    $.ajax({
      type: 'GET',
      url: '../../rest/jdHospital/search?jd_district_id=' + districtUUID,
      dataType: 'json',
      success: function (msg) {
        var list = msg.hospitalList;
        var hospitalDiv = $(".HospitalDiv_ul3");
        $(".HospitalDiv_ul3_li").each(function () {
          $(this).remove();
        });
        for (var i = 0; i < list.length; i++) {
          var hospital = list[i];
          var html = "<li class='HospitalDiv_ul3_li' onclick=\"hospitalchoose" +
                  "('" +hospital.uuid+"','"+hospital.name+"'"+
                  ")\"><p class='HospitalDiv_ul3_li_p1'>"+hospital.name+
                  "<font style='color:#2882D8;'></font></p>";
          html=html+"<p class='HospitalDiv_ul3_li_p2'>"+hospital.address+"</p></li>"
          hospitalDiv.append(html);
        }
        $('.cityul').hide();
        $("#chooseCityName").html(districtName+" v");
      },
      timeout: 10000,
      error: function () {
        var msg = '查询失败，请检查网络';
        var btnword = '确定';
        MsgOpt.showMsgBox(msg, btnword);
        return;
      }
    });
  }

    var pre_title_label;
    var pre_title_id;
    var title_label;
    var title_id='<%=titleModel!=null?titleModel.getUuid():""%>';

    var pre_department_id;
    var pre_department_label;
    var department_id='<%=departmentModel!=null?departmentModel.getUuid():""%>';
    var department_label;

    var hospital_id='<%=hospitalModel!=null?hospitalModel.getUuid():""%>';
    var hospital_label;

    var district_id='<%=doctorModel!=null?doctorModel.getJdDistrictId():""%>';

    function editHead() {
      //$('#UploadImageDiv').show();
      wx.chooseImage({
        count: 1,
        success: function (res) {
          var localIds = res.localIds; // 返回选定照片的本地ID列表，localId可以作为img标签的src属性显示图片
          wx.uploadImage({
            localId:localIds[0], // 需要上传的图片的本地ID，由chooseImage接口获得
            isShowProgressTips: 1, // 默认为1，显示进度提示
            success: function (res) {
              var serverId = res.serverId; // 返回图片的服务器端ID
              var data="serverId="+serverId;
              $.ajax({
                type: 'GET',
                url: "getInfoImage.htm",
                data:data,
                dataType:'text',
                success: function (msg) {
                    $("#infoImage").attr("src",msg);
                },
                timeout: 20000,
                error: function () {
                  MsgOpt.showMsgBox("出错了","确定");
                  return;
                }
              });

            }
          });
        }
      });
    }

    function editName() {
      $("#name_input").val($("#name_input_label").html());
      $('#editNameDiv').show();
    }

    function editJobCode() {
      $("#jobCode_input").val($("#jobCode_input_label").html());
      $('#editJobCodeDiv').show();
    }

    function editJob() {
      pre_title_label = title_label;
      pre_title_id = title_id;
      $('#JobDiv').show();
    }

    var temp_spec_id={};
    var temp_spec_name={};
    function editSpecialty() {
      temp_spec_id={};
      temp_spec_name={};
      $('#SpecialtyDiv').show();
    }

    function editStartTime() {
      $('#StartTimeDiv').show();
    }

    function editRoom() {
      $('#RoomDiv').show();
    }

    function editHospital() {
      $('#HospitalDiv').show();
    }

    function cancelbtn(num) {
      if (num == 1) {
        $('#name_input').val('');
        $('#editNameDiv').hide();
        return;
      }
      if (num == 2) {
        $('#jobCode_input').val('');
        $('#editJobCodeDiv').hide();
        return;
      }
    }

    function choose1(num, ob) {
      var elements=$(".JobDiv_ul1_li1");
      elements.css('background-image', 'url(../../wechat/images/icon11.png)');
      elements.find('span').css('color', '#000000');
      elements.attr('alt', 0);

      var alt = $(ob).attr('alt');
      if (alt == 0) {
        $(ob).css('background-image', 'url(../../wechat/images/icon10.png)');
        $(ob).find('span').css('color', '#FB9D3B');
        $(ob).attr('alt', 1);
      } else {
        $(ob).css('background-image', 'url(../../wechat/images/icon11.png)');
        $(ob).find('span').css('color', '#000000');
        $(ob).attr('alt', 0);
      }
      pre_title_id = num;
      pre_title_label = $(ob).children()[0].innerHTML;
    }

    var spec_id={
      <%
         for(int i=0;i<specSickQueryModelList.size();i++){
            JdSickQueryModel sickQueryModel=specSickQueryModelList.get(i);
            if(i>0){
               out.print(",");
            }
            out.print("'"+sickQueryModel.getUuid()+"':'"+sickQueryModel.getUuid()+"'");
         }
      %>
    };
    var spec_name={
      <%
        for(int i=0;i<specSickQueryModelList.size();i++){
           JdSickQueryModel sickQueryModel=specSickQueryModelList.get(i);
           if(i>0){
              out.print(",");
           }
           out.print("'"+sickQueryModel.getUuid()+"':'"+sickQueryModel.getName()+"'");
        }
     %>
    };
    function choose2(num, ob) {
      var alt = $(ob).attr('alt');
      if (alt == 0) {
        temp_spec_id[num] = num;
        temp_spec_name[num] = $(ob).children()[0].innerHTML;
        $(ob).css('background-image', 'url(../../wechat/images/icon10.png)');
        $(ob).find('span').css('color', '#FB9D3B');
        $(ob).attr('alt', 1);
      } else {
        $(ob).css('background-image', 'url(../../wechat/images/icon11.png)');
        $(ob).find('span').css('color', '#000000');
        $(ob).attr('alt', 0);
        temp_spec_id[num] = null;
        temp_spec_name[num] = null;
      }
    }

    function choose3(num, ob) {
      var alt = $(ob).attr('alt');
      if (alt == 0) {
        $(ob).css('background-image', 'url(../../wechat/images/icon10.png)');
        $(ob).find('span').css('color', '#FB9D3B');
        $(ob).attr('alt', 1);
      } else {
        $(ob).css('background-image', 'url(../../wechat/images/icon11.png)');
        $(ob).find('span').css('color', '#000000');
        $(ob).attr('alt', 0);
      }
      pre_department_id = num;
      pre_department_label = $(ob).children()[0].innerHTML;
    }

    function hospitalchoose(uuid, name) {
      hospital_id = uuid;
      hospital_label = name;
      $("#hospital_label").html(hospital_label);
      $('#HospitalDiv').hide();
      $('.cityul').hide();
    }

    function tocancel1() {
      $('#JobDiv').hide();
    }

   function tosure1() {
      $("#title_label").html(pre_title_label);
      title_label = pre_title_label;
      title_id = pre_title_id;
      $('#JobDiv').hide();
    }

    function tocancel2() {
      $('#SpecialtyDiv').hide();
    }

    function tosure2() {
      var value="";
      spec_id={};
      spec_name={};
      for(var k in temp_spec_id){
        spec_id[k]=temp_spec_id[k];
      }
      for(var k in temp_spec_name){
        spec_name[k]=temp_spec_name[k];
      }
      for(var k in spec_name){
        if(spec_name[k]!=null) {
          value = value + " " + spec_name[k];
        }
      }
      $("#Spec_label").html(value);
      $('#SpecialtyDiv').hide();
    }

    function tocancel3() {
      $('#StartTimeDiv').hide();
    }

    function tosure3() {
      var year = $("#year").val();
      var month = $("#month").val();
      //var day = $("#day").val();
      var time = year + "-" + month
      $("#starttime_label").html(time);
      $('#StartTimeDiv').hide();
    }

    function tocancel4() {
      $('#RoomDiv').hide();
    }

    function tosure4() {
      department_id = pre_department_id;
      department_label = pre_department_label;
      $("#department_label").html(department_label);
      $('#RoomDiv').hide();
    }

    function tocancel5() {
      $('#HospitalDiv').hide();
    }

    function submit1() {
      var name_input = $('#name_input').val();
      $("#name_input_label").html(name_input);
      $('#editNameDiv').hide();
    }

    function submit2() {
      var jobcode_input = $("#jobCode_input").val();
      $("#jobCode_input_label").html(jobcode_input);
      $('#editJobCodeDiv').hide();
    }

    function next() {
     // window.location.href = '你的域名?caseID=' + caseID;
      var name=$("#name_input_label").html();
      if(name==null ||name.length<=0){
        MsgOpt.showMsgBox("姓名必须填写");
        return;
      }

      var jobcode=$("#jobCode_input_label").html();
      if(jobcode==null || jobcode.length<=0){
        MsgOpt.showMsgBox("医生执业证号必须填写");
        return;
      }

      var title=$("#title_label").html();
      if(title==null ||title.length<=0){
        MsgOpt.showMsgBox("职称必须填写");
        return;
      }

      var spec=$("#Spec_label").html();
      if(spec==null ||spec.length<=0){
        MsgOpt.showMsgBox("专长必须填写");
        return;
      }

      var starttime=$("#starttime_label").html();
      if(starttime==null ||starttime.length<=0){
        MsgOpt.showMsgBox("从业时间必须填写");
        return;
      }

      var department=$("#department_label").html();
      if(department==null ||department.length<=0){
        MsgOpt.showMsgBox("科室必须填写");
        return;
      }

      var hospital=$("#hospital_label").html();
      if(hospital==null ||hospital.length<=0){
        MsgOpt.showMsgBox("所在医院必须填写");
        return;
      }

      var count=0;
      for(var k in spec_id){
        if(spec_id[k]!=null){
           count++;
        }
      }
      if(count==0){
        MsgOpt.showMsgBox("专长必须填写");
        return;
      }


      var data="name="+name+"&jobcode="+jobcode+"&title="+title_id+"&district_id="+district_id+
                      "&starttime="+starttime+"&department="+department_id+"&hospital="+hospital_id+
                      "&uuid=<%=doctorModel!=null?doctorModel.getUuid():""%>"+"&headPic="+$("#infoImage").attr("src");
      data=data+"&spec_count="+count;
      var index=0;
      for(var k in spec_id){
        var v=spec_id[k];
        if(v!=null){
            data=data+"&spec_uuid_"+index+"="+v;
            index++;
        }
      }
      $.ajax({
        type: 'POST',
        url: 'saveMyInfo1.htm',
        dataType: 'json',
        data:data,
        success: function (msg) {
          if(msg.result==1){
            window.location.href="fillMyInfo2.htm";
          }else if(msg.result==3){
            window.location.href="toLogin.htm";
          }
        },
        timeout: 10000,
        error: function () {
          var msg = '失败，请检查网络';
          var btnword = '确定';
          MsgOpt.showMsgBox(msg, btnword);
          return;
        }
      });
    }

    function editStarttime() {

    }

  var chooseflag = false;
  function chooseCity(){
    if(chooseflag){
      chooseflag = false;
      $('.cityul').hide();
    }else{
      chooseflag = true;
      $('.cityul').show();
    }
  }

    //消息弹窗类
    var MsgOpt = {
      msgt: null,
      showMsgBox: function (msg, btnword) {
        var mythis = this;
        $('#msgcontp').html(msg);
        $('#btnli').html(btnword);
        $('#MsgBoxDiv').fadeIn(200);
        mythis.msgt = setTimeout(function (){
          MsgOpt.hideMsgBox();
        }, 5000);
      },
      hideMsgBox: function () {
        var mythis = this;
        clearTimeout(mythis.msgt);
        $('#MsgBoxDiv').fadeOut(400);
        $('#msgcontp').html('');
        $('#btnli').html('');
      }
    };
    $(document).ready(function () {
      var myDate = new Date();
      $("#editStarttime").DateSelector({
        ctlYearId: 'year',
        ctlMonthId: 'month',
        ctlDayId: 'day',
        defYear: myDate.getFullYear(),
        defMonth: (myDate.getMonth() + 1),
        defDay: myDate.getDate(),
        minYear: 1960,
        maxYear: (myDate.getFullYear() + 1)
      });
    });

    function isLeapYear(year) {
      var pYear = year;
      if (!isNaN(parseInt(pYear))) {
        if ((pYear % 4 == 0 && pYear % 100 != 0) || (pYear % 100 == 0 && pYear % 400 == 0)) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    }
</script>