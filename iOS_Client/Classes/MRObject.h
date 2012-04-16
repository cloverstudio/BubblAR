//
//  MRObject.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 3/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMGameObject.h"
#import "OpenGLCommon.h"
#import "WMCollisionDetection.h"
#import "MRObjectDrawingManager.h"

@class WMConcreteSubject;
@class CLLocation;
@class CCTexture2D;
@class MRBubble;
@class MRObjectState;
@interface MRObject : NSObject <WMGameObjectProtocol, MRDrawable>
{

	OBJECT_DRAWING_TYPE drawingType;
	
	WMConcreteSubject *concreteSubject;
//	CCTexture2D *modelTex;
	
	Vector3D position;
	Vector3D drawPosition;
	Vector3D velocity;
	Vector3D acceleration;
	Vector3D origin;
	Vector3D animationOffset;
	float updateAnimationTimer;
	
	Sphere boundingSphere;
	
	CLLocation *clPosition;
	int type;
	int ID;
	
	NSString *title;
	NSString *url;
	NSString *description;
	
	float distance;
	float drawDistance;
	float maxDistance;
	
	BOOL touchHandle;
	BOOL touched;
	BOOL dispose;
	BOOL visible;
	
	float scaling;
	
	int touchTicks;
	
	MRBubble *bubble;
	
	CGRect distanceLabelRect;
	
	BOOL doneAnimating;
	
	MRObjectState *state;
	MRObjectState *stateAlive;
	MRObjectState *stateAliveAndVisible;
	MRObjectState *statePopped;
	MRObjectState *statePoppedAndVisible;
	MRObjectState *stateDoneAnimating;
	

}


@property OBJECT_DRAWING_TYPE drawingType;
@property (assign) MRBubble *bubble;

@property (assign) MRObjectState *state;
@property (assign) MRObjectState *stateAlive;
@property (assign) MRObjectState *stateAliveAndVisible;
@property (assign) MRObjectState *statePopped;
@property (assign) MRObjectState *statePoppedAndVisible;
@property (assign) MRObjectState *stateDoneAnimating;

@property float scaling;

@property Sphere boundingSphere;
@property BOOL visible;
@property BOOL touched;
@property BOOL dispose;
@property float distance;
@property BOOL doneAnimating;
@property int ID;
@property int type;

@property Vector3D position;
@property Vector3D drawPosition;

@property (nonatomic, assign) WMConcreteSubject *concreteSubject;
@property (nonatomic, retain) CLLocation *clPosition;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *description; 




-(id) initWithSubject:(WMConcreteSubject *)cs
			 andTitle:(NSString*) titleArg 
	   andDescription:(NSString*) descriptionArg
			   andUrl:(NSString*) urlArg
		andCLPosition:(CLLocation*) clPositionArg 
				andID:(int) idArg
			  andType:(int) typeArg;

-(void) checkTouches;
-(void) resizeLabels;
-(void) animate;

-(void) updateObject;
-(void) drawObject;
-(void) updateBubble;
-(void) drawBubble;
-(void) updateDetailObject;
-(void) drawDetailObject;
-(void) addToDrawingManager;



@end
