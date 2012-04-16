//
//  MRAnnotation.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface MRPlacemark : NSObject <MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(id)initWithCoordinate:(CLLocationCoordinate2D) coordinateArg andTitle:(NSString*) titleArg andSubtitle:(NSString*) subtitleArg;

-(NSString*) title;
-(NSString*) subtitle;

@end