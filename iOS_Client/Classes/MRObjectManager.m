//
//  MRObjectManager.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 3/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRObjectManager.h"
#import "WMConcreteSubject.h"
#import "MRObjectManagerState.h"
#import "KEMD2Object.h"
#import "MRModel.h"
#import "WMConcreteSubject.h"
#import "CCTexture2D.h"
#import <CoreLocation/CoreLocation.h>
#import "MRLabel.h"
#import "CocosWMBridge.h"
#import "MRSharedModels.h" 
#import "MRSharedTextures.h"
#import "MRPicture.h"
#import "MRPolisManager.h"
#import "MRPolis.h"
#import "UIImageResizing.h"
#import "MRRootViewController.h"

typedef enum 
{
	OBJECT_TYPE_LABEL = 1,
	OBJECT_TYPE_PICTURE = 2,
	OBJECT_TYPE_MODEL = 3
} OBJECT_TYPE;

@implementation MRObjectManager
@synthesize concreteSubject;
@synthesize objectsArray;
@synthesize RVC;

@synthesize running;
@synthesize startDownloading;
@synthesize downloading;
@synthesize urlDone;
@synthesize asyncLoad;
@synthesize initialLoadDone;

@synthesize state;
@synthesize stateDownloadingURL;
@synthesize stateDoneProcessing;
@synthesize changeViewAllowed;

static MRObjectManager *sharedInstance = nil;

+(MRObjectManager*) sharedInstance
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

-(void) stop
{
	running = NO;
	startDownloading = NO;
}

-(void) start
{
	running = YES;
	startDownloading = YES;
}

-(id) init
{
	if (self = [super init]) 
	{
		//concreteSubject = subject;
		objectsArray = [[NSMutableArray alloc] initWithCapacity:1];
		
		initialLoadDone = NO;
		changeViewAllowed = YES;
		asyncLoad = NO;
		urlDone = NO;
		startDownloading = NO;
		doneLoading = YES;
		maxDistance = 10000.0;
		running = NO;
		
		stateDownloadingURL = [[MRObjectManagerStateDownloadingURL alloc] initWithInstance:self];
		stateDoneProcessing = [[MRObjectManagerStateDoneProcessing alloc] initWithInstance:self];
		
		//[self startDownload];
		downloadTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(startDownload) userInfo:nil repeats:YES];
		
	}
	
	return self;
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

-(void) loadObject
{

}

-(void) startDownload
{
	if (doneLoading && startDownloading) 
	{
		[RVC addActivity];
		
		state = stateDownloadingURL;
		asyncLoad = YES;
		urlDone = NO;
		doneLoading = NO;
		
		[NSThread detachNewThreadSelector:@selector(download) toTarget:self withObject:nil];
	}	
}

-(void) download
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	while (!doneLoading) 
	{
		[NSThread sleepForTimeInterval:0.01];
		[state downloadURL];
		[state doneProcessingModels];
	}
	
	[pool drain];
	[pool release];
}

-(void) update
{
	if (running) 
	{
		for (id<WMGameObjectProtocol> object in objectsArray) 
		{
			//if an object interupts running
			[object update];
			if (!running) break;
		}
	}
}

-(void) draw
{
	/*
	for (id<WMGameObjectProtocol> object in objectsArray) 
	{
		[object draw];
	}
	 */
}

-(void) cleanup
{

	int i;
	for(i=0; i<[objectsArray count]; i++) {
		MRObject* object = [objectsArray objectAtIndex:i];
		if(object.dispose == YES) 
		{
			[objectsArray removeObjectAtIndex:i];
			i--;
		}
	}	
}

-(void) reset
{
	initialLoadDone = NO;
	changeViewAllowed = YES;
	asyncLoad = NO;
	urlDone = NO;
	startDownloading = NO;
	doneLoading = YES;
	running = NO;
	[self stop];
	[self removeAllObjects];
}

-(void) asyncDownloadURL
{
	//[self downloadURL];
	[self performSelectorOnMainThread:@selector(downloadURL) withObject:nil waitUntilDone:YES];
}

-(void) downloadURL
{
	if(!downloading && !urlDone)
	{
		MRPolis* polis = [[MRPolisManager sharedInstance] polis];

		CLLocationCoordinate2D currentLocation = [[CocosWMBridge inst] currentLocation].coordinate;
		
		NSString *strUrl = [NSString stringWithFormat:@"%@?udid=%@&lat=%f&lon=%f", [polis.url absoluteString], 
																				   [UIDevice currentDevice].uniqueIdentifier,
																					currentLocation.latitude, 
																					currentLocation.longitude];
		
		
		//NSLog(@"%@", [UIDevice currentDevice].uniqueIdentifier);
		//NSString *strUrl = @"http://cloverstudio.no-ip.org/infovision/api/fetchLabels.php";
		 
		[[HttpReader getInstance] 
		 readUrl:[NSURL URLWithString:strUrl]
		 encoding:NSUTF8StringEncoding 
		 delegate:self];
		
		downloading = YES;
	}
}


