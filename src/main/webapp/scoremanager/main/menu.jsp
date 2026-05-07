<%-- メニューJSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:import url="/common/base.jsp">
	<c:param name="title">
		得点管理システム
	</c:param>

	<c:param name="scripts"></c:param>

	<c:param name="content">
		<section class="me-4">
			<h2 class="h3 mb-3 fw-normal bg-secondary bg-opacity-10 py-2 px-4">メニュー</h2>

			<div class="row text-center px-4 my-4">

				<div class="col-md-3 mb-3">
					<div class="card h-100">
						<div class="card-body">
							<h5 class="card-title">学生管理</h5>
							<a href="${pageContext.request.contextPath}/StudentList.action">学生管理</a>
						</div>
					</div>
				</div>

				<div class="col-md-3 mb-3">
					<div class="card h-100">
						<div class="card-body">
							<h5 class="card-title">成績管理</h5>
							<p>
								<a href="${pageContext.request.contextPath}/scoremanager/main/test_regist.jsp">成績登録</a>
							</p>
							<p>
								<a href="${pageContext.request.contextPath}/TestList.action">成績参照</a>
							</p>
						</div>
					</div>
				</div>

				<div class="col-md-3 mb-3">
					<div class="card h-100">
						<div class="card-body">
							<h5 class="card-title">科目管理</h5>
							<a href="${pageContext.request.contextPath}/SubjectList.action">科目管理</a>
						</div>
					</div>
				</div>

				<div class="col-md-3 mb-3">
					<div class="card h-100">
						<div class="card-body">
							<h5 class="card-title">クラス管理</h5>
							<a href="${pageContext.request.contextPath}/scoremanager/main/class_list.jsp">クラス管理</a>
						</div>
					</div>
				</div>

			</div>
		</section>
	</c:param>
</c:import>