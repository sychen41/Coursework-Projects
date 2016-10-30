<form id="documentForm" action="<?php echo $exepath; ?>documents/saveEdit" method="POST" onsubmit="return submitForm();">
	<input type="hidden" id="glyph" name="glyph" />
	<h1>Edit Document <a href="<?php echo $exepath; ?>documents">[Return to Document List]</a></h1>
	
	<table>
		<tr>
			<input type="hidden" name="document_id" <?php echo " value=\"{$this->document->document_id}\""; ?> />
			<td>Title:</td>
			<td>
		      <input class="k-textbox" type="text" maxlength="100" name="title" id="title" <?php echo " value=\"{$this->document->title}\""; ?> required validationMessage="Please enter a title" />
			</td>
		</tr>
		<tr>
			<td valign="top">Content:</td>
			<td>
		      <textarea id="editor" name="content" rows="10" cols="30" style="height:440px"><?php echo $this->document->content; ?>
		      </textarea>
			</td>
		</tr>
	</form>
		<tr>
			<td>Signature:</td>
			<td valign="top">
				<form method="post" action="" class="sigPad" id="sigPadInput">
					<ul class="sigNav">
				      <li class="clearButton"><a href="#clear" style="color: #000;">Clear</a></li>
				    </ul>
				    <div class="sig sigWrapper">
				      <div class="typed"></div>
				      <canvas class="pad" width="98" height="55"></canvas>
				      <input type="hidden" name="output" class="output">
				    </div>
				</form>
			</td>
		</tr>
	</table>

	<button class="k-button" type="submit">Submit For Approval</button>

</form>

<script type="text/javascript">
var inputSig = null;
$(document).ready(function() {
   // create Editor from textarea HTML element with default set of tools
   $("#editor").kendoEditor();

   inputSig = $('#sigPadInput').signaturePad();
   inputSig.setPenWidth(<?php echo $myUser->pen_thickness ?>);
});

function submitForm(){
    var glyph = inputSig.getSignatureString();
    if(glyph == "[]" || glyph == undefined){
        alert("Please draw your signature on the signature canvas.");
        return false;
    }

    $('#glyph').val(glyph);

    return true;
}
</script>