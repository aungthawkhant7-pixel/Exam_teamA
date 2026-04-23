<%-- ログアウトJSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:import url="/common/base.jsp">
	<c:param name="title">
		得点管理システム | ログアウト
	</c:param>

	<c:param name="scripts">
		<style>
			.logout-shell {
				min-height: calc(100vh - 140px);
				display: flex;
				align-items: center;
				justify-content: center;
				padding: 40px 16px;
				background:
					linear-gradient(rgba(0,0,0,.76), rgba(0,0,0,.84)),
					radial-gradient(circle at top left, rgba(229,9,20,.18), transparent 28%),
					radial-gradient(circle at bottom right, rgba(229,9,20,.10), transparent 26%),
					#000;
				border-radius: 18px;
			}

			.logout-card {
				width: 100%;
				max-width: 460px;
				background: rgba(20,20,20,.96);
				border: 1px solid #2a2a2a;
				border-radius: 18px;
				box-shadow: 0 24px 48px rgba(0,0,0,.45);
				overflow: hidden;
				text-align: center;
			}

			.logout-header {
				padding: 26px 24px 16px;
				background: linear-gradient(180deg, rgba(229,9,20,.14), rgba(20,20,20,0));
				border-bottom: 1px solid #252525;
			}

			.logout-title {
				margin: 0;
				font-size: 1.9rem;
				font-weight: 800;
				color: #fff;
				letter-spacing: .03em;
			}

			.logout-body {
				padding: 28px 24px 32px;
			}

			.logout-message {
				background: rgba(229,9,20,.12);
				border: 1px solid rgba(229,9,20,.30);
				color: #ffd6d9;
				border-radius: 14px;
				padding: 16px 18px;
				font-size: 1rem;
				font-weight: 600;
				margin-bottom: 22px;
			}

			.logout-link {
				display: inline-block;
				padding: 12px 26px;
				border-radius: 10px;
				background: linear-gradient(180deg, #e50914, #b20710);
				color: #fff;
				text-decoration: none;
				font-weight: 700;
				letter-spacing: .02em;
				box-shadow: 0 14px 28px rgba(229,9,20,.24);
				transition: all .2s ease;
			}

			.logout-link:hover {
				color: #fff;
				transform: translateY(-1px);
				filter: brightness(1.05);
			}

			.logout-note {
				margin-top: 16px;
				color: #9a9a9a;
				font-size: .92rem;
			}
		</style>
	</c:param>

	<c:param name="content">
		<div class="logout-shell">
			<section class="logout-card">
				<div class="logout-header">
					<h2 class="logout-title">ログアウト</h2>
				</div>

				<div class="logout-body">
					<div class="logout-message">
						ログアウトしました
					</div>

					<a class="logout-link" href="${pageContext.request.contextPath}/Login.action">
						ログイン画面へ
					</a>

					<p class="logout-note">
						ご利用ありがとうございました。
					</p>
				</div>
			</section>
		</div>
	</c:param>
</c:import>