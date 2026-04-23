<%-- ログインJSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:import url="/common/base.jsp">
	<c:param name="title">
		得点管理システム | ログイン
	</c:param>

	<c:param name="scripts">
		<style>
			.login-shell {
				min-height: calc(100vh - 120px);
				display: flex;
				align-items: center;
				justify-content: center;
				padding: 40px 16px 56px;
				background:
					linear-gradient(rgba(0,0,0,.72), rgba(0,0,0,.82)),
					radial-gradient(circle at top left, rgba(229,9,20,.18), transparent 30%),
					radial-gradient(circle at bottom right, rgba(229,9,20,.12), transparent 28%),
					#000;
				border-radius: 18px;
			}

			.login-card {
				width: 100%;
				max-width: 470px;
				background: rgba(20,20,20,0.96);
				border: 1px solid #2b2b2b;
				border-radius: 20px;
				box-shadow: 0 24px 48px rgba(0,0,0,.45);
				overflow: hidden;
			}

			.login-header {
				padding: 30px 30px 18px;
				background: linear-gradient(180deg, rgba(229,9,20,.15), rgba(20,20,20,0));
				border-bottom: 1px solid #252525;
			}

			.login-badge {
				display: inline-flex;
				align-items: center;
				gap: 8px;
				padding: 7px 14px;
				border-radius: 999px;
				font-size: 12px;
				font-weight: 700;
				color: #fff;
				background: rgba(229,9,20,.18);
				border: 1px solid rgba(229,9,20,.35);
				margin-bottom: 14px;
			}

			.login-title {
				font-size: 2rem;
				font-weight: 800;
				letter-spacing: .02em;
				color: #fff;
				margin: 0;
			}

			.login-subtitle {
				margin-top: 8px;
				margin-bottom: 0;
				color: #bdbdbd;
				font-size: .96rem;
				line-height: 1.7;
			}

			.login-body {
				padding: 26px 30px 30px;
			}

			.error-box {
				background: rgba(229,9,20,.14);
				border: 1px solid rgba(229,9,20,.35);
				color: #ffb3b8;
				padding: 14px 16px;
				border-radius: 14px;
				margin-bottom: 20px;
			}

			.error-box ul {
				margin: 0;
				padding-left: 1.2rem;
			}

			.form-group-modern {
				margin-bottom: 18px;
			}

			.form-floating > .form-control {
				height: 60px;
				border-radius: 14px;
				border: 1px solid #333;
				background: #1b1b1b;
				color: #fff;
				box-shadow: none;
				padding-left: 1rem;
				padding-right: 1rem;
				transition: all .2s ease;
			}

			.form-floating > .form-control:focus {
				background: #222;
				color: #fff;
				border-color: #e50914;
				box-shadow: 0 0 0 .22rem rgba(229,9,20,.16);
			}

			.form-floating > .form-control::placeholder {
				color: #888;
			}

			.form-floating > label {
				padding-left: 1rem;
				color: #9ca3af;
				font-weight: 500;
			}

			.login-options {
				display: flex;
				align-items: center;
				justify-content: space-between;
				flex-wrap: wrap;
				gap: 12px;
				margin-top: 4px;
				margin-bottom: 22px;
			}

			.form-check-modern {
				background: #181818;
				border: 1px solid #2d2d2d;
				padding: 10px 14px;
				border-radius: 999px;
				display: inline-flex;
				align-items: center;
			}

			.form-check-modern .form-check-input {
				margin-top: 0;
				margin-right: 8px;
				cursor: pointer;
				background-color: #111;
				border-color: #666;
			}

			.form-check-modern .form-check-input:checked {
				background-color: #e50914;
				border-color: #e50914;
			}

			.form-check-modern .form-check-label {
				color: #e5e5e5;
				font-size: .94rem;
				cursor: pointer;
				user-select: none;
			}

			.login-btn {
				width: 100%;
				height: 56px;
				border: none;
				border-radius: 14px;
				font-size: 1rem;
				font-weight: 800;
				letter-spacing: .03em;
				color: #fff;
				background: linear-gradient(180deg, #e50914, #b20710);
				box-shadow: 0 14px 28px rgba(229,9,20,.22);
				transition: all .2s ease;
			}

			.login-btn:hover {
				transform: translateY(-1px);
				filter: brightness(1.05);
				box-shadow: 0 18px 30px rgba(229,9,20,.28);
			}

			.login-btn:active {
				transform: translateY(0);
			}

			.login-btn:disabled {
				opacity: .8;
				cursor: not-allowed;
			}

			.login-footer-note {
				margin-top: 16px;
				text-align: center;
				font-size: .9rem;
				color: #8f8f8f;
			}

			.input-icon-wrap {
				position: relative;
			}

			.input-status {
				position: absolute;
				right: 16px;
				top: 50%;
				transform: translateY(-50%);
				font-size: .8rem;
				color: #888;
				pointer-events: none;
				transition: .2s ease;
			}

			.form-control:focus + label + .input-status,
			.form-control:not(:placeholder-shown) + label + .input-status {
				color: #e50914;
			}

			@media (max-width: 576px) {
				.login-shell {
					padding: 18px 8px 28px;
				}

				.login-header,
				.login-body {
					padding-left: 18px;
					padding-right: 18px;
				}

				.login-title {
					font-size: 1.65rem;
				}
			}
		</style>

		<script type="text/javascript">
			$(function() {
				const $passwordInput = $('#password-input');
				const $passwordDisplay = $('#password-display');
				const $loginForm = $('#login-form');
				const $loginButton = $('#login-button');

				$passwordDisplay.on('change', function() {
					$passwordInput.attr('type', $(this).prop('checked') ? 'text' : 'password');
				});

				$loginForm.on('submit', function() {
					$loginButton.prop('disabled', true);
					$loginButton.val('ログイン中...');
				});
			});
		</script>
	</c:param>

	<c:param name="content">
		<div class="login-shell">
			<section class="login-card">
				<div class="login-header">
					<div class="login-badge">
						<span>MYFLIX STYLE</span>
					</div>
					<h2 class="login-title">ログイン</h2>
					<p class="login-subtitle">
						教員IDとパスワードを入力して、得点管理システムにサインインしてください。
					</p>
				</div>

				<div class="login-body">
					<form id="login-form" action="${pageContext.request.contextPath}/LoginExecute.action" method="post">
						<c:if test="${errors.size() > 0}">
							<div class="error-box">
								<ul>
									<c:forEach var="error" items="${errors}">
										<li>${error}</li>
									</c:forEach>
								</ul>
							</div>
						</c:if>

						<div class="form-group-modern">
							<div class="form-floating input-icon-wrap">
								<input
									class="form-control"
									autocomplete="off"
									id="id-input"
									maxlength="20"
									name="id"
									placeholder="半角でご入力下さい"
									style="ime-mode: disabled"
									type="text"
									value="${id}"
									required />
								<label for="id-input">教員ID</label>
								<span class="input-status">ID</span>
							</div>
						</div>

						<div class="form-group-modern">
							<div class="form-floating input-icon-wrap">
								<input
									class="form-control"
									autocomplete="off"
									id="password-input"
									maxlength="20"
									name="password"
									placeholder="20文字以内の半角英数字でご入力下さい"
									style="ime-mode: disabled"
									type="password"
									required />
								<label for="password-input">パスワード</label>
								<span class="input-status">PW</span>
							</div>
						</div>

						<div class="login-options">
							<div class="form-check form-check-modern">
								<input class="form-check-input" id="password-display" name="chk_d_ps" type="checkbox" />
								<label class="form-check-label" for="password-display">
									パスワードを表示
								</label>
							</div>
						</div>

						<div>
							<input
								id="login-button"
								class="login-btn"
								type="submit"
								name="login"
								value="ログイン" />
						</div>

						<p class="login-footer-note">
							Secure access for teachers and academic staff.
						</p>
					</form>
				</div>
			</section>
		</div>
	</c:param>
</c:import>