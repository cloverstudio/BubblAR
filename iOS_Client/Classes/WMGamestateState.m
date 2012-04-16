//
//  WMGamestateState.m
//  AirRaidBeta
//
//  Created by marko.hlebar on 3/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WMGamestateState.h"
#import "WMGamestate.h"

@implementation WMGamestateState
@synthesize instance;

-(id) initWithInstance:(WMGamestate*) arg
{
	if (self = [super init]) 
	{
		instance = arg;
	}
	
	return self;
}

-(void) update
{}
-(void) draw
{}
-(void) collisionDetection
{}
-(void) reset
{}
-(void) cleanup
{}

@end

@implementation WMGamestateGameNotRunningState

-(void) update
{
	if (instance.gameIsRunning) 
	{
		instance.gameStateState = instance.gameStateGameRunning;
	}
}

@end


@implementation WMGamestateGameRunningState 

-(void) update
{
	[instance doUpdate];
}

-(void) draw
{
	[instance doDraw];
}

-(void) cleanup
{
	[instance doCleanup];
}

-(void) collisionDetection
{
	[instance doCollisionDetection];
}

@end

@implementation WMGamestateGamePausedState

-(void) draw
{
	[instance doDraw];
}

@end

@implementation WMGamestateGameQuitState

-(void) reset
{
	//[instance doSave];
	[instance doReset];
}

@end
