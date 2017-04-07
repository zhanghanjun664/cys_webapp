<%@ taglib prefix="s" uri="urn:com:sun:jersey:api:view" %>
<%@ page import="cn.aidee.jdoctor.model.JdHospitalQueryModel" %>
<%@ page import="cn.aidee.framework.base.pageutil.Page" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="cn.aidee.jdoctor.model.JdCommentQueryModel" %>
<%@ page import="java.util.List" %>
<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2015/11/23
  Time: 14:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String path = request.getContextPath();
%>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>橙医生</title>
</head>
<body>

	<!--页头-->
	<jsp:include page="/pcassets/include/header.jsp"/>

	<!--banner-->
	<div class="banner">

		
		<div class="banner_wrap">
		
			<div class="banner_move_wrap">
				
				<div class="banner_move">
					<div class="banner_sileder"></div>
					<div class="banner_sileder"></div>
					<div class="banner_sileder"></div>
					<div class="banner_sileder"></div>
				</div>
				
			</div>

		</div>



	


	</div>
	<!--banner-->

	<!--pagination-->
	<div class="pagination">
		<ul class="pointior">
			<li class="clearfix point_active">
				<div class="fl pagintion_left"><img src="/pcassets/upload/5.jpg" alt=""></div>
				<div class="fl pagintion_right">邀请好友获取现金卷</div>
			</li>
			<li class="clearfix">
				<div class="fl pagintion_left"><img src="/pcassets/upload/5.jpg" alt=""></div>
				<div class="fl pagintion_right">邀请好友获取现金卷</div>
			</li>
			<li class="clearfix">
				<div class="fl pagintion_left"><img src="/pcassets/upload/5.jpg" alt=""></div>
				<div class="fl pagintion_right">邀请好友获取现金卷</div>
			</li>
			<li class="clearfix">
				<div class="fl pagintion_left"><img src="/pcassets/upload/5.jpg" alt=""></div>
				<div class="fl pagintion_right">邀请好友获取现金卷</div>
			</li>
		</ul>
	</div>
	<!--pagination-->

	<!--content-->
		<div class="content clearfix">
			
			
			<!--main-->
			<div class="main center">

				<!--main_left-->
				<div class="main_left fl">
					
					<!--hospital_list-->
						<div class="hospital_list">


							<!--hospital_area-->
							<div class="hospital_area">
								<ul class="clearfix">
									<li class="fl pr hospital_area_active">全国<small class="pa"></small></li>
									<li class="fl pr">广州<small class="pa"></small></li>
									<li class="fl pr">北京<small class="pa"></small></li>
									<li class="fl pr">上海<small class="pa"></small></li>
								</ul>
							</div>
							<!--hospital_top-->

							<!--hospital_content-->
							<div class="hospital_content">
								<ul class="clearfix" id="biuuu_city_list">

									<li class="fl pr">
										<a href="javascript:void(0)" class="pr">
											<img src="/pcassets/upload/1.jpg" alt="">
											<div class="hospital_opacity pa"></div>
											<div class="hospital_message pa">
												<p class="hospital_name clearfix colorf"><span class="fl hospital_showname ellipsis">广东省人民医院</span><span class="fr">人气：1099</span></p>
												<p class="hospital_address f12 colorf ellipsis">广东省越秀区大德路112号</p>
											</div>
										</a>

									</li>

									<li class="fl pr">
										<a href="javascript:void(0)" class="pr">
											<img src="/pcassets/upload/2.jpg" alt="">
											<div class="hospital_opacity pa"></div>
											<div class="hospital_message pa">
												<p class="hospital_name clearfix colorf"><span class="fl hospital_showname ellipsis">广东省人民医院</span><span class="fr">人气：1099</span></p>
												<p class="hospital_address f12 colorf ellipsis">广东省越秀区大德路112号</p>
											</div>
										</a>
									</li>

									<li class="fl pr">
										<a href="javascript:void(0)" class="pr">
											<img src="/pcassets/upload/3.jpg" alt="">
											<div class="hospital_opacity pa"></div>
											<div class="hospital_message pa">
												<p class="hospital_name clearfix colorf"><span class="fl hospital_showname ellipsis">广东省人民医院</span><span class="fr">人气：1099</span></p>
												<p class="hospital_address f12 colorf ellipsis">广东省越秀区大德路112号</p>
											</div>
										</a>
									</li>


									<li class="fl pr margin_none">
										<a href="javascript:void(0)" class="pr">
											<img src="/pcassets/upload/4.jpg" alt="">
											<div class="hospital_opacity pa"></div>
											<div class="hospital_message pa">
												<p class="hospital_name clearfix colorf"><span class="fl hospital_showname ellipsis">广东省人民医院</span><span class="fr">人气：1099</span></p>
												<p class="hospital_address f12 colorf ellipsis">广东省越秀区大德路112号</p>
											</div>
										</a>
									</li>

									<li class="fl pr">
										<a href="javascript:void(0)" class="pr">
											<img src="/pcassets/upload/1.jpg" alt="">
											<div class="hospital_opacity pa"></div>
											<div class="hospital_message pa">
												<p class="hospital_name clearfix colorf"><span class="fl hospital_showname ellipsis">广东省人民医院</span><span class="fr">人气：1099</span></p>
												<p class="hospital_address f12 colorf ellipsis">广东省越秀区大德路112号</p>
											</div>
										</a>
									</li>

									<li class="fl pr">
										<a href="javascript:void(0)" class="pr">
											<img src="upload/2.jpg" alt="">
											<div class="hospital_opacity pa"></div>
											<div class="hospital_message pa">
												<p class="hospital_name clearfix colorf"><span class="fl hospital_showname ellipsis">广东省人民医院</span><span class="fr">人气：1099</span></p>
												<p class="hospital_address f12 colorf ellipsis">广东省越秀区大德路112号</p>
											</div>
										</a>
									</li>

									<li class="fl pr">
										<a href="javascript:void(0)" class="pr">
											<img src="upload/3.jpg" alt="">
											<div class="hospital_opacity pa"></div>
											<div class="hospital_message pa">
												<p class="hospital_name clearfix colorf"><span class="fl hospital_showname ellipsis">广东省人民医院</span><span class="fr">人气：1099</span></p>
												<p class="hospital_address f12 colorf ellipsis">广东省越秀区大德路112号</p>
											</div>
										</a>
									</li>


									<li class="fl pr margin_none">
										<a href="javascript:void(0)" class="pr">
											<img src="upload/4.jpg" alt="">
											<div class="hospital_opacity pa"></div>
											<div class="hospital_message pa">
												<p class="hospital_name clearfix colorf"><span class="fl hospital_showname ellipsis">广东省人民医院</span><span class="fr">人气：1099</span></p>
												<p class="hospital_address f12 colorf ellipsis">广东省越秀区大德路112号</p>
											</div>
										</a>
									</li>

									<li class="fl pr">
										<a href="javascript:void(0)" class="pr">
											<img src="upload/1.jpg" alt="">
											<div class="hospital_opacity pa"></div>
											<div class="hospital_message pa">
												<p class="hospital_name clearfix colorf"><span class="fl hospital_showname ellipsis">广东省人民医院</span><span class="fr">人气：1099</span></p>
												<p class="hospital_address f12 colorf ellipsis">广东省越秀区大德路112号</p>
											</div>
										</a>
									</li>

									<li class="fl pr">
										<a href="javascript:void(0)" class="pr">
											<img src="upload/2.jpg" alt="">
											<div class="hospital_opacity pa"></div>
											<div class="hospital_message pa">
												<p class="hospital_name clearfix colorf"><span class="fl hospital_showname ellipsis">广东省人民医院</span><span class="fr">人气：1099</span></p>
												<p class="hospital_address f12 colorf ellipsis">广东省越秀区大德路112号</p>
											</div>
										</a>
									</li>

									<li class="fl pr">
										<a href="javascript:void(0)" class="pr">
											<img src="upload/3.jpg" alt="">
											<div class="hospital_opacity pa"></div>
											<div class="hospital_message pa">
												<p class="hospital_name clearfix colorf"><span class="fl hospital_showname ellipsis">广东省人民医院</span><span class="fr">人气：1099</span></p>
												<p class="hospital_address f12 colorf ellipsis">广东省越秀区大德路112号</p>
											</div>
										</a>
									</li>


									<li class="fl pr margin_none">
										<a href="javascript:void(0)" class="pr">
											<img src="upload/4.jpg" alt="">
											<div class="hospital_opacity pa"></div>
											<div class="hospital_message pa">
												<p class="hospital_name clearfix colorf"><span class="fl hospital_showname ellipsis">广东省人民医院</span><span class="fr">人气：1099</span></p>
												<p class="hospital_address f12 colorf ellipsis">广东省越秀区大德路112号</p>
											</div>
										</a>
									</li>



									

								</ul>
							</div>
							<!--hospital_content-->

							<!--page-->
							<div class="page" id="page">
								<span class="f12">共20条 第1/5页</span>
								<a href="javascript:void(0)" class="page_num f12 page_num_active">1</a>
								<a href="javascript:void(0)" class="page_num f12">2</a>
								<a href="javascript:void(0)" class="page_num f12">3</a>
								<a href="javascript:void(0)" class="page_num f12">4</a>
							</div>
							<!--page-->



						</div>
					<!--hospital_list-->

				</div>
				<!--main_left-->

				<!--main_right-->
				<div class="main_right fr">

					<!--column-->
					<div class="column">
							<!--column_top-->
							<div class="column_top pr"><span class="pa"></span>患者评价</div>
							<!--column_top-->
							<!--column_content-->
							<div class="column_content">
								<a href="javascript:void(0)">
									<ul class="patient_review">
										<li class="f12 doctor_name"><span class=" f15">胡大一</span> 主任医师</li>
										<li class="f12"><span class="doctor_review">150*****690的评论</span>（2015-11-07 12:30:34 发布）</li>
										<li class="f12">治疗疾病：心脑血管</li>
										<li class="f12 doctor_review">医德高尚，待患者和蔼可亲，关怀备至，能够细心了解患者的病情。</li>
									</ul>
								</a>	
							</div>
							<!--column_content-->
					</div>
					<!--column-->

					
					<!--column-->
					<div class="column">
							<!--column_top-->
							<div class="column_top pr"><span class="pa"></span>推荐专家</div>
							<!--column_top-->
							<!--column_content-->
							<div class="column_content clearfix recemmend_list" id="setScroll">

								<a href="javascript:void(0)">
									<dl class="clearfix fl recommend_doctor pr">
										<dt class="fl"><img src="upload/5.jpg" alt=""></dt>
										<dd class="fl ellipsis recommend_name">胡大一 | 主任医师</dd>
										<dd class="fl ellipsis recommend_address">北京人民医院</dd>
										<dd class="fl colorf recommend_button pa">马上预约</dd>
									</dl>
								</a>

								<a href="javascript:void(0)">
									<dl class="clearfix fl recommend_doctor pr">
										<dt class="fl"><img src="upload/5.jpg" alt=""></dt>
										<dd class="fl ellipsis recommend_name">胡大一 | 主任医师</dd>
										<dd class="fl ellipsis recommend_address">北京人民医院</dd>
										<dd class="fl colorf recommend_button pa recommend_add">申请加号</dd>
									</dl>
								</a>

								<a href="javascript:void(0)">
									<dl class="clearfix fl recommend_doctor pr">
										<dt class="fl"><img src="upload/5.jpg" alt=""></dt>
										<dd class="fl ellipsis recommend_name">胡大一 | 主任医师</dd>
										<dd class="fl ellipsis recommend_address">北京人民医院</dd>
										<dd class="fl colorf recommend_button pa">马上预约</dd>
									</dl>
								</a>

								<a href="javascript:void(0)">
									<dl class="clearfix fl recommend_doctor pr">
										<dt class="fl"><img src="upload/5.jpg" alt=""></dt>
										<dd class="fl ellipsis recommend_name">胡大一 | 主任医师</dd>
										<dd class="fl ellipsis recommend_address">北京人民医院</dd>
										<dd class="fl colorf recommend_button pa recommend_add">申请加号</dd>
									</dl>
								</a>

								<a href="javascript:void(0)">
									<dl class="clearfix fl recommend_doctor pr">
										<dt class="fl"><img src="upload/5.jpg" alt=""></dt>
										<dd class="fl ellipsis recommend_name">胡大一 | 主任医师</dd>
										<dd class="fl ellipsis recommend_address">北京人民医院</dd>
										<dd class="fl colorf recommend_button pa recommend_add">申请加号</dd>
									</dl>
								</a>

								<a href="javascript:void(0)">
									<dl class="clearfix fl recommend_doctor pr">
										<dt class="fl"><img src="upload/5.jpg" alt=""></dt>
										<dd class="fl ellipsis recommend_name">胡大一 | 主任医师</dd>
										<dd class="fl ellipsis recommend_address">北京人民医院</dd>
										<dd class="fl colorf recommend_button pa recommend_add">申请加号</dd>
									</dl>
								</a>

								<a href="javascript:void(0)">
									<dl class="clearfix fl recommend_doctor pr">
										<dt class="fl"><img src="upload/5.jpg" alt=""></dt>
										<dd class="fl ellipsis recommend_name">胡大一 | 主任医师</dd>
										<dd class="fl ellipsis recommend_address">北京人民医院</dd>
										<dd class="fl colorf recommend_button pa recommend_add">申请加号</dd>
									</dl>
								</a>

								<a href="javascript:void(0)">
									<dl class="clearfix fl recommend_doctor pr">
										<dt class="fl"><img src="upload/5.jpg" alt=""></dt>
										<dd class="fl ellipsis recommend_name">胡大一 | 主任医师</dd>
										<dd class="fl ellipsis recommend_address">北京人民医院</dd>
										<dd class="fl colorf recommend_button pa recommend_add">申请加号</dd>
									</dl>
								</a>		


							</div>
							<!--column_content-->
					</div>
					<!--column-->


				</div>
				<!--main_right-->

			</div>	

			<!--main-->	

		</div>
	<!--content-->

	

</body>
</html>