-(void) dataReceived:(NSData*) data
{
	downloading = NO;
	[state getURLData:data];

}

-(void) getURLData:(NSData *)data
{
	
	NSString *tempData = [[NSString alloc ] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
	NSArray *listOfItems = [NSArray arrayWithArray:[tempData componentsSeparatedByString:@"\n"]];
	
	NSMutableArray *parsedObjectIDs = [NSMutableArray arrayWithCapacity:1];
	
	[tempData release];
	
	for(NSString *line in listOfItems)
	{
		
		NSArray *cols = [NSArray arrayWithArray:[line componentsSeparatedByString:@"\t"]];
		
		//if <10 columns, the data is irrelevant
		if ([cols count] < 9) 
		{
			continue;
		}
		
		//0 ID
		//1 userID
		//2 objectType
		//3 title
		//4 url
		//5 description
		//6 latitude
		//7 longitude
		//8 altitude
		//9 modelID		//pictureURL
		//10 modelURL
		//11 textureURL
		
		int ID = [(NSString *)[cols objectAtIndex:0] intValue];
		//int userID = [(NSString *)[cols objectAtIndex:1] intValue];	//TO BE USED MAYBE
		int objectType = [(NSString *)[cols objectAtIndex:2] intValue];
		NSString *title = (NSString *)[cols objectAtIndex:3];
		NSString *url = (NSString *)[cols objectAtIndex:4];
		NSString *description = (NSString *)[cols objectAtIndex:5];
		CLLocationCoordinate2D coordinate;
		coordinate.latitude = [(NSString *)[cols objectAtIndex:6] floatValue];
		coordinate.longitude = [(NSString *)[cols objectAtIndex:7] floatValue];
		CLLocationDistance altitude = [(NSString *)[cols objectAtIndex:8] floatValue];
		
		
		CLLocation *location = [[CLLocation alloc] initWithCoordinate:coordinate
															 altitude:altitude 
												   horizontalAccuracy:0.0 
													 verticalAccuracy:0.0 
															timestamp:[NSDate date]];
		
		
		//if object doesnt exist in the objectArray, add it, else dont do anything
		//and object is in specified maxDistance from the user.
		//EDIT: the objects are  sent from the server in range of 1 degree lat/ lon from current location.
		if (![self objectExists:ID])// && [self objectInRange:location]) 
		{
			if (objectType == OBJECT_TYPE_MODEL) 
			{
				
				int modelID = [(NSString *)[cols objectAtIndex:9] intValue];
				
				//if there is no model in sharedmodels, add it.
				if (![[MRSharedModels sharedInstance] modelExistsWithKey:modelID]) 
				{
					
					NSString *modelUrl = [NSString stringWithString:[cols objectAtIndex:10]];
					NSString *textureUrl = [NSString stringWithString:[cols objectAtIndex:11]];
					
					UIImage *tempImage;
					
					//model texture
					tempImage = [[UIImage alloc] initWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:textureUrl]]];
					CCTexture2D *modelTex = [[CCTexture2D alloc] initWithImage:tempImage];
					[tempImage release];
					
					NSData *modelData = [NSData dataWithContentsOfURL:[NSURL URLWithString: modelUrl]];
					
					KEMD2Object *md2model = [[KEMD2Object alloc] initWithData:modelData texture:modelTex];
					
					[[MRSharedModels sharedInstance] addModel:md2model withModelID:modelID];
					
					[modelTex release];
					[md2model release];
				}
				
				MRModel *model = [[MRModel alloc] initWithSubject:concreteSubject 
														 andModel:[[MRSharedModels sharedInstance] getMD2ModelWithID:modelID]
														 andTitle:title
												   andDescription:description
														   andUrl:url
													andCLPosition:location
													   andModelID:modelID
															andID:ID
														  andType:objectType];
				
				[self addObject:model];
				
				[model release];
			}
			else if	(objectType == OBJECT_TYPE_LABEL)
			{
				
				MRLabel *label = [[MRLabel alloc] initWithSubject:concreteSubject 
														 andTitle:title 
												   andDescription:description 
														   andUrl:url
													andCLPosition:location 
															andID:ID
														  andType:objectType];
				
				[self addObject:label];
				[label release]; 	
				
			}
			else if (objectType == OBJECT_TYPE_PICTURE)
			{
				NSString *textureUrl = [NSString stringWithString:[cols objectAtIndex:9]];
				
				//if texture is not present in shared textures, create it
				
				if (![[MRSharedTextures sharedInstance] textureExistsWithKey:textureUrl]) 
				{
				
					//picture texture
					UIImage *tempImage = [[UIImage alloc] initWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:textureUrl]]];
					UIImage *tempImageScaled = [tempImage scaleToSize:CGSizeMake(128., 128.)]; 
					
					CCTexture2D *pictureTex = [[CCTexture2D alloc] initWithImage:tempImageScaled];
					[tempImage release];
					
					[[MRSharedTextures sharedInstance] addTexture:pictureTex withName:textureUrl];
					[pictureTex release];
					
				}
				
				MRPicture *picture = [[MRPicture alloc] initWithSubject:concreteSubject
															 andPicture:textureUrl
															   andTitle:title 
														 andDescription:description 
																 andUrl:url 
														  andCLPosition:location 
																  andID:ID
																andType:objectType];
				
				
				[self addObject:picture];
				[picture release];
				
			}
			
			
			
		}
		[location release];
		[parsedObjectIDs addObject:[NSString stringWithFormat:@"%d",ID]];
	}
	
	[self disposeDeadObjects:parsedObjectIDs];
	
	initialLoadDone = YES;
	urlDone = YES;	
	[RVC removeActivity];
}

