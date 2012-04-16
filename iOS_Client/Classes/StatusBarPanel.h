//
//  StatusBarPanel.h
//  AirRaidBeta
//
//  Created by ken yasue on 3/11/10.
//  Copyright 2010 clover studio. All rights reserved.
//

#import "cocos2d.h"
#import "CSSprite.h"

@interface StatusBarPanel : CSSprite {
	CCLayer			*parentLayer;
	CCSpriteSheet	*spriteSheet;
	CCLabel			*labelMoney;
}

-(StatusBarPanel *) initWithSheet:(CCSpriteSheet*)sheet layer:(CCLayer *)layer;

@end
