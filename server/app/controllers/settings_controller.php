<?php
class SettingsController extends AppController {
	
	var $name = 'Settings';
	var $layout = 'admin';
	var $uses = array("Setting");
	
	function beforeFilter(){
		parent::beforeFilter();
		
		$this->checkLogin();
	}
	
	function index(){
		$allData = $this->Setting->find('all');
		foreach($allData as $value){
			$this->data['Setting'][$value['Setting']['s_key']] = $value['Setting']['s_value'];
		}
	}
	
	function edit(){
		
		App::import('Vendor', 'SimpleImage', array('file' => 'SimpleImage.php'));
		
		$allDataTmp = $this->Setting->find('all');
		$allData = array();
		foreach($allDataTmp as $value){
			$allData[$value['Setting']['s_key']] = $value['Setting']['s_value'];
		}
		
		if(!empty($this->data)){
		
			$this->Setting->create($this->data);
			$this->Setting->validates();
			$validationResult = $this->Setting->validationErrors;

			$objectDir = Configure::read('dataDirPath');
			if (isset($this->data['Setting']['_icon']) && is_uploaded_file($this->data['Setting']['_icon']['tmp_name'])){
	
				$fileName = "polisIcon";
				$tmp = explode('.',$this->data['Setting']['_icon']['name']);
	
				$original_file_name = $this->data['Setting']['_icon']['name'];
				$ext = $tmp[count($tmp) - 1];
				$fileName = $fileName . '.' . $ext;
	
				$allowed = Configure::read('allowedImageFormats');
				if(in_array($ext,$allowed)){
					move_uploaded_file($this->data['Setting']['_icon']['tmp_name'],$objectDir . $fileName);
					$this->data['Setting']['iconname'] = $fileName;
					
					//resize image
					$image = new SimpleImage();
					$image->load($objectDir . $fileName);
					$image->fitArea(57,57);
					$image->save($objectDir . $fileName);
					
					
				}else{
					$this->Setting->validationErrors['_icon'] = 'format';
				}
			}else{
				$this->data['Setting']['iconname'] = $allData['iconname'];
			}
				
				
			if (isset($this->data['Setting']['_pic']) && is_uploaded_file($this->data['Setting']['_pic']['tmp_name'])){
	
				$fileName = "polisPic";
				$tmp = explode('.',$this->data['Setting']['_pic']['name']);
	
				$original_file_name = $this->data['Setting']['_pic']['name'];
				$ext = $tmp[count($tmp) - 1];
				$fileName = $fileName . '.' . $ext;
	
				$allowed = Configure::read('allowedImageFormats');
				if(in_array($ext,$allowed)){
					move_uploaded_file($this->data['Setting']['_pic']['tmp_name'],$objectDir . $fileName);
					$this->data['Setting']['picturename'] = $fileName;
					
					//resize image
					$image = new SimpleImage();
					$image->load($objectDir . $fileName);
					$image->fitArea(128,128);
					$image->save($objectDir . $fileName);
					
				}else{
					$this->Setting->validationErrors['_pic'] = 'format';
				}
			}else{
				$this->data['Setting']['picturename'] = $allData['picturename'];
			}
			
			if(count($validationResult) == 0){
			
				unset($this->data['Setting']['_icon']);
				unset($this->data['Setting']['_pic']);
		
				
				foreach($this->data['Setting'] as $key => $value){
					
					$data = $this->Setting->findBySKey($key);
					
					if(!$data){
						
						$insertData = array(
							's_key' => $key,
							's_value' => $value,
							'created' => date("Y-m-d H:i:s")
						);
		
						$this->Setting->create();
						$this->Setting->save($insertData);
						
						
					}else{
						$data['Setting']['s_value'] = $value;
						$this->Setting->save($data);
					}
				}
			}else{
			
				$this->set('errmsg',__('Pleaes input values properly.',true));
			
			}
		}
				
		$this->render('index');
	}
	
}

?>