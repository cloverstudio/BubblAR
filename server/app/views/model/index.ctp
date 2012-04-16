				<div id="box1" class="box box-100"><!-- box full-width -->
					<div class="boxin">
						<div class="header">
							<h3><?php e(__('Models')) ?></h3>
							<a class="button" href="<?php e($html->url('/model/add')) ?>"><?php __('add new') ?>&nbsp;»</a>
						</div>
						<div id="box1-tabular" class="content">
							<form class="plain" action="" method="post" enctype="multipart/form-data">
								<fieldset>
									<table cellspacing="0">
										<thead><!-- universal table heading -->
											<tr>
												<td width="10%"><?php __('ID') ?></td>
												<th width="20%"><?php __('Name') ?></th>
												<td width="50%"><?php __('Files') ?></td>
												<td width="10%"><?php __('Created') ?></td>
												<td class="tr"  width="10%"><?php __('Action') ?></td>
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
												<td><?php e($row['ModelObject']['id']) ?></td>
												<td><?php e($row['ModelObject']['name']) ?></td>
												<td>
													<a href="<?php e($html->url('/' . Configure::read('dataDir')) . $row['ModelObject']['md2filename']) ?>">
														<?php e($row['ModelObject']['md2filename']) ?>
													</a> &nbsp;&nbsp;
													
													<a target="_blank" href="<?php e($html->url('/' . Configure::read('dataDir')) . $row['ModelObject']['texturefilename']) ?>">
														<?php e($row['ModelObject']['texturefilename']) ?>
													</a> &nbsp;&nbsp;
												</td>
												<td><?php e(date("Y/m/d",strtotime($row['ModelObject']['created']))) ?></td>
												<td class="tr">

													<a class="ico" href="<?php e($html->url('/model/edit/' . $row['ModelObject']['id'])) ?>" title="delete">
														<img src="<?php e($html->url('/')) ?>css/img/led-ico/pencil.png" alt="delete" />
													</a>
																								
													<a class="ico" href="<?php e($html->url('/model/delete/' . $row['ModelObject']['id'])) ?>" title="delete"  onclick="return confirm('<?php __('ok?') ?>')" >
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
									<li><a href="<?php e($html->url('/model/page/' . $prev)) ?>"><?php e(__('previous')) ?></a></li>
									
									<?php for($i = 1; $i <= $pages ; $i++) { ?>
										<li>
											<?php if($i == $page) { ?>
	
												<strong>
													<?php e($i) ?>
												</strong>
	
											<?php } else { ?>
	
												<a href="<?php e($html->url('/model/page/' . $i)) ?>">
													<?php e($i) ?>
												</a>
	
											<?php } ?>
										</li>																		
									<?php } ?>

									<li><a href="<?php e($html->url('/model/page/' . $next)) ?>"><?php e(__('next')) ?></a></li>
								</ul>
							</div>
						</div><!-- .content#box-1-holder -->
					</div>
				</div>
	
