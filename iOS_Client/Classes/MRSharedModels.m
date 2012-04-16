//
//  MRSharedModels.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 3/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRSharedModels.h"
#import "KEMD2Object.h"
#import "CCTexture2D.h"

static MRSharedModels *sharedInstance = nil;

@implementation MRSharedModels

+(MRSharedModels*) sharedInstance
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
		modelDictionary	= [[NSMutableDictionary alloc] initWithCapacity:1];
	}
	
	return self;
}

-(void) addModel:(KEMD2Object*) model withModelID:(int)modelID
{	

	[modelDictionary setValue:model forKey:[NSString stringWithFormat:@"%d",modelID]];

}


//check to see is the model with a certain modelID already exists in te dictionary
-(BOOL) modelExistsWithKey:(int) modelID
{
	for (NSString* key in [modelDictionary allKeys]) 
	{
		if ([key intValue] == modelID) 
		{
			return YES;
		}
	}
	return NO;
}

-(void) removeModelForKey:(int)modelID
{
	[modelDictionary removeObjectForKey:[NSString stringWithFormat:@"%d",modelID]];
}

-(void) removeAllModels
{
	[modelDictionary removeAllObjects];
}


-(KEMD2Object*) getMD2ModelWithID:(int) modelID
{
	return [modelDictionary objectForKey:[NSString stringWithFormat:@"%d",modelID]];	
}


@end
