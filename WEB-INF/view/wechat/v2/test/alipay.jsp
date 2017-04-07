<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
   
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
<%
  String path = request.getContextPath();
  String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path;
  pageContext.setAttribute("basePath",basePath);	
  pageContext.setAttribute("_CONTEXT",basePath);
%>
<script>
var pathName = window.document.location.pathname;
var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
console.log("pathName=",pathName);
console.log("projectName=",projectName);

var basePath = "<%=basePath%>";
console.log("basePath=",basePath);
</script>

</head>

<script src="<%=basePath%>/vendor/jquery/jquery.min.js"></script>

<%
 String test = (String) request.getAttribute("test");
%>


<body>
hello 可以了的，还好还好,恩恩额
<br>
<%=test%>


<div id="ali_form">

</div>


<div>
<form name="punchout_form" method="post" action="https://openapi.alipaydev.com/gateway.do?charset=UTF-8&method=alipay.trade.wap.pay&sign=m7ChF8%2BdwjOAasI6CkR7b0RBEa9DOBcav1Uagiu0kV2SLoPrssGlR6axxmV0duWWwSFHmzGeJazXour9I0rMYWgGa%2FWasRZfswVfduRhv6nWhtsXiRTb4nTcsGzJaaWmca4C0NmwjMEmmuL8eQpy4%2BksOVI7iuLMFvkekAmILRk%3D&return_url=http%3A%2F%2Fdomain.com%2FCallBack%2Freturn_url.jsp&notify_url=http%3A%2F%2Fdomain.com%2FCallBack%2Fnotify_url.jsp&version=1.0&app_id=2016072900119330&sign_type=RSA&timestamp=2016-12-26+16%3A31%3A33&alipay_sdk=alipay-sdk-java-dynamicVersionNo&format=json">
<input type="hidden" name="biz_content" value="{    &quot;out_trade_no&quot;:&quot;20161220010101003&quot;,    &quot;total_amount&quot;:40,    &quot;subject&quot;:&quot;荣耀v8&quot;,    &quot;seller_id&quot;:&quot;2088102169031850&quot;,    &quot;product_code&quot;:&quot;QUICK_WAP_PAY2&quot;  }">
<input type="submit" value="立即支付" style="display:block" >
</form>
</div>



</body>
<script>
$.ajax({
	//url:basePath+"/wxapi/public/alipay/test/",
	url:basePath+"/partnerapi/order/pay/form",
	type:"GET",
	contentType:"text/html",
    beforeSend:function(request){
    	request.setRequestHeader("Authorization", "Bearer eyJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJrdWFpd2VuX20iLCJzdWIiOiJrdWFpd2VuX20iLCJpYXQiOjE0ODE3OTExOTEsImV4cCI6MTU3NjM5OTE5MSwiZXh0cmEiOnt9fQ.I1MScje-e2LUWLDL8_Fm5HJ2b5SiELeQkJIPhB0pFNHvpUgWM5VMWMyl7iyqb-dD6GxNMBgGitE-SSgQRNa6BA");
    },
	success:function(result){
		//alert(result);
		/* if(result.result==0){
			//alert("保存成功");
		} */
		console.log("result=",result);
		$('#ali_form').append(result);
	}

});
</script>
</html>