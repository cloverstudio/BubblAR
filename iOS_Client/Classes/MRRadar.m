//
//  MRRadar.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRRadar.h"
#import "MRSharedTextures.h"
#import "MRObjectManager.h"
#import "MRObject.h"
#import "OpenGLCommon.h"
#import "CCTexture2D.h"
#import "MRRadarPOI.h"
#import "WMConcreteSubject.h"

@implementation MRRadar
@synthesize distance;
@synthesize concreteSubject;

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

-(id) initWithSubject:(WMConcreteSubject*) subject
{
	if (self = [super init]) 
	{
		radarPOIArray = [[NSMutableArray alloc] init];
		concreteSubject = subject;
		distance = 0.0;
		rulerTex = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"ruler.png"]];
		rulerRect = CGRectMake(0, 20, 480, 20);
	}
	
	return self;
}

-(void) update
{
	
	if ([[MRObjectManager sharedInstance] running]) 
	{
		//checking for objects to add to radar...
		for (MRObject *object in [[MRObjectManager sharedInstance] objectsArray]) 
		{
			BOOL exists = NO;
			
			for (MRRadarPOI *radarPOI in radarPOIArray) 
			{
				if ([radarPOI.mrObject isEqual:object]) 
				{
					exists = YES;
				}
			}
			
			if (!exists) 
			{
				MRRadarPOI *tempPOI = [[MRRadarPOI alloc] initWithSubject:concreteSubject andObject:object];
				[radarPOIArray addObject:tempPOI];
				[tempPOI release];
			}
		}
		
		
		for (MRRadarPOI *radarPOI in radarPOIArray) 
		{
			[radarPOI update];
		}
	}
	else //if object manager isnt running we dont need any pois in the radar.
	{
		[radarPOIArray removeAllObjects];
	}
	
	
}

-(void) draw
{
	
	if ([[MRObjectManager sharedInstance] running]) 
	{
		glEnable(GL_TEXTURE_2D);
		glEnable(GL_BLEND);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		glEnable2D();
		
		[rulerTex drawInRect:rulerRect];
		
		for (MRRadarPOI *radarPOI in radarPOIArray) 
		{
			[radarPOI draw];
		}
		
		glDisable2D();
		glDisableClientState(GL_TEXTURE_COORD_ARRAY);
		glDisable(GL_BLEND);
		glDisable(GL_TEXTURE_2D);
	}
}

-(void) reset
{}

-(void) cleanup
{
	//checking for objects which are disposed 
	
	int i;	//DANGEROUS :P
	for(i=0; i<[radarPOIArray count]; i++) {
		MRObject* object = [[radarPOIArray objectAtIndex:i] mrObject];
		if(object.dispose == YES) 
		{
			[radarPOIArray removeObjectAtIndex:i];
			i--;
		}
	}	
}

-(void) dealloc
{
	[rulerTex release];
	[radarPOIArray release];
	[super dealloc];
}

-(void) loadObject
{}

-(float) distance
{
	//because radar is part of the hud
	return 0.0;
}

-(NSComparisonResult) compareDistance:(id <MRDrawable>) object
{
	if (distance < [object distance])
	{
		return NSOrderedAscending;
	}
	else if (distance > [object distance]) 
	{
		return NSOrderedDescending;
	}
	else 
	{
		return NSOrderedSame;
	}	
}


@end
