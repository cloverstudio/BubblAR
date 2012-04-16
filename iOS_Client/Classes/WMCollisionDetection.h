//
//  WMCollisionDetection.h
//  iFireWingo
//
//  Created by Marko Hlebar on 7/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMMath.h"
#import "OpenGLCommon.h"

typedef struct
{
	Vector3D o;
	Vector3D d;
}
Ray;

typedef struct
{
	Vector3D c;
	float r;
}
Sphere;

//COLLISION DETECTION OF POINT AND SQUARE OF UNDEFINED CENTER

static inline BOOL pointSquareCollision(CGPoint point, CGRect square)
{
	if((point.x >= square.origin.x && point.x <= square.origin.x + square.size.width) && 
	   (point.y >= square.origin.y && point.y <= square.origin.y + square.size.height))
		return YES;
	else return NO;
}

//COLLISION DETECTION OF POINT AND SQUARE OF DEFINED CENTER

static inline BOOL pointSquareCollision2(CGPoint point, CGPoint center, CGRect square)
{
	if((point.x >= center.x - (square.size.width / 2.0) && point.x <= center.x + (square.size.width / 2.0)) &&
	   (point.y >= center.y - (square.size.height / 2.0) && point.y <= center.y + (square.size.height / 2.0)))
		return YES;
	else return NO;
}

//COLLISION DETECTION OF POINT AND CIRCLE WITH DEFINED CENTER AND RADIUS

static inline BOOL pointCircleCollision(CGPoint point, CGPoint center, float radius)
{
	if(wmSquaredDistance(point, center) <= (radius * radius)) return YES;
	else return NO;		
}

static inline BOOL pointSphereCollisionDetection(Vector3D point, Vector3D center, float radius)
{
	if (wmSquaredDistance3D(point, center) <= (radius * radius)) return YES; 
	else return NO;
}
//COLLISION DETECTION OF POINT AND ELLIPSE WITH DEFINED CENTER AND AXES

static inline BOOL pointEllipseCollision(CGPoint point, CGPoint center, float a, float b)
{
	
	float ySquared;
	float y1Squared = (point.y * point.y);
	
	float x = point.x - center.x;
	
	ySquared = b*b - (x*x) * (b*b) / (a*a);
	
	if(y1Squared <= ySquared)
	{
		return YES;
	}
	else return NO;
}

//RAY SPHERE INTERSECTION
static inline BOOL raySphereIntersection(Ray ray, Sphere sphere)
{
	Vector3D dst = Vector3DSubtract(ray.o , sphere.c);
	float a = Vector3DDotProduct(ray.d, ray.d);
	float b = 2 * Vector3DDotProduct(dst, ray.d);
	float c = Vector3DDotProduct(dst, dst) - (sphere.r * sphere.r);
	
	//Find discriminant
    float disc = b * b - 4 * a * c;
    
    // if discriminant is negative there are no real roots, so return 
    // false as ray misses sphere
    if (disc < 0)
        return NO;
	
    // compute q as described above
    float distSqrt = sqrtf(disc);
    float q;
    if (b < 0)
        q = (-b - distSqrt)/2.0;
    else
        q = (-b + distSqrt)/2.0;
	
    // compute t0 and t1
    float t0 = q / a;
    float t1 = c / q;
	
    // make sure t0 is smaller than t1
    if (t0 > t1)
    {
        // if t0 is bigger than t1 swap them around
        float temp = t0;
        t0 = t1;
        t1 = temp;
    }
	
    // if t1 is less than zero, the object is in the ray's negative direction
    // and consequently the ray misses the sphere
    if (t1 < 0)
        return NO;
	
    // if t0 is less than zero, the intersection point is at t1
    if (t0 < 0)
    {
        return YES;
    }
    // else the intersection point is at t0
    else
    {
        return YES;
    }
}