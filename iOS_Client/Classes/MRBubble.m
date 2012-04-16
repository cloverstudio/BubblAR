//
//  MRBubble.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRBubble.h"
#import "sphere.h"
#import "icosphere.h"
#import "WMRandom.h"
#import "WMConcreteSubject.h"
#import "MRBubbleState.h"
#import "MRBubbleLow.h"

#define LIGHTBLUE_RED 125.0 / 255.0
#define LIGHTBLUE_GREEN 172.0 / 255.0
#define LIGHTBLUE_BLUE 197.0 / 255.0

@implementation MRBubble
@synthesize position;
@synthesize scaling;
@synthesize origin;
@synthesize concreteSubject;
@synthesize alive;
@synthesize visible;
@synthesize popped;
@synthesize scalingOffset;
@synthesize doneAnimating;
@synthesize distance;

@synthesize state;
@synthesize stateAlive;
@synthesize stateAliveAndVisible;
@synthesize statePopped;
@synthesize statePoppedAndVisible;
@synthesize stateDoneAnimating;

@synthesize drawingType;

-(void) attachGameObject
{
	[concreteSubject attach:self];
}

-(void)detachGameObject
{
	[concreteSubject detach:self];
}

-(void) insertGameObjectAtIndex:(int) index
{
	[concreteSubject insertObject:self atIndex:index];
}

-(id) initWithSubject:(WMConcreteSubject*) subject atPosition:(Vector3D)positionArg
{
	if (self = [super init]) 
	{
		concreteSubject = subject;
		position = positionArg;
		[self makeColors:sphereNumVerts];
		[self reset];
		
		bubblesArray = [[NSMutableArray alloc] initWithCapacity:10];
		
		for (int i = 0; i < 10; i++) 
		{
			MRBubbleLow *tempBubble = [[MRBubbleLow alloc] initAtPosition:position];
			tempBubble.concreteSubject = concreteSubject;
			[bubblesArray addObject:tempBubble];
			[tempBubble release];
		}
		
		//load state machine
		
		stateAlive = [[MRBubbleStateAlive alloc] initWithInstance:self];
		stateAliveAndVisible = [[MRBubbleStateAliveAndVisible alloc] initWithInstance:self];
		statePopped = [[MRBubbleStatePopped alloc] initWithInstance:self]; 
		statePoppedAndVisible = [[MRBubbleStatePoppedAndVisible alloc] initWithInstance:self];
		stateDoneAnimating = [[MRBubbleStateDoneAnimating alloc] initWithInstance:self];
		state = stateAlive;
		
		rotation = getRandom() * 180;
		randomSineOffset = getRandom() * M_PI * 2;
		//rotation = 0;
		rotationAxes = Vector3DMake(getRandom(), getRandom(), getRandom());
		
		//[[MRObjectDrawingManager sharedInstance] addObject:self];
	}
	
	return self;
}



-(void) makeColors:(int) numVertices;
{
	
	color = calloc(numVertices, sizeof(Color3D));
		
	for(int i = 0; i < numVertices; i++)
	{
		
		color[i].red = LIGHTBLUE_RED;
		color[i].green = LIGHTBLUE_GREEN;
		color[i].blue = LIGHTBLUE_BLUE;
		color[i].alpha = 0.5;
	}	
	
}

-(void) update
{
	[state update];
	[state updateBubbles];
	[state dispose];
	
}

-(void) doUpdate
{
	float elapsedTime = [concreteSubject getElapsedTime];
	float time = [concreteSubject getTimeDouble];
	updateTimer += elapsedTime;
	
	//distance = 1. / Vector3DFastInverseMagnitude(position);
	
	//time *= 0.2;
	float timeSine = sinf(time + randomSineOffset);
	float timeCosine = sinf(time + randomSineOffset);
	scalingOffset.x = (0.2 * scaling * timeSine);
	scalingOffset.y = (0.1 * scaling * timeSine);
	scalingOffset.z = (0.3 * scaling * timeSine); 
	
	if (updateTimer >= 1.0) 
	{
		rotationAxes.x = getRandom();
		rotationAxes.y = getRandom();
		rotationAxes.z = getRandom();
	}
	
	lightOffset.x = position.x + 10 * timeSine;
	lightOffset.y = position.y + 10 * timeCosine;
	lightOffset.z = position.z + timeSine;
	
	for (MRBubbleLow *bubble in bubblesArray) 
	{
		bubble.position = position;
	}
	
}

-(void) updateBubbles
{
	int bubblesDead;
	
	for (MRBubbleLow *bubble in bubblesArray) 
	{
		[bubble update];
		
		if (!bubble.alive) 
		{
			bubblesDead++;
		}
	}
	
	if (bubblesDead == bubblesArray.count) 
	{
		doneAnimating = YES;
	}
}

-(void) draw
{
	[state draw];
	[state drawBubbles];
}

