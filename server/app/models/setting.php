<?php
class Setting extends AppModel {

	var $name = 'Setting';
	var $useTable = 'settings';
	
	var $validate = array(

		'polis_name' => array(
			'required' => array(
	   			'rule' => 'notEmpty'
	   		)
		),
		'polis_intro' => array(
			'required' => array(
	   			'rule' => 'notEmpty'
	   		)
		),
		
	);

}
?>