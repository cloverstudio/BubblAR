//
//  MRLabelManager.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 3/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRLabelManager.h"
#import "MRLabel.h"
#import "HttpReader.h"
#import "WMConcreteSubject.h"
#import "ARLabelObject.h"
#import <CoreLocation/CoreLocation.h>

@implementation MRLabelManager
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
		concreteSubject = subject;
		labelsArray = [[NSMutableArray alloc] initWithCapacity:1];
		
		//read data online
		NSString *strUrl = @"http://cloverstudio.no-ip.org/infovision/api/fetchLabels.php";
		
		[[HttpReader getInstance] 
		 readUrl:[NSURL URLWithString:strUrl]
		 encoding:NSUTF8StringEncoding 
		 delegate:self];	
		
	}
	
	return self;
}

-(void) dataReceived:(NSData*) data
{
		
	NSString *tempData = [[NSString alloc ] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
	
	NSArray *listOfItems = [NSArray arrayWithArray:[tempData componentsSeparatedByString:@"\n"]];
	
	[tempData release];
	
	for(NSString *line in listOfItems){
		
		NSArray *cols = [NSArray arrayWithArray:[line componentsSeparatedByString:@"\t"]];
		
		if([cols count] < 8)
			continue;
		
		/*
		ARLabelObject *label = [[ARLabelObject alloc] init];
		
		label.labelId = [(NSString *)[cols objectAtIndex:0] intValue];
		label.title = (NSString *)[cols objectAtIndex:2];
		label.url = (NSString *)[cols objectAtIndex:3];
		label.description = (NSString *)[cols objectAtIndex:4];
		label.latitude = [(NSString *)[cols objectAtIndex:5] floatValue];
		label.longitude = [(NSString *)[cols objectAtIndex:6] floatValue];
		label.altitude = [(NSString *)[cols objectAtIndex:7] floatValue];
		
		*/
		
		int ID = [(NSString *)[cols objectAtIndex:0] intValue];
		NSString *title = (NSString *)[cols objectAtIndex:2];
		NSString *url = (NSString *)[cols objectAtIndex:3];
		NSString *description = (NSString *)[cols objectAtIndex:4];
		CLLocationCoordinate2D coordinate;
		coordinate.latitude = [(NSString *)[cols objectAtIndex:5] floatValue];
		coordinate.longitude = [(NSString *)[cols objectAtIndex:6] floatValue];
		CLLocationDistance altitude = [(NSString *)[cols objectAtIndex:7] floatValue];
		
		CLLocation *location = [[CLLocation alloc] initWithCoordinate: coordinate
															 altitude:altitude 
												   horizontalAccuracy:0.0 
													 verticalAccuracy:0.0 
															timestamp:[NSDate date]];
		
		MRLabel *label = [[MRLabel alloc] initWithSubject:concreteSubject 
												   andTitle:title 
											 andDescription:description 
													 andUrl:url
											  andCLPosition:location 
													  andID:ID];
		
		[self addObject:label];
		[location release];
		[label release];
	}	
}

- (void)connectionError
{
	//error
}

-(void) addObject:(MRLabel*) label
{
	[labelsArray addObject:label];
}

-(void) removeObject:(MRLabel*) label
{
	[labelsArray removeObject:label];
}

-(void) loadObject
{}

-(void) update
{
	
	for (MRLabel *label in labelsArray) 
	{
		[label update];
	}
}

-(void) cleanup
{}

-(void) draw
{
	for (MRLabel *label in labelsArray) 
	{
		[label draw];
	}
}

-(void) reset
{}

-(void) dealloc
{
	[labelsArray release];
	[super dealloc];
}

@end
