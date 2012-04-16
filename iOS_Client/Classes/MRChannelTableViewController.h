//
//  MRChannelTableViewController.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRViewController.h"
#import "MRPolisManager.h"
@class MRRootViewController;
@class MRTableView;
@interface MRChannelTableViewController : MRViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MRPolisManagerListener>
{
	MRTableView *table;
	NSMutableArray *categoryArray;
	NSArray *tableSections;
	UITextField *channelField;
	BOOL connectionError;
	//UIActivityIndicatorView *activityIndicatorView;	
	
	NSMutableArray *polisIconsArray;
}

-(id) initWithRVC:(MRRootViewController*) rvcArg;


@end
