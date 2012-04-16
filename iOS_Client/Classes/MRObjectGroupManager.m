//
//  MRObjectGroupManager.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRObjectGroupManager.h"
#import "MRObject.h"
#import "MRObjectManager.h"
#import "MRObjectDrawingManager.h"
#import "OpenGLCommon.h"
#import "WMConcreteSubject.h"
#import "CocosWMBridge.h"
#import "WMCollisionDetection.h"
#import "MRBubble.h"
#import "CCTexture2D.h"	

#define MIN_AXIS_ANGLE 0.35	//rad

static MRObjectGroupManager *sharedInstance = nil;

@implementation MRObjectGroupManager
@synthesize touchedObject;
@synthesize concreteSubject;
@synthesize swipe;
@synthesize running;

+(MRObjectGroupManager*) sharedInstance
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
		zRot = 0.0;
		selectBubbleLabel = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"lblSelectBubble.png"]];
		objectGroupArray = [[NSMutableArray alloc] initWithCapacity:1];
		running = NO;
		swipe = NO;
	}
	
	return self;
}

-(void) start
{
	running = YES;
}

-(void) stop
{
	running = NO;
}

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

-(void) addObject:(MRObject*) object
{
	[objectGroupArray addObject:object];
}

-(void) removeObject:(MRObject*) object
{
	[objectGroupArray removeObject:object];
}

-(void) removeAllObjects
{
	[objectGroupArray removeAllObjects];
}

-(BOOL) checkGroupings:(NSArray*) objects
{
	for (MRObject* object in objects) 
	{
		[self isGroupObject:object];
	}	
	
	if ([objectGroupArray count] == 1) 
	{	
		[self removeAllObjects];
		return NO;
		//[[CocosWMBridge inst]touchedItem:touchedObject.ID];
	}


	
	//NSLog(@"%d objects in group", [objectGroupArray count]);
	
	return YES;
}

-(void) makeCircularTable
{
	
	float dAngle = 0.35;
	float angle = 0.0;
	float radius = 20;
	Vector3D center = Vector3DMake(30.0, 0, 0);
	
	
	for (MRObject *object in objectGroupArray) 
	{
		
		//need to arrange objects by distance and put the closest one as the first.
		Vector3D circularPosition;
		circularPosition.x = center.x + (cosf(angle) * (-radius));
		circularPosition.y = center.y + (sinf(angle) * (-radius));
		object.drawPosition = circularPosition;
		
		angle += dAngle;
	}
	
	//take over the object drawing and updating.
	
	//[[MRObjectManager sharedInstance] removeAllObjects];
}

-(void) makeLinearTable
{
	Vector3D dPosition = Vector3DMake(0, 5, 0);
	Vector3D position = Vector3DMake(10, 0, 0);
	
	[objectGroupArray sortUsingSelector:@selector(compareDistance:)];

	for (MRObject *object in objectGroupArray) 
	{
		object.drawPosition = position;
		position = Vector3DSubtract(position, dPosition);
	}
}

-(void) alignObjectsRightFromPosition:(Vector3D) position
{
	Vector3D dPosition = Vector3DMake(0, 5, 0);

	
	for (MRObject *object in objectGroupArray) 
	{
		object.drawPosition = position;
		position = Vector3DSubtract(position, dPosition);
	}
}

-(void) alignObjectsLeftFromPosition:(Vector3D) position
{
	Vector3D dPosition = Vector3DMake(0, 5, 0);

	//reverse
	for (int i = [objectGroupArray count] - 1; i >= 0; i--) 
	{
		MRObject *object = [objectGroupArray objectAtIndex:i];
		object.drawPosition = position;
		position = Vector3DAdd(position, dPosition);
	}
}

