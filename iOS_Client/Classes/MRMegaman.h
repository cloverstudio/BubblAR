//
//  MRMegaman.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 3/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMGameObject.h"
#import "OpenGLCommon.h"

@class KEMD2Object;
@class CCTexture2D;
@class WMConcreteSubject;
@interface MRMegaman : NSObject <WMGameObjectProtocol>{

	WMConcreteSubject *concreteSubject;
	KEMD2Object *megamanModel;
	CCTexture2D *megamanTex;
	
	Vector3D position;
}

@property (nonatomic,assign) WMConcreteSubject *concreteSubject;
@property Vector3D position;

-(id) initWithSubject:(WMConcreteSubject*) cs;
-(id) initWithSubject:(WMConcreteSubject*) cs andModel:(KEMD2Object*) model;

@end
