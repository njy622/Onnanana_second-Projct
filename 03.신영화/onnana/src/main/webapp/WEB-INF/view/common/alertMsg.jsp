<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Alert Message</title>
</head>
<body>
	<script>
		let msg = '${msg}';  <%-- userController에 해당 메소드 있음 --%>
		let url = '${url}';	
		alert(msg);
		location.href = url;
	</script>

</body>
</html>