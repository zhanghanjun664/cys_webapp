<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.aidee.jdoctor.model.JdPatientModel" %>
<%
    JdPatientModel patientModel=(JdPatientModel)request.getAttribute("patientModel");
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

        #mainDiv .btmul{width:100%;overflow:hidden;padding:0 0 1.5em 0;}
        #mainDiv .btmul .btmul_li{width:100%;float:left;margin-bottom:0.1em;border-top:#E7E7E7 0.1em solid;border-bottom:#E7E7E7 0.1em solid;-webkit-border-top:#E7E7E7 0.1em solid;-webkit-border-bottom:#E7E7E7 0.1em solid;}
        #mainDiv .btmul .btmul_li ul{width:100%;overflow:hidden;}
        #mainDiv .btmul .btmul_li ul li:nth-child(1){width:35%;float:left;font-size:1.55em;text-align:left;margin-left:3%;}
        #mainDiv .btmul .btmul_li ul li:nth-child(2){width:25%;float:right;font-size:1.53em;color:#848484;text-align:right;margin-right:3%;}
        #mainDiv .btmul .btmul_li ul li:nth-child(2) img{margin-top:0.15em;}

        #MsgBoxDiv{width:100%;height:100%;position:fixed;left:0;top:0;z-index:1000000;display:none;}
        #MsgBoxDiv ul{width:84%;overflow:hidden;margin-left:8%;background:rgba(0,0,0,0.65);border-radius:0.2em;-webkit-border-radius:0.2em;}
        #MsgBoxDiv ul li{width:100%;overflow:hidden;text-align:center;}
        #MsgBoxDiv ul li:nth-child(1) p{width:100%;text-align:center;font-size:1.75em;color:#FFFFFF;}
        #MsgBoxDiv ul li:nth-child(2){border-top:#FFFFFF 0.04em solid;-webkit-border-top:#FFFFFF 0.04em solid;font-size:1.88em;color:#FFFFFF;}

        #updateNameDiv{width:100%;height:100%;position:absolute;left:0;top:0;z-index:1000000;background:rgba(0,0,0,0.65);display:none;}
        #updateNameDiv ul{width:80%;overflow:hidden;margin-left:10%;margin-top:10%;}
        #updateNameDiv ul li{float:left;}
        #updateNameDiv li:nth-child(1){width:100%;text-align:center; font-size:1.7em;color:#FFFFFF;}
        #updateNameDiv li:nth-child(2){border-radius:0.5em;border-radius:0.5em;-webkit-border-radius:0.5em;-webkit-border-radius:0.5em;background:#FFFFFF;}
        #updateNameDiv li:nth-child(2) input[type="text"]{width:100%;font-size:1.55em;color:#000000;background:transparent;border:0;-webkit-border:0;float:left;text-align:center;}
        #updateNameDiv li:nth-child(3){background:#FB9D3B;margin-top:10%;border-radius:0.2em;-webkit-border-radius:0.2em;text-align:center;font-size:1.8em;color:#FFFFFF;}
        #updateNameDiv li:nth-child(4){background:#FB9D3B;margin-top:10%;border-radius:0.2em;-webkit-border-radius:0.2em;text-align:center;font-size:1.8em;color:#FFFFFF;float:right;}
    </style>
</head>
<body>
<div id="mainDiv">
    <ul class="top_ul">
        <a href="javascript:history.back();"><li></li></a>
        <li>我的资料</li>
        <li><a href="toPersonal.htm">首页</a></li>
    </ul>
    <ul class="btmul">
        <li id="btmul_li2" class="btmul_li" onClick="ShowUpdateName();">
            <ul>
                <li class="title_li">姓名</li>
                <li class="cont_li" id="name_li"><%=patientModel.getName()%></li>
            </ul>
        </li>
        <li id="btmul_li3" class="btmul_li">
            <ul>
                <li class="title_li">手机号</li>
                <li class="cont_li"><%=patientModel.getPhoneNumber()%></li>
            </ul>
        </li>
        <li id="btmul_li4" class="btmul_li">
            <ul>
                <li class="title_li">邀请码</li>
                <li class="cont_li"><%=patientModel.getRecommandCode()%></li>
            </ul>
        </li>
    </ul>
