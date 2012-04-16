//
//  MRBubbleOutViewController.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRBubbleOutViewController.h"
#import "MRRootViewController.h" 
#import "ConstantsAndMacros.h"
#import "MRObjectManager.h"
#import "MRObjectDrawingManager.h"
#import "MRObjectGroupManager.h"
#import "MRObjectTouchesManager.h"
#import "MRSharedModels.h"
#import "MRSharedTextures.h"

@implementation MRBubbleOutViewController
@synthesize PVC;

-(id) initWithRVC:(MRRootViewController*) rvcArg
{
	
	if (self = [super init]) 
	{		
		RVC = rvcArg;
		
		lastComment = [[NSMutableString alloc] initWithString:@""];
		commentAdded = NO;	
		
		UIImageView *tempView = [[UIImageView alloc] initWithFrame:IPHONE_SCREEN_LANDSCAPE_RECT];
		tempView.image = [UIImage imageNamed:@"polisInfoBG.png"];
		tempView.alpha = 0.0;
		tempView.userInteractionEnabled = YES;
		tempView.multipleTouchEnabled = YES;
		self.view = tempView;
		[tempView release];	
		
		btnMap = [UIButton buttonWithType:UIButtonTypeCustom];
		btnMap.frame = CGRectMake(145, 5, 100, 88);
		[btnMap setBackgroundImage:[UIImage imageNamed:@"btnMap.png"] forState:UIControlStateNormal];
		[btnMap addTarget:self action:@selector(btnMapPressed) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:btnMap];
		
		btnFeedback = [UIButton buttonWithType:UIButtonTypeCustom];
		btnFeedback.frame = CGRectMake(155,90, 186, 61);	//change
		[btnFeedback setBackgroundImage: [UIImage imageNamed:@"btnFeedback.png"] forState:UIControlStateNormal];
		[btnFeedback addTarget: self action:@selector(btnFeedbackPressed) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:btnFeedback];
		
		btnBubbleOut = [UIButton buttonWithType:UIButtonTypeCustom];
		btnBubbleOut.frame = CGRectMake(174,160, 136, 72);	//change
		[btnBubbleOut setBackgroundImage: [UIImage imageNamed:@"btnBubbleOut.png"] forState:UIControlStateNormal];
		[btnBubbleOut addTarget: self action:@selector(btnBubbleOutPressed) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:btnBubbleOut];
		
		btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
		btnCancel.frame = CGRectMake(180,240, 121, 61);	//change
		[btnCancel setBackgroundImage: [UIImage imageNamed:@"btnCancel.png"] forState:UIControlStateNormal];
		[btnCancel addTarget: self action:@selector(btnCancelPressed) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:btnCancel];
		
		btnCancel2 = [UIButton buttonWithType:UIButtonTypeCustom];
		btnCancel2.frame = CGRectMake(0,257, 121, 61);	//change
		[btnCancel2 setBackgroundImage: [UIImage imageNamed:@"btnCancel.png"] forState:UIControlStateNormal];
		[btnCancel2 addTarget: self action:@selector(btnCancel2Pressed) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:btnCancel2];
		btnCancel2.alpha = 0.0;
		
		btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
		btnSubmit.frame = CGRectMake(357,257, 123, 57);	//change
		[btnSubmit setBackgroundImage: [UIImage imageNamed:@"btnSubmit.png"] forState:UIControlStateNormal];
		[btnSubmit addTarget: self action:@selector(btnSubmitPressed) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:btnSubmit];
		btnSubmit.alpha = 0.0;
		
		feedbackText = [[UITextView alloc] initWithFrame:CGRectMake(100,80,280,100)];
		feedbackText.backgroundColor = [UIColor clearColor];
		feedbackText.delegate = self;
		//descriptionTextView.textColor = [UIColor whiteColor];
		feedbackText.text = NSLocalizedString(@"addComment",@"");
		feedbackText.textColor = UICOLOR_DARKBLUE;
		feedbackText.font = [UIFont boldSystemFontOfSize:16];
		feedbackText.editable = YES;
		feedbackText.alpha = 0.0;
 		[self.view addSubview:feedbackText];
		[feedbackText release];
		
	}
	return self;
}

-(id) initWithRVC:(MRRootViewController*) rvcArg parentVC:(MRViewController*)  pvcArg 
{
	modal = YES;
	
	if (self = [self initWithRVC:rvcArg]) 
	{
		PVC = pvcArg;
	}
	
	return self;
}

- (void) btnMapPressed
{
	if (!modal) 
	{
		[RVC changeView:BB_MAP_VIEW]; 
	}
	else 
	{
		[PVC hideModal];
		[RVC changeView:BB_INFO_PANEL_VIEW];
	}

}

- (void)textViewDidChange:(UITextView *)textView
{
	if (textView.text.length > 0)
	{
		NSRange range = NSMakeRange(textView.text.length - 1, 1);
		[textView scrollRangeToVisible:range];
	}
}

