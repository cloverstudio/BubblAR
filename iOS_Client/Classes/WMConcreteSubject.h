//
//  WMConcreteSubject.h
//  iFireWingo
//
//  Created by Marko Hlebar on 7/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenGLCommon.h"
#import "WMGameSubject.h"
#import "WMGameObject.h"
#import "TPEvents.h"

//CONCRETE SUBJECT IMPLEMENTS OBSERVER PATTERNS GAMESUBJECT PROTOCOL 
//WE USE IT TO STORE ALL IN GAME DATA THAT IS SHARED BETWEEN DIFFERENT CLASSES TO AVOID COUPLING 

@interface WMConcreteSubject : NSObject <WMGameSubjectProtocol>
{	
	//GAMEOBJECTS STORAGE
	NSMutableArray *gameObjects;
	NSMutableArray *enemyBombers;
	
	//EVENTS
	TPEvent event;
	
	//MOUSE
	BOOL touch1;
	BOOL touch2;
	CGPoint touchPosition1;
	CGPoint touchPosition2;	
	
	//TIME
	double timeDouble;
	double elapsedTime;
	
	//CAMERA
	Vector3D cameraPosition;
	Vector3D cameraDirection;
	
	//SPHERICAL ORIENTATION
	float inclination;
	float azimuth;
	
	//PLAYER POSITION
	Vector3D playerPosition;
	
	//TOUCH VECTOR
	Vector3D touchVector;	
}

-(void)initConcreteSubject;

-(void) attach:(id<WMGameObjectProtocol>) object;
-(void) detach:(id<WMGameObjectProtocol>) object;
-(void) insertObject:(id<WMGameObjectProtocol>) object atIndex:(int) index;
-(void) notify;

-(void) cleanup;
-(void) drawAll;
-(void) resetAll;

-(void) fillFastArray;

-(void) getState;
-(void) setState;


//PROPERTIES 

@property (nonatomic,retain) NSMutableArray *gameObjects;


//TOUCH VECTOR
-(Vector3D) getTouchVector;
-(void) setTouchVector:(Vector3D) arg;

//PLAYER POSITION
-(Vector3D) getPlayerPosition;
-(void) setPlayerPosition:(Vector3D) arg;

//ENEMY BOMBERS
-(NSMutableArray*) getEnemyBombers;
-(void) setEnemyBombers:(NSMutableArray*) arg;

//EVENTS
-(TPEvent) getEvent;
-(void) setEvent:(TPEvent) arg;

//CAMERA
-(Vector3D) getCameraPosition;
-(void) setCameraPosition:(Vector3D) arg;

-(Vector3D) getCameraDirection;
-(void) setCameraDirection:(Vector3D) arg;

//SPHERICAL ORIENTATION
-(float) getInclination;
-(void) setInclination:(float) inclinationArg;

-(float) getAzimuth;
-(void) setAzimuth:(float) azimuthArg;

//TIME
-(double) getTimeDouble;
-(void) setTimeDouble:(double) arg;

-(double) getElapsedTime;
-(void) setElapsedTime:(double) arg;

//MOUSE
-(BOOL) getTouch1;
-(void) setTouch1:(BOOL) arg;

-(BOOL) getTouch2;
-(void) setTouch2:(BOOL) arg;

-(CGPoint) getTouchPosition1;
-(void) setTouchPosition1:(CGPoint) arg;

-(CGPoint) getTouchPosition2;
-(void) setTouchPosition2:(CGPoint) arg;



@end
