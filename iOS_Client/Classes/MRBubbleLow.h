//
//  MRBubbleLow.h
//  EffectTestGround
//
//  Created by marko.hlebar on 4/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenGLCommon.h"
#import "MRObjectDrawingManager.h"

@class WMConcreteSubject;
@interface MRBubbleLow : NSObject <MRDrawable> {
	
	Vector3D position;
	Vector3D velocity;
	Vector3D acceleration;
	Color3D materialColor;
	Color3D *color;
	float scaling;
	float time;
	float aliveTime;
	BOOL alive;
	
	float distance;
	int drawingType;
	
	WMConcreteSubject *concreteSubject;
}

@property int drawingType;
@property float distance;
@property (assign) WMConcreteSubject *concreteSubject;
@property Vector3D position;
@property float scaling;
@property BOOL alive;

-(id) initAtPosition:(Vector3D) positionArg;
-(void) makeColorsBlue:(int) numVertices;
-(void) makeMaterialColor;

-(void) reset;
-(void) update;
-(void) draw;

@end
