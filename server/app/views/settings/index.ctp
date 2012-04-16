				<div class="box box-100">
				
					<div class="boxin">
						<div class="header">
							<h3><?php __('Bubble-o-polis settings') ?></h3>						
						</div>

						<?php echo $form->create('Setting',array('url' => '/settings/edit/','type'=>'post','class'=>'basic','enctype' =>"multipart/form-data")); ?>

						
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
									
								
										<dt class="ttop"><label for="some2"><?php __('Bubble-o-polis name') ?></label></dt>
										<dd>
											<?php echo $form->input('polis_name',array(
												'type'=>'text',
												'class'=>'txt',
												'label'=>false,
												'div'=>false,
												'error' => array(
													'required' => __('This field cannot be left blank.',true),
													'class' => 'error'
												)

											));?>
										</dd>
										
										<dt class="ttop"><label for="some2"><?php __('Opening words') ?></label></dt>
										<dd>
											<?php echo $form->input('polis_intro',array(
												'type'=>'textarea',
												'class'=>'txt',
												'label'=>false,
												'div'=>false,
												'error' => array(
													'required' => __('This field cannot be left blank.',true),
													'class' => 'error'
												)

											));?>
										</dd>
										
										<dt class="ttop"><label for="some2"><?php e(__('Icon:')) ?></label></dt>
										<dd>
											<?php echo $form->input('_icon',array(
												'id'=>'form_description',
												'type'=>'file',
												'class'=>'file',
												'label'=>false,
												'div'=>false,
												'error' => array(
													'format' => __('Only Png ang Jpg are allowed.',true),
													'class' => 'error'
												)
											));?><br />
											<small>Png and Jpg are allowed, 57x57 size will shows in best condition.</small>
										</dd>	
										
										<?php if(isset($this->data['Setting']['iconname'])) { ?>
											<dt></dt>	
											<dd>
												<img src="<?php e($html->url('/' . Configure::read('dataDir')) . $this->data['Setting']['iconname']) ?>"  />
											</dd>
										<?php } ?>
										
										<dt class="ttop"><label for="some2"><?php e(__('Picture:')) ?></label></dt>
										<dd>
											<?php echo $form->input('_pic',array(
												'id'=>'form_description',
												'type'=>'file',
												'class'=>'file',
												'label'=>false,
												'div'=>false,
												'error' => array(
													'format' => __('Only Png ang Jpg are allowed.',true),
													'class' => 'error'
												)
											));?><br />
											<small>Png and Jpg are allowed, 128x128 size will shows in best condition.</small>
										</dd>	
										
										<?php if(isset($this->data['Setting']['picturename'])) { ?>
											<dt></dt>	
											<dd>
												<img src="<?php e($html->url('/' . Configure::read('dataDir')) . $this->data['Setting']['picturename']) ?>" />
											</dd>
										<?php } ?>
										
										<dt></dt>
										<dd>
											<input class="button altbutton" type="submit" value="<?php e(__('Save')) ?>" />
										</dd>

									</dl>
							</div>
							<a name="form" id="form"></a>
							
						<?php if(isset($editmode)) { ?>
							<?php echo $form->input('id',array('type'=>'hidden'));?>
						<?php } ?>
						
						</form>
					</div>
				</div>

	