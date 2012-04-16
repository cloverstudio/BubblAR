//
//  WMMath.h
//  openglTestViews
//
//  Created by Marko Hlebar on 5/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <math.h>
#import "OpenGLCommon.h"

//WMMath contains some useful math operations in 2d

@interface WMMath : NSObject {

	
}


//return absolute value of a number 
float wmAbs(float n);

//return sign of the given float
int wmSign(float n);

//returns a 2D unit vector for a given angle
CGPoint wmUnitVector(double angle);

//returns the angle from positive x axis in 2D
double wmCalculateHorizonAngle(CGPoint v);
double wmCalculateHorizonAngle3D(Vector3D v);

//returns absolute value for a given 2D vector
float wmAbsVelocity(CGPoint v);

//returns squared distance between two points;
float wmSquaredDistance(CGPoint a, CGPoint b);

//
float wmSquaredDistance3D(Vector3D a, Vector3D b);

@end
