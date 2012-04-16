<?php
class RegistController extends AppController {

	var $name = 'Regist';
	var $uses = array('User');
	var $layout = "login";
	
	function index(){

		if($this->data){
			
			$loginname = $this->data['login']['loginname'];
			$password = $this->data['login']['password'];
			$test = $this->User->find(" loginname = '{$loginname}' and password = '{$password}'");
			
			if(isset($test['User'])){
				$this->Session->write("loginuser",$test['User']);
				$this->redirect("/admin");
			}else{
				$this->set("error",true);
			}

		}
		
	}
	
	
	function newuser() {

		if(!empty($this->data)){
		
			$this->User->create($this->data);
			$this->User->validates();

			//check duplicated
			$loginname = $this->data['User']['loginname'];
			$test = $this->User->findByLoginname($loginname);
			if(isset($test['User'])){
				$this->User->validationErrors['loginname'] = 'duplicated';
			}
			
			$email = $this->data['User']['email'];
			$test = $this->User->findByEmail($email);
			if(isset($test['User'])){
				$this->User->validationErrors['email'] = 'duplicated';
			}
			
			$validationResult = $this->User->validationErrors;
			
			if(count($validationResult) == 0){
				$this->data['User']['permission'] = PERMISSION_USER;
				$this->data['User']['updated'] = date("Y-m-d H:i:s");
				$this->data['User']['created'] = date("Y-m-d H:i:s");
				$this->User->save($this->data);
				$this->set("saved",true);
				unset($this->data['User']);
			}
	
		}
		
	}
	
	function logout(){
		$this->layout = null;
		$this->Session->delete('loginuser');
		$this->redirect('/');
	}
}
?>
