//
//  MRWebView.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRWebView.h"
#import "MRObject.h"
#import "MRInfoPanelViewController.h"

@implementation MRWebView
@synthesize RVC;

-(void) dealloc
{
	[webView removeFromSuperview];
	[super dealloc];
}

-(id)initWithFrame:(CGRect)frame
{
	
	if (self = [super initWithFrame:frame]) 
	{
		webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
		
		UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		closeBtn.frame = CGRectMake(378,251,100,72);		 
		[closeBtn setBackgroundImage:[UIImage imageNamed:@"btnPanelHide.png"] forState:UIControlStateNormal];
		[closeBtn addTarget:self action:@selector(hideWebView) forControlEvents:UIControlEventTouchUpInside];
		
		[self addSubview:webView];
		[self addSubview:closeBtn];
		
		[webView release];
	}
	
	return self;
}

-(void) hideWebView
{
	[RVC hideWebView];
}

-(void) updateData
{

	NSString *urlAddress = RVC.selectedObject.url;
	NSURL *url = [NSURL URLWithString:urlAddress];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[webView loadRequest:requestObj];
	
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

-(void) removeView
{
	[self removeFromSuperview];
}

@end
