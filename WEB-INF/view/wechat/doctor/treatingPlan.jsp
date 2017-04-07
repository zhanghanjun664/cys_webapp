<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

    #mainDiv .dateul{width:100%;overflow:hidden;margin-top:1.5em;}
    #mainDiv .dateul li{float:left;padding:1.3em 0 1.3em 0;text-align:center;}
    #mainDiv .dateul .dateul_li1{font-size:1.75em;color:#2882D8;}
    #mainDiv .dateul li input[type="button"]{text-align:center;font-size:1.5em;background:#FB9D3B;border:0;color:#FFFFFF;border-radius:0.2em;-webkit-border-radius:0.2em;}
    #mainDiv .dateul li div{text-align:center;font-size:1.5em;background:#FB9D3B;border:0;color:#FFFFFF;border-radius:0.2em;-webkit-border-radius:0.2em;}

    #mainDiv .timeul1{width:100%;overflow:hidden;margin-top:0.5em;}
    #mainDiv .timeul1 li{float:left;background:#FFFFFF;padding:1.3em 0 1.3em 0;}
    #mainDiv .timeul1 li .timeul1p1{width:100%;text-align:center;font-size:1.5em;color:#FB9D3B;border-bottom:#F2F2F2 0.03em solid;padding-bottom:0.2em;}
    #mainDiv .timeul1 li .timeul1p2{width:100%;text-align:center;font-size:1.5em;color:#FB9D3B;}

    #mainDiv .wordsDiv{width:100%;padding:1.6em 0 0.6em 0;}
    #mainDiv .wordsDiv span{font-size:1.5em;margin-left:2%;}

    #mainDiv .timepointul{width:100%;overflow:hidden;background:#FFFFFF;padding:1.5em 0 6em 0;}
    #mainDiv .timepointul li{width:43%;margin-bottom:0.35em;float:left;text-align:center;background:#FFFFFF;border-radius:0.15em;-webkit-border-radius:0.15em;border:#A4A4A4 0.05em solid;-webkit-border:#A4A4A4 0.05em solid;}
    #mainDiv .timepointul .tpchoosed{background:url(../../wechat/images/icon23.png) center right no-repeat #EDF6FF;background-size:15% auto;}
    #mainDiv .timepointul .gray{background-color:#D8D8D8}

    #mainDiv .timepointul .timepointul_li1{margin-left:3%;margin-bottom:0.3em;float:left;padding:0.93em 0.3em 0.93em 0.3em;font-size:1.5em;}
    #mainDiv .timepointul .timepointul_li2{margin-right:3%;margin-bottom:0.3em;float:right;padding:0.93em 0.3em 0.93em 0.3em;font-size:1.5em;}

    #MsgBoxDiv{width:100%;height:100%;position:fixed;left:0;top:0;z-index:1000000;display:none;}
    #MsgBoxDiv ul{width:84%;overflow:hidden;margin-left:8%;background:rgba(0,0,0,0.65);border-radius:0.2em;-webkit-border-radius:0.2em;}
    #MsgBoxDiv ul li{width:100%;overflow:hidden;text-align:center;}
    #MsgBoxDiv ul li:nth-child(1) p{width:100%;text-align:center;font-size:1.75em;color:#FFFFFF;}
    #MsgBoxDiv ul li:nth-child(2){border-top:#FFFFFF 0.04em solid;-webkit-border-top:#FFFFFF 0.04em solid;font-size:1.88em;color:#FFFFFF;}
  </style>
