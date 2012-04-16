//
//  MRSharedGeometry.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRSharedGeometry.h"

static MRSharedGeometry *sharedInstance = nil;

@implementation MRSharedGeometry

+(MRSharedGeometry*) sharedInstance
{
	@synchronized(self)
	{
	
		if (sharedInstance == nil) 
		{
			sharedInstance = [[self alloc] init];
		}
		
		return sharedInstance;
	}
	
	return nil;
}

-(id) init
{
	
	if (self = [super init]) 
	{
		[self makeGeometry];
	}
	
	return self;
}

-(void) makeGeometry
{
	[self makeUnitCircle:20];
		
}

-(void) makeUnitCircle:(int) numSlices
{
	
	numCircleVerts = numSlices + 2;
	
	circleVerts = calloc(numCircleVerts, sizeof(TexturedNormalVertex3D));
	
	//center
	Vertex3D centerVertex = Vertex3DMake(0, 0, 0);
	Vector3D centerNormal = Vector3DMake(0, 0, 1.0);
	TexCoords centerTexCoord = TexCoordsMake(0,0);
	
	float dAngle = 2 * M_PI / numSlices;
	float angle = 0.0;
	
	circleVerts[0].vertices = centerVertex;
	circleVerts[0].normals = centerNormal;
	circleVerts[0].texCoords = centerTexCoord;
	
	for (int i = 1; i < numCircleVerts; i+=1) 
	{
		
		circleVerts[i].vertices = Vertex3DMake(0.5 * sinf(angle), 0.5 * cosf(angle), 0);
		circleVerts[i].normals = Vector3DMake(0, 0, 1);
		circleVerts[i].texCoords = TexCoordsMake(0.5 * sinf(angle), 0.5 * cosf(angle));
		
		angle += dAngle;
	}	
	
	/*	this adjustment will have to be madee by each picture individually
	 */
	 for (int i = 0; i < numCircleVerts; i++) 
	 {
	 circleVerts[i].texCoords.u += 0.5;
	 //circleVerts[i].texCoords.u *= picture.maxS;
	 circleVerts[i].texCoords.v += 0.5;
	 //circleVerts[i].texCoords.v *= picture.maxT;
	 }
	 
}

-(TexturedNormalVertex3D*) circleVerts
{
	return circleVerts;
}

-(int) numCircleVerts
{
	return numCircleVerts;
}


@end
