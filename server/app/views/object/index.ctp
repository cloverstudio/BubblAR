		<script type="text/javascript">
			$(document).ready(function() {
				
				$('#form_type_1').click(function(){
					$("#modelHolder").hide();
					$("#pictureHolder").hide();
				});
				
				$('#form_type_2').click(function(){
					$("#modelHolder").hide();
					$("#pictureHolder").show();
				});

				$('#form_type_3').click(function(){
					$("#modelHolder").show();
					$("#pictureHolder").hide();
				});
				
				<?php if($this->data['LocationObject']['type'] == 1) { ?>
					
					$("#form_type_1").attr('checked','checked');
					$("#pictureHolder").hide();
					$("#modelHolder").hide();
					
				<?php } else if($this->data['LocationObject']['type'] == 2) { ?>
					
					$("#form_type_2").attr('checked','checked');
					$("#pictureHolder").show();
					$("#modelHolder").hide();
					
				<?php } else { ?>
					
					$("#form_type_3").attr('checked','checked');
					$("#form_model_id").val('<?php e($this->data['LocationObject']['model_id']) ?>');
					$("#modelHolder").show();
					$("#pictureHolder").hide();
					
				<?php } ?>
								
				function createMarker(point, number) {
					  var marker = new GMarker(point);
					  var message = ["This","is","the","secret","message"];
					  marker.value = number;
					  GEvent.addListener(marker, "click", function() {
					    var myHtml = "<b>#" + number + "</b><br/>" + message[number -1];
					    map.openInfoWindowHtml(point, myHtml);
					  });
					  return marker;
				}
				
					if (GBrowserIsCompatible()) {
						var map = new GMap2(document.getElementById("map_canvas"));
						
						
						<?php if(isset($lastLatitude)) { 
							
							if(!$lastZoom || $lastZoom == '')
								$lastZoom = 8;
								
						?>
						
							map.setCenter(new GLatLng(<?php e($lastLatitude) ?>,<?php e($lastLongitude) ?>), <?php e($lastZoom) ?>);
							
						<?php } else if(isset($this->data['LocationObject']['latitude'])) { ?>
							
							map.setCenter(new GLatLng(<?php e($this->data['LocationObject']['latitude']) ?>,<?php e($this->data['LocationObject']['longitude']) ?>), 10);
							
						<?php } else { ?>
							
							map.setCenter(new GLatLng(46,16), 8);
							
						<?php } ?>
						
						
						var customUI = map.getDefaultUI();
						customUI.zoom.doubleclick = false;
						map.setUI(customUI);

						var markerIndex = 0;
						GEvent.addListener(map, "dblclick",function(overlay, latlng){     
								$("#form_latitude").val(latlng.lat());
								$("#form_longitude").val(latlng.lng());

								$("#form_altitude").val('');
								$("#form_title").val('');
								$("#form_url").val('');
								$("#form_description").val('');
								$("#form_id").val('');		
								$("#form_pic").val('');		
								$("#pic_holder").hide();
								
								var marker = new GMarker(latlng);
								marker.value = markerIndex++;
								
								map.addOverlay(marker);
								
								
																
								$("#lastLatitude").val(latlng.lat());
								$("#lastLongitude").val(latlng.lng());
								
						});

						GEvent.addListener(map, "zoomend",function(oldLevel, newLevel){     
								$("#lastZoom").val(newLevel);
						});
						
						<?php 
							foreach($list as $row) { 
								$l = $row['LocationObject'];
								
								$l['description'] = str_replace("\r\n","",$l['description']);
								$l['description'] = str_replace("\n","",$l['description']);
								$l['description'] = str_replace("'","\\'",$l['description']);
						?>
						
							var point = new GLatLng(<?php e($l['latitude']) ?>,<?php e($l['longitude']) ?>);
							var marker = new GMarker(point);
							marker.value = markerIndex++;
							
							GEvent.addListener(marker, "click", function() {

								$("#form_latitude").val(<?php e($l['latitude']) ?>);
								$("#form_longitude").val(<?php e($l['longitude']) ?>);
								$("#form_altitude").val(<?php e($l['altitude']) ?>);
								$("#form_title").val('<?php e($l['title']) ?>');
								
								<?php if($l['type'] == 1) { ?>
									
									$("#form_type_1").attr('checked','checked');
									$("#pictureHolder").hide();
									$("#modelHolder").hide();
									
								<?php } else if($l['type'] == 2) { ?>
									
									$("#form_type_2").attr('checked','checked');
									$("#pictureHolder").show();
									
									$("#modelHolder").hide();
									
								<?php } else { ?>
									
									$("#form_type_3").attr('checked','checked');
									$("#form_model_id").val('<?php e($l['model_id']) ?>');
									$("#modelHolder").show();
									$("#pictureHolder").hide();
									
								<?php } ?>
								
								$("#form_url").val('<?php e($l['url']) ?>');
								$("#form_description").val('<?php e($l['description']) ?>');
								$("#form_id").val('<?php e($l['id']) ?>');
								
							});

							
							map.addOverlay(marker);
							
						<?php } ?>
					}

			});
		</script>
						<div class="box box-50">
					<div class="boxin">
						<div class="header">
							<h3><?php e(__('Select points in map')) ?></h3>
						</div>
						<form>
							<div id="map_canvas" style="height: 432px"></div>
						</form>
					</div>
				</div>
				
				<div class="box box-50">
					<div class="boxin">
						<div class="header">
							<h3><?php e(__('Detailed information')) ?></h3>
						</div>
						
						<?php if(!empty($this->data['LocationObject']['id'])) { ?>
							<?php echo $form->create('LocationObject',array('url' => '/object/edit/' . $this->data['LocationObject']['id'],'type'=>'post','class'=>'basic','enctype' =>"multipart/form-data")); ?>
						<?php } else { ?>
							<?php echo $form->create('LocationObject',array('url' => '/object/edit','type'=>'post','class'=>'basic','enctype' =>"multipart/form-data")); ?>
						<?php } ?>
						
							<div class="inner-form">
							
								<?php if(isset($okmsg)) { ?>
									<div class="msg msg-ok"><p><?php e($okmsg) ?></p></div>
								<?php } ?>
								
								<?php if(isset($errmsg)) { ?>
									<div class="msg msg-error"><p><?php e($errmsg) ?></p></div>
								<?php } ?>

								<?php if(isset($infomsg)) { ?>
									<div class="msg msg-info"><p><?php e($infomsg) ?></p></div>
								<?php } ?>
								
									<dl>
										<dt><label for="some1" ><?php e(__('Latitude:')) ?></label></dt>
										<dd>
										
											<?php echo $form->input('latitude',array(
												'id'=>'form_latitude',
												'type'=>'text',
												'class'=>'txt',
												'label'=>false,
												'div'=>false,
												'error' => array(
													'required' => __('This field cannot be left blank.',true),
													'float' => __('This field needs float number.',true),
													'class' => 'error'
												)
											));?>
											
										</dd>
									
										<dt><label for="some3"><?php e(__('Longitude:')) ?></label></dt>
										<dd>
										
											<?php echo $form->input('longitude',array(
												'id'=>'form_longitude',
												'type'=>'text',
												'class'=>'txt',
												'label'=>false,
												'div'=>false,
												'error' => array(
													'required' => __('This field cannot be left blank.',true),
													'float' => __('This field needs float number.',true),
													'class' => 'error'
												)
											));?>
											
										</dd>
										
										<dt><label for="some3"><?php e(__('Altitude:')) ?></label></dt>
										<dd>
										
											<?php echo $form->input('altitude',array(
												'id'=>'form_altitude',
												'type'=>'text',
												'class'=>'txt',
												'label'=>false,
												'div'=>false,
												'error' => array(
													'required' => __('This field cannot be left blank.',true),
													'float' => __('This field needs float number.',true),
													'class' => 'error'
												)
											));?>
											
											<small><?php e(__('Unit is meter')) ?></small>
										</dd>
									
										
										<dt></dt>
										<dd>
										
											<label class="radio">
												<?php 
													$checked = 'checked';
													if(isset($this->data['LocationObject']['type']) && $this->data['LocationObject']['type'] == 1){
														$checked = "checked=checked";
													}
												?> 
												<input class="radio" type="radio" id="form_type_1" name="data[LocationObject][type]" value="1" <?php e($checked) ?>/>
												<?php __('Label') ?>						
											</label>
											
											<label class="radio">
												<?php 
													$checked = '';
													if(isset($this->data['LocationObject']['type']) && $this->data['LocationObject']['type'] == 2){
														$checked = "checked=checked";
													}
												?> 
												<input class="radio" type="radio" id="form_type_2" name="data[LocationObject][type]" value="2" <?php e($checked) ?>/>
												<?php __('Picture') ?>
											</label>
											
											
											<label class="radio">
												<?php 
													$checked = '';
													if(isset($this->data['LocationObject']['type']) && $this->data['LocationObject']['type'] == 3){
														$checked = "checked=checked";
													}
												?> 
												<input class="radio" type="radio" id="form_type_3" name="data[LocationObject][type]" value="3" <?php e($checked) ?>/>
												<?php __('Model') ?>
											</label>
											
										</dd>
										
										<div id="pictureHolder" style="display:none">
											<dt class="ttop"><label for="some2"><?php e(__('picture:')) ?></label></dt>
											<dd>
												
												<?php if(!empty($this->data['LocationObject']['picfilename'])) { ?>						
													<a href="<?php e($html->url('/' . Configure::read('dataDir')) . $this->data['LocationObject']['picfilename']) ?>" target"_blank" id="pic_holder">
														<img src="<?php e($html->url('/' . Configure::read('dataDir')) . $this->data['LocationObject']['picfilename']) ?>" width="57px" />
													</a>
													<!-- <input type="submit" name="deletepic" value="<?php e(__('Delete picture')) ?>" /> -->
													<br />
												<?php } ?>
															
												<?php echo $form->input('_pic',array(
													'type'=>'file',
													'class'=>'file',
													'label'=>false,
													'div'=>false,
													'error' => array(
														'required' => __('This field cannot be left blank.',true),
														'format' => __('Only Png ang Jpg are allowed.',true),
														'class' => 'error'
													)
												));?>
												
											</dd>
										</div>
										
										<div id="modelHolder" style="display:none">
											<dt><?php __('Model') ?></dt>
											<dd>
											
												<?php echo $form->input('model_id',array(
													'id'=>'form_model_id',
													'type'=>'select',
													'class'=>'txt',
													'label'=>false,
													'div'=>false,
													'options' => $modelList,
													'error' => array(
														'required' => __('This field cannot be left blank.',true),
														'class' => 'error'
													)
												));?>
												
											</dd>
										</div>
										
										<dt><label for="some3"><?php e(__('Title:')) ?></label></dt>
										<dd>

											<?php echo $form->input('title',array(
												'id'=>'form_title',
												'type'=>'text',
												'class'=>'txt',
												'label'=>false,
												'div'=>false,
												'error' => array(
													'required' => __('This field cannot be left blank.',true),
													'float' => __('This field needs float number.',true),
													'class' => 'error'
												)
											));?>
											
										</dd>
										
										<dt><label for="some3"><?php e(__('Url:')) ?></label></dt>
										<dd>
						
											<?php echo $form->input('url',array(
												'id'=>'form_url',
												'type'=>'text',
												'class'=>'txt',
												'label'=>false,
												'div'=>false,
												'error' => array(
													'url' => __('Url is invalid.',true),
													'float' => __('This field needs float number.',true),
													'class' => 'error'
												)
											));?>
											<small><?php e(__('must begin with http://')) ?></small>
										</dd>
										
										<dt class="ttop"><label for="some2"><?php e(__('Description:')) ?></label></dt>
										<dd>
						
											<?php echo $form->input('description',array(
												'id'=>'form_description',
												'type'=>'textarea',
												'class'=>'txt',
												'label'=>false,
												'div'=>false,
												'error' => array(
													'required' => __('This field cannot be left blank.',true),
													'float' => __('This field needs float number.',true),
													'class' => 'error'
												)
											));?>
											
										</dd>				
										
										<dt></dt>
										<dd>
										
											<?php echo $form->input('picfilename',array(
												'id'=>'form_pic',
												'type'=>'hidden'
											));?>
											
											<?php echo $form->input('id',array(
												'id'=>'form_id',
												'type'=>'hidden'
											));?>
											
											<input class="button altbutton" type="submit" value="<?php e(__('Save')) ?>" />
										</dd>
									</dl>
							</div>
						
						<input type="hidden" name="lastLatitude" id="lastLatitude" <?php if(isset($this->data['LocationObject']['latitude'])) e("value=\"{$this->data['LocationObject']['latitude']}\""); ?> />
						<input type="hidden" name="lastLongitude" id="lastLongitude" <?php if(isset($this->data['LocationObject']['longitude'])) e("value=\"{$this->data['LocationObject']['longitude']}\""); ?>  />
						<input type="hidden" name="lastZoom" id="lastZoom" />
						
						</form>
					</div>
				</div>

				<a name="list"></a>
				<div id="box1" class="box box-100"><!-- box full-width -->
					<div class="boxin">
						<div class="header">
							<h3><?php __('Model') ?></h3>
							<a class="button" href="<?php e($html->url('/model/add')) ?>"><?php __('add new') ?>&nbsp;»</a>
						</div>
						<div id="box1-tabular" class="content"><!-- content box 1 for tab switching -->
							<form class="plain" action="" method="post" enctype="multipart/form-data">
								<fieldset>
									<table cellspacing="0">
										<thead><!-- universal table heading -->
											<tr>
												<td width="5%"><?php __('ID') ?></td>
												<th width="10%"><?php __('Type') ?></th>
												<th width="15%"><?php __('Title') ?></th>
												<th width="15%"><?php __('Url') ?></th>
												<th width="20%"><?php __('Description') ?></th>
												<td width="15%"><?php __('Location') ?></td>
												<td width="5%"><?php __('Created') ?></td>
												<td class="tr"  width="5%"><?php __('Action') ?></td>
											</tr>
										</thead>
										<tbody>
										
										<?php foreach($list as $index => $row) { 
										
											if($index == 0)
												$class = 'class=first';
											else if($index % 2 == 0)
												$class = 'class=odd';
											else
												$class = 'class=even';

										?>
										
											<tr <?php e($class) ?>>
												<td><?php e($row['LocationObject']['id']) ?></td>
												<td>
													

													<?php if($row['LocationObject']['type'] == 1)  { ?>
														<span class="tag tag-gray"><?php __('Label') ?></span>
													<?php } else if($row['LocationObject']['type'] == 2){ ?>
														<span class="tag tag-gray">
															<?php __('Picture') ?>
														</span><br /><br />
														
														<a href="<?php e($html->url('/' . Configure::read('dataDir')) . $row['LocationObject']['picfilename']) ?>" target"_blank" >
															<img src="<?php e($html->url('/' . Configure::read('dataDir')) . $row['LocationObject']['picfilename']) ?>" width="57px" />
														</a>
													<?php } else { 
														$model = $modelList[$row['LocationObject']['model_id']];
													?>
														<span class="tag tag-gray">
															<a href="<?php e($html->url('/model/edit/' . $row['LocationObject']['model_id'])) ?>">
																<?php __('Model') ?>
															</a>
														</span>
													<?php } ?>

													
												</td>
												<td>
													<?php e($text->truncate($row['LocationObject']['title'],20)) ?>
												</td>
												<td><?php e($text->truncate($row['LocationObject']['url'],20)) ?></td>
												<td><?php e($text->truncate($row['LocationObject']['description'],100)) ?></td>
												
												<td>
													<?php e($row['LocationObject']['longitude']) ?><br />
													<?php e($row['LocationObject']['latitude']) ?><br />
													<?php e($row['LocationObject']['altitude']) ?><br />
												</td>
												<td><?php e(date("Y/m/d",strtotime($row['LocationObject']['created']))) ?></td>
												<td class="tr">

													<a class="ico" href="<?php e($html->url('/object/edit/' . $row['LocationObject']['id'])) ?>" title="delete">
														<img src="<?php e($html->url('/')) ?>css/img/led-ico/pencil.png" alt="delete" />
													</a>
																								
													<a class="ico" href="<?php e($html->url('/object/delete/' . $row['LocationObject']['id'])) ?>" title="delete" onclick="return confirm('<?php __('ok?') ?>')" >
														<img src="<?php e($html->url('/')) ?>css/img/led-ico/delete.png" alt="delete" />
													</a>
													
												</td>											
											</tr>
											
										<?php } ?>
										
										</tbody>
									</table>
								</fieldset>
							</form>
							
							<?php
								
								$next = $page + 1;
								$prev = $page - 1;
								
								if($prev <= 1)
									$prev = 1;
								
								if($next > $pages)
									$next = $page;
								
							?>
							
							<div class="pagination">
								<ul>
									<li><a href="<?php e($html->url("/object/page/{$prev}#list")) ?>"><?php e(__('previous')) ?></a></li>
									
									<?php for($i = 1; $i <= $pages ; $i++) { ?>
										<li>
											<?php if($i == $page) { ?>
	
												<strong>
													<?php e($i) ?>
												</strong>
	
											<?php } else { ?>
	
												<a href="<?php e($html->url("/object/page/{$i}#list")) ?>">
													<?php e($i) ?>
												</a>
	
											<?php } ?>
										</li>																		
									<?php } ?>

									<li><a href="<?php e($html->url("/object/page/{$next}#list")) ?>"><?php e(__('next')) ?></a></li>
								</ul>
							</div>
						</div><!-- .content#box-1-holder -->
					</div>
				</div>