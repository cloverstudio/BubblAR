//
//  MRObjectGroupManager.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMGameObject.h"
#import "OpenGLCommon.h"

@class CCTexture2D;
@class MRObject;
@class WMConcreteSubject;
@interface MRObjectGroupManager : NSObject <WMGameObjectProtocol>{

	float zRot;
	NSMutableArray *objectGroupArray;
	MRObject *touchedObject;
	WMConcreteSubject *concreteSubject;
	CCTexture2D *selectBubbleLabel;
	BOOL touched;
	BOOL swipe;
	BOOL running;
}
@property (assign) WMConcreteSubject *concreteSubject;
@property (assign) MRObject *touchedObject;
@property BOOL swipe;
@property BOOL running;

+(MRObjectGroupManager*) sharedInstance;
-(BOOL) checkGroupings:(NSArray*) objects;
-(void) isGroupObject:(MRObject*) object;
-(void) addObject:(MRObject *)object;
-(void) removeObject:(MRObject *)object;
-(void) removeAllObjects;
-(void) makeCircularTable;
-(void) makeLinearTable;
-(void) moveItems:(float) distance;
-(void) start;
-(void) stop;
-(void) alignObjectsLeftFromPosition:(Vector3D) position;
-(void) alignObjectsRightFromPosition:(Vector3D) position;



@end

