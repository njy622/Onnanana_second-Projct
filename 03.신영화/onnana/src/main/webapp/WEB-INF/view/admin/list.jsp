<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>Dashboard - SB Admin</title>
        <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="/project/assets/css/stylesA.css" rel="stylesheet">
        <script src="https://code.jquery.com/jquery-3.6.4.min.js" integrity="sha256-oP6HI9z1XaZNBrJURtCoUT5SUnxFr8s3BzRl+cbzUq8=" crossorigin="anonymous"></script>
        <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
        <style>
            th, td	{ text-align: center; }
            .disabled-link	{ pointer-events: none; }
        </style>
        <script>
            function updateFunc(uid){
                $.ajax({
                    type: 'GET',
                    url: '/project/user/update/' + uid,
                    success: function(result){
                        let user = JSON.parse(result);
                        $('#uid').val(user.uid);
                        $('#uname').val(user.uname);
                        $('#email').val(user.email);
                        $('#updateModal1').modal('show');
                    }
                });
            }
        // 3) delUid
            function deleteFunc(uid) {
                $('#delUid').val(uid);
                $('#deleteModal').modal('show');
            }
        </script>
    </head>
    <body class="sb-nav-fixed">
        <%@ include file="../common/admin_top.jsp"%>
        <div id="layoutSidenav">
            <div id="layoutSidenav_nav">
                <%@ include file="../common/admin_aside.jsp"%>
            </div>
            <div id="layoutSidenav_content">
                <main>
                    <div class="container-fluid px-4">
                        <h1 class="mt-4">회원목록</h1>
                        <ol class="breadcrumb mb-4">
                            <li class="breadcrumb-item active">회원목록</li>
                        </ol>
                        
                        <div class="row">
                            <div class="col-xl-6">
                                <div class="card mb-4">
                                    <div class="card-header">
                                        <i class="fas fa-chart-area me-1"></i>
                                        월별 회원 가입수
                                    </div>
                                    <div class="card-body"><canvas id="myAreaChart" width="100%" height="40"></canvas></div>
                                </div>
                            </div>
                            <div class="col-xl-6">
                                <div class="card mb-4">
                                    <div class="card-header">
                                        <i class="fas fa-chart-bar me-1"></i>
                                        월별 회원 가입수
                                    </div>
                                    <div class="card-body"><canvas id="myBarChart" width="100%" height="40"></canvas></div>
                                </div>
                            </div>
                        </div>
                        <div class="card mb-4">
                            <div class="card-header">
                                <i class="fas fa-table me-1"></i>
                                회원 목록
                            </div>
                            <div class="card-body">
                                <table class="table table-borderless table-striped">
                                    <thead>
                                        <tr>
                                            <th>번호</th>
                                            <th>UID</th>
                                            <th>이름</th>
                                            <th>이메일</th>
                                            <th>가입일</th>
                                            <th>액션</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="user" items="${userList}" varStatus="loop">
                                        <tr>
                                            <td>${loop.count}</td>
                                            <td>${user.uid}</td>
                                            <td>${user.uname}</td>
                                            <td>${user.email}</td>
                                            <td>${user.regDate}</td>
                                            <td>
                                                <!-- 본인만이 수정 권한이 있음 -->
                                                <c:if test="${sessUid eq user.uid}">
                                                    <a href="javascript:updateFunc('${user.uid}')"><i class="fa-solid fa-user-pen me-2"></i></a>
                                                </c:if>
                                                <c:if test="${sessUid ne user.uid}">
                                                    <a href="#" class="disabled-link"><i class="fa-solid fa-user-pen me-2"></i></a>
                                                </c:if>
                                                <!-- 관리자만이 삭제 권한이 있음 -->
                                                <c:if test="${sessUid eq 'admin'}">
                                                <!-- 2) delUid -->
                                                    <a href="javascript:deleteFunc('${user.uid}')"><i class="fa-solid fa-user-minus"></i></a>
                                                </c:if>
                                                <c:if test="${sessUid ne 'admin'}">
                                                    <a href="#" class="disabled-link"><i class="fa-solid fa-user-minus"></i></a>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                                <ul class="pagination mt-3 justify-content-center">
                                    <c:forEach var="page" items="${pageList}">
                                        <li class="page-item ${(currentUserPage eq page) ? 'active' : ''}">
                                            <a class="page-link" href="/project/user/list/${page}">${page}</a>
                                        </li>
                                    </c:forEach>
                                </ul>
                                <input type="hidden" id="delUid">
                            </div>
                        </div>
                    </div>
                </main>
                <%@ include file="../common/admin_bottom.jsp"%>
                <div class="modal" id="updateModal1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title">사용자 수정</h4>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <form action="/project/user/update" method="post">
                                    <table class="table table-borderless">
                                        <tr>
                                            <td style="width:35%"><label class="col-form-label">사용자 ID</label></td>
                                            <!-- disabled : 바뀌지 않게, 서버로 가지 않음 -->
                                            <td style="width:65%"><input type="text" id="uid" class="form-control" disabled></td>
                                        </tr>
                                        <tr>
                                            <td><label class="col-form-label">패스워드</label></td>
                                            <td><input type="password" name="pwd" class="form-control"></td>
                                        </tr>
                                        <tr>
                                            <td><label class="col-form-label">패스워드 확인</label></td>
                                            <td><input type="password" name="pwd2" class="form-control"></td>
                                        </tr>
                                        <tr>
                                            <td><label class="col-form-label">이름</label></td>
                                            <td><input type="text" name="uname" id="uname" class="form-control"></td>
                                        </tr>
                                        <tr>
                                            <td><label class="col-form-label">이메일</label></td>
                                            <td><input type="text" name="email" id="email" class="form-control"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" style="text-align: center;">
                                                <input class="btn btn-primary" type="submit" value="수정">
                                                <input class="btn btn-secondary ms-1" type="reset" value="취소">
                                            </td>
                                        </tr>
                                    </table>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal" id="deleteModal">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title">사용자 삭제</h4>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <strong>삭제하시겠습니까?</strong>
                                <div class="text-center mt-5">
                                <!-- 4) delUid -->
                                    <button class="btn btn-danger" onclick="location.href='/project/user/delete/'+$('#delUid').val()">삭제</button>
                                    <button class="btn btn-secondary ms-1" data-bs-dismiss="modal">취소</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>	
            </div>
        </div>
        <script src="/project/assets/js/adminScripts.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
        <script src="/project/assets/chart/userChartBar.js"></script>
        <script src="/project/assets/chart/userAreaChart.js"></script>
        <script>
            let jsonData = ${json};
            loadChartWithData(jsonData);
            userAreaProc(jsonData);
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
        <script src="/project/assets/js/datatables-simple-demo.js"></script>
    </body>
</html>
