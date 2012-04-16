//
//  MRRadarPOI.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRRadarPOI.h"
#import "OpenGLCommon.h"
#import "MRSharedTextures.h" 
#import "CCTexture2D.h"
#import "MRObject.h"
#import "WMConcreteSubject.h"

@implementation MRRadarPOI
@synthesize concreteSubject;
@synthesize mrObject;

-(id) initWithSubject:(WMConcreteSubject*) subject andObject:(MRObject*) object;
{
	if (self = [super init]) {
		concreteSubject = subject;
		mrObject = object;
		NSString *poiTexName = [NSString stringWithFormat:@"radar_%d.png", mrObject.type];
		
		poiTexRect = CGRectMake(0, 0, 20, 20);
		position.y = 10.0;
		
		[[MRSharedTextures sharedInstance] addTextureWithName:poiTexName];
		poiSharedTex = [[MRSharedTextures sharedInstance] getTextureForName:poiTexName];
		
	}
	return self;
}

-(void) update
{
	
	Vector3D cameraDirection = [concreteSubject getCameraDirection];
	Vector3D objectPosition = mrObject.position;
	Vector3DNormalize(&objectPosition);
	
	float angleCamera = atan2f(cameraDirection.y, cameraDirection.x);
	float angleObject = atan2f(objectPosition.y, objectPosition.x);
	
	float angle = angleCamera - angleObject;
	
	position.x = (angle / (2.0 * M_PI) * 480.0) + 240.0;
	if (position.x > 480.0) 
	{
		position.x -= 480.0;
	}
	else if (position.x < 0.0)
	{
		position.x += 480.0;
	}
	
}

-(void) cleanup
{}

//Radar (radarPOI manager) should enable 2d drawing. 
-(void) draw
{
	
	glPushMatrix();
	
	glTranslatef(position.x - poiTexRect.size.width / 2.0, position.y - poiTexRect.size.height / 2.0, 0.0);
	
	[poiSharedTex drawInRect:poiTexRect];
	
	glPopMatrix();
}


@end
