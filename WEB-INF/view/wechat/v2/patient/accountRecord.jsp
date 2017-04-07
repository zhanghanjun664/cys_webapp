<%@ page import="cn.aidee.framework.base.utils.DateUtils"%>
<%@ page import="cn.aidee.jdoctor.constants.PatientPaymentHistoryType"%>
<%@ page import="cn.aidee.jdoctor.constants.PaymentStatus"%>
<%@ page import="cn.aidee.jdoctor.model.PatientPaymentHistoryQueryModel"%>
<%@ page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	List<PatientPaymentHistoryQueryModel> paymentlList = (List<PatientPaymentHistoryQueryModel>) request
			.getAttribute("paymentlList");
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
<jsp:include page="../include/head.jsp" />
</head>
<body>
	<!--wrap-->
	<div class="wrap">
		<!--header-->
		<header class="header pr">
			<h1 class="logo pa">
				<a onclick="toMain()"></a>
			</h1>
			<h2>钱包</h2>
		</header>
		<!--header-->

		<!--content-->
		<div class="content mt">
			<!--list-->
			<ul class="list record_list">
				<%
					if (paymentlList == null || paymentlList.size() == 0) {
				%>
				<li class="clearfix">
					<p style="text-align: center; font-size: 22px; margin-top: 13px;">暂无记录</p>
				</li>
				<%
					} else if (paymentlList != null) {
						for (int i = 0; i < paymentlList.size(); i++) {
							PatientPaymentHistoryQueryModel patientPaymentHistoryQueryModel = paymentlList.get(i);
							if (patientPaymentHistoryQueryModel.getType()
									.equals(PatientPaymentHistoryType.WITHDRAW.getValue())) {
				%>
				<li class="clearfix"><i class="fl">
						<p>
							提现(<%=PaymentStatus.getDescription(patientPaymentHistoryQueryModel.getStatus())%>)
						</p>
						<p><%=DateUtils.format(patientPaymentHistoryQueryModel.getCreateDate())%></p>
				</i> <span class="fr">-<%=patientPaymentHistoryQueryModel.getAmount()%>元
				</span></li>
				<%
					} else if (patientPaymentHistoryQueryModel.getType()
									.equals(PatientPaymentHistoryType.REFUND.getValue())) {
				%>
				<li class="clearfix"><i class="fl">
						<p>取消订单退款</p>
						<p><%=DateUtils.format(patientPaymentHistoryQueryModel.getCreateDate())%></p>
				</i> <span class="fr addmoney">+<%=patientPaymentHistoryQueryModel.getAmount()%>元
				</span></li>
				<%
					} else if (patientPaymentHistoryQueryModel.getType()
									.equals(PatientPaymentHistoryType.SERVICE_REFUND.getValue())) {
				%>
				<li class="clearfix"><i class="fl">
						<p>咨询服务退款</p>
						<p><%=DateUtils.format(patientPaymentHistoryQueryModel.getCreateDate())%></p>
				</i> <span class="fr addmoney">+<%=patientPaymentHistoryQueryModel.getAmount()%>元
				</span></li>
				<%
					} else if (patientPaymentHistoryQueryModel.getType()
									.equals(PatientPaymentHistoryType.PAY_SERVICE.getValue())) {
				%>
				<li class="clearfix"><i class="fl">
						<p>咨询服务支付</p>
						<p><%=DateUtils.format(patientPaymentHistoryQueryModel.getCreateDate())%></p>
				</i> <span class="fr">-<%=patientPaymentHistoryQueryModel.getAmount()%>元
				</span></li>
				<%
					} else if (patientPaymentHistoryQueryModel.getType()
							        .equals(PatientPaymentHistoryType.ACTIVITY_OYO.getValue())) {
		        %>
		        <li class="clearfix"><i class="fl">
		        		<p>手术互助计划活动支付</p>
		        		<p><%=DateUtils.format(patientPaymentHistoryQueryModel.getCreateDate())%></p>
		        </i> <span class="fr">-<%=patientPaymentHistoryQueryModel.getAmount()%>元
		        </span></li>
		        <%
		        	}else if (patientPaymentHistoryQueryModel.getType()
									.equals(PatientPaymentHistoryType.QRCODE_REWARD.getValue())) {
				%>
				<li class="clearfix"><i class="fl">
						<p>注册奖励</p>
						<p><%=DateUtils.format(patientPaymentHistoryQueryModel.getCreateDate())%></p>
				</i> <span class="fr addmoney">+<%=patientPaymentHistoryQueryModel.getAmount()%>元
				</span></li>
				<%
					} else if (patientPaymentHistoryQueryModel.getType()
									.equals(PatientPaymentHistoryType.RECOMMEND.getValue())) {
				%>
				<li class="clearfix"><i class="fl">
						<p><%=patientPaymentHistoryQueryModel.getDescription()%></p>
						<p><%=DateUtils.format(patientPaymentHistoryQueryModel.getCreateDate())%></p>
				</i> <span class="fr addmoney">+<%=patientPaymentHistoryQueryModel.getAmount()%>元
				</span></li>
				<%
					} else if (patientPaymentHistoryQueryModel.getType()
									.equals(PatientPaymentHistoryType.BE_INVITED.getValue())) {
				%>
				<li class="clearfix"><i class="fl">
						<p><%=patientPaymentHistoryQueryModel.getDescription()%></p>
						<p><%=DateUtils.format(patientPaymentHistoryQueryModel.getCreateDate())%></p>
				</i> <span class="fr addmoney">+<%=patientPaymentHistoryQueryModel.getAmount()%>元
				</span></li>
				<%
					} else if (patientPaymentHistoryQueryModel.getType()
									.equals(PatientPaymentHistoryType.DOCTOR_CANCEL.getValue())) {
				%>
				<li class="clearfix"><i class="fl">
						<p>医生取消订单退款</p>
						<p><%=DateUtils.format(patientPaymentHistoryQueryModel.getCreateDate())%></p>
				</i> <span class="fr addmoney">+<%=patientPaymentHistoryQueryModel.getAmount()%>元
				</span></li>
				<%
					} else if (patientPaymentHistoryQueryModel.getType()
									.equals(PatientPaymentHistoryType.WX_CHARGE.getValue())) {
				%>
				<li class="clearfix"><i class="fl">
						<p><%=patientPaymentHistoryQueryModel.getDescription()%></p>
						<p><%=DateUtils.format(patientPaymentHistoryQueryModel.getCreateDate())%></p>
				</i> <span class="fr addmoney">+<%=patientPaymentHistoryQueryModel.getAmount()%>元
				</span></li>
				<%
					} else if (patientPaymentHistoryQueryModel.getType()
									.equals(PatientPaymentHistoryType.ALIPAY_CHARGE.getValue())) {
				%>
				<li class="clearfix"><i class="fl">
						<p><%=patientPaymentHistoryQueryModel.getDescription()%></p>
						<p><%=DateUtils.format(patientPaymentHistoryQueryModel.getCreateDate())%></p>
				</i> <span class="fr addmoney">+<%=patientPaymentHistoryQueryModel.getAmount()%>元
				</span></li>
				<%
					} else if (patientPaymentHistoryQueryModel.getType()
									.equals(PatientPaymentHistoryType.PAY_BOND.getValue())) {
				%>
				<li class="clearfix"><i class="fl">
						<p><%=patientPaymentHistoryQueryModel.getDescription()%></p>
						<p><%=DateUtils.format(patientPaymentHistoryQueryModel.getCreateDate())%></p>
				</i> <span class="fr">-<%=patientPaymentHistoryQueryModel.getAmount()%>元
				</span></li>
				<%
					} else if (patientPaymentHistoryQueryModel.getType()
									.equals(PatientPaymentHistoryType.PAY_ORDER.getValue())) {
				%>
				<li class="clearfix"><i class="fl">
						<p><%=patientPaymentHistoryQueryModel.getDescription()%></p>
						<p><%=DateUtils.format(patientPaymentHistoryQueryModel.getCreateDate())%></p>
				</i> <span class="fr">-<%=patientPaymentHistoryQueryModel.getAmount()%>元
				</span></li>
				<%
					} else if (patientPaymentHistoryQueryModel.getType()
									.equals(PatientPaymentHistoryType.RETURN_BOND.getValue())) {
				%>
				<li class="clearfix"><i class="fl">
						<p><%=patientPaymentHistoryQueryModel.getDescription()%></p>
						<p><%=DateUtils.format(patientPaymentHistoryQueryModel.getCreateDate())%></p>
				</i> <span class="fr addmoney">+<%=patientPaymentHistoryQueryModel.getAmount()%>元
				</span></li>
				<%
					} else if (patientPaymentHistoryQueryModel.getType()
									.equals(PatientPaymentHistoryType.RED_ENVELOPE.getValue())) {
				%>
				<li class="clearfix"><i class="fl">
						<p>分享订单红包</p>
						<p><%=DateUtils.format(patientPaymentHistoryQueryModel.getCreateDate())%></p>
				</i> <span class="fr addmoney">+<%=patientPaymentHistoryQueryModel.getAmount()%>元
				</span></li>
				<%
					}
						}
					}
				%>
			</ul>
			<!--list-->
		</div>
		<!--content-->
	</div>
	<!--wrap-->
</body>
<script>
    sendPageVisit(Page_Constant.AccountRecord);
</script>
</html>
