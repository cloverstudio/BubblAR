//
//  MRRadarPOI.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MRObject;
@class CCTexture2D;
@class WMConcreteSubject;
@interface MRRadarPOI : NSObject {
	
	CGPoint position;
	CGRect poiTexRect;
	MRObject *mrObject;
	CCTexture2D *poiSharedTex;
	WMConcreteSubject *concreteSubject;
}
@property(nonatomic, assign) WMConcreteSubject *concreteSubject;
@property(nonatomic, assign) MRObject *mrObject;

-(id) initWithSubject:(WMConcreteSubject*) subject andObject:(MRObject*) object;
-(void) update;
-(void) draw;

@end
