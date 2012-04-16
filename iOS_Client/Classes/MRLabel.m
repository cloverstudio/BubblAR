//
//  MRLabel.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 3/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRLabel.h"
#import "WMConcreteSubject.h"
#import "CCTexture2D.h"
#import "ARToGLCoordinates.h"
#import "CocosWMBridge.h"
#import "MRDistanceLabel.h"
#import "MRSharedTextures.h"
#import "MRBubble.h"

@implementation MRLabel

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
			  andType:(int) typeArg
{
	
	if (self = [super initWithSubject:cs
							 andTitle:titleArg
					   andDescription:descriptionArg
							   andUrl:urlArg
						andCLPosition:clPositionArg 
								andID:idArg
							  andType:typeArg]) 
	{
		
		textTex = [[CCTexture2D alloc] initWithString:title
										 //  dimensions: labelSize
										//	alignment:UITextAlignmentCenter 
										   fontName: @"Arial" 
										   fontSize:14.0];
		
	
		//bgRect = CGRectMake(0, 0, 10, 10);
		float bgMargin = 2.0;
		
		textRect.size = CGSizeMake(textTex.contentSize.width / 10.0, textTex.contentSize.height / 10.0);
		bgRect = textRect;
		bgRect.size.width += bgMargin;
		bgRect.origin.x -= bgRect.size.width / 2.0;
		bgRect.origin.y -= textRect.size.height;
		bgRect.size.height += textRect.size.height;
		textRect.origin.x = bgRect.origin.x;
		textRect.origin.x += bgMargin / 2.0;
		
		origin = getGLCoordinatesFromCLLocation([[CocosWMBridge inst] currentLocation], clPosition);
		Vector3DNormalize(&origin);
		origin = Vector3DMultiplyByScalar(origin, maxDistance);
		position = origin;
		
	//bgRect.size.width += 2.0;
	//	textRect.size = labelSize;
	}
	
	return self;
}

-(CGSize) sizeForText:(NSString*) text ofFontSize:(int) fontSize
{
	
	int numLetters = [text length];
	int width = numLetters * fontSize / 2;
	int height = fontSize;
	BOOL sizeToFit = NO;
	int i;
	
	if((width != 1) && (width & (width - 1))) {
		i = 1;
		while((sizeToFit ? 2 * i : i) < width)
			i *= 2;
		width = i;
	}

	if((height != 1) && (height & (height - 1))) {
		i = 1;
		while((sizeToFit ? 2 * i : i) < height)
			i *= 2;
		height = i;
	}
	
	if (width > 1024) width = 1024;
	if (height > 1024) height = 1024;
	
	return CGSizeMake(width / 2, height);
}

-(void) updateObject
{
	
	//NSLog(@"currentPos (%f, %f)", [[CocosWMBridge inst] currentLocation].coordinate.latitude, [[CocosWMBridge inst] currentLocation].coordinate.longitude);
	//NSLog(@"labelPos (%f, %f)", clPosition.coordinate.latitude, clPosition.coordinate.longitude); 
	/*
	if (!dispose) 
	{
		origin = getGLCoordinatesFromCLLocation([[CocosWMBridge inst] currentLocation], clPosition);
		distance = 1. / Vector3DFastInverseMagnitude(origin);
		
		drawDistance = distance;
		if (drawDistance > maxDistance)
		{
			drawDistance = maxDistance;
		}
		
		Vector3DNormalize(&origin);
		origin = Vector3DMultiplyByScalar(origin, drawDistance);
		
		position = origin;
		//[self animate];
		
		

		
		[self checkTouches];
		[self resizeLabels];
	}
	 */
	
	[super updateObject];
	
	bubble.scaling = bgRect.size.width * 1.2;

}

-(void) resizeLabels
{
	
	float bgMargin = 2.0;
	textRect.origin = CGPointMake(0, 0);
	textRect.size = CGSizeMake(textTex.contentSize.width / 10.0, textTex.contentSize.height / 10.0);
	
	if (distanceLabelRect.size.width < textRect.size.width) bgRect = textRect;
	else bgRect = distanceLabelRect;
	
	bgRect.size.width += bgMargin;
	bgRect.origin.x -= bgRect.size.width / 2.0;
	bgRect.origin.y -= textRect.size.height;
	bgRect.size.height += textRect.size.height;
	textRect.origin.x = bgRect.origin.x;
	textRect.origin.x += bgMargin / 2.0;
	
}

-(void) drawObject
{
	if (!dispose) 
	{
		
		glEnable(GL_TEXTURE_2D);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		glEnable(GL_BLEND);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

		
		float azimuth = [concreteSubject getAzimuth];
		float inclination = [concreteSubject getInclination];
		
		glPushMatrix();
		
		glTranslatef(position.x, position.y, position.z);
		glRotatef(-90 - inclination, 0.0, 1.0, 0.0);
		glRotatef(-azimuth, 1.0, 0.0, 0.0);
		glRotatef(-90, 0, 0, 1);
		
		if (touched) glColor4f(1.0, 1.0, 0.0, 0.5);
		
		
		glColor4f(1.0, 1.0, 1.0, 1.0);
		
		glPopMatrix();
		
		glPushMatrix();
		
		glTranslatef(drawPosition.x, drawPosition.y, drawPosition.z);
		glRotatef(-90 - inclination, 0.0, 1.0, 0.0);
		glRotatef(-azimuth, 1.0, 0.0, 0.0);
		glRotatef(-90, 0, 0, 1);
		
		//glColor4f(0.0, 0.0, 0.0, 1.0);
		[textTex drawInRect:textRect];
		
		//getting the rect of the distance label
		distanceLabelRect = [[MRDistanceLabel sharedInstance] drawNumber: distance atOrigin: CGPointMake(textRect.origin.x, -textRect.size.height)];
		//glColor4f(1.0, 1.0, 1.0, 1.0);
		
		glPopMatrix();
		
		glDisableClientState(GL_TEXTURE_COORD_ARRAY);
		glDisable(GL_TEXTURE_2D);
		glDisable(GL_BLEND);
		
		[super drawObject];

	}

}

-(void) animate
{}

-(void) loadObject
{

}

-(void) dealloc
{
	[textTex release];
	[super dealloc];
}

@end
