//
//  ARToGLCoordinates.m
//  ARKitDemo
//
//  Created by marko.hlebar on 1/15/10.
//  Copyright 2010 Zac White. All rights reserved.
//

#import "ARToGLCoordinates.h"
#import "ARCoordinate.h"
#import "ARGeoCoordinate.h"
#import "ConstantsAndMacros.h"

#define SCALING 1.0;

@implementation ARToGLCoordinates

/*
 x = r sin(theta) cos(phi)
 y = r sin(theta) sin(phi)
 z = r cos(theta)	
 
 theta = inclination
 phi = azimuth 
*/

Vector3D getGLVectorForARCoordinate(ARCoordinate *arCoordArg)
{
	//float r = 1.0; //we take r as 1, because we want a directional unit vector. 
	float theta = (M_PI / 2.0) - arCoordArg.inclination;
	float phi = arCoordArg.azimuth;

	Vector3D normalVector = Vector3DMake(sinf(theta) * cosf(phi), sinf(theta) * sinf(phi), cosf(theta));
	
	return normalVector;
}

float getGLDistanceFromGeoDistance(CLLocationDistance geoDistance, float scaling)
{
	return (float)(geoDistance / scaling);	
}

/*
 var y = Math.sin(dLon) * Math.cos(lat2);
 var x = Math.cos(lat1)*Math.sin(lat2) -
 Math.sin(lat1)*Math.cos(lat2)*Math.cos(dLon);
 var brng = Math.atan2(y, x).toBrng();
 
 
 IF sin(lon2-lon1)<0       
 tc1=acos((sin(lat2)-sin(lat1)*cos(d))/(sin(d)*cos(lat1)))    
 ELSE       
 tc1=2*pi-acos((sin(lat2)-sin(lat1)*cos(d))/(sin(d)*cos(lat1)))    
 ENDIF 
 
 tc1=mod(atan2(sin(lon1-lon2)*cos(lat2),
 cos(lat1)*sin(lat2)-sin(lat1)*cos(lat2)*cos(lon1-lon2)), 2*pi)
 
*/

float getBearing(CLLocationCoordinate2D loc1, CLLocationCoordinate2D loc2)
{
	
	float bearing = 0.0;
	
	float y = sinf(loc2.longitude - loc1.longitude) * cosf(loc2.latitude);
	float x = (cosf(loc1.latitude) * sinf(loc2.latitude)) - (sinf(loc1.latitude) * cosf(loc2.latitude) * cosf(loc2.longitude - loc1.longitude));
	
	bearing = atan2f(y, x);// + 360.0;
	
	/*
	while (bearing > 360) {
		bearing -= 360.0;
	}
	*/
	return bearing;
	
}

Vector3D getGLCoordinatesFromCLLocation(CLLocation* origin, CLLocation* location)
{
	float scaling = SCALING;
	
	//NSLog(@"origin = (%f, %f)", origin.coordinate.latitude, origin.coordinate.longitude);
	//NSLog(@"location = (%f, %f)", location.coordinate.latitude, location.coordinate.longitude);
	
	float distance = getGLDistanceFromGeoDistance([origin getDistanceFrom:location], scaling);
	
	float altitude = getGLDistanceFromGeoDistance(location.altitude, scaling);
	
	float bearing = getBearing(origin.coordinate, location.coordinate);
			
	Vector3D locationVec;
	
	locationVec.x = distance * cosf(bearing);
	locationVec.y = distance * sinf(bearing);
	locationVec.z = altitude;
	
	//CLLocation *testLocation = [ARToGLCoordinates newCLLocationCoordinateGromGLCoordinate:origin :locationVec];
	
	return locationVec;
									
}

float glBearing(Vector3D loc1, Vector3D loc2)
{
	return Vector3DAngleBetweenVectorsXYAxis(loc1, loc2);
}

/*
 var lat2 = Math.asin( Math.sin(lat1)*Math.cos(d/R) + Math.cos(lat1)*Math.sin(d/R)*Math.cos(brng) );
 var lon2 = lon1 + Math.atan2(Math.sin(brng)*Math.sin(d/R)*Math.cos(lat1), Math.cos(d/R)-Math.sin(lat1)*Math.sin(lat2));
 
 lat2 = asin(sin(lat1)*cos(d/R) + cos(lat1)*sin(d/R)*cos(θ))

 */

+(CLLocationCoordinate2D) getMidpointCoordinateFrom:(CLLocation*) origin to:(CLLocation*) location
{

	CLLocationCoordinate2D originCoord = origin.coordinate;
	CLLocationCoordinate2D locationCoord = location.coordinate;
	CLLocationCoordinate2D midPoint;
	
	float lat1 = DEGREES_TO_RADIANS(originCoord.latitude);
	float lat2 = DEGREES_TO_RADIANS(locationCoord.latitude);
	
	float lon1 = DEGREES_TO_RADIANS(originCoord.longitude);
	float lon2 = DEGREES_TO_RADIANS(locationCoord.longitude);
	
	float Bx = cosf(lat2) * cosf(lon2 - lon1);
	float By = cosf(lat2) * sinf(lon2 - lon1);

	midPoint.latitude = RADIANS_TO_DEGREES(atan2f(sinf(lat1) + sinf(lat2), sqrtf((cosf(lat1) + Bx)*(cosf(lat1) + Bx) + (By*By))));
	midPoint.longitude = RADIANS_TO_DEGREES(lon1 + atan2f(By, cosf(lat1) + Bx));
	
	return midPoint;
	
}

+(CLLocation*) newCLLocationCoordinateGromGLCoordinate:(CLLocation*) origin :(Vector3D) glPosition
{
	
	float Rz = 6378137; //m
	
	float scaling = SCALING;
	
	float bearing = 2* M_PI - glBearing(glPosition,Vector3DMake(1,0,0));
	float distance = Vector3DMagnitude(glPosition) * scaling;
		
	float lat1 = DEGREES_TO_RADIANS(origin.coordinate.latitude);
	
	float latitude = asinf(sinf(lat1) * cosf(distance / Rz) + cosf(lat1) * sinf(distance/Rz) * cosf(bearing));
	float longitude = origin.coordinate.longitude + RADIANS_TO_DEGREES(atan2f(sinf(bearing) * sinf(distance / Rz) * cosf(lat1), cosf(distance / Rz) - sinf(lat1) * sinf(latitude)));
	
	latitude = RADIANS_TO_DEGREES(latitude);
	
	CLLocation *tempLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];

	return tempLocation;
}

@end
