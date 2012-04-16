//
//  WMCamera.m
//  openglTestViews
//
//  Created by Marko Hlebar on 5/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WMCamera.h"
#import "OpenGLCommon.h"
#import "WMConcreteSubject.h"

@implementation WMCamera
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

-(void) loadObject
{
	cameraPosition.x = 0.0;
	cameraPosition.y = 0.0;
	cameraPosition.z = 0.0;
	
	[concreteSubject setCameraPosition:cameraPosition];
}

- (void)update
{
	cameraPosition = [concreteSubject getCameraPosition];
	cameraDirection = [concreteSubject getCameraDirection];
}


-(void) draw
{
	Vector3D newCameraDirection = Vector3DAdd(cameraPosition, cameraDirection);
	
	gluLookAt(cameraPosition.x, cameraPosition.y, cameraPosition.z,
			  newCameraDirection.x, newCameraDirection.y, newCameraDirection.z,
			  0,				0,				  1);

}

-(void) reset
{}

-(void) cleanup
{}

-(Vector3D) getCameraPosition
{
	return cameraPosition;
}

-(void) setCameraPosition: (Vector3D) arg
{
	cameraPosition = arg;
}

-(void)dealloc
{
	[super dealloc];
}

@end
