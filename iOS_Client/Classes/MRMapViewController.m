//
//  MRMapViewController.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 5/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRMapViewController.h"
#import "ConstantsAndMacros.h"
#import "MRRootViewController.h"
#import "MRBubbleOutViewController.h"

@implementation MRMapViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



-(id) initWithRVC:(MRRootViewController*) rvcArg
{
	if (self = [super init]) {
		
		RVC = rvcArg; 

		UIImageView *tempView = [[UIImageView alloc] initWithFrame:IPHONE_SCREEN_LANDSCAPE_RECT];
		tempView.userInteractionEnabled = YES;
		tempView.multipleTouchEnabled = YES;
		self.view = tempView;
		[tempView release];
		
		map = [[MKMapView alloc] initWithFrame:CGRectMake(0,0,480,320)];
		//mapView.showsUserLocation = YES;
		map.scrollEnabled = YES;
		map.zoomEnabled = YES;
		map.delegate = self;
		
		optionsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		optionsBtn.frame = CGRectMake(20,20,100,72);		 
		[optionsBtn setBackgroundImage:[UIImage imageNamed:@"btnPanelHide.png"] forState:UIControlStateNormal];
		[optionsBtn addTarget:self action:@selector(btnOptionsPressed) forControlEvents:UIControlEventTouchUpInside];
		
		[self.view addSubview:map];
		[self.view addSubview:optionsBtn];
		
		[map release];
	
	}
	return self;
}

-(void) btnOptionsPressed
{
	optionsBtn.hidden = YES;
	modal = [[MRBubbleOutViewController alloc] initWithRVC:RVC parentVC:self];
	[modal slideIn];
	[self.view addSubview:modal.view];

}

-(void) hideModal
{
	optionsBtn.hidden = NO;
	[modal.view removeFromSuperview];
	[modal release];
	modal = nil;
}

-(void) doneAnimatingOut
{
	if (modal != nil) 
	{
		[self hideModal];
	}
	
	[RVC removeActivity];
	[RVC switchView];
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
