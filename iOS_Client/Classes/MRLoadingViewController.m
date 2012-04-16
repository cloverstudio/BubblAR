//
//  MRLoadingViewController.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 3/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRLoadingViewController.h"
#import "ConstantsAndMacros.h"
#import "MRRootViewController.h"

@implementation MRLoadingViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

-(id) initWithRVC:(MRRootViewController *) rvcArg
{

	if (self = [super init]) 
	{
		
		RVC = rvcArg;
		
		UIView *tempView = [[UIView alloc] initWithFrame:IPHONE_SCREEN_LANDSCAPE_RECT];
		self.view = tempView;
		[tempView release];
		
		bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgTex.png"]];
		bgImageView.frame = IPHONE_SCREEN_LANDSCAPE_RECT;
		[self.view addSubview:bgImageView];
		
		[bgImageView release];
		
	}
	return self;
}

-(void) hideLoadingView
{
	[RVC changeView:BB_INFO_PANEL_VIEW];
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


-(void) doneAnimatingOut
{
	//[self.view removeFromSuperview];
	
	[RVC switchView];
}


-(void) slideIn
{

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
