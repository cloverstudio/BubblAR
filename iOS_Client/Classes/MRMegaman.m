//
//  MRMegaman.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 3/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRMegaman.h"
#import "KEMD2Object.h"
#import "CCTexture2D.h"
#import "WMConcreteSubject.h"

@implementation MRMegaman
@synthesize concreteSubject;
@synthesize position;

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

-(id) initWithSubject:(WMConcreteSubject*) cs
{
	if (self = [super init])
	{
		concreteSubject = cs;
		
		megamanTex = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"megaman.jpg"]];
		megamanModel = [[KEMD2Object alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"megaman" ofType:@"md2"] texture:megamanTex];
		megamanModel.animation = KEMD2AnimationRun;
		[megamanTex release];
		
	}
	
	return self;
}

-(id) initWithSubject:(WMConcreteSubject*) cs andModel:(KEMD2Object*) model
{
	if (self = [super init])
	{
		concreteSubject = cs;
		
		megamanModel = [model retain];
		megamanModel.animation = KEMD2AnimationRun;		
	}
	
	return self;
}


-(void) loadObject
{}

-(void) update
{
	position = Vector3DMake(10,0,0);
	[megamanModel doTick:[concreteSubject getTimeDouble]];
}

-(void) draw
{
	static float rot = 0.0;
	static GLfloat lightPosition[4] = { 200.0, 0.0, 11};
	static GLfloat lightDefuse[4] = { 1.0, 1, 1, 1.0};
	static GLfloat lightAmbient[4] = { 0, 0, 0, 1.0};

	//rot += 2.0;
	
	glEnable( GL_LIGHTING);
	glEnable( GL_LIGHT0);
	glLightfv( GL_LIGHT0, GL_DIFFUSE, lightDefuse);
	glLightfv( GL_LIGHT0, GL_AMBIENT, lightAmbient);
	glLightf( GL_LIGHT0, GL_SPOT_EXPONENT, 68);
	glLightfv( GL_LIGHT0, GL_POSITION, lightPosition);
	
	glTranslatef(position.x, position.y, position.z);
	glRotatef( rot, rot, rot, 1);
	glScalef( 0.119, 0.119, 0.119);
	[megamanModel setupForRenderGL];
	[megamanModel renderGL];	
	[megamanModel cleanupAfterRenderGL];
	
	glDisable( GL_LIGHT0);
	glDisable( GL_LIGHTING);

	
}

-(void) reset
{}

-(void) dealloc
{
	[megamanModel release];
	[super dealloc];
}


@end
