//
//  WMFileOps.m
//  iFireWingo
//
//  Created by marko.hlebar on 7/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WMFileOps.h"


@implementation WMFileOps

+(NSArray*) loadFileContentsToArray:(NSString*)fileName
{
	
	NSArray *array = [NSArray arrayWithContentsOfFile:[self openFile:fileName]];
	return array;
}

+(void) writeArrayToFile:(NSString*)fileName: (NSArray*)array
{

	[array writeToFile:[self openFile:fileName] atomically:YES];
	
}

+(NSString*)openFile:(NSString*)fileName
{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex: 0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];

	return filePath;
}

@end
