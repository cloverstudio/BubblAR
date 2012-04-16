<?php
class User extends AppModel {

	var $name = 'User';
	var $useTable = 'users';
	
	var $validate = array(

		'loginname' => array(
			'min' => array(
	   			'rule' => array('minLength', 5),
	   		),
			'format' => array(
	   			'rule' => 'alphanumeric'
	   		),
			'required' => array(
	   			'rule' => 'notEmpty'
	   		),
		),
		

		'password' => array(
			'min' => array(
	   			'rule' => array('minLength', 5),
	   		),
			'format' => array(
	   			'rule' => 'alphanumeric'
	   		),
			'required' => array(
	   			'rule' => 'notEmpty'
	   		),
		),
		

		'email' => array(
			'format' => array(
	   			'rule' => 'email'
	   		),
			'required' => array(
	   			'rule' => 'notEmpty'
	   		),
		),
		
	);
   	
   	

}
?>