</head>
<body>
<div id="mainDiv">
  <ul class="top_ul">
    <a href="javascript:history.back();"><li></li></a>
    <li>出诊安排</li>
    <li><a onClick="submitTime();">提交</a></li>
  </ul>
  <ul class="dateul">
    <li class="dateul_li1">2015-03-05</li>
    <li class="dateul_li2">
      <div onClick="prevWeek();">上一周</div>
    </li>
    <li class="dateul_li3">
      <div onClick="nextWeek();">下一周</div>
    </li>
  </ul>
  <ul class="timeul1">
    <li onClick="changeDate(0,this);" year="2015" month="5" day="8">
      <p class="timeul1p1">周日</p>
      <p class="timeul1p2" id="week0">8</p>
    </li>
    <li onClick="changeDate(1,this);" year="2015" month="5" day="9">
      <p class="timeul1p1">周一</p>
      <p class="timeul1p2" id="week1">9</p>
    </li>
    <li onClick="changeDate(2,this);" year="2015" month="5" day="10">
      <p class="timeul1p1">周二</p>
      <p class="timeul1p2" id="week2">10</p>
    </li>
    <li onClick="changeDate(3,this);" year="2015" month="5" day="11">
      <p class="timeul1p1">周三</p>
      <p class="timeul1p2" id="week3">11</p>
    </li>
    <li onClick="changeDate(4,this);" year="2015" month="5" day="12">
      <p class="timeul1p1">周四</p>
      <p class="timeul1p2" id="week4">12</p>
    </li>
    <li onClick="changeDate(5,this);" year="2015" month="5" day="13">
      <p class="timeul1p1">周五</p>
      <p class="timeul1p2" id="week5">13</p>
    </li>
    <li onClick="changeDate(6,this);" year="2015" month="5" day="15">
      <p class="timeul1p1">周六</p>
      <p class="timeul1p2" id="week6">14</p>
    </li>
  </ul>
  <div class="wordsDiv">
    <span>点击勾选，即可设置你的出诊时间</span>
  </div>
  <ul class="timepointul">
    <li class="timepointul_li1" onClick="choosetp(this);" flag="0">7:00</li>
    <li class="timepointul_li2" onClick="choosetp(this);" flag="0">7:30</li>
    <li class="timepointul_li1" onClick="choosetp(this);" flag="0">8:00</li>
    <li class="timepointul_li2" onClick="choosetp(this);" flag="0">8:30</li>
    <li class="timepointul_li1" onClick="choosetp(this);" flag="0">9:00</li>
    <li class="timepointul_li2" onClick="choosetp(this);" flag="0">9:30</li>
    <li class="timepointul_li1" onClick="choosetp(this);" flag="0">10:00</li>
    <li class="timepointul_li2" onClick="choosetp(this);" flag="0">10:30</li>
    <li class="timepointul_li1" onClick="choosetp(this);" flag="0">11:00</li>
    <li class="timepointul_li2" onClick="choosetp(this);" flag="0">11:30</li>
    <li class="timepointul_li1" onClick="choosetp(this);" flag="0">12:00</li>
    <li class="timepointul_li2" onClick="choosetp(this);" flag="0">12:30</li>
    <li class="timepointul_li1" onClick="choosetp(this);" flag="0">13:00</li>
    <li class="timepointul_li2" onClick="choosetp(this);" flag="0">13:30</li>
    <li class="timepointul_li1" onClick="choosetp(this);" flag="0">14:00</li>
    <li class="timepointul_li2" onClick="choosetp(this);" flag="0">14:30</li>
    <li class="timepointul_li1" onClick="choosetp(this);" flag="0">15:00</li>
    <li class="timepointul_li2" onClick="choosetp(this);" flag="0">15:30</li>
    <li class="timepointul_li1" onClick="choosetp(this);" flag="0">16:00</li>
    <li class="timepointul_li2" onClick="choosetp(this);" flag="0">16:30</li>
    <li class="timepointul_li1" onClick="choosetp(this);" flag="0">17:00</li>
    <li class="timepointul_li2" onClick="choosetp(this);" flag="0">17:30</li>
    <li class="timepointul_li1" onClick="choosetp(this);" flag="0">18:00</li>
    <li class="timepointul_li2" onClick="choosetp(this);" flag="0">18:30</li>
    <li class="timepointul_li1" onClick="choosetp(this);" flag="0">19:00</li>
    <li class="timepointul_li2" onClick="choosetp(this);" flag="0">19:30</li>
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

    $('.dateul').width(mw);
    $('.dateul li').width(mw/3);
    $('.dateul div').width((mw/3)*0.6).height(mh*0.05);
    $('.dateul div').css('line-height',mh*0.05+'px');

    $('.timeul1').width(mw);
    $('.timeul1 li').width(mw/7);
    $('.timeul1 li').eq(0).css('background','#FB9D3B');
    $('.timeul1 li').eq(0).find('p').css('color','#FFFFFF');

    $('#mainDiv').show();
    $('#MsgBoxDiv').width(mw).height(mh);
    $('#MsgBoxDiv ul').width(mw*0.84).height(mh*0.26);
    $('#MsgBoxDiv ul li').eq(0).width(mw*0.84).height(mh*0.26*0.73);
    $('#MsgBoxDiv ul li').eq(1).width(mw*0.84).height(mh*0.26*0.27);
    $('#MsgBoxDiv ul li').eq(1).css('line-height',mh*0.26*0.27+'px');
    $('#msgcontp').css('margin-top',mh*0.26*0.3);
    $('#MsgBoxDiv ul').css('margin-top',mh*0.15);

    setDayTime();
  }
  function choosetp(ob){
    if(selectedDate==null)return;

    var sSelDate= selectedDate.replace(/-/g,"/");
    var selDate=new Date(sSelDate);

    var nowDate=new Date(nowyear+"/"+nowmonth+"/"+nowday);

    if(selDate.getTime()<nowDate.getTime()){
      return ;
    }
    var flag = $(ob).attr('flag');
    var booked=$(ob).attr("hasBooked");
    if(booked=="true"){
      return;
    }
    if(flag==1){
      $(ob).removeClass('tpchoosed');
      $(ob).attr('flag',0);
    }else{
      $(ob).addClass('tpchoosed');
      $(ob).attr('flag',1);
    }
  }
  var nowyear = null;
  var nowmonth = null;
  var nowday = null;
  var nowday_week = null;
  function setDayTime(){
    var date = new Date();
    nowyear = date.getFullYear();
    nowmonth = date.getMonth() + 1;
    nowday = date.getDate();
    nowday_week = date.getDay();
    $('.dateul_li1').html(nowyear+'-'+nowmonth+'-'+nowday);
    var onedayTimes = 1000*60*60*24;
    for(var i=0;i<=7;i++){
      if(nowday_week>=i){
        var date0 = new Date();
        var  milliseconds = date0.getTime() - onedayTimes*(nowday_week-i);
        var  date1 = new Date();
        date1.setTime(milliseconds);
        $('#week'+i).html(date1.getDate());
        $("#week"+i).attr("date",date1.getFullYear()+"-"+(date1.getMonth() + 1)+"-"+date1.getDate());
      }else{
        var date0 = new Date();
        var  milliseconds = date0.getTime() + onedayTimes*(i-nowday_week);
        var  date1 = new Date();
        date1.setTime(milliseconds);
        $('#week'+i).html(date1.getDate());
        $("#week"+i).attr("date",date1.getFullYear()+"-"+(date1.getMonth() + 1)+"-"+date1.getDate());
      }
    }
    $('.timeul1 li').css('background','#FFFFFF');
    $('.timeul1 li').find('p').css('color','#FB9D3B');
    $('.timeul1 li').eq(nowday_week).css('background','#FB9D3B');
    $('.timeul1 li').eq(nowday_week).find('p').css('color','#FFFFFF');

    var selectedDate=nowyear+'-'+nowmonth+"-"+ $('.timeul1 li').eq(nowday_week).find('p').eq(1).text();
    clearSelected();
    onSelectedDateChangeHandler(selectedDate);
  }
  var grapdays = 0;
  function prevWeek(){
    grapdays -=1;
    $('.timeul1 li').css('background','#FFFFFF');
    $('.timeul1 li').find('p').css('color','#FB9D3B');
    var date = new Date();
    var day_week = date.getDay();
    var onedayTimes = 1000*60*60*24;
    var milliseconds66 = (date.getTime()-day_week*onedayTimes) + onedayTimes*7*grapdays;
    var date0 = new Date();
    date0.setTime(milliseconds66);
    var isnow = false;
    for(var i=0;i<=7;i++){
      var  milliseconds = date0.getTime() + onedayTimes*i;
      var  date1 = new Date();
      date1.setTime(milliseconds);
      if(date1.getFullYear()==nowyear && (date1.getMonth()+1)==nowmonth && date1.getDate()==nowday){
        $('.timeul1 li').eq(nowday_week).css('background','#FB9D3B');
        $('.timeul1 li').eq(nowday_week).find('p').css('color','#FFFFFF');
        isnow = true;
      }
      $('#week'+i).html(date1.getDate());
      $("#week"+i).attr("date",date1.getFullYear()+"-"+(date1.getMonth() + 1)+"-"+date1.getDate());
    }

    clearSelected();

    if(isnow){
      $('.dateul_li1').html(nowyear+'-'+nowmonth+'-'+nowday);

      var day=$('.timeul1 li').eq(nowday_week).find('p').eq(1).text();
      var date= $('.dateul_li1').html();
      var sdate=date.split("-");

      var selectedDate2=sdate[0]+"-"+sdate[1]+"-"+day;
      onSelectedDateChangeHandler(selectedDate2);
    }else{
      var year = date0.getFullYear();
      var month = date0.getMonth() + 1;
      var day = date0.getDate();
      $('.dateul_li1').html(year+'-'+month+'-'+day);
      selectedDate=null;
    }
  }

  function nextWeek(){
    grapdays +=1;
    $('.timeul1 li').css('background','#FFFFFF');
    $('.timeul1 li').find('p').css('color','#FB9D3B');
    var date = new Date();
    var day_week = date.getDay();
    var onedayTimes = 1000*60*60*24;
    var milliseconds66 = (date.getTime()-day_week*onedayTimes) + onedayTimes*7*grapdays;
    var date0 = new Date();
    date0.setTime(milliseconds66);
    var isnow1 = false;
    for(var i=0;i<=7;i++){
      var  milliseconds = date0.getTime() + onedayTimes*i;
      var  date1 = new Date();
      date1.setTime(milliseconds);
      if(date1.getFullYear()==nowyear && (date1.getMonth()+1)==nowmonth && date1.getDate()==nowday){
        $('.timeul1 li').eq(nowday_week).css('background','#FB9D3B');
        $('.timeul1 li').eq(nowday_week).find('p').css('color','#FFFFFF');
        isnow1 = true;
      }
      $('#week'+i).html(date1.getDate());
      $("#week"+i).attr("date",date1.getFullYear()+"-"+(date1.getMonth() + 1)+"-"+date1.getDate());
    }

    clearSelected();

    if(isnow1){
      $('.dateul_li1').html(nowyear+'-'+nowmonth+'-'+nowday);

      var day=$('.timeul1 li').eq(nowday_week).find('p').eq(1).text();
      var date= $('.dateul_li1').html();
      var sdate=date.split("-");

      var selectedDate2=sdate[0]+"-"+sdate[1]+"-"+day;
      onSelectedDateChangeHandler(selectedDate2);
    }else{
      var year = date0.getFullYear();

      var month = date0.getMonth() + 1;
      var day = date0.getDate();
      $('.dateul_li1').html(year+'-'+month+'-'+day);
      selectedDate=null;
    }
  }

  function changeDate(num, ob){
    var year = $(ob).attr('year');
    var month = $(ob).attr('month');
    var day = $(ob).attr('day');
    $('.timeul1 li').css('background','#FFFFFF');
    $('.timeul1 li').find('p').css('color','#FB9D3B');
    $('.timeul1 li').eq(num).css('background','#FB9D3B');
    $('.timeul1 li').eq(num).find('p').css('color','#FFFFFF');

    var day=$('.timeul1 li').eq(num).find('p').eq(1).text();
    var date= $('.dateul_li1').html();
    var sdate=date.split("-");

    var selectedDate=$('.timeul1 li').eq(num).find('p').eq(1).attr("date");

    //var selectedDate=sdate[0]+"-"+sdate[1]+"-"+day;

    onSelectedDateChangeHandler(selectedDate);
  }

  var selectedDate;
  function onSelectedDateChangeHandler(selectDate){
    selectedDate=selectDate;
    data="availableDate="+selectDate;
    $.ajax({
      type: 'GET',
      url: "getDoctorAvailableTimes.htm",
      data: data,
      dataType:'json',
      success: function (msg) {
        var elements1=$(".timepointul_li1");
        var elements2=$(".timepointul_li2");
        elements1.removeClass('tpchoosed');
        elements1.removeClass('gray');
        elements1.removeAttr('hasBooked');
        elements1.attr('flag',0);
        elements1.attr('uuid',"");

        elements2.removeClass('tpchoosed');
        elements2.removeClass('gray');
        elements2.removeAttr('hasBooked');
        elements2.attr('flag',0);
        elements2.attr('uuid',"");

        //已设置出诊时间
        var list=msg.availableTimeList;
        for(var i=0;i<list.length;i++){
          var sdate=list[i].dateTime;
          sdate = sdate.replace(/-/g,"/");
          var date = new Date(sdate);
          var label=date.getHours()+":"+(date.getMinutes()==0?"00":date.getMinutes());
          for(var j=0;j<elements1.length;j++){
            var element=elements1.eq(j);
            if(element.text()==label){
              element.addClass('tpchoosed');
              element.attr('flag',1);
              element.attr('hasBooked',list[i].hasBooked);
              element.attr('uuid',list[i].uuid);
            }
          };
          for(var j=0;j<elements2.length;j++){
            var element=elements2.eq(j);
            if(element.text()==label){
              element.addClass('tpchoosed');
              element.attr('flag',1);
              element.attr('hasBooked',list[i].hasBooked);
              element.attr('uuid',list[i].uuid);
            }
          };
        }
        //不允许出诊时间设置
        if(msg.noVisitedTime) {
          var dateListArray = msg.noVisitedTime.dateList.split(",");
          for(var i=0;i<dateListArray.length;i++){
            var label = dateListArray[i];
            //处理08:00与8:00匹配
            if(label.substring(0,1) == "0")
              label = label.substring(1);
            for(var j=0;j<elements1.length;j++){
              var element=elements1.eq(j);
              if(element.text()==label){
                element.attr('hasBooked',true);
                element.addClass('gray');
              }
            }
            for(var j=0;j<elements2.length;j++){
              var element=elements2.eq(j);
              if(element.text()==label){
                element.attr('hasBooked',true);
                element.addClass('gray');
              }
            }
          }
        }
      },
      timeout: 10000,
      error: function () {
        var msg = '网络连接错误或超时';
        var btnword = '确定';
        MsgOpt.showMsgBox(msg, btnword);
        return;
      }
    });
  }

  function clearSelected(){
    var elements1=$(".timepointul_li1");
    var elements2=$(".timepointul_li2");
    elements1.removeClass('tpchoosed');
    elements1.attr('flag',0);
    elements1.attr('uuid',"");
    elements1.attr("hasBooked",false);

    elements2.removeClass('tpchoosed');
    elements2.attr('flag',0);
    elements2.attr('uuid',"");
    elements1.attr("hasBooked",false);
  }

  function jump(caseID){
    window.location.href = '你的域名?caseID='+caseID;
  }

  function editStarttime(){

  }

  function submitTime(){
     if(selectedDate==null){
        MsgOpt.showMsgBox("请选择日期","确定");
        return;
     }
    var timeList="";
    var uuidList="";
    var elements1=$(".timepointul_li1");
    var elements2=$(".timepointul_li2");
    for(var i=0;i<elements1.length;i++){
        var element=elements1.eq(i);
        if(element.attr('flag')==1){
          if(timeList!=""){
            timeList=timeList+",";
            uuidList=uuidList+",";
          }
          timeList=timeList+element.text();
          if(element.attr('uuid')!=""){
            uuidList=uuidList+element.attr('uuid');
          }else{
            uuidList=uuidList+" ";
          }
        };
    }

    for(var i=0;i<elements2.length;i++){
      var element=elements2.eq(i);
      if(element.attr('flag')==1){
        if(timeList!=""){
          timeList=timeList+",";
          uuidList=uuidList+",";
        }
        timeList=timeList+element.text();
        if(element.attr('uuid')!=""){
          uuidList=uuidList+element.attr('uuid');
        }else{
          uuidList=uuidList+" ";
        }
      };
    }
    var data="selectedDate="+selectedDate+"&timeList="+timeList+"&uuidList="+uuidList;
    $.ajax({
      type: 'POST',
      url: "saveAvailableTimes.htm",
      data: data,
      dataType:'json',
      success: function (msg) {
        if(msg) {
          if(msg=="toLogin"){
            window.location.href="toLogin.htm";
          }
        } else {
          MsgOpt.showMsgBox("提交成功", "确定");
        }
      },
      timeout: 10000,
      error: function () {
        var msg = '网络连接错误或超时';
        var btnword = '确定';
        MsgOpt.showMsgBox(msg, btnword);
        return;
      }
    });
  }

  //获取数据

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