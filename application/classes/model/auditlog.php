<?php
  class Auditlog_Model extends ORM {
	public $id_field = 'log_id';
	protected $has_many=array(
        'users'=>array(
            'model'=>'user',
            'key'=>'user_id'
        )
    );
  }
 ?>