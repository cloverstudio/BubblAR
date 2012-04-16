//
//  MRObjectTouchesManager.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRObjectTouchesManager.h"
#import "MRObject.h"
#import "MRObjectGroupManager.h"
#import "WMConcreteSubject.h"
#import "MRObjectDrawingManager.h"

static MRObjectTouchesManager *sharedInstance = nil;
@implementation MRObjectTouchesManager
@synthesize concreteSubject;

+(MRObjectTouchesManager*) sharedInstance
{
	@synchronized(self)
	{
		if (sharedInstance == nil) 
		{
			sharedInstance = [[self alloc] init];
		}
	}
	return sharedInstance;
}

-(id) init
{

	if (self = [super init]) 
	{
		touchedObjects = [[NSMutableArray alloc] initWithCapacity:1];
	}
	return self;
}

-(void) addObject:(MRObject*) object
{
	BOOL exists = NO;
	for (MRObject *obj in touchedObjects) 
	{
		if ([object isEqual:obj]) 
		{
			exists = YES;
		}
	}
	
	if (!exists) 
	{
		[touchedObjects addObject:object];
	}
}

-(void) removeObject:(MRObject*) object
{
	[touchedObjects removeObject:object];
}

-(void) removeAllObjects
{
	[touchedObjects removeAllObjects];
}

-(MRObject*) getClosestObject
{
	
	float distance = 100000000;
	MRObject *tempObject = nil;
	
	for (MRObject *object in touchedObjects) 
	{
		if (object.distance < distance) 
		{
			tempObject = object;
			distance = object.distance;
		}
	}
	
	//[[MRObjectGroupManager sharedInstance] setTouchedObject:tempObject];
	//[[MRObjectGroupManager sharedInstance] checkGroupings:[[MRObjectDrawingManager sharedInstance] objects]];
	
	return tempObject;
}

-(void) reset
{
	[self removeAllObjects];
}

@end
