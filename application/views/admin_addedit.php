<div id="tab-3" class="tab">
	<article>
		<div class="text-section">
			<form id="userForm" action="<?php echo $exepath; ?>users/save" method="POST" onsubmit="return submitForm();">
				<h1>User Administration <a href="<?php echo $exepath; ?>users">[Return to User List]</a></h1>
				<?php if($mode == "edit") { ?>
					<h2>Edit User <?php echo $user->name; ?></h2>
					<input type="hidden" name="user_id" value="<?php echo $user->user_id; ?>" />
				<?php } else { ?>
				    <h2>Add New User</h2>
				<?php } ?>
				
				<table>
					<tr>
						<td>Username:</td>
						<td>
							<?php if($mode == "edit") { echo $user->name; } else { ?>
							  <input class="k-textbox" type="text" maxlength="100" name="username" id="username" required validationMessage="Please enter a username" />
							<?php } ?>
						</td>
					</tr>
					<tr>
						<td>Password:</td>
						<td><input class="k-textbox" type="password" maxlength="100" name="password" id="password" /> <?php if($mode == "edit") { echo "<i> Leave blank to keep current password.</i>"; } ?></td>
					</tr>
					<tr>
						<td>Email:</td>
						<td><input class="k-textbox" type="text" maxlength="100" name="email" id="email" required validationMessage="Please enter an email address" <?php if(isset($user)) { echo " value=\"{$user->email}\""; } ?> /></td>
					</tr>
					<tr>
						<td>Type:</td>
						<td>
							<select id="group" name="group">
								<option value="100" <?php if($user_type == "100") { echo " selected"; } ?>>Admin</option>
								<option value="1" <?php if($user_type == "1") { echo " selected"; } ?>>User</option>
							</select>
						</td>
					</tr>
				</table>

				<button class="k-button" type="submit">Submit</button>

			</form>
		</div>
	</article>

	<script>
		var validator = $("#userForm").kendoValidator().data("kendoValidator"),
                    status = $(".status");

	   $("#group").kendoDropDownList();

	   function submitForm(){
			if (validator.validate()) {
				return true;
			}
			else{
				alert("Please fix your input values to proceed.");
				return false;
			}
	   }
	</script>
</div>