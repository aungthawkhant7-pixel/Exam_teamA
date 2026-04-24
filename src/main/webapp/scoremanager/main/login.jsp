<%-- ログインJSP（シンプル版） --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:import url="/common/base.jsp">
	<c:param name="title">
		得点管理システム | ログイン
	</c:param>

	<c:param name="scripts"></c:param>

	<c:param name="content">
		<section class="container mt-5" style="max-width: 400px;">

			<h2 class="mb-4 text-center">ログイン</h2>

			<form action="${pageContext.request.contextPath}/LoginExecute.action" method="post">

				<c:if test="${errors.size() > 0}">
					<div class="alert alert-danger">
						<ul>
							<c:forEach var="error" items="${errors}">
								<li>${error}</li>
							</c:forEach>
						</ul>
					</div>
				</c:if>

				<div class="mb-3">
					<label class="form-label">教員ID</label>
					<input
						class="form-control"
						type="text"
						name="id"
						value="${id}"
						required />
				</div>

				<div class="mb-3">
					<label class="form-label">パスワード</label>
					<input
						class="form-control"
						type="password"
						name="password"
						required />
				</div>

				<div class="mb-3">
					<input type="checkbox" name="chk_d_ps"> パスワードを表示
				</div>

				<div class="d-grid">
					<input
						class="btn btn-primary"
						type="submit"
						name="login"
						value="ログイン" />
				</div>

			</form>

		</section>
	</c:param>
</c:import>