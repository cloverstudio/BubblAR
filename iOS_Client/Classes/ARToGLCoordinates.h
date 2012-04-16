//
//  ARToGLCoordinates.h
//  ARKitDemo
//
//  Created by marko.hlebar on 1/15/10.
//  Copyright 2010 Zac White. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenGLCommon.h"
#import <CoreLocation/CoreLocation.h>

@class ARCoordinate;

@interface ARToGLCoordinates : NSObject {

	Vector3D directionVec;
	ARCoordinate *arCoordinate;

}

//+(Vector3D) getGLVectorForARCoordinate:(ARCoordinate*) arCoordArg;
Vector3D getGLVectorForARCoordinate(ARCoordinate *arCoordArg);
float getGLDistanceFromGeoDistance(CLLocationDistance geoDistance, float scaling);
float getBearing(CLLocationCoordinate2D loc1, CLLocationCoordinate2D loc2);
Vector3D getGLCoordinatesFromCLLocation(CLLocation* origin, CLLocation* location);
+(CLLocation*) newCLLocationCoordinateGromGLCoordinate:(CLLocation*) origin :(Vector3D) glPosition;
+(CLLocationCoordinate2D) getMidpointCoordinateFrom:(CLLocation*) origin to:(CLLocation*) location;

@end
