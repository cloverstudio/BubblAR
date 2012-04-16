<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="cs" lang="cs">
    <head>
	
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <meta http-equiv="content-style-type" content="text/css" />
        <meta http-equiv="content-script-type" content="text/javascript" />
        
        <title>Bubblar Login</title>
        
        <link rel="stylesheet" type="text/css" href="<?php e($html->url('/')) ?>css/black.css" media="screen, projection, tv" />  
        <!--[if lte IE 7.0]><link rel="stylesheet" type="text/css" href="<?php e($html->url('/')) ?>css/ie.css" media="screen, projection, tv" /><![endif]-->
		<!--[if IE 8.0]>
			<style type="text/css">
				form.fields fieldset {margin-top: -10px;}
			</style>
		<![endif]-->
		
		<script type="text/javascript" src="<?php e($html->url('/')) ?>js/jquery-1.3.2.min.js"></script>
		<!-- Adding support for transparent PNGs in IE6: -->
		<!--[if lte IE 6]>
			<script type="text/javascript" src="<?php e($html->url('/')) ?>js/ddpng.js"></script>
			<script type="text/javascript">
				DD_belatedPNG.fix('h3 img');
			</script>
		<![endif]-->
		
    </head>
    <body id="login">

		<?php e($content_for_layout) ?>

    </body>
</html>