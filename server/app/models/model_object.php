<?php
class ModelObject extends AppModel {

	var $name = 'ModelObject';
	var $useTable = 'models';
	
	var $validate = array(

		'name' => array(
			'required' => array(
	   			'rule' => 'notEmpty'
	   		)
		),
		
	);
   	
   	

}
?>