-(BOOL) objectInRange:(CLLocation*) location
{
	float distance = [[[CocosWMBridge inst] currentLocation] getDistanceFrom:location];
	
	if (distance <= maxDistance)
	{
		return YES;
	}
	
	return NO;
}

-(void) disposeDeadObjects:(NSArray*) newObjects
{
	//Checking for models which dont exist anymore
	BOOL notExisting = YES;	
	
	for (MRObject *object in objectsArray) 
	{
		notExisting = YES;
		
		for (NSString *ID in newObjects) 
		{
			if (object.ID == [ID intValue]) 
			{
				notExisting = NO;
			}
		}
		
		if(notExisting)
		{
			object.dispose = YES;
		}
		
	}
}

-(BOOL) objectExists:(int) ID
{
	
	for (MRObject *object in objectsArray) 
	{
			if (object.ID == ID) 
			{
				return YES;
			}   
	}
	return NO;
}

/*
-(void) getURLData:(NSData*) data
{
	NSString *tempData = [[NSString alloc ] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
	NSArray *listOfItems = [NSArray arrayWithArray:[tempData componentsSeparatedByString:@"\n"]];
	
	NSMutableArray *modelIDs = [NSMutableArray arrayWithCapacity:1];
	
	[tempData release];
	//NSLog(@"string =  %@", tempData);
	for(NSString *line in listOfItems){
				
		NSArray *cols = [NSArray arrayWithArray:[line componentsSeparatedByString:@"\t"]];
		
		if ([cols count] < 10) 
		{
			continue;
		}
		
		int ID = [(NSString *)[cols objectAtIndex:0] intValue];
		NSString *title = (NSString *)[cols objectAtIndex:2];
		NSString *url = (NSString *)[cols objectAtIndex:3];
		NSString *description = (NSString *)[cols objectAtIndex:4];
		CLLocationCoordinate2D coordinate;
		coordinate.latitude = [(NSString *)[cols objectAtIndex:5] floatValue];
		coordinate.longitude = [(NSString *)[cols objectAtIndex:6] floatValue];
		CLLocationDistance altitude = [(NSString *)[cols objectAtIndex:7] floatValue];
		
		CLLocation *location = [[CLLocation alloc] initWithCoordinate:coordinate
															 altitude:altitude 
												   horizontalAccuracy:0.0 
													 verticalAccuracy:0.0 
															timestamp:[NSDate date]];
		
		NSString *modelUrl = [NSString stringWithString:[cols objectAtIndex:8]];
		NSString *textureUrl = [NSString stringWithString:[cols objectAtIndex:9]];
		
		BOOL exists = NO;
		
		for (MRObject *object in objectsArray) 
		{
			if ([object isKindOfClass:NSClassFromString(@"MRModel")]) 
			{
				if (object.ID == ID) 
				{
					exists = YES;
					break;
				}   
			}
		}
			
		float distance = [[[CocosWMBridge inst] currentLocation] getDistanceFrom:location];
		
		if (exists == NO && distance < maxDistance)
		{

			UIImage *tempImage = [[UIImage alloc] initWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:textureUrl]]];
			CCTexture2D *tempTex = [[CCTexture2D alloc] initWithImage:tempImage];
			
			NSData *modelData = [NSData dataWithContentsOfURL:[NSURL URLWithString: modelUrl]];
			
			KEMD2Object *md2model = [[KEMD2Object alloc] initWithData:modelData texture:tempTex];
			MRModel *model = [[MRModel alloc] initWithSubject:concreteSubject 
													 andModel:md2model
													 andTitle:title
											   andDescription:description
													   andUrl:url
												andCLPosition:location
														andID:ID];
			
			[objectsArray addObject:model];
			[tempImage release];
			[tempTex release];
			[md2model release];
			[model release];
		}

		[modelIDs addObject:[NSString stringWithFormat:@"%d", ID]];
		[location release];
	}
	
	
	//Checking for models which dont exist anymore
	BOOL notExisting = YES;	

	for (MRObject *object in objectsArray) 
	{
		notExisting = YES;
		
		if ([object isKindOfClass:NSClassFromString(@"MRModel")])
		{
			for (NSString *ID in modelIDs) 
			{
				if (object.ID == [ID intValue]) 
				{
					notExisting = NO;
				}
			}
			
			if(notExisting)
			{
				object.dispose = YES;
			}
		}
	}
	
	urlDone = YES;
}
 

-(void) getLabelData:(NSData *)data
{
	NSString *tempData = [[NSString alloc ] initWithBytes:[data bytes] length:[data length] encoding:NSASCIIStringEncoding];
	
	NSArray *listOfItems = [NSArray arrayWithArray:[tempData componentsSeparatedByString:@"\n"]];
		
	[tempData release];
	
	NSMutableArray *labelIDs = [NSMutableArray arrayWithCapacity:1];
	
	for(NSString *line in listOfItems){
				
		NSArray *cols = [NSArray arrayWithArray:[line componentsSeparatedByString:@"\t"]];
		
		if([cols count] < 8)
			continue;
	
		
		int ID = [(NSString *)[cols objectAtIndex:0] intValue];
		NSString *title = (NSString *)[cols objectAtIndex:2];
		NSString *url = (NSString *)[cols objectAtIndex:3];
		NSString *description = (NSString *)[cols objectAtIndex:4];
		CLLocationCoordinate2D coordinate;
		NSLog(@"latitude %@ in float %f in double %lf",(NSString *)[cols objectAtIndex:5], [(NSString *)[cols objectAtIndex:5] floatValue], [(NSString *)[cols objectAtIndex:5] doubleValue]);
		coordinate.latitude = [(NSString *)[cols objectAtIndex:5] doubleValue];
		coordinate.longitude = [(NSString *)[cols objectAtIndex:6] doubleValue];
		CLLocationDistance altitude = [(NSString *)[cols objectAtIndex:7] floatValue];
		
		CLLocation *location = [[CLLocation alloc] initWithCoordinate: coordinate
															 altitude:altitude 
												   horizontalAccuracy:0.0 
													 verticalAccuracy:0.0 
															timestamp:[NSDate date]];
		
		BOOL exists = NO;
		
		for (MRObject *object in objectsArray) 
		{
			if ([object isKindOfClass:NSClassFromString(@"MRLabel")]) 
			{
				if (object.ID == ID) 
				{
					exists = YES;
					break;
				}   
			}
		}
		
		float distance = [[[CocosWMBridge inst] currentLocation] getDistanceFrom:location];
		
		if (!exists && distance < maxDistance) 
		{
			MRLabel *label = [[MRLabel alloc] initWithSubject:concreteSubject 
													 andTitle:title 
											   andDescription:description 
													   andUrl:url
												andCLPosition:location 
														andID:ID];
			
			[self addObject:label];
			[label release]; 
		}

		[labelIDs addObject:[NSString stringWithFormat:@"%d",ID]];
		[location release];
		
	}	
	
	//Checking for models which dont exist anymore
	BOOL notExisting = YES;	
	
	for (MRObject *object in objectsArray) 
	{
		notExisting = YES;
		
		if ([object isKindOfClass:NSClassFromString(@"MRLabel")])
		{
			for (NSString *ID in labelIDs) 
			{
				if (object.ID == [ID intValue]) 
				{
					notExisting = NO;
				}
			}
			
			if(notExisting)
			{
				object.dispose = YES;
			}
		}
	}
	
	labelsDone = YES;
}
*/


- (void)connectionError
{
	doneLoading = YES;
	downloading = NO;
	[RVC removeActivity];
	NSLog(@"ERROR");
}

-(void) removeAllObjects
{
	[objectsArray removeAllObjects];
}


-(void) addObject:(id<WMGameObjectProtocol>) object
{
	[objectsArray addObject:object];
}

-(void) removeObject:(id<WMGameObjectProtocol>) object
{
	[objectsArray addObject:object];
}

-(void) doneProcessingModels
{
	//[downloadTimer invalidate];
	doneLoading = YES;
	[[CocosWMBridge inst] doneLoadingObjects];
}

-(void) dealloc
{
	[(NSObject*)stateDownloadingURL release];
	[(NSObject*)stateDoneProcessing release];

	[objectsArray release];
	[super dealloc];
}

@end
