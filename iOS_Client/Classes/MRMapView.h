//
//  MRMapView.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class MRPlacemark;

@class MRInfoPanelViewController;
@interface MRMapView : UIView <MKMapViewDelegate>
{	
	MKMapView *mapView;
	MRPlacemark *originPlacemark;

	MRInfoPanelViewController *RVC;
}

@property (assign) MRInfoPanelViewController *RVC;

-(void) slideIn;
-(void) slideOut;
-(void) updateData;

@end