- (void)textViewDidBeginEditing:(UITextView *)textView 
{
	commentAdded = YES;
	textView.text = @"";
}

//dismissing keyboard.
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
		return FALSE;
    }
    return TRUE;
}

-(void) fadeToFeedback
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationDelegate:self];
	
	[btnMap setAlpha:0.0];
	[btnFeedback setAlpha:0.0];
	[btnCancel setAlpha:0.0];
	[btnBubbleOut setAlpha:0.0];
	[btnCancel2 setAlpha:1.0];
	[btnSubmit setAlpha:1.0];
	[feedbackText setAlpha:1.0];

	[UIView commitAnimations];
}

-(void) fadeToMenu
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationDelegate:self];	

	[btnMap setAlpha:1.0];
	[btnFeedback setAlpha:1.0];
	[btnCancel setAlpha:1.0];
	[btnBubbleOut setAlpha:1.0];
	[btnCancel2 setAlpha:0.0];
	[btnSubmit setAlpha:0.0];
	[feedbackText setAlpha:0.0];
	
	[UIView commitAnimations];
}

-(void) btnFeedbackPressed
{
	[self fadeToFeedback];
}

-(void) btnSubmitPressed
{
	
	if ([feedbackText.text isEqualToString:@""] || commentAdded == NO) 
	{
		[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"emptyComment", @"") 
														message:NSLocalizedString(@"emptyCommentDesc",@"") 
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"ok", @"")
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		alert = nil;
	}
	else if([feedbackText.text isEqualToString:lastComment])
	{
		[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"sameComment", @"") 
														message:NSLocalizedString(@"sameCommentDesc", @"")
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"ok", @"")
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		alert = nil;
	}
	else 
	{		
		commentHandled = NO;
		
		NSString *encodedString = [feedbackText.text stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
		
		NSString *strUrl = [NSString stringWithFormat:@"http://www.bubblar.com/feedbackapi.php?msg=%@", encodedString];
		
		[[HttpReader getInstance] readUrl:[NSURL URLWithString:strUrl]
								 encoding:NSUTF8StringEncoding 
								 delegate:self];
	}
}

- (void)dataReceived:(NSData *)data
{
	
	[RVC removeActivity];	
	
	NSString *tempData = [[NSString alloc ] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
	NSArray *listOfItems = [NSArray arrayWithArray:[tempData componentsSeparatedByString:@"\n"]];
	

	if (!commentHandled) 
	{
	
		[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
		UIAlertView *alert;

		
		if ([[listOfItems objectAtIndex:1] isEqualToString:@"ok"]) 
		{
			alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"thankYou", @"")
											   message:NSLocalizedString(@"thankYouCommentDesc", @"")
											  delegate:self
									 cancelButtonTitle:NSLocalizedString(@"ok", @"") 
									 otherButtonTitles:nil];
			
			//save last comment that was succesfully sent.
			[lastComment setString:feedbackText.text];
			
		}
		else 
		{
			alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"sorry", @"") 
											   message:NSLocalizedString(@"sorryCommentDesc", @"") 
											  delegate:self
									 cancelButtonTitle:NSLocalizedString(@"ok", @"")
									 otherButtonTitles:nil];
		}
		
		[alert show];
		[alert release];
		alert = nil;
		
		commentHandled = YES;
	}

}

- (void)connectionError
{
	[RVC removeActivity];
	
	[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"connectionError",@"")
													message:NSLocalizedString(@"connectionErrorCommentDesc", @"") 
												   delegate:self
										  cancelButtonTitle:NSLocalizedString(@"ok", @"")
										  otherButtonTitles:nil];
	
	[alert show];
	[alert release];
	alert = nil;
	
	commentHandled = YES;
}

-(void) btnCancel2Pressed
{
	[self fadeToMenu];
}

-(void) btnCancelPressed
{
	if (!modal) 
	{
		[RVC changeView:BB_INFO_PANEL_VIEW]; 
	}
	else 
	{
		[self slideOut];
		//[PVC hideModal];
	}

	
}

-(void) btnBubbleOutPressed
{
	
	//TODO: CLEANUP 
	
	
	[[MRSharedTextures sharedInstance] removeAllTextures];
	[[MRSharedModels sharedInstance] removeAllModels];
	[[MRObjectManager sharedInstance] reset];
	[[MRObjectDrawingManager sharedInstance] reset];
	[[MRObjectGroupManager sharedInstance] reset];
	[[MRObjectTouchesManager sharedInstance] reset];
	
	if (modal) 
	{
		[PVC hideModal];
	}
	
	[RVC changeView:BB_CHANNEL_TABLE_VIEW];
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

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return NO;
}
 */


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
	if (!modal) 
	{
		[RVC switchView];
	}
	else 
	{
		[PVC hideModal];
	}

}


- (void)dealloc {
	[lastComment release];
    [super dealloc];
}


@end
