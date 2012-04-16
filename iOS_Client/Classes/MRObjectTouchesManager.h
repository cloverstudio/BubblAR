//
//  MRObjectTouchesManager.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MRObject;
@class WMConcreteSubject;
@interface MRObjectTouchesManager : NSObject {

	NSMutableArray *touchedObjects;
	WMConcreteSubject *concreteSubject;
	
}

@property (assign) WMConcreteSubject *concreteSubject;

+(MRObjectTouchesManager*) sharedInstance;
-(MRObject*) getClosestObject;
-(void) addObject:(MRObject *)object;
-(void) removeObject:(MRObject *)object;
-(void) removeAllObjects;
-(void) reset;

@end
