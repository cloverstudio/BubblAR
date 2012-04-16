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
		
		$lat = 0;
		$lon = 0;
		
		App::import("Helper","Html");
		$htmlHelper = new HtmlHelper;
		$dataUrl = $htmlHelper->url('/data/',true);
		
		if(isset($_GET['lat'])){
			$lat = $_GET['lat'] + 0.0;
		}
		
		if(isset($_GET['lon'])){
			$lon = $_GET['lon'] + 0.0;
		}
		
		$this->log("Lat:{$lat},Lon:{$lon}",LOG_DEBUG);
		$this->log(print_r($_GET,true),LOG_DEBUG);
		
		$dataAll = array();
		        
        $radius = 0.001;

        //WELCOME
        
        $angle = 0.0;
        $ID = 1;
        
        $locationLat = $lat + $radius * cos(deg2rad($angle));
        $locationLon = $lon + $radius * sin(deg2rad($angle));

        $title = "Welcome!";
        $url = "";
        $description = "Hello and welcome to BubblAR. Please follow this tutorial to ge to know a little about building your own AR worlds. To get started, please turn right and pop the next bubble :)";
        
        $data = array();
			
        $data[] = $ID;
        $data[] = 1;
        $data[] = 1;
        $data[] = $title;
        $data[] = $url;
        $data[] = $description;
        $data[] = $locationLat;
        $data[] = $locationLon;
        $data[] = 0;
        
        $dataAll[0] = $data;
        
                
        //HOWTO
                
        $angle = 90.0;
        $ID += 1;
        
        $locationLat = $lat + $radius * cos(deg2rad($angle));
        $locationLon = $lon + $radius * sin(deg2rad($angle));

        $title = "How to?";
        $url = "http://polis1.bubblar.com";
        $description = "BubblAR lets you view points of interest which you can place via simple web CMS. To open this web CMS, please press the open web button and log in. Also if you would like to view where the bubble is placed in the real world, press the open map button. Please turn right to proceed.";
        
        $data = array();
			
        $data[] = $ID;
        $data[] = 1;
        $data[] = 1;
        $data[] = $title;
        $data[] = $url;
        $data[] = $description;
        $data[] = $locationLat;
        $data[] = $locationLon;
        $data[] = 0;
        
        $dataAll[1] = $data;
        
        
        
        
        //OBJECTS
                
        $angle = 140.0;
        $ID += 1;
        
        $locationLat = $lat + $radius * cos(deg2rad($angle));
        $locationLon = $lon + $radius * sin(deg2rad($angle));

        $title = "Objects.";
        $url = "http://www.clover-studio.com/iphone";
        $description = "You can place three types of objects in your AR world, labels, images and 3D models. If the objects are stacked densely and you pop one of them, a new view will appear where you can see them all ordered by distance and you can pop them from there. Pop the three bubbles to see what's inside and turn right to proceed.";
        
        $data = array();
			
        $data[] = $ID;
        $data[] = 1;
        $data[] = 1;
        $data[] = $title;
        $data[] = $url;
        $data[] = $description;
        $data[] = $locationLat;
        $data[] = $locationLon;
        $data[] = 0;
        
        $dataAll[2] = $data;
        
        
        
        //label
        
        $angle = 180.0;
        $ID += 1;
        
        $locationLat = $lat + $radius * cos(deg2rad($angle));
        $locationLon = $lon + $radius * sin(deg2rad($angle));

        $title = "Label";
        $url = "http://www.clover-studio.com/iphone";
        $description = "This is a label :)";
        
        $data = array();
			
        $data[] = $ID;
        $data[] = 1;
        $data[] = 1;
        $data[] = $title;
        $data[] = $url;
        $data[] = $description;
        $data[] = $locationLat;
        $data[] = $locationLon;
        $data[] = 0;
        
        $dataAll[3] = $data;
        
        //image
        
        $angle = 190.0;
        $ID += 1;
        
        $locationLat = $lat + $radius * cos(deg2rad($angle));
        $locationLon = $lon + $radius * sin(deg2rad($angle));

        $title = "Image";
        $url = "http://www.clover-studio.com/iphone";
        $imageUrl = "http://tutorial.bubblar.com/data/picture_bgTex.png";
        $description = "This is an image :)";
        
        $data = array();
			
        $data[] = $ID;
        $data[] = 1;
        $data[] = 2;
        $data[] = $title;
        $data[] = $url;
        $data[] = $description;
        $data[] = $locationLat;
        $data[] = $locationLon;
        $data[] = 0;
        $data[] = $imageUrl;
        
        $dataAll[4] = $data;
        
        //model
        
        $angle = 185.0;
        $ID += 1;
        
        $locationLat = $lat + $radius * cos(deg2rad($angle));
        $locationLon = $lon + $radius * sin(deg2rad($angle));

        $title = "Model";
        $description = "This is a model :)";
        $url = "http://www.clover-studio.com/iphone";
		$modelID = 28;
        $modelUrl = "http://tutorial.bubblar.com/data/model_28.md2";
        $textureUrl = "http://tutorial.bubblar.com/data/texture_28.png";
       
        
        $data = array();
			
        $data[] = $ID;
        $data[] = 1;
        $data[] = 3;
        $data[] = $title;
        $data[] = $url;
        $data[] = $description;
        $data[] = $locationLat;
        $data[] = $locationLon;
        $data[] = 30;
		$data[] = $modelID;
        $data[] = $modelUrl;
        $data[] = $textureUrl;
        
        $dataAll[5] = $data;
        
        
        //THANKS!
                
        $angle = 270.0;
        $ID += 1;
        
        $locationLat = $lat + $radius * cos(deg2rad($angle));
        $locationLon = $lon + $radius * sin(deg2rad($angle));

        $title = "Thank you!";
        $url = "http://www.clover-studio.com/iphone";
        $description = "Thank you for going through this tutorial. If you would like to get out of tutorial polis, please press the bubble with BubblAR icon on the bottom of the screen and then BUBBLE OUT. Also, if you liked the app, or have some comments, you can send them to us directly by pressing the FEEDBACK button, writing a comment and submitting it.";
        
        $data = array();
			
        $data[] = $ID;
        $data[] = 1;
        $data[] = 1;
        $data[] = $title;
        $data[] = $url;
        $data[] = $description;
        $data[] = $locationLat;
        $data[] = $locationLon;
        $data[] = 0;
        
        $dataAll[6] = $data;
        
		//print_r($dataAll);
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