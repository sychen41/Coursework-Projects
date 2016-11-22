<!doctype html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	
	<title>Login</title>

	<link rel="stylesheet" href="<?php echo $subpath ?>css/login/reset.css">
	<link rel="stylesheet" href="<?php echo $subpath ?>css/login/animate.css">
	<link rel="stylesheet" href="<?php echo $subpath ?>css/login/styles.css">
</head>
<body>
	<div id="container">
		<?php if(isset($invalid_login)) { echo "Invalid Login!<br />"; } ?>
		<form action="<?php echo $exepath ?>users/login" method="POST">
			<label for="name">Username:</label>
			<input type="name" name="username" maxlength="100">
			<label for="username">Password:</label>
			<input type="password" name="password" maxlength="100">
			<div id="lower">
				<input type="submit" value="Login">
			</div>
		</form>
	</div>
</body>
</html>