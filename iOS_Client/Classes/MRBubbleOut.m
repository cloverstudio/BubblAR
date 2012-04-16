//
//  MRBubbleOut.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRBubbleOut.h"
#import "WMConcreteSubject.h"
#import "MRBubble.h"
#import "MRSharedGeometry.h"
#import "CCTexture2D.h"
#import "WMCollisionDetection.h"
#import "MRRootViewController.h"
#import "MRObjectManager.h"
#import "MRObjectGroupManager.h"
#import "WMGamestate.h"
#import "MRViewController.h" 

@implementation MRBubbleOut
@synthesize concreteSubject;
@synthesize gamestate;

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

-(id) initWithSubject:(WMConcreteSubject *)subject andRootController:(MRRootViewController*) rootControllerArg andGamestate:(WMGamestate*) gamestateArg
{
	if (self = [super init]) 
	{
		concreteSubject = subject;
		rootController = rootControllerArg;
		gamestate = gamestateArg;
		bubblarIconTex = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"icon.png"]];
		drawPosition = Vector3DMake(10, 0, -5);

		bubble = [[MRBubble alloc] initWithSubject:concreteSubject atPosition:drawPosition];
	
		scaling = 2.0;
		touched = NO;
		
		screenPosition = CGPointMake(240, 320);
		touchRadius = 30.0;
		
		bubble.scaling = scaling * 3./ 2.;
		
		circleVerts = [[MRSharedGeometry sharedInstance] circleVerts];
		numVertices = [[MRSharedGeometry sharedInstance] numCircleVerts];
		//[self makeUnitCircle:20];
		
		circleTexCoords = calloc(numVertices, sizeof(TexCoords));
		
		[self makeUVCorrection];
	}
	return self;
}


-(void) loadObject
{
	
}

-(void) makeUVCorrection
{
	for (int i = 0; i < numVertices; i++) 
	{
		circleTexCoords[i].u = circleVerts[i].texCoords.u;
		circleTexCoords[i].v = circleVerts[i].texCoords.v;
		circleTexCoords[i].u *= bubblarIconTex.maxS;
		circleTexCoords[i].v *= bubblarIconTex.maxT;
	}
}


-(void) cleanup
{}

-(void) update
{
	[bubble update];
	
	//check for touches if object manager is (initially loaded AND running) OR group manager is running.
	BOOL touchesAllowed = ([[MRObjectManager sharedInstance] running] && [[MRObjectManager sharedInstance] initialLoadDone]) || [[MRObjectGroupManager sharedInstance] running];
	
	//AND if InfoPanelView is hidden
	touchesAllowed = touchesAllowed && rootController.currentViewController.hidden;
		
	if (touchesAllowed) 
	{
		[self checkTouches];
	}
}

-(void) checkTouches
{
	if([concreteSubject getTouch1])
	{
		//detach all touches.
		//
		if (pointCircleCollision([concreteSubject getTouchPosition1], screenPosition, touchRadius)) 
		{
			[concreteSubject setTouch1:NO];
			
			
			[rootController changeView:BB_BUBBLE_OUT_VIEW];
		}
	}
}

-(void) draw
{
	float azimuth = 0;//[concreteSubject getAzimuth];
	float inclination = 0;//[concreteSubject getInclination];
	
	glPushMatrix();
	{
		
		glLoadIdentity();
		
		glMatrixMode(GL_MODELVIEW);
		
		gluLookAt(0, 0, 0, 
				  10, 0, 0, 
				  0, 0, 1);	
		
		
		glEnable(GL_TEXTURE_2D);
		glEnable(GL_BLEND);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		
		glBindTexture(GL_TEXTURE_2D, bubblarIconTex.name);
		
		glPushMatrix();
		{
			
			glTranslatef(drawPosition.x, drawPosition.y, drawPosition.z);
			
			glRotatef(-90 - inclination, 0.0, 1.0, 0.0);
			glRotatef(-180 -azimuth, 1.0, 0.0, 0.0);
			glRotatef(90 , 0, 0, 1);		
			//glRotatef(rot, 1.0, 1.0, 1.0);
			
			glScalef(scaling + bubble.scalingOffset.x, scaling + bubble.scalingOffset.y, scaling + bubble.scalingOffset.z);
			
			glVertexPointer(3, GL_FLOAT, sizeof(TexturedNormalVertex3D), &circleVerts[0].vertices);
			glNormalPointer(GL_FLOAT, sizeof(TexturedNormalVertex3D), &circleVerts[0].normals);
			glTexCoordPointer(2, GL_FLOAT, 0, circleTexCoords);
			glDrawArrays(GL_TRIANGLE_FAN, 0, numVertices);
		}
		glPopMatrix();
		
		
		glDisable(GL_BLEND);
		glDisable(GL_TEXTURE_2D);
		glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	

		[bubble draw];
		
	}
	glPopMatrix();

}

-(void) reset
{}

-(void) dealloc
{
	[bubblarIconTex release];
	[bubble release];
	[super dealloc];
}

@end
