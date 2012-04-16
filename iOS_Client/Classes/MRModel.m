//
//  MRModel.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 3/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRModel.h"
#import "KEMD2Object.h"
#import "CCTexture2D.h"
#import "WMConcreteSubject.h"
#import "CocosWMBridge.h"
#import "ARToGLCoordinates.h"
//#import "MRLabel.h"
#import "MRBubble.h"
#import "MRDistanceLabel.h"

#define UNIFORM_MODEL_SCALE 5.0

@implementation MRModel

-(id) initWithSubject:(WMConcreteSubject*) subject 
			 andModel:(KEMD2Object*) modelArg
			 andTitle:(NSString*) titleArg
	   andDescription:(NSString*) descriptionArg
			   andUrl:(NSString*) urlArg
		andCLPosition:(CLLocation*) clPositionArg
		   andModelID:(int) modelIDArg
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
		//concreteSubject = subject;
		
		rot = 0.0;
		model = [modelArg retain];
		modelID = modelIDArg;
		model.animation = KEMD2AnimationRun;	
		scaling = UNIFORM_MODEL_SCALE / [model getVertexMaxOffsets];
			
		//NSLog(@"vSize = (%f , %f ,%f)", vertexSize.x, vertexSize.y, vertexSize.z);
		
		/*
		modelLabel = [[MRLabel alloc] initWithSubject:subject 
											 andTitle:titleArg 
									   andDescription:descriptionArg 
											   andUrl:urlArg 
										andCLPosition:clPositionArg 
												andID:idArg];

	*/
		 
	}
	
	return self;
}

-(void) updateObject
{
	/*
	if (!dispose) 
	{
		
		position = getGLCoordinatesFromCLLocation([[CocosWMBridge inst] currentLocation], clPosition);
		Vector3D relativePosition = position;
		
		distance = 1. / Vector3DFastInverseMagnitude(position);
		
		drawDistance = distance;
		if (drawDistance > maxDistance)
		{
			drawDistance = maxDistance;
		}
		
		Vector3DNormalize(&relativePosition);

		relativePosition = Vector3DMultiplyByScalar(relativePosition, drawDistance);
	 
		boundingSphere.c = relativePosition;
		//position = Vector3DMake(10,0,0);

		
		[self checkTouches];
		
		[bubble setPosition: relativePosition];
		[bubble setScaling:3.0];
		[bubble update];
	}
	 */
	
	[super updateObject];
	bubble.scaling = 8.0;
	[self animate];
}

-(void) drawObject
{
	
	if (!dispose) 
	{
	
		float azimuth = [concreteSubject getAzimuth];
		float inclination = [concreteSubject getInclination];

		GLfloat lightPosition[4] = { 200.0, 0.0, 11};
		GLfloat lightDefuse[4] = { 1.0, 1, 1, 1.0};
		GLfloat lightAmbient[4] = { 0.8, 0.8, 0.8, 1.0};
		
		//rot += 2.0;
		glEnable(GL_BLEND);
		glEnable( GL_DEPTH_TEST);
		glDepthFunc(GL_LESS);
		glCullFace(GL_FRONT);
		glEnable(GL_TEXTURE_2D);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		glEnable( GL_LIGHTING);
		glEnable( GL_LIGHT0);
		glLightfv( GL_LIGHT0, GL_DIFFUSE, lightDefuse);
		glLightfv( GL_LIGHT0, GL_AMBIENT, lightAmbient);
		glLightf( GL_LIGHT0, GL_SPOT_EXPONENT, 68);
		glLightfv( GL_LIGHT0, GL_POSITION, lightPosition);
		glBindTexture( GL_TEXTURE_2D, model.texture.name);

		glPushMatrix();
		{
			
			glTranslatef(drawPosition.x, drawPosition.y, drawPosition.z);
			glScalef( scaling, scaling, scaling);
			
			GLfloat color[] = { 1.0f, 1.0f, 0.0f, 1.0};
			glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_BLEND );
			glTexEnvfv( GL_TEXTURE_ENV, GL_TEXTURE_ENV_COLOR, color );
			[model renderGL];	
			glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
			
			
			//[model setupForRenderGL];
			//if (touched) 
			//{
				/*
				float alpha = 0.2 + 0.8 * sinf([concreteSubject getTimeDouble]); 
				GLfloat color[] = { 1.0f, 1.0f, 0.0f, alpha};
				glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_BLEND );
				glTexEnvfv( GL_TEXTURE_ENV, GL_TEXTURE_ENV_COLOR, color );
				[model renderGL];	
				glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
				//	glTexEnvfv( GL_TEXTURE_ENV, GL_TEXTURE_ENV_COLOR, normalColor)
				*/
			//}
			//else [model renderGL];	
			//[model cleanupAfterRenderGL];
			//glColor4f(1.0, 1.0, 1.0, 1.0);
		}
		glPopMatrix();
		glCullFace(GL_BACK);
		glDisable(GL_DEPTH_TEST);
		glDisable( GL_LIGHT0);
		glDisable( GL_LIGHTING);
		
		//distance label
		glPushMatrix();
		
		glTranslatef(drawPosition.x, drawPosition.y, drawPosition.z);
		glRotatef(-90 - inclination, 0.0, 1.0, 0.0);
		glRotatef(-azimuth, 1.0, 0.0, 0.0);
		glRotatef(-90, 0, 0, 1);
		
		distanceLabelRect = [[MRDistanceLabel sharedInstance] drawNumber: distance atOrigin: CGPointMake(-distanceLabelRect.size.width / 2.0, -UNIFORM_MODEL_SCALE / 2.0)];

		glPopMatrix();
		
		glDisableClientState(GL_TEXTURE_COORD_ARRAY);
		glDisable(GL_TEXTURE_2D);
		glDisable(GL_BLEND);

		

		//[super drawObject];
	}
}

-(void) updateDetailObject
{
	[self animate];
	rot += 2.0;
}

-(void) animate
{
	[model doTick:[concreteSubject getTimeDouble]];
}

-(void) drawDetailObject
{
	
	
	//glEnable( GL_BLEND);
	//glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glBindTexture( GL_TEXTURE_2D, model.texture.name);
	
	glPushMatrix();
	{
		
	glLoadIdentity();	
		
	glMatrixMode(GL_MODELVIEW);
		
	gluLookAt(0, 0, 0, 
			  10, 0, 0, 
			  0, 0, 1);	
		
	glTranslatef(10, 5, 2);
	glRotatef( rot, 0, 0, 1);
	glScalef( scaling, scaling, scaling);
		
	//[model doTick:elapsedTime];
		
	glEnable( GL_DEPTH_TEST);
	glDepthFunc(GL_LESS);
	glCullFace(GL_FRONT);
	[model renderGL];	
	glDisable(GL_DEPTH_TEST);
	glCullFace(GL_BACK);
		
	}
	glPopMatrix();
	
	//glDisable(GL_BLEND);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisable(GL_TEXTURE_2D);
	
}

-(void) dealloc
{
	[model release];
	[super dealloc];
}

@end
