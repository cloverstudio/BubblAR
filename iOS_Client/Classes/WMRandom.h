//
//  WMRandom.h
//  iFireWingo
//
//  Created by marko.hlebar on 7/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define RANDOMFILE @"randomFileNameTemp1"
#define RANDOMARRAYSIZE 1000



@interface WMRandom : NSObject {

}

//inits random numbers
+(void) initRandom;

//stores NSArray to a static c array
+(void) loadFastArray:(NSArray*)array;

//creates a file to store pseudorandom numbers to
+(void) createFile;

//gets a pseudorandom number from a previously generated array of pseudorandom numbers
double getRandom();

//gets randomly signed 1.0
float getRandomSign();

@end
