//
//  MRBubbleState.m
//  EffectTestGround
//
//  Created by marko.hlebar on 4/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRBubbleState.h"
#import "MRBubble.h"

@implementation MRBubbleState

-(id) initWithInstance:(MRBubble*) instArg
{
	
	if (self = [super init]) 
	{
		instance = instArg;
	}
	
	return self; 
}

-(void) update
{}

-(void) draw 
{}

-(void) updateBubbles
{}

-(void) drawBubbles
{}

-(void) dispose
{}

@end



@implementation MRBubbleStateAlive

-(void) update
{
	if (instance.alive) 
	{
		[instance doUpdate];
		
		if (instance.popped) 
		{
			instance.state = instance.statePopped;
			return;
		}
		
		if (instance.visible) 
		{
			instance.state = instance.stateAliveAndVisible;
			return;
		}
	}
}

@end

@implementation MRBubbleStateAliveAndVisible

-(void) update
{
	if (instance.alive) 
	{
		[instance doUpdate];
		
		if (instance.popped) 
		{
			instance.state = instance.statePopped;
			return;
		}
		
		if (!instance.visible) 
		{
			instance.state = instance.stateAlive;
			return;
		}
	}
}

-(void) draw 
{
	[instance doDraw];
}

@end

@implementation MRBubbleStatePopped 

-(void) updateBubbles
{
	if (instance.popped) 
	{
		[instance updateBubbles];

		if (instance.visible) 
		{
			instance.state = instance.statePoppedAndVisible;
			return;
		}
		
		if (instance.doneAnimating) 
		{
			instance.state = instance.stateDoneAnimating;
		}
		
	}

}


@end

@implementation MRBubbleStatePoppedAndVisible

-(void) updateBubbles
{

	if (instance.popped) 
	{
		[instance updateBubbles];
		
		if (!instance.visible) 
		{
			instance.state = instance.statePopped;
			return;
		}
		
		if (instance.doneAnimating) 
		{
			instance.state = instance.stateDoneAnimating;
		}
		
	}

}

-(void) drawBubbles
{
	[instance drawBubbles];

}

@end

@implementation MRBubbleStateDoneAnimating

/*
-(void) dispose
{
	//[instance dispose];

}
 */

@end



