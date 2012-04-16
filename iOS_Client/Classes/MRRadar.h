//
//  MRRadar.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMGameObject.h"
#import "MRObjectDrawingManager.h"

@class WMConcreteSubject;
@class CCTexture2D;
@interface MRRadar : NSObject <WMGameObjectProtocol, MRDrawable>{

	WMConcreteSubject *concreteSubject;
	float distance;
	NSMutableArray *radarPOIArray;
	CCTexture2D *rulerTex;
	CGRect rulerRect;
}

@property float distance;
@property (nonatomic, assign) WMConcreteSubject *concreteSubject;

-(id) initWithSubject:(WMConcreteSubject*) subject;


@end
