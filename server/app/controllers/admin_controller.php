<?php
class AdminController extends AppController {

	var $name = 'Admin';
	var $uses = array('User');
	var $layout = "admin";
	
	
	function beforeFilter(){
		parent::beforeFilter();
		$this->checkLogin();
	}
	
	function index(){
		
		
		
	}
	
	
}
?>
