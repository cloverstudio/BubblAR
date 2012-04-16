//
//  MRPolisManager.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRPolisManager.h"
#import "MRPolis.h"
#import "MRRootViewController.h"

static MRPolisManager *sharedInstance = nil;

@implementation MRPolisManager
@synthesize downloading;
@synthesize downloadError;
@synthesize doneLoading;
@synthesize polisArray;
@synthesize selectedPolis;
@synthesize isPolisSelected;
@synthesize polisType;
@synthesize userUrl;
@synthesize RVC;
@synthesize userPolisURL;

+(MRPolisManager*) sharedInstance
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
		[self reset];
 		polisArray = [[NSMutableArray alloc] initWithCapacity:1];
		listeners = [[NSMutableArray alloc] initWithCapacity:1];

	}
	
	return self;
}

-(void) reset
{
	polisType = POLIS_TYPE_FEATURED;
	isPolisSelected = NO;
	selectedPolis = -1;
}

-(void) cleanup
{
	
	int i;
	for(i=0; i<[polisArray count]; i++) {
		MRPolis* polis = [polisArray objectAtIndex:i];
		if(polis.dispose == YES) 
		{
			[polisArray removeObjectAtIndex:i];
			i--;
		}
	}	
}

/*
-(void) setUserPolisURL:(NSString *) url
{
	userPolisURL = [url retain];
}
 */

-(void) startDownload:(NSString*) strUrl
{
	//NSString *strUrl = [NSString stringWithString:@"http://www.bubblar.com/polislist.php"];
	
	[[HttpReader getInstance] readUrl:[NSURL URLWithString:strUrl]
							 encoding:NSUTF8StringEncoding 
							 delegate:self];
	
	downloading = YES;
	downloadError = NO;
	doneLoading = NO;
	[RVC addActivity];
}

-(void) dataReceived:(NSData*) data
{
	downloading = NO;
	downloadError = NO;
	
	NSString *tempData = [[NSString alloc ] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
	NSArray *listOfItems = [NSArray arrayWithArray:[tempData componentsSeparatedByString:@"\n"]];
	[tempData release];
	
	NSMutableArray *parsedObjectURLs = [NSMutableArray arrayWithCapacity:1];
	
	for(NSString *line in listOfItems)
	{
		
		NSArray *cols = [NSArray arrayWithArray:[line componentsSeparatedByString:@"\t"]];
		
		if ([cols count] < 4) 
		{
			continue;
		}
		
		/*
		 0 - title
		 1 - description
		 2 - icon
		 3 - image
		 4 - url
		*/
		
		NSURL *url = [NSURL URLWithString:[NSString stringWithString:(NSString*)[cols objectAtIndex:4]]];
		
		if (![self objectExists:url]) 
		{
			NSString *title = [NSString stringWithString:(NSString*)[cols objectAtIndex:0]];
			NSString *description = [NSString stringWithString:(NSString*)[cols objectAtIndex:1]];
			NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithString:(NSString*)[cols objectAtIndex:2]]];
			NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithString:(NSString*)[cols objectAtIndex:3]]];
			
			UIImage *polisIcon = [UIImage imageWithData: [NSData dataWithContentsOfURL:iconUrl]];
			
			MRPolis *polis = [[MRPolis alloc] initWithTitle:title
											 andDescription:description
												 andIconImage:polisIcon
												andImageUrl:imageUrl 
													 andUrl:url];
			
			
			if (polisType == POLIS_TYPE_FEATURED) 
			{
				[polisArray addObject:polis];
			}
			else {
				userPolis = [polis retain];
			}

			[polis release];
		}
		
		[parsedObjectURLs addObject:url];
	}
	
	[self disposeDeadObjects:parsedObjectURLs];
	[self updateListeners];
	doneLoading = YES;
	[RVC removeActivity];
}

-(void) disposeDeadObjects:(NSArray*) newObjects
{
	//Checking for polises which dont exist anymore
	BOOL notExisting = YES;	
	
	for (MRPolis *polis in polisArray) 
	{
		notExisting = YES;
		
		for (NSURL *url in newObjects) 
		{
			if ([[polis.url absoluteString] isEqualToString:[url absoluteString]]) 
			{
				notExisting = NO;
			}
		}
		
		if(notExisting)
		{
			polis.dispose = YES;
		}
		
	}
}

-(BOOL) objectExists:(NSURL*) urlArg
{
	
	for (MRPolis *polis in polisArray) 
	{
		if ([[polis.url absoluteString] isEqualToString:[urlArg absoluteString]]) 
		{
			return YES;
		}   
	}
	return NO;
}


-(void) addListener:(id <MRPolisManagerListener>) listener
{
	[listeners addObject:listener];
}

-(void) removeListener:(id <MRPolisManagerListener>) listener
{
	[listeners removeObject:listener];
}

-(void) updateListeners
{
	for (id<MRPolisManagerListener> listener in listeners) 
	{
		[listener updateData];
	}
}

-(void) updateListenersForError
{
	for (id<MRPolisManagerListener> listener in listeners) 
	{
		[listener downloadError];
	}
}


-(MRPolis*) polis
{
	if (polisType == POLIS_TYPE_FEATURED) {
		return [polisArray objectAtIndex:selectedPolis];
	}
	else {
		return userPolis;
	}

}

-(void) connectionError
{
	doneLoading = NO;
	downloading = NO;
	downloadError = YES;
	[self updateListenersForError];
	[RVC removeActivity];
}

@end
