//
//  MRLabel.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 3/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMGameObject.h"
#import "OpenGLCommon.h"
#import "WMCollisionDetection.h" 
#import "MRObject.h"

@class CLLocation;
@class CCTexture2D;
@class WMConcreteSubject;
@class MRBubble;
@interface MRLabel : MRObject
{

	CCTexture2D *textTex;
	//CCTexture2D *bgTex;
	
	CGRect textRect;
	CGRect bgRect;
 		
	float labelPerimeter;
	
}

-(id) initWithSubject:(WMConcreteSubject *)cs 
			 andTitle:(NSString*) titleArg 
	   andDescription:(NSString*) descriptionArg
			   andUrl:(NSString*) urlArg
		andCLPosition:(CLLocation*) clPositionArg 
				andID:(int) idArg
			  andType:(int) typeArg;

-(CGSize) sizeForText:(NSString*) text ofFontSize:(int) fontSize;
-(void) animate;

@end
