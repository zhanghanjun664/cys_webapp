<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %><%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2016/5/6
  Time: 11:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="/vendor/bootstrap/css/bootstrap.min.css">
</head>
<body>
<div class="container-fluid">
    <div class="row-fluid">
        <div class="span12">
            <table class="table">
                <thead>
                <tr>
                    <th>
                        医生姓名
                    </th>
                    <th>
                        橙子号
                    </th>
                    <th>
                        电话号码
                    </th>
                    <th>
                        时间
                    </th>
                    <th>
                        抽中红包金额
                    </th>
                </tr>
                </thead>
                <tbody>
                <%
                    List<Map> list = (List<Map>) request.getAttribute("result_list");
                    if(list != null){
                    for(Map<String,String> map : list){
                %>
                <tr class="success">
                    <td>
                        <%=map.get("name")%>
                    </td>
                    <td>
                        <%=map.get("chengNum")%>
                    </td>
                    <td>
                        <%=map.get("phone")%>
                    </td>
                    <td>
                        <%=map.get("time")%>
                    </td>
                    <td>
                        <%=map.get("money")%>
                    </td>
                </tr>
                <%
                        }
                    }
                %>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>


</body>
</html>
