<?php
class LocationObject extends AppModel {

	var $name = 'LocationObject';
	var $useTable = 'objects';

	var $validate = array(
		'latitude' => array(
			'required' => array(
	   			'rule' => 'notEmpty'
	   		),
			'float' => array(
	   			'rule' => array('numeric')
	   		),
		),
		'longitude' => array(
			'required' => array(
	   			'rule' => 'notEmpty'
	   		),
			'float' => array(
	   			'rule' => array('numeric')
	   		),
		),
		'altitude' => array(
			'required' => array(
	   			'rule' => 'notEmpty'
	   		),
			'number' => array(
	   			'rule' => array('numeric')
	   		),
		),
		'title' => array(
			'required' => array(
	   			'rule' => 'notEmpty'
	   		)
		),
		'url' => array(
			'url' => array(
	   			'rule' => '/^http:\/\/.*$/i',
				'allowEmpty' => true,
	   		)
		),
	);
   	
   	

}
?>