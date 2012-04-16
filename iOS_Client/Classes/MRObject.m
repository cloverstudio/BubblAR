//
//  MRObject.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 3/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRObject.h"
#import "CocosWMBridge.h"
#import "WMConcreteSubject.h"
#import "ARToGLCoordinates.h"
#import "MRLabel.h" 
#import "MRObjectTouchesManager.h"
#import "WMRandom.h"
#import "MRBubble.h"
#import "MRObjectState.h"
#import "MRObjectGroupManager.h"
#import "MRObjectManager.h"

@implementation MRObject

@synthesize concreteSubject;
@synthesize clPosition;
@synthesize title;
@synthesize url;
@synthesize description;
@synthesize ID;
@synthesize type;
@synthesize position;
@synthesize drawPosition;
@synthesize dispose;
@synthesize distance;
@synthesize touched;
@synthesize scaling;
@synthesize visible;
@synthesize doneAnimating;
@synthesize bubble;
@synthesize boundingSphere;

@synthesize drawingType;

@synthesize state;
@synthesize stateAlive;
@synthesize stateAliveAndVisible;
@synthesize statePopped;
@synthesize statePoppedAndVisible;
@synthesize stateDoneAnimating;

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

-(id) initWithSubject:(WMConcreteSubject *)cs 
			 andTitle:(NSString*) titleArg 
	   andDescription:(NSString*) descriptionArg
			   andUrl:(NSString*) urlArg
		andCLPosition:(CLLocation*) clPositionArg 
				andID:(int) idArg
			  andType:(int) typeArg;
{

	if (self = [super init]) 
	{
		
		
		concreteSubject = cs;
		ID = idArg;
		type = typeArg;
		title = [titleArg retain];
		url = [urlArg retain];
		description = [descriptionArg retain];
		clPosition = [clPositionArg retain];
		
		position = getGLCoordinatesFromCLLocation([[CocosWMBridge inst] currentLocation], clPosition);
		distance = 1. / Vector3DFastInverseMagnitude(position);

		boundingSphere.c = position;
		boundingSphere.r = 5.0;
		touched = NO;
		dispose = NO;
		visible = YES;
		doneAnimating = NO;
		maxDistance = 25.0;

		stateAlive = [[MRObjectStateAlive alloc] initWithInstance:self];
		stateAliveAndVisible = [[MRObjectStateAliveAndVisible alloc] initWithInstance:self];
		statePopped = [[MRObjectStatePopped alloc] initWithInstance:self];
		statePoppedAndVisible = [[MRObjectStatePoppedAndVisible alloc] initWithInstance:self];
		stateDoneAnimating = [[MRObjectStateDoneAnimating alloc] initWithInstance:self];
		state = stateAlive;
				
		bubble = [[MRBubble alloc] initWithSubject:concreteSubject atPosition:position];
		
		[[MRObjectDrawingManager sharedInstance] addObject:self];
		drawingType = DRAWING_TYPE_WORLD;
	}
	
	return self;
}

-(void) checkTouches
{

	if ([concreteSubject getTouch1] == YES) 
	{
		
		Ray ray;
		ray.o = [concreteSubject getCameraPosition];
		ray.d = [concreteSubject getTouchVector];
		
		//NSLog(@ ");  
		
		if(raySphereIntersection(ray, boundingSphere))
		{
			//[[CocosWMBridge inst]touchedItem:self.ID];
			if (touchTicks == 0) 
			{
				touchHandle = YES;
				[[MRObjectTouchesManager sharedInstance] addObject:self];
			}
			else 
			{
				if ([self isEqual:[[MRObjectTouchesManager sharedInstance] getClosestObject]]) 
				{
					
					[concreteSubject setTouch1:NO];
					
					[[MRObjectDrawingManager sharedInstance] stop];
					[[MRObjectManager sharedInstance] stop];
					
					[[MRObjectGroupManager sharedInstance] setTouchedObject: self];
					
					//if there is a group of objects
					if ([[MRObjectGroupManager sharedInstance] checkGroupings:[[MRObjectDrawingManager sharedInstance] objects]]) 
					{
						[[MRObjectGroupManager sharedInstance] makeLinearTable];
						[[MRObjectGroupManager sharedInstance] start];
					}//else, handle one object
					else
					{
						
						[[MRObjectDrawingManager sharedInstance] start];
						[[MRObjectManager sharedInstance] start];
						touched = YES;
						[[CocosWMBridge inst]touchedItem:self.ID];
					}
					//[[CocosWMBridge inst]touchedItem:self.ID];
				
				}	
			}
			touchTicks++;
		}
		
	}
	else 
	{
		if (touchHandle) 
		{
			touchHandle = NO;
			[[MRObjectTouchesManager sharedInstance] removeObject:self];
		}
		
		touched = NO;
		touchTicks = 0;
	}
	

}

