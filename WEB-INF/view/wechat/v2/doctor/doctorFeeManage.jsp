<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.com.chengyisheng.sys.constant.WebConstants" %>
<%@ page import="cn.com.chengyisheng.sys.constant.SystemParams" %>
<%@ page import="java.net.URLEncoder" %>
<%
    String client = (String)request.getSession().getAttribute(WebConstants.SESSION_CLIENT_TYPE);
    boolean isReqFromApp = true;
    if (client == null || !client.equals(WebConstants.SESSION_CLIENT_APP)){
        isReqFromApp = false;
    }
    String appToken = request.getSession().getAttribute(SystemParams.APP_JSP_REQUEST_TOKEN_PARAM_NAME) != null ? 
            URLEncoder.encode((String)request.getSession().getAttribute(SystemParams.APP_JSP_REQUEST_TOKEN_PARAM_NAME), "UTF-8") : ""; 

%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <% if (isReqFromApp){ %>
            <title>管理诊金</title>
    <% } %>
  <jsp:include page="../include/doctor_head.jsp"/>
</head>
<body>
<!-- topbar start -->
<!--  对于从app过来的请求，不显示页面的header -->
<% if (!isReqFromApp) { %>
<header class="fixed topbar">
    <a class="back-to-home logo" onclick="backToHome()">返回首页</a>
    <h3 class="tit">管理诊金</h3>
</header>
<% } %> 
<!-- topbar end -->

<!-- address manage start -->
<div class="main fee-manage" id="feeList" <% if (isReqFromApp){ %> style="padding-top:0px;" <% } %>></div>
<!-- address manage end -->

<!-- address new start -->
<a class="fixed btn-addr-fee" onclick="goto('toAddDoctorFee.htm')">添加诊金</a>
<!-- address new end -->
</body>
<script>
  function asynFeeList() {
    var data = {"random":Math.random()*10000};
    sendRequest("asynDoctorFeeList.htm", "GET", data, function(result) {
      if(result) {
        var str = new StringBuilder();
        for(var i = 0, len = result.length; i < len; i++) {
          var fee = result[i];
          var fee_on = "";
          // 注意： fee为-1时，当前记录仅用于携带默认折扣，这里应当忽略 
          if (fee.fee < 0){
              continue;
          }
          if(fee.isDefault){
            fee_on = "fee-on";
          }
          str.append('<div class="grid  fee-column mt-10"><p class="fee">￥'+fee.fee+'</p>');
          str.append('<div class="fee-column-dw clearfix"><span onclick="setDefault(this)" class="fee-default '+fee_on+' fl" fee="'+fee.fee+'"><i></i>设为默认诊金</span>');
          str.append('<span class="operations fr"><a class="btn-opera btn-opera-edit" onclick="goto(\'toAddDoctorFee.htm?fee='+fee.fee+'\')"><i class="icon-opera ico-edit"></i>编辑</a>');
          str.append('<a class="btn-opera btn-opera-del" onclick="delDoctorFee(this,\''+fee.fee+'\')"><i class="icon-opera ico-del"></i>删除</a>');
          str.append('</span></div></div>');
        }
        $("#feeList").html(str.toString());
      }
    });
  }
  asynFeeList();

  //设置默认诊金
  function setDefault(_this) {
    if(!$(_this).hasClass("fee-on")) {
      var fee = $(_this).attr("fee");
      var data = {"fee":fee};
      sendRequest("setDefaultDoctorFee.htm", "POST", data, function(msg) {
        if(msg) {
          layer.alert(msg, {
            title: false,
            closeBtn: false
          }, function () {
            layer.closeAll();
          });
        } else {
          $(".fee-on").removeClass("fee-on");
          $(_this).addClass("fee-on");
          
          layer.msg('设置成功', {
              //icon: 1,
              time: 1000 //1秒关闭（如果不配置，默认是3秒）
            }, function(){
                goto('toVisitArrange.htm?<%=SystemParams.APP_JSP_REQUEST_TOKEN_PARAM_NAME%>=<%=appToken%>');
            }
          );   
        }
      });
    }
  }

  //删除诊金
  function delDoctorFee(_this, fee) {
    layer.confirm('确定要删除诊金?', {
      title: false,
      closeBtn: false,
      btn: ['取消', '确定']
    }, function(){
      layer.closeAll();
    }, function(){
      var data = {"fee":fee};
      sendRequest("deleteDoctorFee.htm", "POST", data, function(msg) {
        if(msg) {
          layer.alert(msg, {
            title: false,
            closeBtn: false
          }, function () {
            layer.closeAll();
          });
        } else {
          layer.msg('删除成功');
          $(_this).closest('.fee-column').remove();
        }
      });
    });
  }
</script>
</html>
