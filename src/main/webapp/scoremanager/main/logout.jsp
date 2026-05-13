<%-- ログアウトJSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:import url="/common/base.jsp">
	<c:param name="title">
		得点管理システム | ログアウト
	</c:param>

	
	<c:param name="content">
		<div class="logout-shell">1
			<section class="logout-card">
				<div class="logout-header">
				
					<h2 class="logout-title" style="background-color: #f8f9fa;">ログアウト</h2>
				</div>

				<div class="logout-body">
					<div class="logout-message" style="background-color:#8fb9a4">
					<div class="text-center">
					
						ログアウトしました
						</div>
						
					</div>

					<a class="logout-link" href="${pageContext.request.contextPath}/Login.action">
						ログイン
					</a>

					
				</div>
			</section>
		</div>
	</c:param>
</c:import>