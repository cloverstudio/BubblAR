//
//  WMGamestate.h
//  iFireWingo
//
//  Created by Marko Hlebar on 7/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WMGameObject.h"
#import "OpenGLCommon.h"

#import "WMGamestateState.h"
@class WMConcreteSubject;
@class EAGLView;
@class ARViewController;
//WMGamestate class is the main entry point for the game. 
//it is used to handle updates and drawings of all the objects on screen
//and also user input.

@class ARExplosion;

@class CLLocation;
@class CCTexture2D;
@class MRObjectManager;
@interface WMGamestate : NSObject
{

	CCTexture2D *house1;
	CGRect house1Rect;
	
	NSDate *lastDate;
	
	CLLocation *origin;
	
	EAGLView *eaglView;
	
	//OBJECTS
	id <WMGameObjectProtocol> camera;
	id <WMGameObjectProtocol> megaman;
	//id <WMGameObjectProtocol> label;
	//id <WMGameObjectProtocol> labelManager;
	MRObjectManager *objectManager;
	
	//CARDS	
	int currentView;
	int viewToBe;
	
	BOOL gameIsRunning;
	
	WMConcreteSubject *concreteSubject;
	
	//LOADER THREAD
	
	NSThread *loaderThread;
	BOOL threadIsWorking;
	BOOL threadIsDone;
	
	// TOUCH STATES
	 
	BOOL touch1;
	BOOL touch2;
	CGPoint touchPosition1;
	CGPoint touchPosition2;
	float touchRadius;
	
	BOOL buttonLock;			//USED TO LOCK THE BUTTONS FROM TOUCH ONCE THEY ARE PRESSED
	BOOL endGame;
	BOOL viewSwitchEvent;
	
	Vector3D touchVector;
	
	//TIME
	
	NSTimeInterval secondsPlayed;
	NSDate *beginDate;
	double time;

	id newView;
	
	ARViewController *arView;
	
	//GAME STATES
	
	id<WMGamestateStateProtocol> gameStateGameNotRunning;
	id<WMGamestateStateProtocol> gameStateGameRunning;
	id<WMGamestateStateProtocol> gameStateGamePaused;
	id<WMGamestateStateProtocol> gameStateGameQuit;
	id<WMGamestateStateProtocol> gameStateState;
	
	BOOL changeViewAllowed;
}

@property (nonatomic, retain) MRObjectManager* objectManager;

@property (assign) id<WMGamestateStateProtocol> gameStateGameNotRunning;
@property (assign) id<WMGamestateStateProtocol> gameStateGameRunning;
@property (assign) id<WMGamestateStateProtocol> gameStateGamePaused;
@property (assign) id<WMGamestateStateProtocol> gameStateGameQuit;
@property (assign) id<WMGamestateStateProtocol> gameStateState;

@property (nonatomic, assign) EAGLView *eaglView; 
@property (nonatomic, assign) ARViewController *arView;

@property BOOL gameIsRunning;

//EVENTS
-(void) handleEvents;
-(void) destroyEvents;

-(BOOL)getButtonLock;
-(void)performLoad:(id)sender;
-(void)performCurrentTextureLoad:(id)sender;

-(void)setTouch:(BOOL) t1:(BOOL)t2:(CGPoint)touchPos1:(CGPoint)touchPos2;
-(void)setCameraDirection:(Vector3D)dir;
-(void) setSphericalOrientationWithAzimuth:(float) azimuth andInclination:(float)inclination;

-(void)destroyCurrentView;
-(void) setView:(int)view;

-(void)setSubjectState;

-(void) loadGameState;
-(void) loadGame;

-(void) startGame;

-(Vector3D) calculateTouchVector;

//state functions
-(void) collisionDetection;
-(void) update;
-(void) draw;
-(void) reset;
-(void) cleanup;

//real functions
-(void) doCollisionDetection;
-(void) doUpdate;
-(void) doDraw;
-(void) doCleanup;
-(void) doReset;

-(void) resetToMenu;
-(void) resetToGame;

-(void) dealloc;

@end
