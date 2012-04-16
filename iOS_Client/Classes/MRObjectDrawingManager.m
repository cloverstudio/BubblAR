//
//  MRObjectDrawingManager.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRObjectDrawingManager.h"
#import "MRObject.h"
#import "WMConcreteSubject.h"

static MRObjectDrawingManager *sharedInstance = nil;

@implementation MRObjectDrawingManager
@synthesize concreteSubject;
@synthesize objects;
+(MRObjectDrawingManager*) sharedInstance
{
	@synchronized(self)
	{
		if (sharedInstance == nil) 
		{
			sharedInstance = [[self alloc] init];
		}
		return sharedInstance;
	}
	return nil;
}

-(id) init
{
	if (self = [super init]) 
	{
		objects = [[NSMutableArray alloc] initWithCapacity:1];
		[self start];
	}
	return self;
}

-(void) addObject:(id <MRDrawable>) object
{
	[objects addObject:object];
	[self sortObjects];

}

-(void) removeObject:(id <MRDrawable>) object
{
	[objects removeObject:object];
}

-(void) removeAllObjects
{
	[objects removeAllObjects];
}

-(void) sortObjects
{
	[objects sortUsingSelector:@selector(compareDistance:)];
	//[objects sortUsingSelector:@selector(compareType:)];
}

-(void) start
{
	running = YES;
}
-(void) stop
{
	running = NO;
}

-(void) draw
{
	if (running) 
	{
		for (int i = [objects count] - 1; i >= 0 ; i--) 
		{
			[[objects objectAtIndex:i] draw];

		}
	}
}

-(void) attachGameObject
{
	[concreteSubject attach:self];
}

-(void)detachGameObject
{
	[concreteSubject detach:self];
}

-(void) insertGameObjectAtIndex:(int) index
{
	[concreteSubject insertObject:self atIndex:index];
}

-(void) loadObject{}
-(void) cleanup{}
-(void) update{}

-(void) reset
{
	[self stop];
	[self removeAllObjects];
}

-(void) dealloc
{
	[super dealloc];
}


@end
