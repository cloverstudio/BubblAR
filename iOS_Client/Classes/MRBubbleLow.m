//
//  MRBubbleLow.m
//  EffectTestGround
//
//  Created by marko.hlebar on 4/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRBubbleLow.h"
#import "sphereLow.h"
#import "WMRandom.h"
#import "WMConcreteSubject.h"
/*
#define LIGHTBLUE_RED 125 / 255.0
#define LIGHTBLUE_GREEN 172 / 255.0
#define LIGHTBLUE_BLUE 197 / 255.0
*/
#define COLOR_CYAN Color3DMake(0.0, 1.0, 1.0,1.0)
#define COLOR_YELLOW Color3DMake(1.0, 1.0, 0.0, 1.0)
#define COLOR_MAGENTA Color3DMake(1.0, 0.0, 1.0, 1.0)
#define COLOR_GREEN Color3DMake(0.5, 1.0, 0.0, 1.0)

@implementation MRBubbleLow
@synthesize scaling;
@synthesize alive;
@synthesize position;
@synthesize concreteSubject;
@synthesize distance; 
@synthesize drawingType;

-(id) initAtPosition:(Vector3D)positionArg
{

	if (self = [super init]) 
	{

		position = positionArg;
		[self reset];
		[self makeColorsBlue:sphereLowNumVerts];
		[self makeMaterialColor];
	}
	
	return self;
}

-(void) reset
{
	time = 0.0;
	aliveTime = 1.0 + getRandom() * 1.0;
	alive = YES;
	velocity = Vector3DMake(getRandomSign()*getRandom() * 5, getRandomSign()*getRandom() *5, getRandomSign()*getRandom() *5);
	acceleration = Vector3DMake(0,0,10);
	scaling = 2.0 * getRandom();	
}

-(void) makeMaterialColor
{
	switch (arc4random() % 4) 
	{
		case 0:
			materialColor = COLOR_CYAN;
			break;
		case 1:
			materialColor = COLOR_MAGENTA;
			break;
		case 2:
			materialColor = COLOR_YELLOW;
			break;
		case 3:
			materialColor = COLOR_GREEN;
			break;
		default:
			break;
	}
}

-(void) makeColorsBlue:(int) numVertices
{
	
	color = calloc(numVertices, sizeof(Color3D));
	
	for(int i = 0; i < numVertices; i++)
	{
		
		color[i].red = 125 / 255.0;
		color[i].green = 172 / 255.0;
		color[i].blue = 197 / 255.0;
		color[i].alpha = 1.0;
	}	
	
}

-(void) update
{

	if (alive) 
	{
		distance = 1. / Vector3DFastInverseMagnitude(position);
		
		float elapsedTime = 0.016;
		
		time += elapsedTime;
		
		acceleration = Vector3DMake(sinf(time) * 2, -sinf(time) * 2, 5);
		
		Vector3D dVelocity = Vector3DMultiplyByScalar(acceleration, elapsedTime);
		velocity = Vector3DAdd(velocity, dVelocity);
		
		Vector3D dPosition = Vector3DMultiplyByScalar(velocity, elapsedTime);
		position = Vector3DAdd(position, dPosition);
		
		if (time > aliveTime) 
		{
			alive = NO;
		}
	}
}

-(void) draw
{
	
	if (alive) 
	{
		
		Vector3D cameraPosition = [concreteSubject getCameraPosition];
		
		float lightAmbient[] = { 0.8, 0.8, 0.8, 1.0f };
		float lightDiffuse[] = { 1.0, 1.0, 1.0, 1.0f };
		float lightSpecular[] = { 1.0f, 1.0f, 1.0f, 1.0f };

		float lightPosition[] = { cameraPosition.x , cameraPosition.y+5.0, cameraPosition.z + 20.0f, 0.0f };
		
		//float matAmbient[] = { materialColor.red , materialColor.green , materialColor.blue, 0.1f };
		float matAmbient[] = { color[0].red *0.8, color[0].green*0.8, color[0].blue*0.8, 0.1f };

		float matDiffuse[] = { materialColor.red , materialColor.green, materialColor.blue, 0.7f };
		float matSpecular[] = { 1.0f, 1.0f, 1.0f, 1.0f };
		
		glEnable(GL_BLEND);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		
		glEnable(GL_LIGHTING);
		glEnable(GL_LIGHT0);
		glEnable(GL_NORMALIZE);
		
		glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, matAmbient);
		glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, matDiffuse);
		glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, matSpecular);
		glMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, 20);
		
		glLightfv(GL_LIGHT0, GL_AMBIENT, lightAmbient);
		glLightfv(GL_LIGHT0, GL_DIFFUSE, lightDiffuse);
		glLightfv(GL_LIGHT0, GL_SPECULAR, lightSpecular);
		glLightfv(GL_LIGHT0, GL_POSITION, lightPosition );
		
		
		//glEnable(GL_CULL_FACE);
		glShadeModel(GL_SMOOTH);
		glEnableClientState(GL_COLOR_ARRAY);
		
		glPushMatrix();
		
		glTranslatef(position.x, position.y, position.z);
		glScalef(scaling, scaling, scaling);
		glVertexPointer(3, GL_FLOAT, 0, sphereLowVerts);
		glColorPointer(4, GL_FLOAT, 0, color);
		glNormalPointer(GL_FLOAT, 0, sphereLowVerts);	//using the verts as normals because they are the same
		glDrawArrays(GL_TRIANGLES, 0, sphereLowNumVerts);

		glPopMatrix();	
		
		glDisableClientState(GL_COLOR_ARRAY);
		
		glDisable(GL_BLEND);
		glDisable(GL_LIGHT0);
		glDisable(GL_LIGHTING);
		//glDisable(GL_CULL_FACE);
		//glDisable(GL_DEPTH_TEST);
	
	}
}

-(NSComparisonResult) compareDistance:(id <MRDrawable>) object
{
	if (distance < [object distance])
	{
		return NSOrderedAscending;
	}
	else if (distance > [object distance]) 
	{
		return NSOrderedDescending;
	}
	else 
	{
		return NSOrderedSame;
	}	
}

@end
