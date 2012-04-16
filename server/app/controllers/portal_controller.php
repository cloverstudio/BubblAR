<?php
class PortalController extends AppController {

	var $name = 'Portal';
	var $uses = array('LocationObject','ModelObject','User','Setting');
	var $layout = false;
	
	function _strip($text){
		$text = str_replace("\t","",$text);
		$text = str_replace("\r\n","",$text);
		$text = str_replace("\n","",$text);
		
		//if($limit > 0){
			//mb_substr($text,0,$limit);
		//}
		
		return $text;
	}
	
	function _outputTsv($data){
		
		$output = "\n";
		
		foreach($data as $row){
			
			foreach($row as $col){
				
				$output .= $col . "\t";
				
			}
			
			$output .= "\n";
			
		}
		
		header("Content-Type: text/plain");
		header('Content-type: text/html; charset=utf-8');
		
		print $output;
	
	}
	
	function index(){
		
		
		
	}
	
	function data($user_id = null){
		
		App::import("Helper","Html");
		$htmlHelper = new HtmlHelper;
		$dataUrl = $htmlHelper->url('/data/',true);
		
		$this->LocationObject->bindModel(
			array('belongsTo' => array(
				'Model' => array(
					'className' => 'Model',
					'foreignKey' => 'model_id'
					)
				)
			)
		);
		
		$query = " 1=1 ";
		
		if($user_id){
			$query = "LocationObject.user_id = {$user_id}";
		} else {
		}
		
		if(isset($_GET['lat'])){
			$lat = $_GET['lat'] + 0.0;
			$query .= " and ( latitude > " . ($lat - 1.0) . " and latitude <= " . ($lat + 1.0) . ")";
		}
		
		if(isset($_GET['lon'])){
			$lon = $_GET['lon'] + 0.0;
			$query .= " and ( longitude > " . ($lon - 1.0) . " and longitude <= " . ($lon + 1.0) . ")";
		}
		
		
		$bubbles = $this->LocationObject->find('all',array(
			'conditions' => $query,
			'order' => 'LocationObject.created asc'
		));
			
		$dataAll = array();
		
		foreach($bubbles as $row){
			
			$data = array();
			
			if($row['LocationObject']['type'] == 0)
				continue;
				
			$data[] = $row['LocationObject']['id'];
			$data[] = $row['LocationObject']['user_id'];
			$data[] = $row['LocationObject']['type'];
			$data[] = $this->_strip($row['LocationObject']['title']);
			$data[] = $row['LocationObject']['url'];
			$data[] = $this->_strip($row['LocationObject']['description']);
			$data[] = $row['LocationObject']['latitude'];
			$data[] = $row['LocationObject']['longitude'];
			$data[] = $row['LocationObject']['altitude'];
			
			if($row['LocationObject']['type'] == 2){
				$data[] = $dataUrl . $row['LocationObject']['picfilename'];
			}

			if($row['LocationObject']['type'] == 3){
			
				$data[] = $row['Model']['id'];
				$data[] = $dataUrl . $row['Model']['md2filename'];
				$data[] = $dataUrl . $row['Model']['texturefilename'];
			}
			
			$dataAll[] = $data;
		}

		$this->_outputTsv($dataAll);
		$this->render(false);
	}
	
	function polis() {
		
		$settingsTmp = $this->Setting->find('all');
		$settings = array();
		foreach($settingsTmp as $value){
			$settings[$value['Setting']['s_key']] = $value['Setting']['s_value'];
		}
		
		App::import("Helper","Html");
		$htmlHelper = new HtmlHelper;
		$baseUrl = $htmlHelper->url('/',true);
		
		$sendData = array();
		
		$sendData[] = $this->_strip($settings['polis_name']);
		$sendData[] = $this->_strip($settings['polis_intro']);
		$sendData[] = $baseUrl . Configure::read('dataDir') . $settings['iconname'];
		$sendData[] = $baseUrl . Configure::read('dataDir') . $settings['picturename'];
		$apiUrl = $htmlHelper->url('/portal/data',true);	
		$sendData[] = $apiUrl;
		
		$this->_outputTsv(array($sendData));
		$this->render(false);
		
	}
	
	function user($user_id) {
		
		$settingsTmp = $this->Setting->find('all');
		$settings = array();
		foreach($settingsTmp as $value){
			$settings[$value['Setting']['s_key']] = $value['Setting']['s_value'];
		}
		
		App::import("Helper","Html");
		$htmlHelper = new HtmlHelper;
		$baseUrl = $htmlHelper->url('/',true);
		
		$sendData = array();
		
		$sendData[] = $this->_strip($settings['polis_name']);
		$sendData[] = $this->_strip($settings['polis_intro']);
		$sendData[] = $baseUrl . Configure::read('dataDir') . $settings['iconname'];
		$sendData[] = $baseUrl . Configure::read('dataDir') . $settings['picturename'];
		$apiUrl = $htmlHelper->url('/portal/data/' . $user_id,true);		
		$sendData[] = $apiUrl;
		
		$this->_outputTsv(array($sendData));
		$this->render(false);
	}
	
}
?>