</div>
<div id="MsgBoxDiv">
    <ul>
        <li><p id="msgcontp"></p></li>
        <li id="btnli" onClick="MsgOpt.hideMsgBox();"></li>
    </ul>
</div>
<div id="updateNameDiv">
    <ul>
        <li>修改姓名</li>
        <li><input id="name" type="text"/></li>
        <li onClick="CancelUpdate();">取消</li>
        <li onClick="UpdateName();">修改</li>
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
        $('.btmul li').width(mw).height(mh*0.085);
        $('.btmul li ul').width(mw).height(mh*0.085);
        $('.title_li').width(mw*0.35).height(mh*0.085);
        $('.cont_li').width(mw*0.25).height(mh*0.085);
        $('.btmul li ul li img').height(mh*0.085*0.87);
        $('.btmul li ul li').css('line-height',mh*0.085+'px');

        $('#mainDiv').show();
        $('#MsgBoxDiv').width(mw).height(mh);
        $('#MsgBoxDiv ul').width(mw*0.84).height(mh*0.26);
        $('#MsgBoxDiv ul li').eq(0).width(mw*0.84).height(mh*0.26*0.73);
        $('#MsgBoxDiv ul li').eq(1).width(mw*0.84).height(mh*0.26*0.27);
        $('#MsgBoxDiv ul li').eq(1).css('line-height',mh*0.26*0.27+'px');
        $('#msgcontp').css('margin-top',mh*0.26*0.3);
        $('#MsgBoxDiv ul').css('margin-top',mh*0.15);

        $('#updateNameDiv').width(mw).height(mh);
        $('#updateNameDiv li').width(mw*0.8).height(mh*0.069);
        $('#updateNameDiv li').eq(0).width(mw*0.8).height(mh*0.069);
        $('#updateNameDiv li').eq(1).width(mw*0.8).height(mh*0.069);
        $('#updateNameDiv li').eq(2).width(mw*0.8*0.45).height(mh*0.069);
        $('#updateNameDiv li').eq(3).width(mw*0.8*0.45).height(mh*0.069);
        $('#updateNameDiv li input').width(mw*0.8).height(mh*0.069);
        $('#updateNameDiv li').css('line-height',mh*0.069+'px');
        $('#updateNameDiv li input').height(mh*0.069);
        $('#updateNameDiv ul').css('margin-top',mh*0.1);

    }
    //显示修改姓名弹窗
    function ShowUpdateName(){
        var name = $('#name_li').html();
        $('#name').val(name);
        $('#updateNameDiv').show();
    }
    function CancelUpdate(){
        $('#name').val('');
        $('#updateNameDiv').hide();
    }
    //修改姓名
    var updflag = false;
    function UpdateName(){
        if(updflag){
            return;
        }
        updflag = true;
        var name = $.trim($('#name').val());
        var data = {name:name};
        $.ajax({
            type:'POST',
            url:'updateName.htm',
            data:data,
            success:function(msg){
                var msged = eval('('+msg+')');
                if(msged['result']==1){
                    $('#name').val('');
                    $('#name_li').html(name);
                    $('#updateNameDiv').hide();
                    var msg = '更新数据成功';
                    var btnword = '确定';
                    MsgOpt.showMsgBox(msg, btnword);
                    updflag = false;
                    return;
                }else{
                    $('#name').val('');
                    $('#updateNameDiv').hide();
                    var msg = '更新数据失败';
                    var btnword = '确定';
                    MsgOpt.showMsgBox(msg, btnword);
                    updflag = false;
                    return;
                }
            },
            timeout: 10000,
            error:function(){
                var msg = '更新数据失败，请检查网络';
                var btnword = '确定';
                MsgOpt.showMsgBox(msg, btnword);
                updflag = false;
                return;
            }
        });
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