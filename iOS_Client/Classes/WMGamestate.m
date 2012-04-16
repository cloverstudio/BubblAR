//
//  WMGamestate.m
//  iFireWingo
//
//  Created by Marko Hlebar on 7/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "EAGLView.h"

#import "WMFileOps.h"
#import "WMRandom.h"
#import "WMMath.h"
#import "WMCollisionDetection.h"
#import "TPEvents.h"
#import "ConstantsAndMacros.h"

#import "WMGameObject.h"
#import "WMGamestate.h"
#import "WMConcreteSubject.h"

#import "WMCamera.h"

#import "ARViewController.h"
#import "ARToGLCoordinates.h"

#import <CoreLocation/CoreLocation.h>

#import "CCTexture2D.h"

#import "CocosWMBridge.h"

#import "MRMegaman.h"
#import "MRLabel.h"
#import "MRLabelManager.h"
#import "MRObjectManager.h" 
#import "MRPolisManager.h"
#import "MRRootViewController.h"
#import "MRObjectDrawingManager.h"
#import "MRObjectTouchesManager.h"
#import "MRObjectGroupManager.h"
#import "MRBubbleOut.h"
#import "MRRadar.h"

@implementation WMGamestate

@synthesize eaglView;
@synthesize arView;

@synthesize gameStateState;
@synthesize gameStateGameNotRunning;
@synthesize gameStateGameRunning;
@synthesize gameStateGamePaused;
@synthesize gameStateGameQuit;

@synthesize gameIsRunning;

@synthesize objectManager;

-(BOOL)getButtonLock
{
	return buttonLock;
}


//loadGameState is used to load gamestate variables

#pragma mark -
#pragma mark GAME LOAD

-(void) loadGameState
{
	
	lastDate = [[NSDate date]retain];
		
	touchRadius = 20.0;
	time = 0;
	[WMRandom initRandom];	

	concreteSubject = [WMConcreteSubject new];
	[concreteSubject initConcreteSubject];
	[concreteSubject setTimeDouble:0.0];
		
	changeViewAllowed = YES;
	threadIsWorking = NO;
	threadIsDone = YES;
	
	gameIsRunning = NO;
	
	buttonLock = NO;
	currentView = -1;
		
	gameStateGameNotRunning = [[WMGamestateGameNotRunningState alloc] initWithInstance:self];
	gameStateGameRunning = [[WMGamestateGameRunningState alloc] initWithInstance:self];
	gameStateGamePaused = [[WMGamestateGamePausedState alloc] initWithInstance:self];
	gameStateGameQuit = [[WMGamestateGameQuitState alloc] initWithInstance:self];
	gameStateState = gameStateGameNotRunning;
	
}

-(void) startGame
{
	
	[self loadGame];
	//[self reset];
	gameIsRunning = YES;
}

-(void) setSphericalOrientationWithAzimuth:(float) azimuth andInclination:(float)inclination 
{
	[concreteSubject setAzimuth:RADIANS_TO_DEGREES(azimuth)];
	[concreteSubject setInclination:RADIANS_TO_DEGREES(inclination)];
	
}

-(void)setCameraDirection:(Vector3D)dir
{
	[concreteSubject setCameraDirection:dir];
}


-(void)setTouch:(BOOL) t1:(BOOL)t2:(CGPoint)touchPos1:(CGPoint)touchPos2
{
	/*
	touch1 = t1;
	touch2 = t2;
	touchPosition1 = touchPos1;
	touchPosition2 = touchPos2;
	 */
	[concreteSubject setTouch1:t1];
	[concreteSubject setTouch2:t2];
	[concreteSubject setTouchPosition1:touchPos1];
	[concreteSubject setTouchPosition2:touchPos2];
	 
}

//loadGame loads all game data

-(void) loadGame
{	
	camera = [WMCamera new];
	[(WMCamera*) camera setConcreteSubject:concreteSubject];
	[camera loadObject];
	[camera attachGameObject];
	
	objectManager = [MRObjectManager sharedInstance];
	[objectManager setRVC:eaglView.rootController];
	[objectManager setConcreteSubject:concreteSubject];
	[objectManager attachGameObject];
	[objectManager stop];
	
	[[MRObjectDrawingManager sharedInstance] setConcreteSubject:concreteSubject];
	[[MRObjectDrawingManager sharedInstance] attachGameObject];
	[[MRObjectDrawingManager sharedInstance] stop];
	
	[[MRObjectTouchesManager sharedInstance] setConcreteSubject:concreteSubject];
		
	[[MRObjectGroupManager sharedInstance] setConcreteSubject:concreteSubject];
	[[MRObjectGroupManager sharedInstance] attachGameObject];
	[[MRObjectGroupManager sharedInstance] stop];
	
	MRBubbleOut *tempGUI = [[MRBubbleOut alloc] initWithSubject:concreteSubject andRootController:eaglView.rootController andGamestate:self];
	[tempGUI attachGameObject];
	[tempGUI release];
	
	MRRadar *radar = [[MRRadar alloc] initWithSubject:concreteSubject];
	[radar attachGameObject];
	[radar release];

}


//setSubjectState updates the concrete subject with fresh input

-(void)setSubjectState
{
	[concreteSubject setTimeDouble:time];
}

#pragma mark -
#pragma mark ITEM SHOP


#pragma mark -
#pragma mark COLLISION DETECTION

