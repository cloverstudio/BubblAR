//
//  StatusBarPanel.m
//  AirRaidBeta
//
//  Created by ken yasue on 3/11/10.
//  Copyright 2010 clover studio. All rights reserved.
//

#import "StatusBarPanel.h"


@implementation StatusBarPanel

-(StatusBarPanel *) initWithSheet:(CCSpriteSheet*)sheet layer:(CCLayer *) layer{
	
	
	self = [super initWithSpriteSheet:sheet rect:CGRectMake(481,550,233,46)];
	
    if (self != nil) {

		spriteSheet = sheet;
		[spriteSheet addChild:self z:50];
		
		self.position = CGPointMake(247,320);
		
		parentLayer = layer;
		
		labelMoney = [[CCLabel alloc] initWithString:@"000000000" fontName:@"Arial-BoldMT" fontSize:20];
		[labelMoney setColor:ccc3(0, 0, 0)];
		labelMoney.position = CGPointMake(425,310);
		
		[parentLayer addChild:labelMoney];
	}
	
	return self;
	
}

@end
