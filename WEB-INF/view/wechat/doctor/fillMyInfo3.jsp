<%@ page import="cn.aidee.jdoctor.model.JdDoctorModel" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  JdDoctorModel jdDoctorModel=(JdDoctorModel)request.getAttribute("jdDoctorModel");
  String wxconfig = (String)request.getAttribute("wxconfig");
%>
<!DOCTYPE html>
<html>
<head>
  <jsp:include page="../include/head.jsp" />
  <script src="../../wechat/js/ajaxfileupload.js"></script>
  <script src="../../wechat/js/weixin.js" type="text/javascript"></script>
  <script>
    function ajaxFileUpload()
    {
      $.ajaxFileUpload
      (
              {
                url:'uploadCertImage.htm', //你处理上传文件的服务端
                secureuri:false,
                fileElementId:'image',
                dataType: 'html',
                success: function (data)
                {
                  var text=$(data).text();
                  if(text==null ||text.length==0){
                     text=data;
                  }
                  $("#certImage").attr("src",text);
                  $('#UploadImageDiv').hide();
                  MsgOpt.showMsgBox("上传完成","确定");
                }
              }
      )
      return false;
    }
  </script>
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
    #mainDiv .btmul .btmul_li{width:100%;float:left;}
    #mainDiv .btmul .btmul_li ul{width:100%;overflow:hidden;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li0{width:100%;overflow:hidden;float:left;padding:1.2em 0 1.2em 0;background:#F2F2F2;text-align:center;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li0 img{width:93%;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li1{width:100%;padding:0.6em 0 0.6em 0;float:left;float:left;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li1 p{width:96%;padding:0.2em 0 0.2em 0;margin-left:2%;font-size:1.55em;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li2{width:100%;padding:0.2em 0 0.2em 0;background:#FFFFFF;float:left;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li2 p{width:96%;padding:0.6em 0 0.3em 0;margin-left:2%;font-size:1.5em;color:#A4A4A4;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li3{width:100%;height:10%;padding:0.5em 0 0.6em 0;background:#FFFFFF;float:left;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li3 img{height:100%;margin-left:2%;margin-bottom:2%;float:left;}

    #MsgBoxDiv{width:100%;height:100%;position:fixed;left:0;top:0;z-index:1000000;display:none;}
    #MsgBoxDiv ul{width:84%;overflow:hidden;margin-left:8%;background:rgba(0,0,0,0.65);border-radius:0.2em;-webkit-border-radius:0.2em;}
    #MsgBoxDiv ul li{width:100%;overflow:hidden;text-align:center;}
    #MsgBoxDiv ul li:nth-child(1) p{width:100%;text-align:center;font-size:1.75em;color:#FFFFFF;}
    #MsgBoxDiv ul li:nth-child(2){border-top:#FFFFFF 0.04em solid;-webkit-border-top:#FFFFFF 0.04em solid;font-size:1.88em;color:#FFFFFF;}

    #UploadImageDiv{width:100%;height:100%;position:absolute;left:0;top:0;z-index:1000000;display:none;background:#F2F2F2;overflow-y:auto;}

  </style>
</head>
<body>
<div id="mainDiv">
  <ul class="top_ul">
    <a href="javascript:history.back();"><li></li></a>
    <li>填写个人信息</li>
    <li><a onClick="next();" href="#">提交</a></li>
  </ul>
  <ul class="btmul">
    <li class="btmul_li">
      <ul class="btmul_li_ul">
        <li class="btmul_li_ul_li0">
          <img src="../../wechat/images/icon21.png"/>
        </li>
        <li class="btmul_li_ul_li1">
          <p class="btmul_li_ul_li1_p1">请上传你的职称证明照片（工牌、证书、成绩单、医生聘书等，上传一项多项皆可）</p>
        </li>
        <li class="btmul_li_ul_li2">
          <p class="btmul_li_ul_li2_p1">点击下面的图片即可删除重新上传</p>
        </li>
        <li class="btmul_li_ul_li3">
          <img id="certImage" style="margin-left:3%;" src='<%=jdDoctorModel.getCertificateImage()==null?"":jdDoctorModel.getCertificateImage()%>' style="width:128px;height:128px;"/>
          <button onclick="editCert();" style="width:100px;height:30px;">上传</button>
        </li>
      </ul>
    </li>
  </ul>
</div>
<div id="UploadImageDiv">
  <form method="post" enctype="multipart/form-data" action="uploadInfoImage.htm">
    <input type="file" name="image" id="image" style="width:100px;height:50px;"/>
    <input type="button" value="上传" style="width:100px;height:50px;" onclick="ajaxFileUpload();"/>
    <input type="button" onclick="$('#UploadImageDiv').hide()" value="关闭" style="width:100px;height:50px;">
  </form>
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

    $('.btmul').width(mw);
    $('.btmul_li_ul_li3 img').height(mh*0.085);

    $('#mainDiv').show();
    $('#MsgBoxDiv').width(mw).height(mh);
    $('#MsgBoxDiv ul').width(mw*0.84).height(mh*0.26);
    $('#MsgBoxDiv ul li').eq(0).width(mw*0.84).height(mh*0.26*0.73);
    $('#MsgBoxDiv ul li').eq(1).width(mw*0.84).height(mh*0.26*0.27);
    $('#MsgBoxDiv ul li').eq(1).css('line-height',mh*0.26*0.27+'px');
    $('#msgcontp').css('margin-top',mh*0.26*0.3);
    $('#MsgBoxDiv ul').css('margin-top',mh*0.15);

    var wxconfig = <%=wxconfig%>;
    wx.config({
      debug: false,
      appId: wxconfig.appId,
      timestamp: wxconfig.timestamp,
      nonceStr: wxconfig.nonceStr,
      signature: wxconfig.signature,
      jsApiList: ['chooseImage','uploadImage']
    });
  }

  function editCert() {
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
              url: "getCertImage.htm",
              data:data,
              dataType:'text',
              success: function (msg) {
                $("#certImage").attr("src",msg);
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

  function addPic(){
    var htmls0 = '<img src="../../wechat/images/2.jpg"/>';
    $('.btmul_li_ul_li3').prepend(htmls0);
    $('.btmul_li_ul_li3 img').eq(0).height(mh*0.085);
  }

  function next(){
    data="certImage="+$("#certImage").attr("src");
    $.ajax({
      type: 'POST',
      url: 'saveMyInfo3.htm',
      dataType: 'json',
      data:data,
      success: function (msg) {
        if(msg.result==1){
          MsgOpt.showMsgBox("提交成功 审核需要2-7个工作日","确定","myinfo.htm");
        }else if(msg.result==3){
          window.location.href="toLogin.htm";
        }
      },
      timeout:10000,
      error: function () {
        var msg = '失败，请检查网络';
        var btnword = '确定';
        MsgOpt.showMsgBox(msg, btnword);
        return;
      }
    });
  }


  //消息弹窗类
  var MsgOpt = {
    msgt:null,
    href:null,
    showMsgBox:function(msg, btnword, href){
      var mythis = this;
      if(href)
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