<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String path = request.getContextPath();
	String basePath = request.getServerName() + ":"
			+ request.getServerPort() + path + "/";
	String basePath2 = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
"http://www.w3.org/TR/html4/strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<script type="text/javascript" src="<%=basePath2%>resources/jquery.js"></script>
<style>
textarea {
	height: 300px;
	width: 100%;
	resize: none;
	outline: none;
}

input[type=button] {
	float: right;
	margin: 5px;
	width: 50px;
	height: 35px;
	border: none;
	color: white;
	font-weight: bold;
	outline: none;
}

.clear {
	background: red;
}

.send {
	 background: green;
 }
.friends{
	background: blue;
}

.clear:active {
	background: yellow;
}

.send:active {
	background: yellow;
}
.friends:active{
	background: yellow;
}
.msg {
	width: 100%;
	height: 25px;
	outline: none;
}

#content {
	border: 1px solid gray;
	width: 100%;
	height: 400px;
	overflow-y: scroll;
}

.from {
	background-color: green;
	width: 80%;
	border-radius: 10px;
	height: 30px;
	line-height: 30px;
	margin: 5px;
	float: left;
	color: white;
	padding: 5px;
	font-size: 22px;
}

.to {
	background-color: gray;
	width: 80%;
	border-radius: 10px;
	height: 30px;
	line-height: 30px;
	margin: 5px;
	float: right;
	color: white;
	padding: 5px;
	font-size: 22px;
}

.name {
	color: gray;
	font-size: 12px;
}

.tmsg_text {
	color: white;
	background-color: rgb(47, 47, 47);
	font-size: 18px;
	border-radius: 5px;
	padding: 2px;
}

.fmsg_text {
	color: white;
	background-color: rgb(66, 138, 140);
	font-size: 18px;
	border-radius: 5px;
	padding: 2px;
}

.sfmsg_text {
	color: white;
	background-color: rgb(148, 16, 16);
	font-size: 18px;
	border-radius: 5px;
	padding: 2px;
}

.tmsg {
	clear: both;
	float: right;
	width: 80%;
	text-align: right;
}

.fmsg {
	clear: both;
	float: left;
	width: 80%;
}
</style>
<script>
		var path = '<%=basePath%>';
		var uid=${uid eq null?-1:uid};
		if(uid==-1){
			location.href="<%=basePath2%>";
		}
		var from=uid;
		var fromName='${name}';
//        alert($("#selectID>option:selected").attr("value"));
		var to= $("#selectID>option:selected").attr("value");
//			$("#selectID").find("option:selected").attr("value");
		
		var websocket;
		if ('WebSocket' in window) {
			websocket = new WebSocket("ws://" + path + "/ws?uid="+uid);
		} else if ('MozWebSocket' in window) {
			websocket = new MozWebSocket("ws://" + path + "/ws"+uid);
		} else {
			websocket = new SockJS("http://" + path + "/ws/sockjs"+uid);
		}
		websocket.onopen = function(event) {
			console.log("WebSocket:已连接");
			console.log(event);
		};
		websocket.onmessage = function(event) {
			var data=JSON.parse(event.data);
			console.log("WebSocket:收到一条消息",data);
			var textCss=data.from==-1?"sfmsg_text":"fmsg_text";
			$("#content").append("<div class='fmsg'><label class='name'>"+data.fromName+"&nbsp;"+data.date+"</label><div class='"+textCss+"'>"+data.text+"</div></div>");
			scrollToBottom();
		};
		websocket.onerror = function(event) {
			console.log("WebSocket:发生错误 ");
			console.log(event);
		};
		websocket.onclose = function(event) {
			console.log("WebSocket:已关闭");
			console.log(event);
		}
			function sendMsg(){
				var v=$("#msg").val();

				if(v==""){
					return;
				}else{
					var data={};
					data["from"]=from;
					data["fromName"]=fromName;
					console.log($("#selectID>option:selected").attr("value"));
					//通过下拉框选中发送人员
					data["to"]=$("#selectID>option:selected").attr("value");
					data["text"]=v;
					websocket.send(JSON.stringify(data));
					$("#content").append("<div class='tmsg'><label class='name'>我&nbsp;"+new Date().Format("yyyy-MM-dd hh:mm:ss")+"</label><div class='tmsg_text'>"+data.text+"</div></div>");
					scrollToBottom();
					$("#msg").val("");
				}
			}
			
			function scrollToBottom(){
				var div = document.getElementById('content');
				div.scrollTop = div.scrollHeight;
			}
			
			Date.prototype.Format = function (fmt) { //author: rona
			    var o = {
			        "M+": this.getMonth() + 1, //月份 
			        "d+": this.getDate(), //日 
			        "h+": this.getHours(), //小时 
			        "m+": this.getMinutes(), //分 
			        "s+": this.getSeconds(), //秒 
			        "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
			        "S": this.getMilliseconds() //毫秒 
			    };
			    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
			    for (var k in o)
			    if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
			    return fmt;
			}
			
			function send(event){
                <%--<c:forEach var="onlineUid" items="${uidList}">--%>
                <%--Console.log(${onlineUid})--%>
                <%--</c:forEach>--%>
				var code;
				 if(window.event){
					 code = window.event.keyCode; // IE
				 }else{
					 code = e.which; // Firefox
				 }
				if(code==13){ 
					sendMsg();            
				}
			}
			
			function clearAll(){
				$("#content").empty();
			}
//        	$("#friends").click(function(){
//                $.ajax({
//                    url:'http://localhost:8080/msg/getAllUser',
//                    type:"get"
//                });
////				console.log(path);
////                $.get("http://localhost:8080/msg/getAllUser");
//        	});
			function refreshUser() {
			    <%--console.log(${pageContext.request.contextPath}+"");--%>
                $.get("http://localhost:8080/websocket/msg/getAllUser",function () {
                    $("#selectID option").remove();
					<c:forEach var="item" items="${userList }">
						$("#selectID").append("<option value='${item.id}'>${item.name}</option>")
					</c:forEach>
                });

            }
		</script>
</head>
<body>


当前在线人员:
<select id="selectID">
<c:forEach var="item" items="${userList }">
	<option value="${item.id}">${item.name}</option>
</c:forEach>
</select><br>
欢迎：${sessionScope.name }
        <%--<c:forEach var="onlineUid" items="${uidList}">--%>
        <%--用户:<p><c:out value="${onlineUid}"/></p>--%>
        <%--</c:forEach>--%>
	<div id="content"></div>
	<input type="text" placeholder="请输入要发送的信息" id="msg" class="msg" onkeydown="send(event)">
	<input type="button" id="friends" value="刷新好友" class="friends" onclick="refreshUser()"  >
	<input type="button" value="发送" class="send" onclick="sendMsg()" >
	<input type="button" value="清空" class="clear" onclick="clearAll()">

</body>
</html>
