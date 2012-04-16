//
//  MRPolisInfoView.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRPolisInfoView.h"
#import "ConstantsAndMacros.h"
#import "MRPolis.h"
#import "MRRootViewController.h"
#import "MRObjectManager.h"
#import "MRObjectDrawingManager.h"
#import <QuartzCore/QuartzCore.h>


#define IMAGE_RECT CGRectMake(0, 0, 128, 128)
#define LABEL_RECT CGRectMake(140, 0, 160, 40)
#define TEXTVIEW_RECT CGRectMake(140, 40, 160, 300)

@implementation MRPolisInfoView

-(id) initWithRVC:(MRRootViewController *)rvcArg
{
	if (self = [super init]) {
		
		
		if ([[MRPolisManager sharedInstance] polisType] == POLIS_TYPE_USER) 
		{
			[[MRPolisManager sharedInstance] startDownload:[MRPolisManager sharedInstance].userPolisURL];
		}
		[[MRPolisManager sharedInstance] addListener:self];
		
		RVC = rvcArg;
		
		UIImageView *tempView = [[UIImageView alloc] initWithFrame:IPHONE_SCREEN_LANDSCAPE_RECT];
		tempView.image = [UIImage imageNamed:@"polisInfoBG.png"];
		tempView.alpha = 0.0;
		tempView.userInteractionEnabled = YES;
		tempView.multipleTouchEnabled = YES;
		self.view = tempView;
		[tempView release];
		
		scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(80, 50, 300, 200)];
		scrollView.pagingEnabled = NO;
		scrollView.contentSize = CGSizeMake(300, 340);
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.showsVerticalScrollIndicator = YES;
		scrollView.scrollsToTop = YES;	
		scrollView.delegate = self;
		
		[self.view addSubview:scrollView];
		
		MRPolis *polis = [[MRPolisManager sharedInstance] polis];
		//image view
		imageView = [[UIImageView alloc] initWithFrame:IMAGE_RECT];
		UIImage *tempImage = [[UIImage alloc] initWithData: [NSData dataWithContentsOfURL:polis.imageUrl]];
		imageView.image = tempImage;
		imageView.layer.masksToBounds = YES;
		imageView.layer.cornerRadius = 20.0;
		[tempImage release];
		[scrollView addSubview:imageView];
		[imageView release];
		
		//title label
		titleLabel = [[UILabel alloc] initWithFrame:LABEL_RECT];
		titleLabel.text = polis.title;
		titleLabel.adjustsFontSizeToFitWidth = YES;
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.textColor = UICOLOR_DARKBLUE;
		titleLabel.font = [UIFont boldSystemFontOfSize:25];
		[scrollView addSubview:titleLabel];
		[titleLabel release];
		
		//description text
		descriptionTextView = [[UITextView alloc] initWithFrame:TEXTVIEW_RECT];
		descriptionTextView.backgroundColor = [UIColor clearColor];
		descriptionTextView.textColor = UICOLOR_DARKBLUE;
		descriptionTextView.font = [UIFont boldSystemFontOfSize:14];
		descriptionTextView.editable = NO;
		descriptionTextView.text = polis.description;
		[scrollView addSubview:descriptionTextView];
		[descriptionTextView release];
		
		[scrollView release];
		
		bubbleInButton = [UIButton buttonWithType:UIButtonTypeCustom];
		bubbleInButton.frame = CGRectMake(357,257, 126, 69);	//change
		[bubbleInButton setBackgroundImage: [UIImage imageNamed:@"btnBubbleIn.png"] forState:UIControlStateNormal];
		[bubbleInButton addTarget: self action:@selector(btnPressed) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:bubbleInButton];
		
		cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
		cancelButton.frame = CGRectMake(0,257, 121, 61);	//change
		[cancelButton setBackgroundImage: [UIImage imageNamed:@"btnCancel.png"] forState:UIControlStateNormal];
		[cancelButton addTarget: self action:@selector(btnCancelPressed) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:cancelButton];
		
	}

	return self;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return NO;
}
 */


-(void) updateData
{
	//in case data arrived too slow...
	MRPolis *polis = [[MRPolisManager sharedInstance] polis];
	UIImage *tempImage = [[UIImage alloc] initWithData: [NSData dataWithContentsOfURL:polis.imageUrl]];
	imageView.image = tempImage;
	titleLabel.text = polis.title;
	descriptionTextView.text = polis.description;
	[tempImage release];
	
}

-(void) downloadError
{
	
	[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];

	//in case polis manager had a download error
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Download Error!"
														message:@"Check your polis URL and internet connection." 
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
	
	[alertView show];
	[alertView release];
	
	[RVC changeView:BB_CHANNEL_TABLE_VIEW];
	
}

-(void) btnCancelPressed
{
	[RVC changeView:BB_CHANNEL_TABLE_VIEW];
}

-(void) btnPressed
{
	[[MRObjectManager sharedInstance] setChangeViewAllowed:YES];
	[[MRPolisManager sharedInstance] setIsPolisSelected:YES];
	[[MRObjectManager sharedInstance] start];
	[[MRObjectManager sharedInstance] startDownload];
	[[MRObjectDrawingManager sharedInstance] start];

	
	//[[MRObjectManager sharedInstance] start];
	cancelButton.hidden = YES;
	bubbleInButton.hidden = YES;
	[RVC addActivity];
	//[RVC.activityIndicatorView startAnimating];
	
	//[RVC changeView:BB_INFO_PANEL_VIEW];
}




-(void) slideOut
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(doneAnimatingOut)];
	
	//CGAffineTransform translate = CGAffineTransformMakeTranslation(0, 320);
	//[self.view setTransform:translate];
	[self.view setAlpha:0.0];
	[UIView commitAnimations];
}

-(void) slideIn
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationDelegate:self];	
	//CGAffineTransform translate = CGAffineTransformMakeTranslation(0, 320);
	//[self.view setTransform:translate];
	[self.view setAlpha:1.0];
	[UIView commitAnimations];
}

-(void) doneAnimatingOut
{
	[RVC removeActivity];
	[RVC switchView];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void) cleanup
{
	[[MRPolisManager sharedInstance] removeListener:self];
}


- (void)dealloc {
    [super dealloc];
}


@end
