//
//  WMConcreteSubject.m
//  iFireWingo
//
//  Created by Marko Hlebar on 7/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WMConcreteSubject.h"


@implementation WMConcreteSubject
@synthesize gameObjects;
/*
@synthesize position;
@synthesize velocity;
@synthesize elapsedTime;
@synthesize gas;
@synthesize touch1;
@synthesize touch2;
@synthesize touchPosition1;
@synthesize touchPosition2;
*/
 
-(void) attach:(id<WMGameObjectProtocol>) object
{
	if(gameObjects != nil)
		[gameObjects addObject:object];	
	
	//[self fillFastArray];
}

-(void) detach:(id<WMGameObjectProtocol>) object
{
	if(gameObjects != nil)
	{
		[gameObjects removeObject:object];
		//[object release];
	}	
	//[self fillFastArray];
}

-(void) insertObject:(id<WMGameObjectProtocol>) object atIndex:(int) index
{
	if(gameObjects != nil)
	{
		[gameObjects insertObject:object atIndex:index];
	}
}

-(void) fillFastArray
{
	/*
	int i = 0;
	for(id<WMGameObjectProtocol> object in gameObjects)
	{
		fastGameObjects[i++] = object;
	}
	 */
}

-(void) notify
{
	
	////NSLog(@"NOTIFY");
/*
	for(int i = 0; i < gameObjects.count; i++)
	{
				timerStart();
		[fastGameObjects[i] update];
		timerStopAndPrint(@"ConcreteSubject - Update");
	}
*/
	
//	timerStart();
	for(id<WMGameObjectProtocol> object in gameObjects)
	{
	//	timerStart();
		[object update];
	//	timerStopAndPrint(@"subject update");
	}
//	timerStopAndPrint(@"ConcreteSubject - Update");

}

-(void) drawAll
{
	//timerStart();
	for(id<WMGameObjectProtocol> object in gameObjects)
	{
		[object draw];
	}
//	timerStopAndPrint(@"ConcreteSubject - Draw");
	/*
	for(int i = 0; i < gameObjects.count; i++)
	{
		[fastGameObjects[i] draw];
	}
	 */
	
}

-(void) cleanup
{
	for(id<WMGameObjectProtocol> object in gameObjects)
	{
		[object cleanup];
	}
}

-(void) resetAll
{
	for(id<WMGameObjectProtocol> object in gameObjects)
	{
		[object reset];
	}
}

-(void) initConcreteSubject
{
	//gas = 5;
		//position = CGPointMake(0,0);
	//velocity = CGPointMake(0,0);
	//elapsedTime = 1.0/60.0;
	
	gameObjects = [NSMutableArray new];
}

//PROPERTIES

//TOUCH VECTOR
-(Vector3D) getTouchVector
{
	return touchVector;
}

-(void) setTouchVector:(Vector3D) arg
{
	touchVector = arg;
}

//PLAYER POSITION
-(Vector3D) getPlayerPosition
{
	return playerPosition;
}

-(void) setPlayerPosition:(Vector3D) arg
{
	playerPosition = arg;
}

//ENEMY BOMBERS
-(NSMutableArray*) getEnemyBombers
{
	return enemyBombers;
}

-(void) setEnemyBombers:(NSMutableArray*) arg
{
	enemyBombers = arg;
}


//EVENTS
-(TPEvent) getEvent
{
	return event;
}

-(void) setEvent:(TPEvent) arg
{
	event = arg;
}


//CAMERA
-(Vector3D) getCameraPosition
{
	return cameraPosition;
}

-(void) setCameraPosition:(Vector3D) arg
{
	cameraPosition = arg;
}

-(Vector3D) getCameraDirection
{
	return cameraDirection;
}

-(void) setCameraDirection:(Vector3D) arg
{
	cameraDirection = arg;
}

//SPHERICAL ORIENTATION
-(float) getInclination
{
	return inclination;
}

-(void) setInclination:(float) inclinationArg
{
	inclination = inclinationArg;
}

-(float) getAzimuth
{
	return azimuth; 
}

-(void) setAzimuth:(float) azimuthArg
{
	azimuth = azimuthArg;
}

//TIME
//double timeDouble;
-(double) getTimeDouble
{
	return timeDouble;
}

-(void) setTimeDouble:(double) arg
{
	timeDouble = arg;
}

-(double) getElapsedTime
{
	return elapsedTime;
}

-(void) setElapsedTime:(double) arg
{
	elapsedTime = arg;
}


//TOUCH

-(BOOL) getTouch1
{
	return touch1;
}

-(void) setTouch1:(BOOL) arg
{
	touch1 = arg;
}

-(BOOL) getTouch2
{
	return touch2;
}

-(void) setTouch2:(BOOL) arg
{
	touch2 = arg;
}

-(CGPoint) getTouchPosition1
{
	return touchPosition1;
}

-(void) setTouchPosition1:(CGPoint) arg
{
	touchPosition1 = arg;
}

-(CGPoint) getTouchPosition2
{
	return touchPosition2;
}

-(void) setTouchPosition2:(CGPoint) arg
{
	touchPosition2;
}


-(void)getState
{
	
}

-(void)setState
{

}



-(void) dealloc
{
	[gameObjects removeAllObjects];
	[gameObjects release];
	gameObjects = nil;
	[super dealloc];
}

@end
