//
//  MRModel.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 3/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRObject.h"


@class KEMD2Object;
@class CCTexture2D;
//@class MRLabel;
@interface MRModel : MRObject 
{

	int modelID;
	KEMD2Object *model;
	float rot;

	//MRLabel *modelLabel;
		
}

-(id) initWithSubject:(WMConcreteSubject*) subject 
			 andModel:(KEMD2Object*) modelArg
			 andTitle:(NSString*) titleArg
	   andDescription:(NSString*) descriptionArg
			   andUrl:(NSString*) urlArg
		andCLPosition:(CLLocation*) clPositionArg
		   andModelID:(int) modelIDArg
				andID:(int) idArg
			  andType:(int) typeArg;


-(void) animate;

@end
