//
//  MRInfoPanelViewController.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 3/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRInfoPanelViewController.h"
#import "MRObject.h"
#import "MRLabel.h"
#import "MarketRaidBetaAppDelegate.h"
#import "CocosWMBridge.h"
#import "ARToGLCoordinates.h"
#import "MRPlacemark.h" 
#import "ConstantsAndMacros.h"
#import "WMGamestate.h"
#import "MRObjectManager.h"

#import "MRInfoView.h"
#import "MRMapView.h"
#import "MRWebView.h"

@implementation MRInfoPanelViewController
@synthesize selectedObject;
@synthesize selectedObjects;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

-(id) initWithRVC:(MRRootViewController*) rvcArg
{
	if (self = [super init]) 
	{
		
		RVC = rvcArg;
		hidden = YES;
		UIView *tempView = [[UIView alloc] initWithFrame:IPHONE_SCREEN_LANDSCAPE_RECT];
		self.view = tempView;
		[tempView release];
		lastTouchedId = -1;

		[[CocosWMBridge inst] setObjectTouchDelegate:self selector:@selector(objectTouched)];
	}
	
	return self;
}

-(void) addView:(int)viewArg
{
	
	switch (viewArg) {
		case INFO_VIEW:
			[self showInfoView];
			break;
		case MAP_VIEW:
			[self showMapView];
			break;
		case WEB_VIEW:
			[self showWebView];
			break;
		default:
			break;
	}
}

-(void) showInfoView
{

	infoView = [[MRInfoView alloc] initWithFrame:CGRectMake(480, 0, 353, 320)];
	infoView.RVC = self;
	infoView.userInteractionEnabled = YES;
	[self.view addSubview:infoView];
	[infoView release];
	[infoView slideIn];	
	[infoView updateData];
	hidden = NO;
}

-(void) hideInfoView
{
	selectedObject = nil;
	lastTouchedId = -1;
	[infoView slideOut];
	hidden = YES;
}

-(void) showMapView
{
	hidden = NO;

	mapView = [[MRMapView alloc] initWithFrame:CGRectMake(0, 320, 480, 320)];
	mapView.RVC = self;
	[self.view addSubview:mapView];
	[mapView release];
	
	[mapView updateData];
	[mapView slideIn];
}

-(void) hideMapView
{
	[mapView slideOut];
	hidden = YES;

}

-(void) showWebView
{
	hidden = NO;
	webView = [[MRWebView alloc] initWithFrame:CGRectMake(0, 320, 480, 320)];
	webView.RVC = self;
	[self.view addSubview:webView];
	[webView release];
	
	[webView updateData];
	[webView slideIn];
}

-(void) hideWebView
{
	[webView slideOut];
	hidden = YES;

}

-(void) objectTouched{
	
	int touchedId = [CocosWMBridge inst].lastTouchedId;
	
	//if(lastTouchedId != touchedId)
	//{
		lastTouchedId = touchedId;
		
		for (MRObject *mrObject in [CocosWMBridge inst].gamestate.objectManager.objectsArray) 
		{
			if (mrObject.ID == lastTouchedId) 
			{
				[self showInfo:mrObject];
			}
		}
	//}
	
	
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return NO;
}
 */


-(void) slideOpen
{

}

-(void)	showInfo:(MRObject *)mrObject
{
	if (selectedObject != nil) 
	{
		[selectedObject reset];
		selectedObject = mrObject;
		[infoView updateData];
	}
	else 
	{
		selectedObject = mrObject;
		[self showInfoView];
	}
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


- (void)dealloc {
    [super dealloc];
}


@end
