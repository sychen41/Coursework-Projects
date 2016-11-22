<h1>Review Document <a href="<?php echo $exepath; ?>documents">[Return to Document List]</a></h1>

<table>
	<tr>
		<td>Title:</td>
		<td>
	     	<?php echo $this->document->title; ?>
		</td>
	</tr>
	<tr>
		<td valign="top">Content:</td>
		<td>
			<?php echo "{$this->document->content}"; ?> 
		</td>
	</tr>
</table>

