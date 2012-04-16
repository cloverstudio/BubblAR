//
//  MRMapView.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRMapView.h"
#import "CocosWMBridge.h"
#import "ARToGLCoordinates.h"
#import "MRPlacemark.h" 
#import "MRInfoPanelViewController.h"
#import "MRObject.h"

@implementation MRMapView
@synthesize RVC;

-(id) initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) 
	{
	
		mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,0,480,320)];
		//mapView.showsUserLocation = YES;
		mapView.scrollEnabled = YES;
		mapView.zoomEnabled = YES;
		mapView.delegate = self;
	
		/*
		UIButton *mapCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom]; 
		[mapCloseBtn setFrame:CGRectMake(460, 0, 20, 320)];
		[mapCloseBtn setBackgroundImage:[UIImage imageNamed:@"btnCloseWeb.png"] forState:UIControlStateNormal];
		[mapCloseBtn addTarget:self action:@selector(hideMapView) forControlEvents:UIControlEventTouchUpInside];
		*/
		
		UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		closeBtn.frame = CGRectMake(378,251,100,72);		 
		[closeBtn setBackgroundImage:[UIImage imageNamed:@"btnPanelHide.png"] forState:UIControlStateNormal];
		[closeBtn addTarget:self action:@selector(hideMapView) forControlEvents:UIControlEventTouchUpInside];
		
		[self addSubview:mapView];
		[self addSubview:closeBtn];
		
		[mapView release];
		//[mapCloseBtn release];
	}
	
	return self;
}

-(void) hideMapView
{
	[RVC hideMapView];
}

-(void) slideIn
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	
	CGAffineTransform translate = CGAffineTransformMakeTranslation(0, -320);
	[self setTransform:translate];
	[UIView commitAnimations];
}

-(void) slideOut
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeView)];
	
	CGAffineTransform translate = CGAffineTransformMakeTranslation(0, 320);
	[self setTransform:translate];

	[UIView commitAnimations];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	
	MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
	[pin setCanShowCallout:YES];
	[pin setAnimatesDrop:YES];
	[pin setEnabled:YES];
	
	if ([annotation isEqual: originPlacemark]) [pin setPinColor: MKPinAnnotationColorGreen];
	else [pin setPinColor: MKPinAnnotationColorRed];
	
	return [pin autorelease];
}

-(void) updateData
{
	
	CLLocation *selectedLocation = RVC.selectedObject.clPosition;
	NSString *selectedTitle = RVC.selectedObject.title;
	
	MKCoordinateRegion region;
	
	CLLocationDistance distance = [[[CocosWMBridge inst] currentLocation] getDistanceFrom:selectedLocation];
	CLLocationCoordinate2D midPoint = [ARToGLCoordinates getMidpointCoordinateFrom:[[CocosWMBridge inst] currentLocation] to:selectedLocation];
	
	//distance *= 2.0;
	
	region = MKCoordinateRegionMakeWithDistance(midPoint, distance, distance);
	
	[mapView setRegion:region animated:NO];
	[mapView regionThatFits:region];
	
	MRPlacemark *objectPlacemark = [[MRPlacemark alloc] initWithCoordinate:selectedLocation.coordinate andTitle: selectedTitle andSubtitle: @""]; 
	originPlacemark = [[MRPlacemark alloc] initWithCoordinate:[[CocosWMBridge inst] currentLocation].coordinate andTitle:@"You are here." andSubtitle:@""]; 
	
	
	[mapView addAnnotation:objectPlacemark];
	[mapView addAnnotation:originPlacemark];
	
	[objectPlacemark release];
	[originPlacemark release];
	 
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{

}

-(void) removeView
{
	[self removeFromSuperview];
}

-(void) dealloc
{
	[mapView removeFromSuperview];
	[super dealloc];
}

@end
