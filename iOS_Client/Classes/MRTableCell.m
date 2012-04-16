//
//  MRTableCell.m
//  ChildDocs
//
//  Created by marko.hlebar on 2/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRTableCell.h"

#define TABLE_CELL_FRAME CGRectMake(0, 0, 480, 60);

@implementation MRTableCell

-(id) initWithReuseIdentifier:(NSString *)reuseIdentifier
{

	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) 
	{
		//self.frame = TABLE_CELL_FRAME;
		self.opaque = NO;
		self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
		self.textLabel.backgroundColor = [UIColor clearColor];
		self.textLabel.textColor = [UIColor whiteColor];
	}
	
	return self;
}


@end
