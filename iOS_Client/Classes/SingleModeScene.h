//
//  SingleModeScene.h
//  AirRaidBeta
//
//  Created by ken yasue on 3/5/10.
//  Copyright 2010 clover studio. All rights reserved.
//


#import "BaseScene.h"
#import "CSSprite.h"
#import "SimpleButton.h"
#import "AttackView.h"
#import "StatusBarPanel.h"

@class ImageButton;

@interface SingleModeLayer : BaseLayer {
	
	CSSprite		*sprtSight;
	
	CSSprite		*sprtCoverTop;
	CSSprite		*sprtCoverBottom;
	CSSprite		*sprtRadarBG;
	CCSpriteSheet	*spriteSheetUI;
	
	NSMutableArray	*panelMainSprites;
	CSSprite		*toolBar;
	SimpleButton	*btnShop;
	SimpleButton	*btnMap;
	
	NSMutableArray	*panelShopSprites;
	CSSprite		*sprtBg;
	SimpleButton	*btnAAGun;
	SimpleButton	*btnBack;
	
	BOOL			tapState;
	BOOL			panelState;
	
	AttackView		*attackView;
	StatusBarPanel	*statusBarPanel;
}

-(void) onSelectShop:(id) sender;
-(void) onSelectShopBack:(id) sender;
-(void) onSelectShopAAGun:(id) sender;
-(void) hideShopPanel;

@end


@interface SingleModeScene : BaseScene {
	
	
	
}

@end



