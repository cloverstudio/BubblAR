				
				<div class="box box-100">
					<div class="boxin">
						<div class="header">
							<h3><?php __('Your bubble-o-polis informaton') ?></h3>
						</div>
						
						<?php echo $form->create('User',array('url' => '/user/add','type'=>'post','class'=>'basic','enctype' =>"multipart/form-data")); ?>
						
							<div class="inner-form">

								<dl>
										<dt><?php __('Your Portal point URL') ?></dt>
										<dd class="urlbox">
											<?php e($html->url("/portal/user/" . $loginuser['id'],true)) ?>
										</dd><div class="clear" />

										<dt><?php __("Polis's Portal point URL") ?></dt>
										<dd class="urlbox">
											<?php e($html->url("/portal/polis" ,true)) ?>
										</dd><div class="clear" />
							</div>
						</form>
					</div>
				</div>
				
