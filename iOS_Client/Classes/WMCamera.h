//
//  WMCamera.h
//  openglTestViews
//
//  Created by Marko Hlebar on 5/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WMGameObject.h"
#import "WMConcreteSubject.h"
#import "OpenGLCommon.h"

@interface WMCamera : NSObject <WMGameObjectProtocol> {
	
	WMConcreteSubject *concreteSubject; 
	Vector3D cameraPosition;
	Vector3D cameraDirection;
	Vector3D position;
}

@property (nonatomic, assign) WMConcreteSubject *concreteSubject; 
@property Vector3D position;
-(Vector3D) getCameraPosition;
-(void) setCameraPosition: (Vector3D) arg;

-(void) attachGameObject;
-(void) detachGameObject;
-(void) insertGameObjectAtIndex:(int) index;
-(void) loadObject;
-(void) update;
-(void) draw;
-(void) reset;
-(void) dealloc;


@end
