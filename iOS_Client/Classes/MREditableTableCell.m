//
//  MREditableTableCell.m
//  ChildDocs
//
//  Created by marko.hlebar on 2/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MREditableTableCell.h"


@implementation MREditableTableCell

-(id) initWithReuseIdentifier:(NSString *)reuseIdentifier andTextField:(UITextField*) textField
{
	
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) 
	{
		self.opaque = NO;
		self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
		self.textLabel.backgroundColor = [UIColor clearColor];
	}
	
	self.accessoryView = textField;
	return self;
}

@end
