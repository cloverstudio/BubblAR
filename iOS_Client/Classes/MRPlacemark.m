//
//  MRPlacemark.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRPlacemark.h"


@implementation MRPlacemark

@synthesize coordinate;

-(id)initWithCoordinate:(CLLocationCoordinate2D) coordinateArg andTitle:(NSString*) titleArg andSubtitle:(NSString*) subtitleArg
{
	
	if (self = [super init]) 
	{
		coordinate = coordinateArg;
		title = [[NSString alloc] initWithString:titleArg];
		subtitle = [[NSString alloc] initWithString:subtitleArg];
	}
	
	return self;
}

-(NSString*) title
{
	return title;
}
-(NSString*) subtitle
{
	return subtitle;
}

-(void) dealloc
{
	[title release];
	[subtitle release];
	[super dealloc];	
}

@end
