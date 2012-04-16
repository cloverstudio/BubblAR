//
//  MarketRaidBetaAppDelegate.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 3/17/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MarketRaidBetaAppDelegate.h"
#import "ARGeoViewController.h"
#import "EAGLView.h"
#import "MRRootViewController.h"

@implementation MarketRaidBetaAppDelegate

@synthesize window;
@synthesize glView;
@synthesize geoViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

	
//	[application setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];

    // Override point for customization after application launch
	CGRect winrect = [[UIScreen mainScreen] bounds];
	window = [[UIWindow alloc] initWithFrame:winrect];
	
    geoViewController = [[ARGeoViewController alloc] init];
	geoViewController.delegate = self;
	geoViewController.scaleViewsBasedOnDistance = YES;
	geoViewController.minimumScaleFactor = .5;
	geoViewController.rotateViewsBasedOnPerspective = YES;
	[geoViewController startListening];
	//geoViewController.cameraController.cameraOverlayView = glView;
	
	glView = [[EAGLView alloc] initWithCoder:nil];
	glView.animationInterval = 1./60.;
	[glView startAnimation];
	glView.arView = geoViewController;
		
	//geoViewController.cameraController.cameraOverlayView = glView;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
	NSString *currentLanguage = [languages objectAtIndex:0];
	
	//NSLog(@"Current Locale: %@", [[NSLocale currentLocale] localeIdentifier]);
	//NSLog(@"Current language: %@", currentLanguage);
	//NSLog(@"Welcome Text: %@", NSLocalizedString(@"bla", @""));
	
	//NSString *bla = NSLocalizedString(@"bla", nil);
	
	//NSLog(@"lokalizacija = %@", bla);
	
	[window addSubview:geoViewController.view];
	[window addSubview:glView];
	
	[window makeKeyAndVisible];
}

- (UIView *)viewForCoordinate:(ARCoordinate *)coordinate;
{
	return nil;
}

- (void)dealloc 
{
	[glView removeFromSuperview];
	[glView release];
	[geoViewController.view removeFromSuperview];
	[geoViewController release];
    [window release];
    [super dealloc];
}


@end
