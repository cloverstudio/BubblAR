//
//  WMGameObject.h
//  iFireWingo
//
//  Created by Marko Hlebar on 7/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//OBSERVER PATTERN OBJECT PROTOCOL

@protocol WMGameObjectProtocol

-(void) attachGameObject;
-(void) detachGameObject;
-(void) insertGameObjectAtIndex:(int) index;
-(void) loadObject;
-(void) cleanup;
-(void) update;
-(void) draw;
-(void) reset;
-(void) dealloc;

@end


