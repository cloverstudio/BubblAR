<?php
class UserController extends AppController {

	var $name = 'User';
	var $uses = array('User');
	var $rows = 20;
	var $layout = 'admin';
	
	function beforeFilter(){
		parent::beforeFilter();
		
		$this->checkLogin();
	}
	
	function _readList($page = 1){

		$this->set('list',$this->User->find('all',array(
			'order' => 'created desc',
			'limit' => $this->rows,
			'offset' => $this->rows * ($page - 1)
		)));
		
		$count = $this->User->find('count');
		
		$this->set('rows',$this->rows);
		$this->set('count',$count);
		$this->set('pages',ceil($count / $this->rows));
		$this->set('page',$page);
	}
	
	
	function index() {
		
		$this->_readList(1);
		
	}
	
	function page($page = 1) {
		
		$this->_readList($page);
		$this->render('index');
		
	}

	function profile(){
			
		$id = $this->loginUser['id'];
		
		if(!empty($this->data)){
			$this->User->create($this->data);
			$this->User->validates();
			$validationResult = $this->User->validationErrors;
			
			if(count($validationResult) == 0){
				$oldData = $this->User->findById($id);
				$this->data['User']['updated'] = date("Y-m-d H:i:s");				
				$data = am($oldData['User'],$this->data['User']);
				$this->User->save($data);
				$this->set('okmsg',__('You profile is modified.',true));
			}else{
				$this->set('errmsg',__('Pleaes input values properly.',true));
			}
			
		}else{
			$this->data = $this->User->findById($id);
								
			if(!$this->data )
				$this->redirect('index');
		}

		$this->set('id',$id);
		
	}
	
	function edit($id = 0){
			
		if(!empty($this->data)){
			$this->User->create($this->data);
			$this->User->validates();
			$validationResult = $this->User->validationErrors;
			
			if(count($validationResult) == 0){
				$oldData = $this->User->findById($id);
				$this->data['User']['updated'] = date("Y-m-d H:i:s");				
				$data = am($oldData['User'],$this->data['User']);
				$this->User->save($data);
				$this->set('okmsg',__('User modified.',true));
			}else{
				$this->set('errmsg',__('Pleaes input values properly.',true));
			}
			
		}else{
			$this->data = $this->User->findById($id);
								
			if(!$this->data )
				$this->redirect('index');
		}

		$this->set('id',$id);
		
	}
	
	function add() {
		
		if(!empty($this->data)){
			
			$this->User->create($this->data);
			$this->User->validates();

			$validationResult = $this->User->validationErrors;
			
			if(count($validationResult) == 0){
				
				$id = '';
				
				$this->data['User']['user_id'] = $this->loginUser['id'];
				$this->data['User']['created'] = date("Y-m-d H:i:s");
				$this->User->save($this->data);
				
				$id = $this->User->getLastInsertId();
				$this->data['User']['id'] = $id;
				
				$this->User->save($this->data);
				$this->set('okmsg',__('New user is added.',true));
				unset($this->data['User']);
				
			}else{
				$this->set('errmsg',__('Pleaes input values properly.',true));
			}
			
		}
		
	}
	
	function delete($id){
		$this->User->delete($id);
		$this->set('infomsg',__('User is deleted.',true));
		
		$this->_readList(1);
		$this->render('index');
	}
}
?>