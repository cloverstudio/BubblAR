//
//  CocosWMBridge.m
//  AirRaidBeta
//
//  Created by ken yasue on 3/8/10.
//  Copyright 2010 clover studio. All rights reserved.
//

#import "CocosWMBridge.h"
#import "WMGamestate.h"
#import "MRObject.h"
#import "MRObjectManager.h"

CocosWMBridge *_CocosWMBridge;

@implementation CocosWMBridge
@synthesize gamestate;

@synthesize currentLocation;
@synthesize initialLocation;

@synthesize isLoad;
@synthesize lastTouchedId;

-(id) init{
	
	self = [super init];
	
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[locationManager startUpdatingLocation];
	
	isLoad = NO;
	
	return self;
	
}

+(CocosWMBridge *)inst
{
	@synchronized([CocosWMBridge class])
	{
		if (!_CocosWMBridge)
			_CocosWMBridge = [[self alloc] init];
		
		return _CocosWMBridge;
	}
	
	// to avoid compiler warning
	return nil;
}

-(void) startGame{
	
	[gamestate startGame];
	
}

/*
-(void) sendTouchBegin:(CGPoint)point{

	[gamestate setTouch:YES :YES :point :point];
	
}

-(void) sendTouchEnd:(CGPoint)point{
	[gamestate setTouch:NO :NO :point :point];
}
*/

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	
	
	if(initialLocation == nil){
		self.initialLocation = newLocation;
		
	//	NSLog(@"initialLocation = (%Lf, %Lf)", initialLocation.coordinate.latitude, initialLocation.coordinate.longitude);
	}
	
	
	//self.initialLocation = [[CLLocation alloc] initWithLatitude:46.0 longitude:16.0];
	
	self.currentLocation = newLocation;
	if (objectChangePositionInvocation) 
	{
		[objectChangePositionInvocation invoke];

	}
	
	//CLLocationCoordinate2D loc = currentLocation.coordinate;

}

-(void) setObjectTouchDelegate:(id)target selector:(SEL)selector{
	
	
	NSMethodSignature * sig1 = nil;
	sig1 = [[target class] instanceMethodSignatureForSelector:selector];
	
	objectTouchInvocation = nil;
	objectTouchInvocation = [NSInvocation invocationWithMethodSignature:sig1];
	[objectTouchInvocation setTarget:target];
	[objectTouchInvocation setSelector:selector];
	[objectTouchInvocation retain];
	
	
}

-(void) setObjectChangePositionDelegate:(id)target selector:(SEL) selector
{
	NSMethodSignature * sig1 = nil;
	sig1 = [[target class] instanceMethodSignatureForSelector:selector];
	
	objectChangePositionInvocation = nil;
	objectChangePositionInvocation = [NSInvocation invocationWithMethodSignature:sig1];
	[objectChangePositionInvocation setTarget:target];
	[objectChangePositionInvocation setSelector:selector];
	[objectChangePositionInvocation retain];
}


-(void) touchedItem:(int) ID
{
	for (MRObject *mrObject in gamestate.objectManager.objectsArray) 
	{
		if (mrObject.ID == ID) 
		{
			
			lastTouchedId = ID;
			//NSLog(@"Touched object %@", mrObject.title);
			
			if(objectTouchInvocation){
				[objectTouchInvocation invoke];
				break;
			}
			
		}
	}
}

-(void) doneLoadingObjects{
	//
	isLoad = YES;
}

@end
