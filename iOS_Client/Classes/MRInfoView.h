//
//  MRInfoView.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MRInfoPanelViewController;
@interface MRInfoView : UIView 
{
	UIImageView *backgroundView;
	UIButton	*closeBtn;
	UIButton	*webBtn;
	UIButton	*mapBtn;	
	UILabel		*labelTitle;
	UITextView	*descriptionTextView;

	MRInfoPanelViewController *RVC;
	
}

@property (assign) MRInfoPanelViewController *RVC;

-(void) updateData;
-(void) slideIn;
-(void) slideOut;

@end
