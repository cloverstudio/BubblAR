//
//  WMGameSubject.h
//  iFireWingo
//
//  Created by Marko Hlebar on 7/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WMGameObject.h"
//#import "WMTerrain.h"

//OBSERVER PATTERN SUBJECT PROTOCOL

@protocol WMGameSubjectProtocol

-(void) attach:(id<WMGameObjectProtocol>) object;
-(void) detach:(id<WMGameObjectProtocol>) object;
-(void) insertObject:(id<WMGameObjectProtocol>) object atIndex:(int) index;
-(void) notify;

@optional

-(BOOL) getTouch1;
-(void) setTouch1:(BOOL) arg;

-(BOOL) getTouch2;
-(void) setTouch2:(BOOL) arg;

-(CGPoint) getTouchPosition1;
-(void) setTouchPosition1:(CGPoint) arg;

-(CGPoint) getTouchPosition2;
-(void) setTouchPosition2:(CGPoint) arg;

-(void)getState;
-(void)setState;

@end
