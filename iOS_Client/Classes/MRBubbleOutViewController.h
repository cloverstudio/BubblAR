//
//  MRBubbleOutViewController.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRViewController.h"
#import "HttpReader.h"

@class MRRootViewController;

@interface MRBubbleOutViewController : MRViewController <UITextViewDelegate, HttpReaderProtocol>
{

	/*
	UIImageView *imageView;
	UIButton *btnCancel;
	UIButton *btnBubbleOut;
	 */
	BOOL commentAdded;
	BOOL commentHandled;
	BOOL modal;
	
	UIButton *btnMap;
	UIButton *btnCancel;
	UIButton *btnFeedback;
	UIButton *btnBubbleOut;
	
	UIButton *btnCancel2;
	UIButton *btnSubmit;
	UITextView *feedbackText;
	
	NSMutableString *lastComment;
	
	MRViewController *PVC;
	
}

@property (nonatomic, assign) MRViewController *PVC;


-(id) initWithRVC:(MRRootViewController*) rvcArg; 
-(id) initWithRVC:(MRRootViewController*) rvcArg parentVC:(MRViewController*)  pvcArg; 

-(void) btnCancelPressed;
-(void) btnBubbleOutPressed;

@end
