//
//  MRSharedModels.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 3/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KEMD2Object;
@class CCTexture2D;
@interface MRSharedModels : NSObject {

	NSMutableDictionary *modelDictionary;
}

+(MRSharedModels*) sharedInstance;

-(KEMD2Object*) getMD2ModelWithID:(int) modelID;

-(void) addModel:(KEMD2Object *)model withModelID:(int)modelID;
-(void) removeModelForKey:(int)modelID;
-(void) removeAllModels;
-(BOOL) modelExistsWithKey:(int)modelID;

@end
