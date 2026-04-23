<%-- メニューJSP --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:import url="/common/base.jsp">
	<c:param name="title">
		得点管理システム
	</c:param>

	<c:param name="scripts">
		<style>
			.netflix-menu-wrap {
				background: #0b0b0b;
				border-radius: 18px;
				padding: 24px;
				margin: 20px 10px 20px 0;
				box-shadow: 0 12px 30px rgba(0, 0, 0, 0.35);
			}

			.netflix-menu-title {
				background: linear-gradient(90deg, #111, #1b1b1b);
				color: #fff;
				border-left: 6px solid #e50914;
				border-radius: 10px;
				padding: 14px 18px;
				font-weight: 700;
				letter-spacing: .5px;
				box-shadow: 0 6px 16px rgba(0,0,0,.25);
			}

			.netflix-menu-row {
				row-gap: 20px;
			}

			.netflix-card {
				min-height: 180px;
				background: linear-gradient(180deg, #181818, #111);
				border: 1px solid #262626;
				border-radius: 16px;
				color: #fff;
				transition: transform .28s ease, box-shadow .28s ease, border-color .28s ease;
				cursor: pointer;
				position: relative;
				overflow: hidden;
				animation: fadeInUp .5s ease;
			}

			.netflix-card::before {
				content: "";
				position: absolute;
				inset: 0;
				background: linear-gradient(135deg, rgba(229, 9, 20, 0.10), transparent 55%);
				opacity: .9;
				pointer-events: none;
			}

			.netflix-card:hover {
				transform: translateY(-6px) scale(1.02);
				box-shadow: 0 18px 30px rgba(0, 0, 0, 0.45);
				border-color: #3a3a3a;
			}

			.netflix-card-body {
				position: relative;
				z-index: 1;
				width: 100%;
				padding: 24px 16px;
			}

			.netflix-card-title {
				color: #fff;
				font-size: 1.6rem;
				font-weight: 700;
				margin-bottom: 10px;
			}

			.netflix-card a {
				color: #fff;
				text-decoration: none;
				font-weight: 600;
			}

			.netflix-card a:hover {
				color: #e50914;
			}

			.netflix-mini-link {
				display: inline-block;
				margin-top: 8px;
				padding: 8px 14px;
				border-radius: 999px;
				background: #e50914;
				color: #fff !important;
				font-size: 0.95rem;
				font-weight: 700;
				text-decoration: none;
				transition: background .2s ease, transform .2s ease;
			}

			.netflix-mini-link:hover {
				background: #b20710;
				transform: translateY(-1px);
			}

			.netflix-subtext {
				color: #cfcfcf;
				font-size: 0.95rem;
			}

			@keyframes fadeInUp {
				from {
					opacity: 0;
					transform: translateY(18px);
				}
				to {
					opacity: 1;
					transform: translateY(0);
				}
			}

			@media (max-width: 991px) {
				.netflix-card {
					min-height: 150px;
				}

				.netflix-card-title {
					font-size: 1.3rem;
				}
			}
		</style>

		<script>
			document.addEventListener("DOMContentLoaded", function() {
				const cards = document.querySelectorAll(".netflix-card[data-link]");
				cards.forEach(function(card) {
					card.addEventListener("click", function(e) {
						if (e.target.tagName.toLowerCase() !== "a") {
							window.location.href = this.dataset.link;
						}
					});
				});
			});
		</script>
	</c:param>

	<c:param name="content">
		<section class="netflix-menu-wrap">
			<h2 class="h3 mb-4 netflix-menu-title">メニュー</h2>

			<div class="row text-center px-2 my-4 netflix-menu-row">

				<div class="col-md-6 col-xl-3 d-flex">
					<div class="netflix-card w-100 d-flex align-items-center justify-content-center"
						data-link="${pageContext.request.contextPath}/StudentList.action">
						<div class="netflix-card-body">
							<div class="netflix-card-title">学生管理</div>
							<div class="netflix-subtext">学生情報の登録・更新・確認</div>
						</div>
					</div>
				</div>

				<div class="col-md-6 col-xl-3 d-flex">
					<div class="netflix-card w-100 d-flex align-items-center justify-content-center">
						<div class="netflix-card-body">
							<div class="netflix-card-title">成績管理</div>
							<div class="netflix-subtext mb-2">成績の登録と一覧確認</div>
							<div>
								<a class="netflix-mini-link me-2"
									href="${pageContext.request.contextPath}/scoremanager/main/test_regist.jsp">成績登録</a>
								<a class="netflix-mini-link"
									href="${pageContext.request.contextPath}/scoremanager/main/test_list.jsp">成績参照</a>
							</div>
						</div>
					</div>
				</div>

				<div class="col-md-6 col-xl-3 d-flex">
					<div class="netflix-card w-100 d-flex align-items-center justify-content-center"
						data-link="${pageContext.request.contextPath}/scoremanager/main/subject_list.jsp">
						<div class="netflix-card-body">
							<div class="netflix-card-title">科目管理</div>
							<div class="netflix-subtext">科目情報の管理</div>
						</div>
					</div>
				</div>

				<div class="col-md-6 col-xl-3 d-flex">
					<div class="netflix-card w-100 d-flex align-items-center justify-content-center"
						data-link="${pageContext.request.contextPath}/scoremanager/main/class_list.jsp">
						<div class="netflix-card-body">
							<div class="netflix-card-title">クラス管理</div>
							<div class="netflix-subtext">クラス情報の登録・確認</div>
						</div>
					</div>
				</div>

			</div>
		</section>
	</c:param>
</c:import>