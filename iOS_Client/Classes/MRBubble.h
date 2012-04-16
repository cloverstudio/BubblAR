//
//  MRBubble.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenGLCommon.h"
#import "WMGameObject.h"
#import "MRObjectDrawingManager.h"

@class WMConcreteSubject;
@class MRBubbleState;
@interface MRBubble : NSObject <WMGameObjectProtocol, MRDrawable>
{

	Vector3D origin;
	Vector3D position;
	Vector3D velocity;
	Vector3D acceleration;
	float scaling;
	Color3D *color;
	
	Vector3D rotationAxes;
	Vector3D offset;
	Vector3D scalingOffset;

	float randomSineOffset;
	float rotation;
	
	Vector3D lightOffset;
	
	NSMutableArray *bubblesArray;
	
	BOOL alive;
	BOOL visible;
	BOOL popped;
	BOOL doneAnimating;
	
	float updateTimer;
	
	WMConcreteSubject *concreteSubject;
	
	MRBubbleState *state;
	MRBubbleState *stateAlive;
	MRBubbleState *stateAliveAndVisible;
	MRBubbleState *statePopped;
	MRBubbleState *statePoppedAndVisible;
	MRBubbleState *stateDoneAnimating;
	
	float distance;
	
	int drawingType;
	
}

@property (assign) MRBubbleState *state;
@property (assign) MRBubbleState *stateAlive;
@property (assign) MRBubbleState *stateAliveAndVisible;
@property (assign) MRBubbleState *statePopped;
@property (assign) MRBubbleState *statePoppedAndVisible;
@property (assign) MRBubbleState *stateDoneAnimating;

@property BOOL alive;
@property BOOL visible;
@property BOOL popped;
@property BOOL doneAnimating;
@property float distance;
@property int drawingType;

@property Vector3D scalingOffset;

@property (assign) WMConcreteSubject *concreteSubject;

@property Vector3D origin;
@property Vector3D position;
@property float scaling;

-(void) makeColors:(int) numVertices;
-(id) initWithSubject:(WMConcreteSubject*) subject atPosition:(Vector3D)positionArg;
-(void) update;
-(void) draw;
-(void) doUpdate;
-(void) doDraw;
-(void) updateBubbles;
-(void) drawBubbles;


@end