-(BOOL) visible
{
	
	Vector3D cameraVector = [concreteSubject getCameraDirection];
	
	float angleXY = Vector3DAngleBetweenVectorsXYAxis(cameraVector, drawPosition);
	float axisAngle = Vector3DAxisAngleBetweenVectors(cameraVector, drawPosition);
	
	if (angleXY > 2*M_PI) 
	{
		angleXY -= 2*M_PI;
	}
	
	if (axisAngle > 2*M_PI) 
	{
		axisAngle -= 2*M_PI;
	}
	
	float viewPortRight = M_PI / 2;
	float viewPortTop = M_PI / 3;
	
	
	if (angleXY > viewPortRight) 
	{
		return NO; 
	}
	
	if (axisAngle > viewPortTop) 
	{
		return NO;
	}
	return YES;
	
}

-(void) cleanup
{}

-(void) animate
{
	
	float elapsedTime = [concreteSubject getElapsedTime];
	
	updateAnimationTimer += elapsedTime;
	
	if(updateAnimationTimer >= 0.5)
	{
		updateAnimationTimer = 0.0;
		
		animationOffset = Vector3DAdd(origin, Vector3DMake(getRandom()*0.2, getRandom()*0.2, getRandom()*0.2));
	}
	
	acceleration = Vector3DMakeWithStartAndEndPoints(position, animationOffset);
	
	Vector3D dVelocity = Vector3DMultiplyByScalar(acceleration, elapsedTime);
	velocity.x += dVelocity.x;
	velocity.y += dVelocity.y;
	velocity.z += dVelocity.z;
	
	Vector3D dPosition = Vector3DMultiplyByScalar(velocity, elapsedTime);
	position.x += dPosition.x;
	position.y += dPosition.y;
	position.z += dPosition.z;
	
}

-(void) update
{
	[state updateObject];
	[state updateBubble];
	[state updateDetailObject];
}

-(void) draw
{
	[state drawObject];
	[state drawBubble];	
	[state drawDetailObject];
}

-(void) updateObject
{
	if (!dispose) 
	{
		position = getGLCoordinatesFromCLLocation([[CocosWMBridge inst] currentLocation], clPosition);
		drawPosition = position;
		distance = 1. / Vector3DFastInverseMagnitude(position);
		
		drawDistance = distance;
		if (drawDistance > maxDistance)
		{
			drawDistance = maxDistance;
		}
		
		Vector3DNormalize(&drawPosition);
		drawPosition = Vector3DMultiplyByScalar(drawPosition, drawDistance);
		
		//[self animate];
		
		boundingSphere.c = drawPosition;	//center of the bounding sphere is at drawing position
		[self checkTouches];
	}
}


-(void) addToDrawingManager
{
	[[MRObjectDrawingManager sharedInstance] addObject:self];
	[[MRObjectDrawingManager sharedInstance] sortObjects];
}

-(void) drawObject
{

}

-(void) updateDetailObject
{}

-(void) drawDetailObject
{

}

-(void) updateBubble
{
	bubble.distance = distance;
	bubble.position = drawPosition;
	[bubble update];
}

-(void) drawBubble
{
	[bubble draw];
}

-(void) loadObject
{

}

-(void) reset
{
	[bubble reset];
	boundingSphere.c = position;
	boundingSphere.r = 5.0;
	touched = NO;
	dispose = NO;
	visible = YES;
	doneAnimating = NO;
	maxDistance = 25.0;
	state = stateAlive;
}

-(void) dealloc
{
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

-(void) resizeLabels
{}

@end
