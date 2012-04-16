//
//  MRSharedTextures.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 3/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRSharedTextures.h"
#import "CCTexture2D.h"

static MRSharedTextures* sharedInstance = nil;

@implementation MRSharedTextures

+(MRSharedTextures*) sharedInstance
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
		textureDictionary = [[NSMutableDictionary alloc] initWithCapacity:1];
	}
	
	return self;
}

-(BOOL) textureExistsWithKey:(NSString*) keyArg
{
	
	for (NSString* key in [textureDictionary allKeys]) 
	{
		if ([key isEqualToString: keyArg]) 
		{
			return YES;
		}
	}
	return NO;
}

-(void) addTextureWithName:(NSString*) name
{
	if (![self textureExistsWithKey:name]) 
	{
		CCTexture2D *tex = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed: name]];
		[textureDictionary setValue:tex forKey:name];
		[tex release];
	}
}

-(void) addTexture:(CCTexture2D*) tex withName:(NSString*) name
{
	[textureDictionary setValue:tex forKey:name];
}

-(void) removeTextureWithName:(NSString*) name
{
	[textureDictionary removeObjectForKey:name];
}

-(void) removeAllTextures
{
	[textureDictionary removeAllObjects];
}

-(CCTexture2D*) getTextureForName:(NSString*) name
{
	return [textureDictionary objectForKey:name];
}

@end
