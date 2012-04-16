//
//  MRChannelTableViewController.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRChannelTableViewController.h"
#import "MRRootViewController.h"
#import "ConstantsAndMacros.h"
#import "MRTableCell.h"
#import "MRTableView.h"
#import "MRPolisManager.h"
#import "MRPolis.h"
#import "UIImageResizing.h"
#import <QuartzCore/QuartzCore.h>

#define TABLE_RECT CGRectMake(60, 40, 360, 240)

@implementation MRChannelTableViewController

-(id) initWithRVC:(MRRootViewController*) rvcArg
{
	
	if (self = [super init]) {
		
		RVC = rvcArg;

		connectionError = NO;
		[[MRPolisManager sharedInstance] setRVC:RVC];
		[[MRPolisManager sharedInstance] reset];
		[[MRPolisManager sharedInstance] startDownload:@"http://www.bubblar.com/polislist.php"];
		[[MRPolisManager sharedInstance] addListener:self];
		
		UIImageView *tempView = [[UIImageView alloc] initWithFrame:IPHONE_SCREEN_LANDSCAPE_RECT];
		tempView.image = [UIImage imageNamed:@"polisInfoBG.png"];
		tempView.alpha = 0.0;
		tempView.userInteractionEnabled = YES;
		tempView.multipleTouchEnabled = YES;
		self.view = tempView;
		[tempView release];

		[self.view setAlpha:0.0];
		
		table = [[MRTableView alloc] initWithFrame:TABLE_RECT andDelegate:self andDatasource:self];
		table.allowsSelection = NO;
		[self.view addSubview: table];
		[table release];
		
		tableSections = [[NSArray alloc] initWithObjects:@"", NSLocalizedString(@"yourbubbl", @""), NSLocalizedString(@"bubblopolis", @""), nil];
		
		polisIconsArray = [[NSMutableArray alloc] init];
	}
	
	return self;
}

/*
- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryDetailDisclosureButton;
}
 */

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	
	if (indexPath.section == 1)
	{
		if (channelField.text == nil || [channelField.text isEqualToString:@""]) 
		{
			
			[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];

			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"invalidUrl", @"")
															message:NSLocalizedString(@"invalidUrlDesc", @"")
														    delegate:self
												  cancelButtonTitle:NSLocalizedString(@"ok", @"")
												  otherButtonTitles:nil];
			
			[alert show];
			[alert release];
						
			return;		//if error - bail.
		}
		else 
		{
			[[MRPolisManager sharedInstance] setUserPolisURL:channelField.text];
			[[MRPolisManager sharedInstance] setSelectedPolis:indexPath.row];
			[[MRPolisManager sharedInstance] setPolisType:POLIS_TYPE_USER];
		}
	}
	else if (indexPath.section == 2) //for featured bubbles;
	{
		[[MRPolisManager sharedInstance] setSelectedPolis:indexPath.row];
		[[MRPolisManager sharedInstance] setPolisType:POLIS_TYPE_FEATURED];
	}

	//[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];

	[RVC changeView:BB_POLIS_INFO_VIEW]; 

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return [tableSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if (!connectionError) 
	{
		if (section == 0) 
		{
			return 1;
		}
		else if (section == 1) //first section is used to write a custom URL if there is a connection error, there is nothing to write.
			return 1;
		else return [[[MRPolisManager sharedInstance] polisArray] count];//[categoryArray count];
	}
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [tableSections objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", indexPath.section, indexPath.row];
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[MRTableCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		
		MRPolis *polis; 
		UIImageView *imageView;
		
		switch (indexPath.section) {
			case 0:
				//commercial
				imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"commercialTex.png"]];
				imageView.frame = CGRectMake(0, 0, 340, 70);
				imageView.layer.masksToBounds = YES;
				imageView.layer.cornerRadius = 10.0;
				cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
				cell.accessoryType = UITableViewCellAccessoryNone;
				[cell.contentView addSubview:imageView];
				[imageView release];
				break;
			case 1:
				channelField = [[UITextField alloc] initWithFrame:CGRectMake(10, 25, 280, 40)];
				channelField.delegate = self;
				//default
				channelField.text = @"http://polis1.bubblar.com/portal/user/1";
				//channelField.text = @"tap to enter...";
				channelField.returnKeyType = UIReturnKeyDone;
				//channelField.text = @"";
				channelField.textColor = UICOLOR_DARKBLUE;
				channelField.clearsOnBeginEditing = NO;
				channelField.tag = 0;
				[cell.contentView addSubview: channelField];
				[channelField release];
				break;
			case 2:
				polis = [[[MRPolisManager sharedInstance] polisArray] objectAtIndex:indexPath.row]; 
				cell.textLabel.text = polis.title;//[NSString stringWithFormat:@"Name %d", indexPath.row];
				cell.textLabel.textColor = UICOLOR_DARKBLUE;
				cell.imageView.image = 	polis.iconImage;
				cell.imageView.layer.masksToBounds = YES;
				cell.imageView.layer.cornerRadius = 10.0;
				break;
			default:
				break;
		}
    }
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 70;
}

-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	[theTextField resignFirstResponder];
	return YES;
}

-(void) updateData
{
	[RVC.activityIndicatorView stopAnimating];
	[table reloadData];
	//[activityIndicatorView stopAnimating];
}

-(void) downloadError
{
	
	connectionError = YES;
	
	[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"downloadError", @"")
													message:NSLocalizedString(@"downloadErrorDesc", @"") 
												   delegate:self
										  cancelButtonTitle:NSLocalizedString(@"ok", @"")
										  otherButtonTitles:nil];
	
	[alert show];
	[alert release];
	
	[table reloadData];
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{

	//	[MVC pushView:HELPTOPICSVIEW];
}

-(void) slideOut
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(doneAnimatingOut)];
	
	//CGAffineTransform translate = CGAffineTransformMakeTranslation(0, 320);
	//[self.view setTransform:translate];
	[self.view setAlpha:0.0];
	[UIView commitAnimations];
}

-(void) slideIn
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationDelegate:self];	
	//CGAffineTransform translate = CGAffineTransformMakeTranslation(0, 320);
	//[self.view setTransform:translate];
	[self.view setAlpha:1.0];
	[UIView commitAnimations];
}


-(void) doneAnimatingOut
{
	//[self.view removeFromSuperview];
	
	[RVC switchView];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	//[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
	
	return YES;

}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {

	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
 */


-(void) cleanup
{
	[table removeFromSuperview];
	[[MRPolisManager sharedInstance] removeListener:self];
}


- (void)dealloc {
	[tableSections release];
    [super dealloc];
}



@end
