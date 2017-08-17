<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>WebSocket示例</title>
<script type="text/javascript" src="resources/jquery.js"></script>
</head>
<body>
<style>
	.friends{
		background-color: blue;
	}
	.friends:active{
		background: yellow;
	}
</style>
<script>
	function check() {
//        alert($(":selected","#sel").attr("id"));
//        alert($("#id>option:selected").attr("value"));
        console.log(${pageContext.request.contextPath});
    }
    $("#la").on("click",function () {
        console.log(${pageContext.request.contextPath});
        $.get(${pageContext.request.contextPath}+"/msg/getAllUser");
    })

</script>
	<form action="msg/login" method="post">
		用户名:
		<select name="id" id="id">
			<option value="1">rona一号</option>
			<option value="2">rona二号</option>
			<option value="3">rona三号</option>
		</select><br>
		<input type="button" onclick="check()"/>
		密码:
		<input name="password" type="text" value="123456">
		<input type="submit" value="登录">
		<input type="button" id="la" class="friends">
	</form>
</body>

</html>
