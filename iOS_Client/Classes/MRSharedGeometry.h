//
//  MRSharedGeometry.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenGLCommon.h"

@interface MRSharedGeometry : NSObject {

	TexturedNormalVertex3D *circleVerts;
	int numCircleVerts;
}

+(MRSharedGeometry*) sharedInstance;
-(void) makeGeometry;

//circle
-(void) makeUnitCircle:(int) numSlices;
-(TexturedNormalVertex3D*) circleVerts;
-(int) numCircleVerts;



@end
