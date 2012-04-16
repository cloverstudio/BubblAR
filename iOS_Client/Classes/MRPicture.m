//
//  MRPicture.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRPicture.h"
#import "MRBubble.h"
#import "CCTexture2D.h"
#import "WMConcreteSubject.h"
#import "MRDistanceLabel.h"
#import "MRSharedGeometry.h"
#import "WMRandom.h"
#import "MRSharedTextures.h"

#define UNIFORM_PICTURE_SCALE 5.0

@implementation MRPicture

-(id) initWithSubject:(WMConcreteSubject*) subject 
		   andPicture:(NSString*) pictureArg
			 andTitle:(NSString*) titleArg
	   andDescription:(NSString*) descriptionArg
			   andUrl:(NSString*) urlArg
		andCLPosition:(CLLocation*) clPositionArg
				andID:(int) idArg
			  andType:(int) typeArg
{

	if (self = [super initWithSubject:subject
							 andTitle:titleArg
					   andDescription:descriptionArg
							   andUrl:urlArg
						andCLPosition:clPositionArg 
								andID:idArg
							  andType:typeArg]) 
	{
		
		picture = [[MRSharedTextures sharedInstance] getTextureForName:pictureArg];//[pictureArg retain];
		circleVerts = [[MRSharedGeometry sharedInstance] circleVerts];
		numVertices = [[MRSharedGeometry sharedInstance] numCircleVerts];
		//[self makeUnitCircle:20];
				
		circleTexCoords = calloc(numVertices, sizeof(TexCoords));
		
		[self makeUVCorrection];
		//memcpy(circleTexCoords, &circleVerts[0].texCoords, numVertices * sizeof(TexCoords));
		
		time = 0.0;
		
		scaling = UNIFORM_PICTURE_SCALE;
		bubble.scaling = scaling * 3.0 / 2.0;

		makeVertexAnimationOffsets(&vertexAnimationOffsets, numVertices);
		
		touched = NO;
		
	}
	
	return self;
}

-(void) makeUVCorrection
{
	for (int i = 0; i < numVertices; i++) 
	{
		circleTexCoords[i].u = circleVerts[i].texCoords.u;
		circleTexCoords[i].v = circleVerts[i].texCoords.v;
		circleTexCoords[i].u *= picture.maxS;
		circleTexCoords[i].v *= picture.maxT;
	}
}

void makeVertexAnimationOffsets(float **animationOffsArg, int numVerticesArg)
{
	float *animationOffs = malloc(numVerticesArg / 2.0 * sizeof (float));
	
	for(int i = 0; i < numVerticesArg / 2.0; i++)
	{
		animationOffs[i] = getRandom() * 0.1;
	}
	
	*animationOffsArg = animationOffs;
}



-(void) drawObject
{
	
	float azimuth = [concreteSubject getAzimuth];
	float inclination = [concreteSubject getInclination];
	
	if (!touched) 
	{
		
		glEnable(GL_TEXTURE_2D);
		glEnable(GL_BLEND);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		
		glBindTexture(GL_TEXTURE_2D, picture.name);
		
		glPushMatrix();
		
		glTranslatef(drawPosition.x, drawPosition.y, drawPosition.z);
		
		
		glRotatef(-90 - inclination, 0.0, 1.0, 0.0);
		glRotatef(-180 -azimuth, 1.0, 0.0, 0.0);
		glRotatef(90  + rotation, 0, 0, 1);		
		//glRotatef(rot, 1.0, 1.0, 1.0);
		 
		glScalef(scaling + bubble.scalingOffset.x, scaling + bubble.scalingOffset.y, scaling + bubble.scalingOffset.z);
		
		//glColor4f(1.0, 1.0, 1.0, 0.9);
		glVertexPointer(3, GL_FLOAT, sizeof(TexturedNormalVertex3D), &circleVerts[0].vertices);
		glNormalPointer(GL_FLOAT, sizeof(TexturedNormalVertex3D), &circleVerts[0].normals);
		//glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedNormalVertex3D), &circleVerts[0].texCoords);
		glTexCoordPointer(2, GL_FLOAT, 0, circleTexCoords);
		glDrawArrays(GL_TRIANGLE_FAN, 0, numVertices);
		//glColor4f(1.0, 1.0, 1.0, 1.0);
		
		glPopMatrix();
		//distance label
		glPushMatrix();
		
		glTranslatef(drawPosition.x, drawPosition.y, drawPosition.z);
		glRotatef(-90 - inclination, 0.0, 1.0, 0.0);
		glRotatef(-azimuth, 1.0, 0.0, 0.0);
		glRotatef(-90, 0, 0, 1);
		
		distanceLabelRect = [[MRDistanceLabel sharedInstance] drawNumber: distance atOrigin: CGPointMake(-distanceLabelRect.size.width / 2.0, -UNIFORM_PICTURE_SCALE / 2.0)];
		
		glPopMatrix();
		
		glDisable(GL_BLEND);
		glDisable(GL_TEXTURE_2D);
		glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	}
	
	[super drawObject];
}

-(void) updateObject
{

	[super updateObject];
	[self animate];
	
}

-(void) drawDetailObject
{
	glEnable(GL_TEXTURE_2D);
	//glEnable(GL_DEPTH_TEST);
	//glDepthFunc(GL_LESS);
	//glEnable(GL_BLEND);
	//glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glPushMatrix();
	glEnable2D();
	[picture drawInRect:CGRectMake(50, 150, 128, 128)];
	glDisable2D();
	glPopMatrix();
	
//	glDisable(GL_BLEND);
	//glDisable(GL_DEPTH_TEST);
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
}

-(void) animate
{	
	if (!reverseRotation) rotation += 0.2;
	else rotation -= 0.2;
	
	if (rotation >= 20 || rotation <= -20) 
	{
		reverseRotation = !reverseRotation;
	}	
}

-(void) dealloc
{
	free(circleTexCoords);
	[super dealloc];
}

@end
