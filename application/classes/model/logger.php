<?php
  class Logger_Model {
  	public static function Log($event){
  		$log = ORM::factory('auditlog');  		

  		$log->user_id = Session::get('user_id');
  		if($log->user_id == '' || $log->user_id == null) $log->user_id = 0;
  		$log->action_date = date('Y-m-d H:i:s');
  		$log->action_name = $event;
  		$log->save();
  	}
  }
?>