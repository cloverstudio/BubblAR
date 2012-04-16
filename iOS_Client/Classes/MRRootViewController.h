//
//  MRRootViewController.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum 
{
	BB_LOADING_VIEW,
	BB_CHANNEL_TABLE_VIEW,
	BB_POLIS_INFO_VIEW,
	BB_INFO_PANEL_VIEW,
	BB_BUBBLE_OUT_VIEW,
	BB_MAP_VIEW
} MR_VIEW;

@class MRViewController;
@class EAGLView;

@interface MRRootViewController : UIViewController 
{
	
	int currentView;
	MRViewController *currentViewController;	
	UIActivityIndicatorView *activityIndicatorView;	
	int activitiesInProgress;
	NSTimer *loadingTimer;

	EAGLView *glView;
}

@property (nonatomic, assign) EAGLView *glView;
@property (nonatomic, assign) UIActivityIndicatorView *activityIndicatorView;	
@property (nonatomic, assign) MRViewController *currentViewController;
-(void) addActivity;
-(void) removeActivity;

-(void) changeView:(int) currentViewArg;
-(void) removeView;
-(void) switchView;

@end
