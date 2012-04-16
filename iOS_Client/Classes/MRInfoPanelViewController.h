//
//  MRInfoPanelViewController.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 3/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MRViewController.h"

typedef enum
{
	INFO_VIEW,
	MAP_VIEW,
	WEB_VIEW
	
} INFO_PANEL_VIEWS;

@class MRObject;
@class MRPlacemark;
@class MRInfoView;
@class MRMapView;
@class MRWebView;

@class MRRootViewController;

@interface MRInfoPanelViewController : MRViewController {

	MRInfoView *infoView;
	MRMapView *mapView;
	MRWebView *webView;
	
	NSMutableArray *selectedObjects;
	MRObject *selectedObject;	
		
	int lastTouchedId;
}

@property (nonatomic, assign) NSMutableArray *selectedObjects;
@property (nonatomic, assign) MRObject *selectedObject;

-(id) initWithRVC:(MRRootViewController*) rvcArg;
-(void) addView:(int) viewArg;

-(void)	showInfo:(MRObject *)mrObject;

-(void) showInfoView;
-(void) hideInfoView;

-(void) showMapView;
-(void) hideMapView;

-(void) showWebView;
-(void) hideWebView;

@end
