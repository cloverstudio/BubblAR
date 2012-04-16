//
//  WMFileOps.h
//  iFireWingo
//
//  Created by marko.hlebar on 7/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WMFileOps : NSObject {

}

+(NSArray*) loadFileContentsToArray:(NSString*)fileName;
+(void) writeArrayToFile:(NSString*)fileName: (NSArray*)array;
+(NSString*)openFile:(NSString*)fileName;

@end
