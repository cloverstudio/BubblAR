
		<div class="box box-50 altbox">
			<div class="boxin">
				<div class="header">
					<h3><img src="<?php e($html->url('/')) ?>css/img/black/logo-login.png" alt="BubbAR login" /></h3>
					<ul> 
						<li><a href="#" class="active"><?php __('Login') ?></a></li
						<li><a href="<?php e($html->url('/regist/newuser')) ?>"><?php __('Register') ?></a></li> 
					</ul> 
				</div>
				<?php echo $form->create('login',array('url' => '/','type'=>'post')); ?>
					<div class="inner-form">
						
						<?php if(isset($error)) { ?>
							<div class="msg msg-error"><p><?php __('Incorrect id or password.') ?></p></div>
						<?php } else { ?>
							<div class="msg msg-info"><p><?php __('Input your id and password.') ?></p> </div>
						<?php } ?>
							
						<table cellspacing="0">
							<tr>
								<th><label for="some1"><?php __('ID') ?></label></th>
								<td>
									<?php echo $form->input('loginname',array('type'=>'text','class'=>'txt','label'=>false,'div'=>false));?>
								</td>
							</tr>
							<tr>
								<th><label for="some3"><?php __('Password') ?></label></th>
								<td>
									<?php echo $form->input('password',array('type'=>'password','class'=>'txt','label'=>false,'div'=>false));?>
								</td>
							</tr>
							<tr>
								<th></th>
								<td class="tr proceed">
									<input class="button" type="submit" value="<?php __('Login') ?>" />
								</td>
							</tr>
						</table>
					</div>
				</form>
			</div>
		</div>
