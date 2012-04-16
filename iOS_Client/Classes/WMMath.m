//
//  WMMath.m
//  openglTestViews
//
//  Created by Marko Hlebar on 5/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WMMath.h"


@implementation WMMath

float wmAbs(float n)
{
	
	
	if (n >= 0) {
		return n;
	}
	else return -n;
}

int wmSign(float n)
{
	if(n >=0)
		return 1;
	else return -1;
}

CGPoint wmUnitVector(double angle)
{
	CGPoint u;
	u.x = (float)cos(angle);
	u.y = (float)sin(angle);
	
	return u;
}

double wmCalculateHorizonAngle(CGPoint v)
{
	if(v.x != 0 && v.y !=0)
		return atan2(v.y, v.x);
	else return 0;
}

double wmCalculateHorizonAngle3D(Vector3D v)
{
	if(v.x != 0 && v.y !=0)
		return atan2(v.y, v.x);
	else return 0;
}

float wmAbsVelocity(CGPoint v)
{
	return (float)sqrt(v.x*v.x + v.y*v.y);
}

float wmSquaredDistance(CGPoint a, CGPoint b)
{
	return ((b.x - a.x) * (b.x - a.x)) + ((b.y - a.y) * (b.y - a.y));
}

float wmSquaredDistance3D(Vector3D a, Vector3D b)
{	
	return ((b.x - a.x) * (b.x - a.x)) + ((b.y - a.y) * (b.y - a.y)) + ((b.z - a.z) * (b.z - a.z));
}

@end
