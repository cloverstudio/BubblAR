<?php
class ModelController extends AppController {

	var $name = 'Model';
	var $uses = array('ModelObject');
	var $layout = 'admin';
	
	var $rows = 20;
	
	function beforeFilter(){
		parent::beforeFilter();
		
		$this->checkLogin();
	}
	
	function _readList($page = 1){

/*
		$this->set('list',$this->ModelObject->find('all',array(
			'conditions' => "user_id = {$this->loginUser['id']}",
			'order' => 'created desc',
			'limit' => $this->rows,
			'offset' => $this->rows * ($page - 1)
		)));
*/

		$this->set('list',$this->ModelObject->find('all',array(
			'order' => 'created desc',
			'limit' => $this->rows,
			'offset' => $this->rows * ($page - 1)
		)));

		
		$count = $this->ModelObject->find('count');
		
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
	
	function edit($id = 0){
			
		if(!empty($this->data)){
			$this->ModelObject->create($this->data);
			$this->ModelObject->validates();
			$validationResult = $this->ModelObject->validationErrors;
			
			if(count($validationResult) == 0){
				$oldData = $this->ModelObject->findById($id);
				$this->data['ModelObject']['updated'] = date("Y-m-d H:i:s");
				
				$objectDir = Configure::read('dataDirPath');
				if (is_uploaded_file($this->data['ModelObject']['_md2object']['tmp_name'])){
	
					$fileName = "model_" . $id;
					$tmp = explode('.',$this->data['ModelObject']['_md2object']['name']);
	
					$original_file_name = $this->data['ModelObject']['_md2object']['name'];
					$ext = $tmp[count($tmp) - 1];
					$fileName = $fileName . '.' . $ext;
		
					move_uploaded_file($this->data['ModelObject']['_md2object']['tmp_name'],
						$objectDir . $fileName);

					$this->data['ModelObject']['md2filename'] = $fileName;
				}
			
				if (is_uploaded_file($this->data['ModelObject']['_texture']['tmp_name'])){
	
					$fileName = "texture_" . $id;
					$tmp = explode('.',$this->data['ModelObject']['_texture']['name']);
	
					$original_file_name = $this->data['ModelObject']['_texture']['name'];
					$ext = $tmp[count($tmp) - 1];
					$fileName = $fileName . '.' . $ext;
		
					move_uploaded_file($this->data['ModelObject']['_texture']['tmp_name'],
						$objectDir . $fileName);

					$this->data['ModelObject']['texturefilename'] = $fileName;
				}
				

				$data = am($oldData['ModelObject'],$this->data['ModelObject']);
				
				$this->ModelObject->save($data);
				$this->set('okmsg',__('Model modified.',true));
			}else{
				$this->set('errmsg',__('Pleaes input values properly.',true));
			}
			
		}else{
			$this->data = $this->ModelObject->findById($id);
								
			if(!$this->data )
				$this->redirect('index');
		}

		$this->set('id',$id);
		
	}
	
	function add() {
		
		if(!empty($this->data)){
			
			$this->ModelObject->create($this->data);
			$this->ModelObject->validates();
			
			//Check does exist md2 file
			if (!isset($this->data['ModelObject']['_md2object']['tmp_name'])){
				$this->ModelObject->validationErrors['_md2object'] = 'required';
			}
			
			//Check does exist texture file
			if (!isset($this->data['ModelObject']['_texture']['tmp_name'])){
				$this->ModelObject->validationErrors['_texture'] = 'required';
			}
			
			
			$validationResult = $this->ModelObject->validationErrors;
			
			if(count($validationResult) == 0){
				
				$id = '';
				
				$this->data['ModelObject']['user_id'] = $this->loginUser['id'];
				$this->data['ModelObject']['created'] = date("Y-m-d H:i:s");
				$this->ModelObject->save($this->data);
				
				$id = $this->ModelObject->getLastInsertId();
				$this->data['ModelObject']['id'] = $id;
				
				$objectDir = Configure::read('dataDirPath');

				if (is_uploaded_file($this->data['ModelObject']['_md2object']['tmp_name'])){
	
					$fileName = "model_" . $id;
					$tmp = explode('.',$this->data['ModelObject']['_md2object']['name']);
	
					$original_file_name = $this->data['ModelObject']['_md2object']['name'];
					$ext = $tmp[count($tmp) - 1];
					$fileName = $fileName . '.' . $ext;
		
					move_uploaded_file($this->data['ModelObject']['_md2object']['tmp_name'],
						$objectDir . $fileName);
					
					$this->data['ModelObject']['md2filename'] = $fileName;
				}
			
				if (is_uploaded_file($this->data['ModelObject']['_texture']['tmp_name'])){
	
					$fileName = "texture_" . $id;
					$tmp = explode('.',$this->data['ModelObject']['_texture']['name']);
	
					$original_file_name = $this->data['ModelObject']['_texture']['name'];
					$ext = $tmp[count($tmp) - 1];
					$fileName = $fileName . '.' . $ext;
		
					move_uploaded_file($this->data['ModelObject']['_texture']['tmp_name'],
						$objectDir . $fileName);

					$this->data['ModelObject']['texturefilename'] = $fileName;
				}
				
				$this->ModelObject->save($this->data);
				$this->set('okmsg',__('New model is added.',true));
				unset($this->data['ModelObject']);
				
			}else{
				$this->set('errmsg',__('Pleaes input values properly.',true));
			}
			
		}
		
	}
	
	function delete($id){
		$this->ModelObject->delete($id);
		
		$this->set('infomsg',__('Model is deleted.',true));
		
		$this->redirect('index');
	}
}
?>