-(void) collisionDetection
{
	//[gameStateState collisionDetection];
	//[humanPlayer collisionDetection];
}

-(void) doCollisionDetection
{	

}


#pragma mark -
#pragma mark UPDATE

-(void) cleanup
{
	[gameStateState cleanup];
}

-(void) doCleanup
{
	[concreteSubject cleanup];
}

-(void) update
{
	[gameStateState update];
}

-(void) doUpdate
{
	
	NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:lastDate];
	time += elapsedTime;
	
	[lastDate release];
	lastDate = [[NSDate date]retain];
	
	//if group manager is running, force camera direction.
	if ([MRObjectGroupManager sharedInstance].running) {
		[concreteSubject setCameraDirection:Vector3DMake(10,0,0)];
	}
	
	//if touch
	if ([concreteSubject getTouch1] == YES) 
	{
		[concreteSubject setTouchVector:[self calculateTouchVector]];
	}
	
	if ([[MRPolisManager sharedInstance] isPolisSelected]) 
	{
		//[objectManager start];
	}
	
	//TODO CHANGE THIS!!!!!1
	if (objectManager.urlDone && objectManager.changeViewAllowed)// && changeViewAllowed) 
	{
		objectManager.changeViewAllowed = NO;
		[eaglView.rootController changeView:BB_INFO_PANEL_VIEW];
		
	}
	
	[concreteSubject setTimeDouble:time];
	[concreteSubject setElapsedTime:elapsedTime];
	[concreteSubject notify];
	
	
	//time += eaglView.animationInterval;
	
	[self handleEvents];
	[self setSubjectState];
}

-(Vector3D) calculateTouchVector
{
	
	CGPoint touchPosition = [concreteSubject getTouchPosition1];
	touchPosition.y = 320.0 - touchPosition.y;
	CGPoint centerCoord = IPHONE_CENTERCOORDINATE_LANDSCAPE;
	
	CGPoint relativeTouchPos = CGPointMake(touchPosition.x - centerCoord.x, touchPosition.y - centerCoord.y);
	
	Vector3D cameraDir = [concreteSubject getCameraDirection];
	
	float alpha = IPHONE_FOV_WIDTH * relativeTouchPos.x / 480.0;
	float beta = IPHONE_FOV_HEIGHT * relativeTouchPos.y / 320.0;
	
	float focus = -IPHONE_FOCUS / 100;	//m
	
	Vector3D originVec = Vector3DMultiplyByScalar(cameraDir, focus);
	
	Vector3D direction = Vector3DMakeWithStartAndEndPoints(originVec, Vector3DMake(0,0,0));
	
	Matrix3DRotateVectorZ(&direction, -alpha * 2);
	direction.z += beta * 2;

	return direction;

}


-(void) handleEvents
{
	TPEvent tempEvent = [concreteSubject getEvent];
	
	if([loaderThread isExecuting] == NO && tempEvent.onEvent == YES)
	{	
		if(buttonLock == NO)
		{
			//[eaglView setTouch1:NO];
			//[eaglView setTouch2:NO];
			buttonLock = YES;

		}
	}
	
	if([loaderThread isFinished] == YES && threadIsWorking == YES)
	{
		
		threadIsWorking = NO;
		buttonLock = NO;
		//[loadingView detachGameObject];
		
		
		switch (viewToBe) {
			default:
				break;
		}
		
		[self destroyCurrentView];
		
		currentView = viewToBe;
		
	}
	
	[self destroyEvents];
	
}

-(void) destroyEvents
{
	buttonLock = NO;
	
	TPEvent tempEvent;
	
	tempEvent.name = nil;
	tempEvent.onEvent = NO;
	
	[concreteSubject setEvent:tempEvent];
}

#pragma mark -
#pragma mark DRAW

-(void) draw
{
	//[bullet draw];
	[gameStateState draw];
}

-(void) doDraw
{

	[concreteSubject drawAll];

}


//DESTROY THE VIEWS

-(void) destroyCurrentView
{
	switch (currentView) {
		default:
			break;
	}
}


-(void) setView:(int) nooView
{
	
	viewToBe = nooView;
	
	
	switch (nooView) {
		default:
			break;
	}
	
	//[newView setEaglView:eaglView];
	
	if(loaderThread != nil)
	{
		[loaderThread release];
		loaderThread = nil;
	}
	loaderThread = [[NSThread alloc] initWithTarget:self selector:@selector(performLoad:) object:(id)newView];
	[loaderThread start];
	threadIsWorking = YES;
	threadIsDone = NO;

}

-(void)performLoad:(id)sender
{
	
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	sleep(0.2);
	[sender setConcreteSubject:concreteSubject];
	[self performSelectorOnMainThread:@selector(performCurrentTextureLoad:) withObject:sender waitUntilDone:YES];	
	[pool drain];
	
}

//PERFORM ASYNCHRONOUS LOAD
-(void)performCurrentTextureLoad:(id)sender
{
	[sender loadObject];
}

#pragma mark -
#pragma mark RESET

-(void) resetToMenu
{
	[self reset];	
}

-(void) resetToGame
{	
	
}

-(void) reset
{

	
	
}

-(void) doReset
{}

//DEALLOC OBJECTS

-(void) dealloc
{
	
	[origin release];
	[concreteSubject release];
	[(WMCamera*)camera release];
	camera = nil;
	[loaderThread release];
	loaderThread = nil;
	[self destroyCurrentView];
	[super dealloc];
}

@end
