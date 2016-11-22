<?php
return array(
	'routes' => array(
		array('default', '(/<controller>(/<action>(/<id>)))', array(
				'controller' => 'users',
				'action' => 'index'
			)
		),
	),
	'modules' => array('database', 'orm', 'cache'),
    'basepath'=>'/sandbox/cisc474_p2/'
);
