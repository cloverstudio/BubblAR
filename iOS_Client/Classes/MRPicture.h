//
//  MRPicture.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRObject.h"
#import "OpenGLCommon.h"

@interface MRPicture : MRObject 
{

	CCTexture2D *picture;	
	TexturedNormalVertex3D *circleVerts;
	TexCoords *circleTexCoords;
	int numVertices;
	
	float *vertexAnimationOffsets;
	float time;
	float rotation;
	BOOL reverseRotation;
		
}


-(id) initWithSubject:(WMConcreteSubject*) subject 
		   andPicture:(NSString*) pictureArg
			 andTitle:(NSString*) titleArg
	   andDescription:(NSString*) descriptionArg
			   andUrl:(NSString*) urlArg
		andCLPosition:(CLLocation*) clPositionArg
				andID:(int) idArg
			  andType:(int) typeArg;

void makeVertexAnimationOffsets(float **animationOffsArg, int numVerticesArg);
-(void) makeUVCorrection;

@end
