<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
 	<%@include file="../common/head.jspf" %>
 	<style>
 		th, td {text-align: center;}
 	</style>
</head>
<body>
   <div class="container" style="margin-top:200px;">
   		<div class="row">
   			<div class="col-2"></div>
   			<div class="col-4">
   				<a href="/onnana/home/">
					<img src="/onnana/img/onna.png" width="100px" style="float: right; z-index:-1;">   
   				</a>
   				<h3 style="color:green;"><i class="fa-solid fa-leaf"></i>&nbsp;비밀번호 변경하기</h3>
				<hr>
				<form action="/onnana/user/Pwdchange" method="post">				
                <table class="table table-borderless">
                    <tr>
                        <td style="width:35%"><label class="col-form-label">사용자 ID</label></td>
                        <td style="width:65%"><input type="text" id="pwdUid" name="pwdUid" class="form-control" ></td>
                    </tr>
                    <tr>
                        <td><label class="col-form-label">이름</label></td>
                        <td><input type="text" name="pwdUname" id="pwdUname" class="form-control"></td>
                    </tr>
                    <tr>
                        <td><label class="col-form-label">이메일</label></td>
                        <td><input type="text" name="pwdEmail" id="pwdEmail" class="form-control"></td>
                    </tr>
                    <tr>
                        <td><label class="col-form-label">새로운 비밀번호</label></td>
                        <td><input type="password" name="pwd"  class="form-control"></td>
                    </tr>
                    <tr>
                        <td><label class="col-form-label">패스워드 확인</label></td>
                        <td><input type="password" name="pwd2" class="form-control"></td>
                    </tr>
                    <tr>
                        <td colspan="3" style="text-align: center;">
                            <input class="btn btn-primary" type="submit" value="확인">
	  			            <a href="/onnana/home">
                   	        	<input class="btn btn-light ms-1" type="reset" value="취소">
               	        	</a>
                            <a href="/onnana/user/Idsearch">
               	        		<button type="button" class="btn btn-light" ">ID 찾기</button>
           	        		</a>
                        </td>
                    </tr>
                </table>    
              </form>
			</div>
			<div class="col-6">
				<img src="/onnana/img/greencam.png">
			</div>
   		</div>
   </div>
   <%@ include file="../common/bottom.jspf" %>
</body>
</html>