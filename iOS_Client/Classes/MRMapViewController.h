//
//  MRMapViewController.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 5/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MRViewController.h"

@class MRPlacemark;
@class MRRootViewController;
@class MRBubbleOutViewController;
@interface MRMapViewController : MRViewController <MKMapViewDelegate>
{
	UIButton *optionsBtn;
	MKMapView *map;
	MRPlacemark *originPlacemark;
	MRBubbleOutViewController *modal;
}

-(id) initWithRVC:(MRRootViewController*) rvcArg;

@end