-(void) moveItems:(float) distance
{
	
	//swipe = YES;

	
	for (MRObject *object in objectGroupArray) 
	{
		Vector3D moveVector = Vector3DMake(0, distance/20, 0);
		
		object.drawPosition = Vector3DAdd(object.drawPosition, moveVector);
	}
	
	if([objectGroupArray count] >= 2)
	{
		MRObject *firstObject = [objectGroupArray objectAtIndex:0];
		MRObject *lastObject = [objectGroupArray lastObject];
	
		if (firstObject.drawPosition.y < 0) 
		{
			[self alignObjectsRightFromPosition:Vector3DMake(10,0,0)];

		}
		
		
		if (lastObject.drawPosition.y > 0) 
		{
			[self alignObjectsLeftFromPosition:Vector3DMake(10,0,0)];

		}
	}
}

//we will do all the custom update from here
-(void) update
{
	
	if (running) 
	{
		
		zRot += 0.001;
		
		for (MRObject *object in objectGroupArray) 
		{
			/*
			 Vector3D tempDrawPosition = object.drawPosition;
			 Matrix3DRotateVectorZ(&tempDrawPosition, zRot);
			 object.drawPosition = tempDrawPosition;
			 */
			Sphere newSphere = object.boundingSphere;
			newSphere.c = object.drawPosition;
			newSphere.r = 2.0;
			object.boundingSphere = newSphere;
			object.state = object.stateAliveAndVisible;
			[object animate];
			[object updateBubble];
		}
		
		
		//if not swiping, check for touches
		if (!swipe) 
		{
			if ([concreteSubject getTouch1] == YES) 
			{
				touched = YES;
			}
			
			if (![concreteSubject getTouch1] && touched) 
			{
				touched = NO;
				
				Ray ray;
				ray.o = [concreteSubject getCameraPosition];
				ray.d = [concreteSubject getTouchVector];
				
				
				//iterate through all objects
				for (MRObject *object in objectGroupArray) 
				{
					
					if(raySphereIntersection(ray, object.boundingSphere))
					{
						
						[[MRObjectDrawingManager sharedInstance] start];
						[[MRObjectManager sharedInstance] start];
						[object update];
						[object setState:object.statePoppedAndVisible];
						[object setDistance:0.0];
					
						object.bubble.popped = YES;
						
						[[MRObjectDrawingManager sharedInstance] sortObjects];	//to get the frustum culling ok
						//[object updateBubble];
						[[CocosWMBridge inst]touchedItem:object.ID];
						// reset bounding spheres back.
						for (MRObject* object in objectGroupArray) 
						{
							Sphere newSphere;
							newSphere.r = 5.0;
							object.boundingSphere = newSphere;
						}
						[self reset];
						break;
					}
				}
			}
		}
		else 
		{
			touched = NO;
		}

	}
}

-(void) draw
{
	if (running) 
	{

		//force azimuth and inlination
		[concreteSubject setAzimuth:0];
		[concreteSubject setInclination:0];
		
		glEnable(GL_TEXTURE_2D);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		glEnable2D();
		[selectBubbleLabel drawInRect:CGRectMake(290, 245, 170, 63)];
		glDisable2D();
		glDisableClientState(GL_TEXTURE_COORD_ARRAY);
		glDisable(GL_TEXTURE_2D);
		
		glPushMatrix();
		
		glLoadIdentity();
		
		glMatrixMode(GL_MODELVIEW);
		
		gluLookAt(0, 0, 0, 
				  10, 0, 0, 
				  0, 0, 1);	
		
		for (MRObject* object in objectGroupArray) 
		{
			
			glPushMatrix();
			{
				
				glTranslatef(object.drawPosition.x, object.drawPosition.y, 0);			
				[object draw];
				
			}
			glPopMatrix();
			
		}
		
		glPopMatrix();
	}
}


//we will determine if the object is in group with touched objects
//by means of angular distance between the two. 
//if yes, adding the object to group object array.
-(void) isGroupObject:(MRObject*) object
{
	if (Vector3DAxisAngleBetweenVectors(touchedObject.position, object.position) < MIN_AXIS_ANGLE)
	{
		[self addObject:object];
	}
}

-(void) loadObject
{}
-(void) cleanup{}

-(void) reset
{

	
	[self stop];
	[self removeAllObjects];
}


-(void) dealloc
{
	[super dealloc];
}

@end
