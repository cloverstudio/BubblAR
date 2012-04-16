//
//  MRPolisInfoView.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRViewController.h"
#import "MRPolisManager.h"

@class MRRootViewController;

@interface MRPolisInfoView : MRViewController <UIScrollViewDelegate, MRPolisManagerListener>
{
	UIScrollView *scrollView;
	UIImageView *imageView;
	UILabel *titleLabel;
	UITextView *descriptionTextView;
	UIButton *bubbleInButton;
	UIButton *cancelButton;
}

-(id) initWithRVC:(MRRootViewController*) rvcArg;


@end
