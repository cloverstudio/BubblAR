//
//  CocosWMBridge.h
//  AirRaidBeta
//
//  Created by ken yasue on 3/8/10.
//  Copyright 2010 clover studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class WMGamestate;

@interface CocosWMBridge : NSObject <CLLocationManagerDelegate>{
	
	CLLocationManager *locationManager;
	
	CLLocation *currentLocation;
	CLLocation *initialLocation;
	
	WMGamestate *gamestate;	
	BOOL		isLoad;
	
	int				lastTouchedId;
	NSInvocation	*objectTouchInvocation;
	NSInvocation	*objectChangePositionInvocation;
}

+(CocosWMBridge *) inst;

-(void) startGame;
-(void) touchedItem:(int) ID;
-(void) doneLoadingObjects;
-(void) setObjectTouchDelegate:(id)target selector:(SEL)selector;
-(void) setObjectChangePositionDelegate:(id)target selector:(SEL) selector;

@property (nonatomic, assign) WMGamestate *gamestate;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) CLLocation *initialLocation;
@property (readonly) BOOL isLoad;
@property (readonly) int lastTouchedId;
@end
