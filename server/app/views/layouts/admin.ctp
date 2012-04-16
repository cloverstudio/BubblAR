<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="cs" lang="cs">
    <head>
	
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <meta http-equiv="content-style-type" content="text/css" />
        <meta http-equiv="content-script-type" content="text/javascript" />
        
        <title>BubblAR</title>
        
        <link rel="stylesheet" type="text/css" href="<?php e($html->url('/')) ?>css/black.css" media="screen, projection, tv" /><!-- Change name of the stylesheet to change colors (blue/red/black/green/brown/orange/purple) -->
        <!--[if lte IE 7.0]><link rel="stylesheet" type="text/css" href="<?php e($html->url('/')) ?>css/ie.css" media="screen, projection, tv" /><![endif]-->
		<!--[if IE 8.0]>
			<style type="text/css">
				form.fields fieldset {margin-top: -10px;}
			</style>
		<![endif]-->
		
		<script type="text/javascript" src="<?php e($html->url('/')) ?>js/jquery-1.3.2.min.js"></script>
		<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=<?php e(Configure::read('GoogleApiKey')) ?>&sensor=true" type="text/javascript"></script>

		<!-- Adding support for transparent PNGs in IE6: -->
		<!--[if lte IE 6]>
			<script type="text/javascript" src="js/ddpng.js"></script>
			<script type="text/javascript">
				DD_belatedPNG.fix('#nav #h-wrap .h-ico');
				DD_belatedPNG.fix('.ico img');
				DD_belatedPNG.fix('.msg p');
				DD_belatedPNG.fix('table.calendar thead th.month a img');
				DD_belatedPNG.fix('table.calendar tbody img');
			</script>
		<![endif]-->
		<script type="text/javascript">
			$(document).ready(function() {

				// Switch categories
					$('#h-wrap').hover(function(){
							$(this).toggleClass('active');
							$("#h-wrap ul").css('display', 'block');
						}, function(){
							$(this).toggleClass('active');
							$("#h-wrap ul").css('display', 'none');
					});
				
			});
		
		</script>
		
    </head>
    <body>

		<div id="header">
			<div class="inner-container clearfix">
				<h1 id="logo">
					<a class="home" href="#" title="Go to admin's homepage">
						BubblAR
						<span class="ir"></span>
					</a><br />
				</h1>
				
					<div id="userbox">
						<div class="inner">
							<strong><?php e($loginuser['loginname']) ?></strong>
							<ul class="clearfix">
							
								<li><a href="<?php e($html->url('/user/profile')) ?>"><?php e(__('profile')) ?></a></li>
								
								<?php if($loginuser['permission'] == PERMISSION_ADMIN) { ?>
									<li><a href="<?php e($html->url('/settings')) ?>"><?php e(__('settings')) ?></a></li>
								<?php } ?>
								
								<li><a href="#">help</a></li>
							
							</ul>
						</div>
						<a id="logout" href="<?php e($html->url('/regist/logout')) ?>"><?php e(__('logout')) ?><span class="ir"></span></a>
					</div>
					
			</div>
		</div>
		
      	<div id="nav">
			<div class="inner-container clearfix">
				<div id="h-wrap">
					<div class="inner">
						<h2>		

							<?php if(preg_match('/\/admin/',$this->here)) { ?>
								<span class="h-ico ico-dashboard"><span><?php e(__('Dashboard')) ?></span></span>
							<?php } else if(preg_match('/\/object/',$this->here)) { ?>
								<span class="h-ico ico-edit"><span><?php e(__('Objects')) ?></span></span>
							<?php } else if(preg_match('/\/model/',$this->here)) { ?>
								<span class="h-ico ico-comments"><span><?php e(__('Models')) ?></span></span>
							<?php } else if(preg_match('/\/user/',$this->here)) { ?>
								<span class="h-ico ico-users"><span><?php e(__('Users')) ?></span></span>
							<?php } else { ?>
								 <span class="h-ico ico-dashboard"><span><?php e(__('Dashboard')) ?></span></span>
							<?php } ?>				


							<span class="h-arrow"></span>
						</h2>
						<ul class="clearfix">
							<li><a class="h-ico ico-dashboard" href="<?php e($html->url('/admin')) ?>"><span><?php e(__('Dashboard')) ?></span></a></li>
							<li><a class="h-ico ico-edit" href="<?php e($html->url('/object')) ?>"><span><?php e(__('Objects')) ?></span></a></li>
							<li><a class="h-ico ico-comments" href="<?php e($html->url('/model')) ?>"><span><?php e(__('Models')) ?></span></a></li>
							
															
							<?php if($loginuser['permission'] == PERMISSION_ADMIN) { ?>
								<li><a class="h-ico ico-users" href="<?php e($html->url('/user')) ?>"><span><?php e(__('Users')) ?></span></a></li>
							<?php } ?>
								
						</ul>
					</div>
				</div><!-- #h-wrap -->

			</div><!-- .inner-container -->
      	</div><!-- #nav -->
		
		<div id="container">
			<div class="inner-container">
				
			<?php e($content_for_layout) ?>
				
			<div id="footer"><!-- footer, maybe you don't need it -->
				<p>© <a href="http://www.clover-studio.com">CloverStudio</a></p>
			</div>
			
			</div><!-- .inner-container -->
		</div><!-- #container -->
		
    </body>
</html>