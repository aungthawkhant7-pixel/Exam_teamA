<%-- サイドバー --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<ul class="nav nav-pills flex-column mb-auto px-4">
	<li class="nav-item my-3"><a href="${pageContext.request.contextPath}/Menu.action">メニュー</a></li>
	<li class="nav-item mb-3"><a href="${pageContext.request.contextPath}/StudentList.action">学生管理</a></li>
	<li class="nav-item">成績管理</li>
	<li class="nav-item mx-3 mb-3"><a href="${pageContext.request.contextPath}/scoremanager/main/test_regist.jsp">成績登録</a></li>
	<li class="nav-item mx-3 mb-3"><a href="${pageContext.request.contextPath}/TestList.action">成績参照</a></li>
	<li class="nav-item mb-3"><a href="${pageContext.request.contextPath}/SubjectList.action">科目管理</a></li>
	<li class="nav-item mb-3"><a href="${pageContext.request.contextPath}/ClassList.action">クラス管理</a></li>
</ul>
