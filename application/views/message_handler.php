<ul class="states">
  <?php if($error_message != '') { ?><li class="error"><?php echo $error_message; ?></li><?php } ?>
  <?php if($warning_message != '') { ?><li class="warning"><?php echo $warning_message; ?></li><?php } ?>
  <?php if($success_message != '') { ?><li class="succes"><?php echo $success_message; ?></li><?php } ?>		
</ul>