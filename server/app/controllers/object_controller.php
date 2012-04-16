<?php
class ObjectController extends AppController {

	var $name = 'Object';
	var $uses = array('LocationObject','ModelObject');
	var $helpers = array('Text');
	var $layout = 'admin';
	
	var $rows = 10;

	function beforeFilter(){
		parent::beforeFilter();
		
		$this->checkLogin();
	}
	
	function _readList($page = 1){
		
		$labels = $this->LocationObject->find('all',array(
			'conditions' => "user_id = {$this->loginUser['id']}",
			'order' => 'created asc',
			'limit' => $this->rows,
			'offset' => $this->rows * ($page - 1)
		));
		$this->set('list',$labels);
		
		$count = $this->LocationObject->find('count',array(
			'conditions' => "user_id = {$this->loginUser['id']}",
		));
		$this->set('rows',$this->rows);
		$this->set('count',$count);
		$this->set('pages',ceil($count / $this->rows));
		$this->set('page',$page);
		
		/*
		$this->set('modelList',$this->ModelObject->find('list',array(
			'conditions' => "user_id = {$this->loginUser['id']}",
			'fields' => array('id','name'),
		)));
		*/

		$this->set('modelList',$this->ModelObject->find('list',array(
			'fields' => array('id','name'),
		)));

		
	}
	
	function page($page = 1) {
		
		$this->_readList($page);
		$this->render('index');
		
	}
	
	function index() {
		$this->_readList(1);
	}
	
	function edit($id = 0){
		
		App::import('Vendor', 'SimpleImage', array('file' => 'SimpleImage.php'));
		
		$objectDir = Configure::read('dataDirPath');
		
		
		//if delete picture
		if(isset($_POST['deletepic'])){
			$data = $this->LocationObject->findById($this->data['LocationObject']['id']);
			$data['LocationObject']['picfilename'] = '';
			$this->LocationObject->save($data);
			$this->redirect("/object/edit/" . $this->data['LocationObject']['id']);
		}
		
		if(!empty($this->data)){
			
			$this->LocationObject->create($this->data);
			$this->LocationObject->validates();
			
			if (is_uploaded_file($this->data['LocationObject']['_pic']['tmp_name'])){
			
				$original_file_name = $this->data['LocationObject']['_pic']['name'];
				$tmp = explode('.',$this->data['LocationObject']['_pic']['name']);
				
				$ext = $tmp[count($tmp) - 1];
				$allowed = Configure::read('allowedImageFormats');
				
				if(!in_array($ext,$allowed)){
					$this->LocationObject->validationErrors['_pic'] = 'format';
				}
			}else{
				
				if($this->data['LocationObject']['type'] == 2 && empty($this->data['LocationObject']['picfilename']))
					$this->LocationObject->validationErrors['_pic'] = 'required';
				
			}
					
			$validationResult = $this->LocationObject->validationErrors;

			
			if(count($validationResult) == 0){
				
				if(!empty($this->data['LocationObject']['id'])){

					$id = $this->data['LocationObject']['id'];
					$oldData = $this->LocationObject->findById($id);
					
					$this->data['LocationObject']['updated'] = date("Y-m-d H:i:s");
					$data = am($oldData['LocationObject'],$this->data['LocationObject']);
					
					$this->LocationObject->save($data);

					$this->set('okmsg',__('Selected object is modified.',true));
				}else{
					
					$this->data['LocationObject']['user_id'] = $this->loginUser['id'];
					$this->data['LocationObject']['created'] = date("Y-m-d H:i:s");
					$this->LocationObject->save($this->data);	
					
					
					$id = $this->LocationObject->getLastInsertId();
	
					$this->set('okmsg',__('New label is added.',true));		
				}
				
				
				if (is_uploaded_file($this->data['LocationObject']['_pic']['tmp_name'])){
	
					$fileName = "picture_" . $id;
					$tmp = explode('.',$this->data['LocationObject']['_pic']['name']);
	
					$original_file_name = $this->data['LocationObject']['_pic']['name'];
					$ext = $tmp[count($tmp) - 1];
					//$fileName = $fileName . '.' . $ext;
					$fileName = "picture_" . $original_file_name;
					
					move_uploaded_file($this->data['LocationObject']['_pic']['tmp_name'],
						$objectDir . $fileName);

					//resize image
					$image = new SimpleImage();
					$image->load($objectDir . $fileName);
					$image->fitArea(128,128);
					$image->save($objectDir . $fileName);
					
					$this->data['LocationObject']['picfilename'] = $fileName;
					$this->data['LocationObject']['id'] = $id;
					$this->LocationObject->save($this->data);	
				}
					
			}else{
				
				$this->set('errmsg',__('Pleaes input values properly.',true));
				
			}
		}else{
			$this->data = $this->LocationObject->findById($id);
			
			if(!$this->data )
				$this->redirect('index');
		}
		
		if(isset($_POST['lastLatitude'])){
			
			$this->set("lastLatitude",$_POST['lastLatitude']);
			$this->set("lastLongitude",$_POST['lastLongitude']);
			$this->set("lastZoom",$_POST['lastZoom']);
			
		}
		
		$this->_readList();
		$this->render('index');
	}

	function delete($id){
		$this->LocationObject->delete($id);
		
		$this->set('infomsg',__('Object is deleted.',true));
		
		$this->_readList();
		$this->render('index');
	}
	
}
?>
