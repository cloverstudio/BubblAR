//
//  MRViewController.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRRootViewController;
@interface MRViewController : UIViewController {

	BOOL hidden;
	MRRootViewController *RVC;
}

@property (assign) MRRootViewController *RVC;
@property BOOL hidden;

-(void) slideIn;
-(void) slideOut;
-(void) doneAnimatingOut;
-(void) cleanup;
-(void) hideModal;

@end
