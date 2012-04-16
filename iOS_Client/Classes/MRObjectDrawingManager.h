//
//  MRObjectDrawingManager.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMGameObject.h"

@protocol MRDrawable

-(void) draw;
-(float) distance;
-(NSComparisonResult) compareDistance:(id <MRDrawable>) object;
-(void) setDrawingType:(int) typeArg;

@end

typedef enum
{
	RENDERSTYLE_TEXTUREDNORMALVERTEX,
	RENDERSTYLE_COLOREDNORMALVERTEX,
	RENDERSTYLE_TEXTURE2D
	
} OBJECT_RENDERSTYLE;

typedef enum
{
	DRAWING_TYPE_INTERFACE,
	DRAWING_TYPE_WORLD
	
} OBJECT_DRAWING_TYPE;

@class WMConcreteSubject;

@interface MRObjectDrawingManager : NSObject <WMGameObjectProtocol> 
{
	BOOL running;
	WMConcreteSubject *concreteSubject;
	NSMutableArray *objects;
}
@property (assign) WMConcreteSubject *concreteSubject;
@property (assign) 	NSMutableArray *objects;
+(MRObjectDrawingManager*) sharedInstance;
-(void) addObject:(id <MRDrawable>)object;
-(void) removeObject:(id <MRDrawable>)object;
-(void) removeAllObjects;
-(void) sortObjects;
-(void) start;
-(void) stop;


@end
