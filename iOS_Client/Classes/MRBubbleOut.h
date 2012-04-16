//
//  MRBubbleOut.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMGameObject.h"
#import "OpenGLCommon.h"

@class WMConcreteSubject;
@class MRBubble;
@class CCTexture2D;
@class MRRootViewController;
@class WMGamestate;
@interface MRBubbleOut :  NSObject<WMGameObjectProtocol>{

	BOOL touched;
	float scaling;
	
	MRBubble *bubble;
	WMConcreteSubject *concreteSubject;
	
	CCTexture2D *bubblarIconTex;
	
	TexturedNormalVertex3D *circleVerts;
	int numVertices;
	TexCoords *circleTexCoords;
	
	Vector3D drawPosition;
	
	CGPoint screenPosition;
	float touchRadius;
	
	MRRootViewController *rootController;
	WMGamestate *gamestate;
	
}

@property (assign) WMConcreteSubject *concreteSubject;
@property (assign) WMGamestate *gamestate;
-(id) initWithSubject:(WMConcreteSubject *)subject andRootController:(MRRootViewController*) rootControllerArg andGamestate:(WMGamestate*) gamestateArg;
-(void) makeUVCorrection;
-(void) checkTouches;


@end
