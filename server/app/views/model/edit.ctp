				
				<div class="box box-100">
					<div class="boxin">
						<div class="header">
							<h3><?php __('Edit model') ?></h3>
							<a class="button" href="<?php e($html->url('/model')) ?>">&laquo;&nbsp;<?php __('back to list') ?></a>
						</div>
						
						<?php echo $form->create('ModelObject',array('url' => '/model/edit/' . $id,'type'=>'post','class'=>'basic','enctype' =>"multipart/form-data")); ?>
						
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
										<dt><label for="some1"><?php __('Name') ?></label></dt>
										<dd>

											<?php echo $form->input('name',array(
												'id'=>'form_url',
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
											
											<small><?php e(__('This is used for only backend. You can in objects set title.')) ?></small>
										</dd>

										<dt class="ttop"><label for="some2"><?php e(__('MD2 Object:')) ?></label></dt>
										<dd>
						
											<?php echo $form->input('_md2object',array(
												'id'=>'form_description',
												'type'=>'file',
												'class'=>'file',
												'label'=>false,
												'div'=>false,
												'error' => array(
													'required' => __('This field cannot be left blank.',true),
													'class' => 'error'
												)
											));?>
											<small><?php e(__('Upload file if you want to replace.')) ?></small>
										</dd>	


										<dt class="ttop"><label for="some2"><?php e(__('Texture:')) ?></label></dt>
										<dd>
						
											<?php echo $form->input('_texture',array(
												'id'=>'form_description',
												'type'=>'file',
												'class'=>'file',
												'label'=>false,
												'div'=>false,
												'error' => array(
													'required' => __('This field cannot be left blank.',true),
													'class' => 'error'
												)
											));?>
											<small><?php e(__('Upload file if you want to replace.')) ?></small>
										</dd>	


										<dt class="ttop"><label for="some2"><?php e(__('icon:')) ?></label></dt>
										<dd>
						
											<?php echo $form->input('_icon',array(
												'id'=>'form_description',
												'type'=>'file',
												'class'=>'file',
												'label'=>false,
												'div'=>false,
												'error' => array(
													'required' => __('This field cannot be left blank.',true),
												)
											));?>
											<small><?php e(__('Upload file if you want to replace.')) ?></small>
										</dd>
										

										<dt></dt>
										<dd>
											<input class="button altbutton" type="submit" value="<?php e(__('Save')) ?>" />
										</dd>
									</dl>
							</div>
							
						<?php echo $form->input('id',array('type'=>'hidden'));?>	
						</form>
						
					</div>
				</div>
				
