<%@ page import="cn.aidee.jdoctor.message.util.TokenUtil" %>
<%@ page import="cn.aidee.jdoctor.message.response.JsapiTicketResult" %>
<%@ page import="cn.aidee.jdoctor.message.util.MessageUtil" %>
<%@ page import="cn.com.chengyisheng.services.cs.utils.ContentStorageUtils" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2015/12/19
  Time: 13:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head lang="en">
  <meta charset="UTF-8">
  <title>查看二维码推荐关注数量</title>
  <link rel="stylesheet" href="/vendor/bootstrap/css/bootstrap.min.css">
  <%
    String result = (String)request.getAttribute("result");
    String number = "";
    String name = "";
    String img = "";
    String qrcodeId = "";
    if(result.equals("0")){
      qrcodeId = (String)request.getAttribute("qrcodeId");
      number = (String)request.getAttribute("number");
      name = (String)request.getAttribute("name");
      img = (String)request.getAttribute("img");
    }
  %>
  <style>
    *{ margin:0; padding:0; list-style:none;}
    a{ text-decoration:none;}
    a:hover{ text-decoration:none;}
    .tcdPageCode{padding: 15px 20px;text-align: left;color: #ccc;}
    .tcdPageCode a{display: inline-block;color: #428bca;display: inline-block;height: 25px;	line-height: 25px;	padding: 0 10px;border: 1px solid #ddd;	margin: 0 2px;border-radius: 4px;vertical-align: middle;}
    .tcdPageCode a:hover{text-decoration: none;border: 1px solid #428bca;}
    .tcdPageCode span.current{display: inline-block;height: 25px;line-height: 25px;padding: 0 10px;margin: 0 2px;color: #fff;background-color: #428bca;	border: 1px solid #428bca;border-radius: 4px;vertical-align: middle;}
    .tcdPageCode span.disabled{	display: inline-block;height: 25px;line-height: 25px;padding: 0 10px;margin: 0 2px;	color: #bfbfbf;background: #f2f2f2;border: 1px solid #bfbfbf;border-radius: 4px;vertical-align: middle;}
  </style>
  <script src="/vendor/jquery/jquery.min.js"></script>
  <script src="/vendor/artTemplate/template.js"></script>
  <script src="/vendor/artTemplate/jquery.page.js"></script>
  <script id="test" type="text/html">
    <table ng-table="tableParams" class="table table-hover ng-scope ng-table"><thead class="ng-scope">
    <tr>
      <th class="center">地区</th>
      <th class="center">&nbsp;&nbsp;姓名</th>
      <th class="center">&nbsp;&nbsp;手机号码</th>
      <th class="center">&nbsp;&nbsp;注册时间</th>
      <th class="center">&nbsp;&nbsp;来源渠道(邀请人号码)</th>
    </tr>
    </thead>
      <tbody>
      {{each result as value i}}
      <tr>
        <td class="center">{{value.location}}</td>
        <td class="center">{{value.name}}</td>
        <td class="center">{{value.phoneNumber}}</td>
        <td class="center">{{value.createDate}}</td>
        <td class="center">{{value.parentPhone}}</td>
        <td class="center">{{value.sceneName}}({{value.parentPhone}})</td>
      </tr>
      {{/each}}
      </tbody>
    </table>

  </script>
</head>
<body>
<div>
  <div id="header_bar">
  </div>
  <!-- E header_bar -->
  <div class="container">
    <div class="text-center" id="header">
      <div style="height: 65px;"></div>

      <div class="container">
        <div class="text-center header">
          <p>

            <span style="padding:4px;">二维码渠道:${name}</span>
          </p></div>
        <!-- E header -->
        <div class="panel" id="bd">
          <div class="panel-body" id="panel1">
            <form action="#">
              <div class="form-group avatar text-center">

                <a name="1" class="img-circle" href="javascript:void(0)"><span style="float: left;text-align: center; width: 100%; padding-top: 18px;">
                            <img src="${img}"></span> </a>
              </div>
              <dl>
                <dd>该二维码推荐人数:${number} 人</dd>
              </dl>
            </form>
          </div>
          <!-- E bd -->
        </div>
        <div id="content"></div>
        <div class="tcdPageCode">
        </div>
        <div class="clear"></div>
        <!-- E container -->
      </div>

    </div>
  </div>
</div>
<script>
  <%
    if(!StringUtils.isEmpty(qrcodeId)){
  %>
  var run = function(pageIndex,pageSize){
    //分页
    $.ajax({
      url:"/weixin/qrcodeSpread/list.htm",
      async:false,
      type:"get",
      dataType:'json',
      data:{"qrcodeList":'<%=qrcodeId%>',pageIndex:pageIndex,pageSize:pageSize},
      beforeSend:function(){},
      success:function(s){
        if(s.result.length > 0){
          var html = template('test', s);
          document.getElementById('content').innerHTML = html;
          $(".tcdPageCode").createPage({
            pageCount:s.result.totalPage,
            current:s.result.nowPage,
            backFn:function(p){
              run(p,'10');
            }
          });

        }
      },
      error:function(msgbak){

      }
    });
  }
  run('1','10');
  <%
    }
  %>
</script>
</body>
</html>