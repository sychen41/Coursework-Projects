<h1>Admin Panel</h1>

<a href="<?php echo $exepath; ?>users">User List</a> | <a href="<?php echo $exepath; ?>users/auditlogs">Audit Logs</a> | <a href="<?php echo $exepath; ?>users/approve">Approve Documents</a><br /><br />

<p>List of all users <button class="k-button" type="button" onclick="window.location='<?php echo $exepath; ?>users/addedit'">Add User</button></p>  
<?php if(count($users) == 0) {
	    echo "<p>No users found...</p>";
	  } else {
	  ?>

	    <table id="user_list" style="font-size:11px;">
	    	<thead>
	    		<tr>
	    			<th>Action</th>
	    			<th data-field="name">Username</th>
	    			<th data-field="email">Email</th>
	    			<th data-field="group">Type</th>
	    			<th data-field="last_login">Last Login</th>
	    		</tr>
	    	</thead>
	    	<tbody>
	  <?php
	  	foreach($users as $user):?>
         <tr>
         	<td>
         		<?php if($user->user_id != $myUser->user_id) { ?>
         		  <a href="<?php echo $exepath; ?>users/become?user_id=<?php echo $user->user_id ?>">Become</a> | 
         		<?php } ?>
         		<a href="<?php echo $exepath; ?>users/addedit?user_id=<?php echo $user->user_id ?>">Edit</a> | <a href="javascript:deleteUser(<?php echo $user->user_id ?>)">Delete</a>
         	</td>
         	<td><?php echo $user->name;?></td>
         	<td><?php echo $user->email;?></td>
         	<td><?php if($user->group == 100) { echo "Admin"; } else { echo "User"; } ?></td>
         	<td><?php 
         			$dte = date('m/d/Y H:i:s', strtotime($user->last_login));
         			if($dte == '12/31/1969 19:00:00'){
         				echo "Never";
         			}
         			else{
         				echo $dte;
         			}
         		?></td>
         </tr>
<?php endforeach; ?>
  </tbody>
</table>
<script>
$(document).ready(function() {
    $("#user_list").kendoGrid({
    	sortable: true
    });
});

function deleteUser(userid){
	if(confirm("Are you sure you want to delete this user?")){
		window.location = '<?php echo $exepath; ?>users/delete?user_id=' + userid;
	}
}
</script>
<?php } ?>