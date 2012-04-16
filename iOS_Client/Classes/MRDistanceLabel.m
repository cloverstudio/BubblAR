//
//  MRDistanceLabel.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 3/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRDistanceLabel.h"
#import "CCTexture2D.h"

static MRDistanceLabel *sharedInstance = nil;

@implementation MRDistanceLabel

+(MRDistanceLabel*) sharedInstance
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
		numbersArray = [[NSMutableArray alloc] initWithCapacity:10];
		
		for (int i = 0; i < 10; i++) 
		{
			CCTexture2D *number = [[CCTexture2D alloc] initWithString:[NSString stringWithFormat:@"%d",i] 
															 fontName:@"Arial" 
															 fontSize:14.0];
			
			[numbersArray addObject: number];
			[number release];
		}
		
		CCTexture2D *meters = [[CCTexture2D alloc] initWithString:@"m" 
														 fontName:@"Arial" 
														 fontSize:14.0];
		
		
		
		[numbersArray addObject:meters];
		[meters release];
		
		CCTexture2D *kilometers = [[CCTexture2D alloc] initWithString:@"km" 
															 fontName:@"Arial" 
															 fontSize:14.0];
		[numbersArray addObject:kilometers];
		[kilometers release];
	}
	
	return self;
}

-(CGRect) drawNumber:(int) num atOrigin:(CGPoint) origin
{
	CGRect distanceLabelRect = CGRectMake(0, 0, 0, 0);
	
	BOOL isKilo = NO;
	if (num > 1000) 
	{
		isKilo = YES;
		
		num /= 1000;
	}

	CGRect numberRect = CGRectMake(0,0,0,0);
	int numDigits = 0;
	
	int tempNum = num;
	
	while (tempNum > 0) 
	{
		tempNum /= 10;
		numDigits++;
	}
	
	int revNum = 0;
	tempNum = num;
	
	for (int i = numDigits - 1; i >= 0; i--) 
	{
		revNum += tempNum % 10 * (int)powf(10, i);
		tempNum /= 10;
	}
	
	//draw numbers
	for(int i = 0; i < numDigits; i++)
	{
		CCTexture2D *numTex = [numbersArray objectAtIndex:revNum % 10];
		numberRect.origin = origin;
		numberRect.size = CGSizeMake(numTex.contentSize.width / 10.0, numTex.contentSize.height / 10.0);
		
		[numTex drawInRect: numberRect];
		
		revNum /= 10;
		origin.x += numberRect.size.width;
		distanceLabelRect.size.width += numberRect.size.width;
	}
	
	//draw meter sign
	numberRect.origin = origin;
	if (!isKilo) 
	{
		[[numbersArray objectAtIndex:10] drawInRect:numberRect];	//meter
	}
	else 
	{
		numberRect.size.width *= 2.0;
		[[numbersArray objectAtIndex:11] drawInRect:numberRect];	//kilometer
	}
	
	distanceLabelRect.size.width += numberRect.size.width;
	distanceLabelRect.size.height = numberRect.size.height;
	
	return distanceLabelRect;
}

@end
