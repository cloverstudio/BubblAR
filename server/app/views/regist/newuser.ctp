
		<div class="box box-50 altbox">
			<div class="boxin">
				<div class="header">
					<h3><img src="<?php e($html->url('/')) ?>css/img/black/logo-login.png" alt="BubnblAR Regist" /></h3>
					<ul> 
						<li><a href="<?php e($html->url('/')) ?>"><?php __('Login') ?></a></li
						<li><a href="<?php e($html->url('/regist/newuser')) ?>"  class="active"><?php __('Register') ?></a></li> 
					</ul> 
				</div>
				<?php echo $form->create('User',array('url' => '/regist/newuser','type'=>'post')); ?>
					<div class="inner-form">
				
						<?php if(isset($this->validationErrors['User'])) { ?>
							<div class="msg msg-error"><p><?php __('Please correct errors.') ?></p></div>
						<?php } ?>
		
						<?php if(isset($saved)) { ?>
							<div class="msg msg-ok"><p><?php __('You are registered, thank you !') ?></p></div>
						<?php } ?>
							
						<table cellspacing="0">
							<tr>
								<th><label for="some1"><?php __('ID') ?></label></th>
								<td>
									<?php echo $form->input('loginname',array('type'=>'text','class'=>'txt','label'=>false,'div'=>false,
										'error' => array(
											'required' => __('Please input this field.',true),
											'format' => __('Only alphabet and numbers are allowed.',true),
											'min' => __('Please input more than 4 characters.',true),
											'duplicated' => __('This id is already teken.',true),
											'class' => 'error'
									)));?>
								</td>
							</tr>
							<tr>
								<th><label for="some3"><?php __('Password') ?></label></th>
								<td>
									<?php echo $form->input('password',array('type'=>'password','class'=>'txt','label'=>false,'div'=>false,
										'error' => array(
											'required' => __('Please input this field.',true),
											'format' => __('Only alphabet and numbers are allowed.',true),
											'min' => __('Please input more than 4 characters.',true),
											'class' => 'error'
									)));?>
								</td>
							</tr>
							<tr>
								<th><label for="some3"><?php __('Email') ?></label></th>
								<td>
									<?php echo $form->input('email',array('type'=>'text','class'=>'txt','label'=>false,'div'=>false,
										'error' => array(
											'required' => __('Please input this field.',true),
											'format' => __('Invalid email address.',true),
											'duplicated' => __('You are already registered.',true),
											'class' => 'error'
									)));?>
								</td>
							</tr>
							<tr>
								<th></th>
								<td class="tr proceed">
									<input class="button" type="submit" value="<?php __('Register') ?>" />
								</td>
							</tr>
						</table>
					</div>
				</form>
			</div>
		</div>
