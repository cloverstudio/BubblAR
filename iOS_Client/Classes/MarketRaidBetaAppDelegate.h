//
//  MarketRaidBetaAppDelegate.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 3/17/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARViewController.h"

@class ARGeoViewController;
@class EAGLView;
@class MRRootViewController;
@interface MarketRaidBetaAppDelegate : NSObject <UIApplicationDelegate, ARViewDelegate> {
    UIWindow *window;
	EAGLView *glView;
	MRRootViewController *rootView;
	ARGeoViewController *geoViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) EAGLView *glView;
@property (nonatomic, retain) ARGeoViewController *geoViewController;

@end

