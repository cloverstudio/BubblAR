//
//  MRWebView.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MRInfoPanelViewController;
@interface MRWebView : UIView 
{
	UIWebView *webView;
	MRInfoPanelViewController *RVC;
}

@property (assign) MRInfoPanelViewController *RVC;

-(void) slideIn;
-(void) slideOut;
-(void) updateData;

@end
