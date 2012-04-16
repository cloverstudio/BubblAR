//
//  MRObjectState.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRObjectState.h"
#import "MRObject.h"
#import "MRBubble.h"
#import "MRObjectDrawingManager.h"

@implementation MRObjectState

-(id) initWithInstance:(MRObject*) instanceArg
{
	
	if (self = [super init]) 
	{
		instance = instanceArg;
	}
	return self;
}


-(void) updateObject{}
-(void) drawObject{}
-(void) updateBubble{}
-(void) drawBubble{}
-(void) drawDetailObject{}
-(void) updateDetailObject{}

@end


@implementation MRObjectStateAlive

-(void) updateObject
{
	
	[instance updateObject];
	
	if (instance.visible) 
	{
		instance.state = instance.stateAliveAndVisible;
		return;
	}
	
	if (instance.touched) 
	{
		instance.distance = 0.0;
		[[MRObjectDrawingManager sharedInstance] sortObjects];	//to get the frustum culling ok
		instance.bubble.popped = YES;
		instance.state = instance.statePopped;
		return;
	}
	
}

-(void) updateBubble
{
	[instance updateBubble];
}

@end

@implementation MRObjectStateAliveAndVisible

-(void) updateObject
{
	[instance updateObject];

	if (!instance.visible) 
	{
		instance.state = instance.stateAlive;
		return;
	}
	
	if (instance.touched) 
	{
		instance.distance = 0.0;
		[[MRObjectDrawingManager sharedInstance] sortObjects];	//to get the frustum culling ok
		instance.bubble.popped = YES;
		instance.state = instance.statePoppedAndVisible;
		return;
	}
}

-(void) drawObject
{
	[instance drawObject];
}

-(void) updateBubble
{
	[instance updateBubble];
}

-(void) drawBubble
{
	[instance drawBubble];
}

@end

@implementation MRObjectStatePopped

-(void) updateBubble
{

	[instance updateBubble];
	
	if (instance.visible) 
	{
		instance.state = instance.statePoppedAndVisible;
		return;
	}
	
	if (instance.doneAnimating) 
	{
		instance.state = instance.stateDoneAnimating;
		return;
	}
	
}

-(void) updateDetailObject
{
	[instance updateDetailObject];
}

-(void) drawDetailObject
{
	[instance drawDetailObject];
}

@end

@implementation MRObjectStatePoppedAndVisible

-(void) updateBubble
{

	[instance updateBubble];
	
	
	if (!instance.visible) 
	{
		instance.state = instance.statePopped;
		return;
	}
	
	if (instance.doneAnimating) 
	{
		instance.state = instance.stateDoneAnimating;
		return;
	}
	 
	
}

-(void) drawBubble
{
	[instance drawBubble];
}

-(void) updateDetailObject
{
	[instance updateDetailObject];
}

-(void) drawDetailObject
{
	[instance drawDetailObject];
}

@end

@implementation MRObjectStateDoneAnimating 

-(void) updateDetailObject
{
	[instance updateDetailObject];
}

-(void) drawDetailObject
{
	[instance drawDetailObject];
}

@end
