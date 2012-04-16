//
//  MRLoadingViewController.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 3/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRViewController.h"

@class MRRootViewController;

@interface MRLoadingViewController : MRViewController {

	UIImageView *bgImageView;
	
	NSTimer *loadingTimer;
}

-(id) initWithRVC:(MRRootViewController *) rvcArg;

@end
