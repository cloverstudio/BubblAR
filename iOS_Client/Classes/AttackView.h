//
//  AttackView.h
//  AirRaidBeta
//
//  Created by ken yasue on 3/9/10.
//  Copyright 2010 clover studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AttackView : UIView <MKMapViewDelegate>{
	
	MKMapView *mkMapView;
	MKPlacemark *selfBasePosition;
	
	UISlider *slider;
	UIButton *btnBack,*btnAttack;
	UIImageView *backgroundView;
	UIImageView	*markerView;
	
	UILabel		*labelLatitude,*labelLongitude,*labelLatitudeValue,*labelLongitudeValue;
	UILabel		*labelAttacks,*labelAttacksValue;
}

-(void) updateLocation;
-(void) showUp;
@end


@interface SelfPlaceMark : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
-(id)initWithCoordinate:(CLLocationCoordinate2D) coordinate;
- (NSString *)subtitle;
- (NSString *)title;

@end


@interface EnemyPlaceMark : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
-(id)initWithCoordinate:(CLLocationCoordinate2D) coordinate;
- (NSString *)subtitle;
- (NSString *)title;

@end
