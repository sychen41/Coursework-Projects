<!DOCTYPE html>
<head>
	<meta charset="utf-8">
	<title><?php echo $title ?></title>
	<link media="all" rel="stylesheet" type="text/css" href="<?php echo $subpath; ?>css/all.css" />
	<link media="all" rel="stylesheet" type="text/css" href="<?php echo $subpath; ?>css/kendo.common.min.css" />
	<link media="all" rel="stylesheet" type="text/css" href="<?php echo $subpath; ?>css/kendo.default.min.css" />

	<script type="text/javascript" src="<?php echo $subpath; ?>js/jquery.min.js"></script>
	<script type="text/javascript" src="<?php echo $subpath; ?>js/kendo.all.min.js"></script>
	<script type="text/javascript" src="<?php echo $subpath; ?>js/jquery.main.js"></script>
	<script type="text/javascript" src="<?php echo $subpath; ?>js/jquery-ui.min.js"></script>
	<link href="<?php echo $subpath; ?>js/jquery-ui.css" rel="stylesheet" type="text/css"/>
	<link rel="stylesheet" href="<?php echo $subpath; ?>js/jquery.signaturepad.css">
	<script type="text/javascript" src="<?php echo $subpath; ?>js/jquery.signaturepad.js"></script>
	<!--[if lt IE 9]><link rel="stylesheet" type="text/css" href="<?php echo $subpath; ?>css/ie.css" /><![endif]-->
</head>
<body>
	<div id="wrapper">
		<div id="content">
			<div class="c1">
				<div class="controls">
					<div class="profile-box" >
						<span class="profile" >
								<img class="image" src="<?php echo $subpath; ?>images/img1.png" alt="image description" width="26" height="26" />
								<span class="text-box" style="margin:2px;">
									<strong class="name"><?php echo $myUser->name ?>
										<?php if($old_user_id != 0) { ?>
										 <br /><a href="<?php echo $exepath; ?>users/backtome">[Back to me]</a>
										<?php } ?>
									</strong>
								</span>
						</span>
						<a href="<?php echo $exepath; ?>users/logout" class="btn-on">On</a>
					</div>
				</div>
				<div class="tabs">
					<div id="tab-1" class="tab">
						<article>
							<div class="text-section">
								<?php if($active_tab == "intro" && $has_message) { 
									include($message_handler);
								} ?>

								<h1>Introduction</h1>
								<?php include($home_view); ?>
							</div>
						</article>
					</div>
					<div id="tab-2" class="tab">
						<article>
							<div class="text-section">
								<?php if($active_tab == "signatures" && $has_message) { 
									include($message_handler);
								} ?>
								<?php include($signatures_view); ?>
							</div>
						</article>
					</div>

					<div id="tab-3" class="tab">
						<article>
							<div class="text-section">
								<?php if($active_tab == "settings" && $has_message) { 
									include($message_handler);
								} ?>
								<h1>Account Settings</h1>
								<?php include($account_settings); ?>
							</div>
						</article>
					</div>

					<?php if($admin_view != "") { ?>
					<div id="tab-4" class="tab">
						<article>
							<div class="text-section">
								<?php if($active_tab == "admin" && $has_message) { 
									include($message_handler);
								} ?>
								<?php include($admin_view); ?>
							</div>
						</article>
					</div>
					
					<?php } ?>

				</div>
			</div>
		</div>
		<aside id="sidebar">
			<strong class="logo"></strong>
			<ul class="tabset buttons">
				<li <?php if($active_tab == "intro") { echo "class=\"active\""; } ?>>
					<a href="#tab-1" class="ico1"><span>Introduction</span><em></em></a>
					<span class="tooltip"><span>Introduction</span></span>
				</li>
				<li <?php if($active_tab == "signatures") { echo "class=\"active\""; } ?>>
					<a href="#tab-2" class="ico2"><span>Manage Signatures</span><em></em></a>
					<span class="tooltip"><span>Manage Signatures</span></span>
				</li>
				<li <?php if($active_tab == "settings") { echo "class=\"active\""; } ?>>
					<a href="#tab-3" class="ico8"><span>Account Settings</span><em></em></a>
					<span class="tooltip"><span>Account Settings</span></span>
				</li>
				<?php if($admin_view != "") { ?>
				<li <?php if($active_tab == "admin") { echo "class=\"active\""; } ?>>
					<a href="#tab-4" class="ico3"><span>Admin Panel</span><em></em></a>
					<span class="tooltip"><span>Admin Panel</span></span>
				</li>
				
				<?php } ?>
			</ul>
			<span class="shadow"></span>
		</aside>
	</div>
	Copyright &copy; <?php echo date("Y"); ?> Sooper Company
</body>
</html>