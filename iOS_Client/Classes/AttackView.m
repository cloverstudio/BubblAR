//
//  AttackView.m
//  AirRaidBeta
//
//  Created by ken yasue on 3/9/10.
//  Copyright 2010 clover studio. All rights reserved.
//

#import "AttackView.h"
#import "CocosWMBridge.h"
#import "CSMapAnnotation.h"
#import "CSImageAnnotationView.h"

@implementation AttackView

-(void) dealloc
{
	
	[mkMapView release];
	[selfBasePosition release];
	[slider release];
	[btnBack release];
	[btnAttack release];
	[backgroundView release];
	[markerView release];
	[labelLatitude release];
	[labelLongitude release];
	[labelLatitudeValue release];
	[labelLongitudeValue release];
	[labelAttacks release];
	[labelAttacksValue release];
	
	[super dealloc];
}

-(id) initWithFrame:(CGRect) frameRect{
	
	self = [super initWithFrame:frameRect];
	
	if(self){
		
		//CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(0.5 * M_PI);
		//landscapeTransform = CGAffineTransformTranslate (landscapeTransform,-80,80);
		//[self setTransform:landscapeTransform];
		
		backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UIBackground.png"]];
		[self insertSubview:backgroundView atIndex:0];
		//[backgroundView release];
		
		markerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"marker_map.png"]];
		markerView.frame = CGRectMake(155, 115, 50, 50);
		[self insertSubview:markerView atIndex:10];
		//[markerView release];
		
		mkMapView = [[MKMapView alloc] initWithFrame:CGRectMake(10,10,320,240)];
		mkMapView.scrollEnabled = YES;
		mkMapView.zoomEnabled = YES;
		mkMapView.delegate = self;
		[self insertSubview:mkMapView atIndex:1];
	//	[mkMapView release];
		
		slider = [[UISlider alloc] initWithFrame:CGRectMake(10,260,320,50)];
		slider.minimumValue = 1;
		slider.maximumValue = 10;
		[slider addTarget:self action:@selector(onSliderVange) forControlEvents:UIControlEventValueChanged];
		[self insertSubview:slider atIndex:1];
		[self updateLocation];
		//[slider release];
	
		btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
		btnBack.frame = CGRectMake(360,220,89,42);		 
		[btnBack setBackgroundImage:[UIImage imageNamed:@"uibtn_cancel.png"] forState:UIControlStateNormal];
		[btnBack addTarget:self action:@selector(onClose) forControlEvents:UIControlEventTouchUpInside];
		[self insertSubview:btnBack atIndex:2];
		//[btnBack release];
		
		btnAttack = [UIButton buttonWithType:UIButtonTypeCustom];
		btnAttack.frame = CGRectMake(363,270,89,42);		 
		[btnAttack setBackgroundImage:[UIImage imageNamed:@"uibtn_attack.png"] forState:UIControlStateNormal];
		[btnAttack addTarget:self action:@selector(onAttack) forControlEvents:UIControlEventTouchUpInside];
		[self insertSubview:btnAttack atIndex:2];
		//[btnAttack release];
		
		
		labelLatitude = [[UILabel alloc] initWithFrame:CGRectMake(340,10,120,30)];
		labelLatitude.text = @"Latitude";
		labelLatitude.backgroundColor = [UIColor clearColor];
		[self insertSubview:labelLatitude atIndex:2];
		//[labelLatitude release];
		
		labelLatitudeValue = [[UILabel alloc] initWithFrame:CGRectMake(340,30,120,30)];
		labelLatitudeValue.text = @"";
		labelLatitudeValue.textAlignment = UITextAlignmentRight;
		labelLatitudeValue.backgroundColor = [UIColor clearColor];
		[self insertSubview:labelLatitudeValue atIndex:2];		
		//[labelLatitudeValue release];
		
		labelLongitude = [[UILabel alloc] initWithFrame:CGRectMake(340,60,120,30)];
		labelLongitude.text = @"Longitude";
		labelLongitude.backgroundColor = [UIColor clearColor];
		[self insertSubview:labelLongitude atIndex:2];
		//[labelLongitude release];
		
		labelLongitudeValue = [[UILabel alloc] initWithFrame:CGRectMake(340,80,120,30)];
		labelLongitudeValue.text = @"";
		labelLongitudeValue.textAlignment = UITextAlignmentRight;
		labelLongitudeValue.backgroundColor = [UIColor clearColor];
		[self insertSubview:labelLongitudeValue atIndex:2];	
	//	[labelLongitudeValue release];
		
		labelAttacks = [[UILabel alloc] initWithFrame:CGRectMake(340,110,120,30)];
		labelAttacks.text = @"Attacks";
		labelAttacks.backgroundColor = [UIColor clearColor];
		[self insertSubview:labelAttacks atIndex:2];
	//	[labelAttacks release];
		
		labelAttacksValue = [[UILabel alloc] initWithFrame:CGRectMake(340,130,120,30)];
		labelAttacksValue.text = @"000";
		labelAttacksValue.textAlignment = UITextAlignmentRight;
		labelAttacksValue.backgroundColor = [UIColor clearColor];
		[self insertSubview:labelAttacksValue atIndex:2];
	//	[labelAttacksValue release];
	}
	
	return self;
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{

	if([annotation title]==@"Your Base")
	{
		CSMapAnnotation *csannotation = (CSMapAnnotation *) annotation;
		[csannotation setUserData:@"customAnnotationBlue.png"];
		CSImageAnnotationView *imageAnnotationView = [[[CSImageAnnotationView alloc] initWithAnnotation:csannotation reuseIdentifier:@"Image"] autorelease];	
		return imageAnnotationView;
	}
	else
	{
		CSMapAnnotation *csannotation = (CSMapAnnotation *) annotation;
		[csannotation setUserData:@"customAnnotationRed.png"];
		CSImageAnnotationView *imageAnnotationView = [[[CSImageAnnotationView alloc] initWithAnnotation:csannotation reuseIdentifier:@"Image"] autorelease];
		 return imageAnnotationView;
	}

}

