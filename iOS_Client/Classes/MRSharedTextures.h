//
//  MRSharedTextures.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 3/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCTexture2D;
@interface MRSharedTextures : NSObject {

	NSMutableDictionary *textureDictionary;
}

+(MRSharedTextures*) sharedInstance;

-(void) addTextureWithName:(NSString*) name;
-(void) addTexture:(CCTexture2D*) tex withName:(NSString*) name;
-(void) removeTextureWithName:(NSString *)name;
-(void) removeAllTextures;
-(CCTexture2D*) getTextureForName:(NSString *)name;
-(BOOL) textureExistsWithKey:(NSString*) keyArg;
@end
