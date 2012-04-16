//
//  MRInfoView.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRInfoView.h"
#import "MRInfoPanelViewController.h"
#import "MRObject.h"
#import "ConstantsAndMacros.h"

@implementation MRInfoView
@synthesize RVC;

#define PANEL_BACK_FRAME CGRectMake(0,0,353,320)

-(id) initWithFrame:(CGRect)frame
{
	
	if (self = [super initWithFrame:frame]) 
	{
		backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"panelBG.png"]];
		backgroundView.frame = CGRectMake(0, 0, 353, 320);
		backgroundView.userInteractionEnabled = YES;
		backgroundView.multipleTouchEnabled = YES;
		[self insertSubview:backgroundView atIndex:0];
		[backgroundView release];

		labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(140,10,180,30)];
		labelTitle.text = @"text";
		labelTitle.adjustsFontSizeToFitWidth = YES;
		labelTitle.backgroundColor = [UIColor clearColor];
		labelTitle.textColor = UICOLOR_DARKBLUE;
		labelTitle.font = [UIFont boldSystemFontOfSize:25];
		[backgroundView addSubview:labelTitle];
		[labelTitle release];
		
		descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(140,40,180,200)];
		descriptionTextView.backgroundColor = [UIColor clearColor];
		//descriptionTextView.textColor = [UIColor whiteColor];
		descriptionTextView.textColor = UICOLOR_DARKBLUE;
		descriptionTextView.font = [UIFont boldSystemFontOfSize:12];
		descriptionTextView.editable = NO;
		[backgroundView addSubview:descriptionTextView];
		[descriptionTextView release];
		
		webBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		webBtn.frame = CGRectMake(47,234,100,89);		 
		[webBtn setBackgroundImage:[UIImage imageNamed:@"btnWeb.png"] forState:UIControlStateNormal];
		[webBtn addTarget:self action:@selector(showWebView) forControlEvents:UIControlEventTouchUpInside];
		[backgroundView addSubview:webBtn];
		
		mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		mapBtn.frame = CGRectMake(145,239,100,88);		 
		[mapBtn setBackgroundImage:[UIImage imageNamed:@"btnMap.png"] forState:UIControlStateNormal];
		[mapBtn addTarget:self action:@selector(showMapView) forControlEvents:UIControlEventTouchUpInside];
		[backgroundView addSubview:mapBtn];		
		
		closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		closeBtn.frame = CGRectMake(251,251,100,72);		 
		[closeBtn setBackgroundImage:[UIImage imageNamed:@"btnPanelHide.png"] forState:UIControlStateNormal];
		[closeBtn addTarget:self action:@selector(hideInfoView) forControlEvents:UIControlEventTouchUpInside];
		[backgroundView addSubview:closeBtn];
		
	}
	
	return self;
}

-(void) slideIn
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	
	CGAffineTransform translate = CGAffineTransformMakeTranslation(-backgroundView.frame.size.width, 0);
	[self setTransform:translate];
	[UIView commitAnimations];
}

-(void) updateData
{
	labelTitle.text = RVC.selectedObject.title;
	descriptionTextView.text = RVC.selectedObject.description;
	if ([RVC.selectedObject.url isEqualToString:@""]) webBtn.hidden = YES;
	else webBtn.hidden = NO;
}

-(void) hideInfoView
{
	[RVC.selectedObject reset];
	[RVC hideInfoView];
}

-(void) showWebView
{
	[RVC showWebView];
}

-(void) showMapView
{
	[RVC showMapView];
}

-(void) slideOut
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeView)];
	
	CGAffineTransform translate = CGAffineTransformMakeTranslation(backgroundView.frame.size.width, 0);
	[self setTransform:translate];
	[UIView commitAnimations];
}

-(void) removeView
{
	[self removeFromSuperview];
}

-(void) dealloc
{
	[super dealloc];
}

@end