-(void)showUp{
	
	//アニメーションの対象となるコンテキスト
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	//アニメーションを実行する時間
	[UIView setAnimationDuration:0.5];
	//アニメーションイベントを受け取るview
	[UIView setAnimationDelegate:self];
	//アニメーション終了後に実行される
	//[self setAnimationDidStopSelector:@selector(endAnimation)];
	
	//TODO:
	CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(0.5 * M_PI);
	landscapeTransform = CGAffineTransformTranslate (landscapeTransform,0,-240);
	[self setTransform:landscapeTransform];
	
	// アニメーション開始
	[UIView commitAnimations];	
}

-(void)hide{
	
	//アニメーションの対象となるコンテキスト
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	//アニメーションを実行する時間
	[UIView setAnimationDuration:0.5];
	//アニメーションイベントを受け取るview
	[UIView setAnimationDelegate:self];
	//アニメーション終了後に実行される
	[UIView setAnimationDidStopSelector:@selector(onFinish:)];
	
	//TODO:
	CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(0.5 * M_PI);
	landscapeTransform = CGAffineTransformTranslate (landscapeTransform,0,165);
	[self setTransform:landscapeTransform];
	
	// アニメーション開始
	[UIView commitAnimations];	
}

-(void)onFinish:(id)sender{
	
	[self removeFromSuperview];
	
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{

	labelLatitudeValue.text = [NSString stringWithFormat:@"%3.3lf",mapView.centerCoordinate.latitude];
	labelLongitudeValue.text = [NSString stringWithFormat:@"%3.3lf",mapView.centerCoordinate.longitude];
	
}

-(void) updateLocation{
	
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta=0.5; // zoom level
	span.longitudeDelta=0.5;
	
	region.span=span;
	region.center=[CocosWMBridge inst].currentLocation.coordinate;
	
	[mkMapView setRegion:region animated:NO];
	[mkMapView regionThatFits:region];
	
	
	CSMapAnnotation *annotation = [[[CSMapAnnotation alloc] initWithCoordinate:[CocosWMBridge inst].initialLocation.coordinate
											   annotationType:CSMapAnnotationTypeImage
														title:@"Your Base"] autorelease];
	[annotation setUserData:@"customAnnotationBlue.png"];
	
	[mkMapView addAnnotation:annotation];
	
	
	CSMapAnnotation *annotation2 = [[[CSMapAnnotation alloc] initWithCoordinate:[CocosWMBridge inst].enemyLocation.coordinate
																annotationType:CSMapAnnotationTypeImage
																		 title:@"Enemy Base"] autorelease];
	[annotation2 setUserData:@"customAnnotationRed.png"];
	
	[mkMapView addAnnotation:annotation2];
}

-(void) onClose{
	
	[self hide];
	
}

-(void) onAttack{
	
	int number = (int) slider.value;
	
	CLLocation *coodinate = [[CLLocation alloc] initWithLatitude:mkMapView.centerCoordinate.latitude
													  longitude:mkMapView.centerCoordinate.longitude];
	
	[[CocosWMBridge inst] sendAttackWithUnits:1	andNumber:number andCoordinate:coodinate];
	
	[coodinate release];
	
	
	[self hide];
	
}


-(void) onSliderVange{
	
	labelAttacksValue.text = [NSString stringWithFormat:@"%03.0f",slider.value];
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	NSLog(@"test");
	
}

@end



@implementation SelfPlaceMark

@synthesize coordinate;

- (NSString *)subtitle{
	return @"";
}
- (NSString *)title{
	return @"Your Base";
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	return self;
}

@end


@implementation EnemyPlaceMark

@synthesize coordinate;

- (NSString *)subtitle{
	return @"";
}
- (NSString *)title{
	return @"Enemy Base";
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	return self;
}

@end


