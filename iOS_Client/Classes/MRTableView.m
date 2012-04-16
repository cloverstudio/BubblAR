//
//  MRTableView.m
//  ChildDocs
//
//  Created by marko.hlebar on 2/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRTableView.h"
//#import "ConstantsAndMacros.h"

@implementation MRTableView

-(id) initWithFrame:(CGRect)frame andDelegate:(id) delegate andDatasource: (id) dataSource
{
	if (self = [super initWithFrame:frame style:UITableViewStyleGrouped]) {
		self.backgroundColor = [UIColor clearColor];
		self.delegate = delegate;
		self.dataSource = dataSource;
		self.separatorColor= [UIColor whiteColor];
		self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	}
	
	return self;
}

@end
