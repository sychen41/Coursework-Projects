<p>This is a quick overview of some features.</p>

<?php
preg_match('/MSIE (.*?);/', $_SERVER['HTTP_USER_AGENT'], $matches);

if (count($matches)>1){
	// using IE
	$version = $matches[1];
	if($version < 10){
		?>
		    <ul class="states">
		      <li class="warning">Detected IE <?php echo $version; ?>.  Please upgrade to at least IE 10 to use this demo, or use Chrome, Safari or FireFox instead.</li>
		    </ul>
		<?php
	}
}
?>