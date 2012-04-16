//
//  MRPolis.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRPolis.h"


@implementation MRPolis
@synthesize title;
@synthesize description;
@synthesize imageUrl;
@synthesize iconImage;
@synthesize url;
@synthesize dispose;

-(id) initWithTitle:(NSString*)titleArg 
	 andDescription:(NSString*) descriptionArg 
	   andIconImage:(UIImage*) iconImageArg
		andImageUrl:(NSURL*) imageUrlArg 
			 andUrl:(NSURL*) urlArg

{
	if (self = [super init])
	{
		dispose = NO;
		title = [titleArg retain];
		description = [descriptionArg retain];
		iconImage = [iconImageArg retain];
		imageUrl = [imageUrlArg retain];
		url = [urlArg retain];
	}
	
	return self;
}

-(void) dealloc
{
	[title release];
	[description release];
	[iconImage release];
	[imageUrl release];
	[url release];
	
	[super dealloc];
}

@end