-(void) doDraw
{
	
	Vector3D cameraPosition = [concreteSubject getCameraPosition];
	
	rotation += 1.0;
	
	float lightAmbient[] = { 0.8, 0.8, 0.8, 1.0f };
	float lightDiffuse[] = { 1.0, 1.0, 1.0, 1.0f };
	//float lightDiffuse[] = { 0.7, 0.7, 0.7, 1.0f };
	float lightSpecular[] = { 1.0f, 1.0f, 1.0f, 1.0f };
	float lightSpecular2[] = { 0.4f, 0.0f, 0.0f, 1.0f };
	float lightSpecular3[] = { 0.0f, 0.4f, 0.0f, 1.0f };
	float lightSpecular4[] = { 0.0f, 0.0f, 0.4f, 1.0f };
	
	/*
	float lightPosition[] = { position.x , position.y + 5.0f, position.z + 5.0f, 0.0f };
	float lightPosition2[] = { lightOffset.x - 10.0f, lightOffset.y - 8.0f, lightOffset.z - 8.0f, 0.0f };
	float lightPosition3[] = { lightOffset.x - 8.0f, lightOffset.y - 6, lightOffset.z - 6 , 0.0f };
	float lightPosition4[] = { lightOffset.x - 6.0f, lightOffset.y - 4.0f, lightOffset.z - 4.0f, 0.0f };
	*/
	
	float lightPosition[] = { cameraPosition.x , cameraPosition.y + 5.0f, cameraPosition.z + 5.0f, 0.0f };
	float lightPosition2[] = { cameraPosition.x + lightOffset.x - 10.0f, cameraPosition.y + lightOffset.y - 8.0f, cameraPosition.z + lightOffset.z - 8.0f, 0.0f };
	float lightPosition3[] = { cameraPosition.x + lightOffset.x - 8.0f, cameraPosition.y + lightOffset.y - 6, cameraPosition.z + lightOffset.z - 6 , 0.0f };
	float lightPosition4[] = { cameraPosition.x + lightOffset.x - 6.0f, cameraPosition.y + lightOffset.y - 4.0f, cameraPosition.z + lightOffset.z - 4.0f, 0.0f };
	
	//float lightPosition2[]
	
	float matAmbient[] = { LIGHTBLUE_RED *0.4 , LIGHTBLUE_GREEN * 0.4 , LIGHTBLUE_BLUE *0.7, 0.1f };
	float matDiffuse[] = { LIGHTBLUE_RED, LIGHTBLUE_GREEN, LIGHTBLUE_BLUE, 0.6f };
	float matSpecular[] = { 1.0f, 1.0f, 1.0f, 1.0f };
	//float matClear[] = {0.0f, 0.0f, 0.0f, 0.0f};
	
	
	//float lightDirection[] = { 0.0f, 0.0f, 0.0f };
	
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	glEnable(GL_LIGHTING);
	glEnable(GL_LIGHT0);
	glEnable(GL_LIGHT1);
	glEnable(GL_LIGHT2);
	glEnable(GL_LIGHT3);
	glEnable(GL_NORMALIZE);
	
	
	glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, matAmbient);
	glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, matDiffuse);
	glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, matSpecular);
	glMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, 100);
	
	glLightfv(GL_LIGHT0, GL_AMBIENT, lightAmbient);
	glLightfv(GL_LIGHT0, GL_DIFFUSE, lightDiffuse);
	glLightfv(GL_LIGHT0, GL_SPECULAR, lightSpecular);
	glLightfv(GL_LIGHT0, GL_POSITION, lightPosition );
	
	glLightfv(GL_LIGHT1, GL_SPECULAR, lightSpecular2);
	glLightfv(GL_LIGHT1, GL_POSITION, lightPosition2 );
	
	glLightfv(GL_LIGHT2, GL_SPECULAR, lightSpecular3);
	glLightfv(GL_LIGHT2, GL_POSITION, lightPosition3 );
	
	glLightfv(GL_LIGHT3, GL_SPECULAR, lightSpecular4);
	glLightfv(GL_LIGHT3, GL_POSITION, lightPosition4);
	
	//glLightfv(GL_LIGHT0, GL_SPOT_DIRECTION, lightDirection);
	
	//glLightf(GL_LIGHT0, GL_SPOT_CUTOFF, 1.2f);
	
	//glLightf(GL_LIGHT0, GL_SPOT_EXPONENT, 20.0f);
	
	//glEnable(GL_DEPTH_TEST);
	//glDepthFunc(GL_LEQUAL);
	
	//glEnable(GL_CULL_FACE);
	glShadeModel(GL_SMOOTH);
	glEnableClientState(GL_COLOR_ARRAY);
	
	glPushMatrix();
	
	glTranslatef(position.x, position.y, position.z);
	glRotatef(rotation, 1, 1, 1);
	glScalef(scaling + scalingOffset.x, scaling + scalingOffset.y, scaling + scalingOffset.z);
	
	glVertexPointer(3, GL_FLOAT, 0, sphereVerts);
	glColorPointer(4, GL_FLOAT, 0, color);
	glNormalPointer(GL_FLOAT, 0, sphereVerts);	//using the vers as normals because they are the same
	glDrawArrays(GL_TRIANGLES, 0, sphereNumVerts);
	
	glPopMatrix();	
	
	glDisableClientState(GL_COLOR_ARRAY);
	
	glDisable(GL_LIGHT0);
	glDisable(GL_LIGHT1);
	glDisable(GL_LIGHT2);
	glDisable(GL_LIGHT3);
	glDisable(GL_BLEND);
	glDisable(GL_LIGHTING);
	//glDisable(GL_DEPTH_TEST);
}

-(void) drawBubbles
{
	for (MRBubbleLow *bubble in bubblesArray) 
	{
		[bubble draw];
	}
}

-(void) reset
{
	popped = NO;
	alive = YES;
	visible = YES;
	doneAnimating = NO;
	state = stateAlive;
	if (bubblesArray) 
	{
		for (MRBubbleLow *bubble in bubblesArray) 
		{
			[bubble reset];
		}
	}
}

-(void) dealloc
{
	free(color);
	[bubblesArray release];
	
	[stateAlive release];
	[stateAliveAndVisible release];
	[statePopped release];
	[statePoppedAndVisible release];
	[stateDoneAnimating release];
	
	[super dealloc];
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

-(void) cleanup{}
-(void) loadObject{}


@end
