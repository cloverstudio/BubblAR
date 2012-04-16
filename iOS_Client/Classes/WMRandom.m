//
//  WMRandom.m
//  iFireWingo
//
//  Created by marko.hlebar on 7/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WMRandom.h"
#import "WMFileOps.h"

#define ARC4RANDOM_MAX 0x100000000

static double randomArray[RANDOMARRAYSIZE];
static int randomArrayNumber;

@implementation WMRandom

+(void) initRandom
{
	
	randomArrayNumber = arc4random()%RANDOMARRAYSIZE; 
	
	NSArray *arrayOfDoubles = [WMFileOps loadFileContentsToArray:RANDOMFILE];
	
	if(arrayOfDoubles.count == 0)
	{
		[self createFile];
		
		arrayOfDoubles = [WMFileOps loadFileContentsToArray:RANDOMFILE];
	}
	
	[self loadFastArray:arrayOfDoubles];
}

+(void) loadFastArray:(NSArray*) array
{

	int i = 0;
	
	for(NSNumber* ranNum in array)
	{
		randomArray[i++] = [ranNum doubleValue];
	}
}

+(void) createFile
{
	
//	double val = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f);
	
	NSMutableArray *doubleArray = [NSMutableArray array];
	
	for(int i = 0; i < RANDOMARRAYSIZE; i++)
	{
		[doubleArray addObject:[NSNumber numberWithDouble:((double)arc4random() / ARC4RANDOM_MAX)]];
	}
	
	[WMFileOps writeArrayToFile:RANDOMFILE :doubleArray];
}

double getRandom()
{
	
	if(randomArrayNumber > RANDOMARRAYSIZE) randomArrayNumber = 0;
	return randomArray[randomArrayNumber++];	
}

float getRandomSign()
{	
	if(arc4random() % 2) return 1.0;
	else return -1.0;
}

@end
