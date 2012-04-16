//
//  MRRootViewController.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRRootViewController.h"
#import "MRLoadingViewController.h"
#import "MRInfoPanelViewController.h"
#import "MRChannelTableViewController.h"
#import "MRBubbleOutViewController.h"
#import "MRPolisInfoView.h"
#import "MRMapViewController.h"

#import "ConstantsAndMacros.h"
#import "MRViewController.h"
#import "MRPolisManager.h"
#import "EAGLView.h"

@implementation MRRootViewController
@synthesize activityIndicatorView;
@synthesize currentViewController;
@synthesize glView;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
	{
		
		UIView *tempView = [[UIView alloc] initWithFrame:IPHONE_SCREEN_LANDSCAPE_RECT];
		self .view = tempView;
		[tempView release];
        // Custom initialization
		activitiesInProgress = 0;
		
		[self changeView:BB_LOADING_VIEW];
		loadingTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(hideLoadingView) userInfo:nil repeats:NO];
		
		activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		activityIndicatorView.frame = CGRectMake(230, 200, 20, 20);
		
		[self.view addSubview:activityIndicatorView];
		[activityIndicatorView release];
    }
    return self;
}

-(void) hideLoadingView
{
	
	[self changeView:BB_CHANNEL_TABLE_VIEW];
}

-(void) changeView:(int) currentViewArg
{	
	//[activityIndicatorView startAnimating];
	//[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
	[self addActivity];
	currentView = currentViewArg;
	
	//check if there is a view to be changed, if not just put a new view on
	if (currentViewController != nil) [currentViewController slideOut];	
	else [self switchView];
}

-(void) removeView
{
	if (currentViewController != nil) 
	{
		[currentViewController cleanup];
		[currentViewController.view removeFromSuperview];		
		[currentViewController release];
		//currentViewController = nil;
	}
}

-(void) addActivity
{
	activitiesInProgress++;
	
	if (activitiesInProgress > 0) 
	{
		[activityIndicatorView startAnimating];
	}
}

-(void) removeActivity
{
	activitiesInProgress--;
	
	if (activitiesInProgress < 0) activitiesInProgress = 0;
	
	if (activitiesInProgress == 0) 
	{
		[activityIndicatorView stopAnimating];
	}
}

-(void) switchView
{
	[self removeView];
	//give processor time to views
	[glView stopAnimation];
			
	switch (currentView) 
	{
		case BB_LOADING_VIEW:
			currentViewController = [[MRLoadingViewController alloc] initWithRVC:self];
			break;
		case BB_CHANNEL_TABLE_VIEW:
			currentViewController = [[MRChannelTableViewController alloc] initWithRVC:self];
			break;
		case BB_POLIS_INFO_VIEW:
			currentViewController = [[MRPolisInfoView alloc] initWithRVC:self];
			[glView startAnimation];
			break;
		case BB_INFO_PANEL_VIEW:
			currentViewController = [[MRInfoPanelViewController alloc] initWithRVC:self];
			[glView startAnimation];
			break;
		case BB_BUBBLE_OUT_VIEW:
			currentViewController = [[MRBubbleOutViewController alloc] initWithRVC:self];
			[glView startAnimation];
			break;
		case BB_MAP_VIEW:
			currentViewController = [[MRMapViewController alloc] initWithRVC:self];
			break;
		default:
			break;
	}
	
	
	[self.view addSubview:currentViewController.view];
	[currentViewController slideIn];
	
	[self removeActivity];
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
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
 */


- (void)dealloc {
	[self removeView];
    [super dealloc];
}


@end
