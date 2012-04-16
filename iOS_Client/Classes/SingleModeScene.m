//
//  SingleModeScene.m
//  AirRaidBeta
//
//  Created by ken yasue on 3/5/10.
//  Copyright 2010 clover studio. All rights reserved.
//

#import "SingleModeScene.h"
#import "GameManager.h"
#import "CocosWMBridge.h"
#import "MarketRaidBetaAppDelegate.h"
#import "ARGeoViewController.h"

@implementation SingleModeLayer

- (id) init {
	
    self = [super init];
	
    if (self != nil) {
		
		self.isTouchEnabled = YES;

		spriteSheetUI = [[GameManager inst] getTextureAtlas:textureAtlasUI];
		
		sprtCoverTop = [[CSSprite alloc] initWithSpriteSheet:spriteSheetUI rect:CGRectMake(0,320,480,160)];
		sprtCoverBottom = [[CSSprite alloc] initWithSpriteSheet:spriteSheetUI rect:CGRectMake(0,480,480,160)];
		
		sprtCoverTop.position = CGPointMake(0,320);
		sprtCoverBottom.position = CGPointMake(0,160);
		
		sprtRadarBG = [[CSSprite alloc] initWithSpriteSheet:spriteSheetUI rect:CGRectMake(482,435,112,112)];
		sprtRadarBG.position = CGPointMake(5,315);

		[self addChild:spriteSheetUI z:1];
		[spriteSheetUI addChild:sprtCoverTop z:150];
		[spriteSheetUI addChild:sprtCoverBottom z:150];
		[spriteSheetUI addChild:sprtRadarBG z:50];
		
		
		sprtSight = [[CSSprite alloc] initWithSpriteSheet:spriteSheetUI rect:CGRectMake(610,435,57,57)];
		sprtSight.position = CGPointMake(212,188);
		[spriteSheetUI addChild:sprtSight z:60];
		
		
		toolBar = [[CSSprite alloc] initWithSpriteSheet:spriteSheetUI rect:CGRectMake(712,0,75,320)];
		toolBar.position = CGPointMake(480,320);
		[spriteSheetUI addChild:toolBar z:75];
		
		btnShop = [[SimpleButton alloc] initWithSpriteSheet:spriteSheetUI rect:CGRectMake(787,0,60,60)];
		btnShop.position = CGPointMake(480,320);
		[spriteSheetUI addChild:btnShop z:80];
		[btnShop setCallback:self selector:@selector(onSelectShop:)];
		 
		btnMap = [[SimpleButton alloc] initWithSpriteSheet:spriteSheetUI rect:CGRectMake(787,60,60,60)];
		btnMap.position = CGPointMake(480,260);
		[spriteSheetUI addChild:btnMap z:80];
		[btnMap setCallback:self selector:@selector(onSelectMap:)];
		
		panelMainSprites = [[NSMutableArray alloc] init];

		[panelMainSprites addObject:toolBar];
		[panelMainSprites addObject:btnShop];
		[panelMainSprites addObject:btnMap];
	
		sprtBg = [[CSSprite alloc] initWithSpriteSheet:spriteSheetUI rect:CGRectMake(0,640,480,320)];
		sprtBg.position = CGPointMake(0,0);
		[spriteSheetUI addChild:sprtBg z:75];
		
		btnBack = [[SimpleButton alloc] initWithSpriteSheet:spriteSheetUI rect:CGRectMake(787,180,60,60)];
		btnBack.position = CGPointMake(420,-260);
		[spriteSheetUI addChild:btnBack z:80];
		[btnBack setCallback:self selector:@selector(onSelectShopBack:)];
		
		btnAAGun = [[SimpleButton alloc] initWithSpriteSheet:spriteSheetUI rect:CGRectMake(787,120,60,60)];
		btnAAGun.position = CGPointMake(10,-10);
		[spriteSheetUI addChild:btnAAGun z:80];
		[btnAAGun setCallback:self selector:@selector(onSelectShopAAGun:)];
		
		panelShopSprites = [[NSMutableArray alloc] init];
		[panelShopSprites addObject:sprtBg];
		[panelShopSprites addObject:btnBack];
		[panelShopSprites addObject:btnAAGun];
		
		tapState = NO;
		panelState = NO;
		
		attackView = [[AttackView alloc] initWithFrame:CGRectMake(-320,80,480,320)];
		CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(0.5 * M_PI);
		[attackView setTransform:landscapeTransform];

		statusBarPanel = [[StatusBarPanel alloc] initWithSheet:spriteSheetUI layer:self];
		
		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	}
	
    return self;
}

-(void) onEnter
{
	[super onEnter];
	
	[[GameManager inst] playMusic:musicPlay];
	
	[NSTimer scheduledTimerWithTimeInterval:0.5
									 target:self 
								   selector:@selector(openCover) 
								   userInfo:nil 
									repeats:NO];
	
}

-(void) openCover{
	[sprtCoverTop runAction:[CCEaseSineOut actionWithAction:[CCMoveTo actionWithDuration:1.0  position:CGPointMake(0,480)]]];
	[sprtCoverBottom runAction:[CCEaseSineOut actionWithAction:[CCMoveTo actionWithDuration:1.0  position:CGPointMake(0,0)]]];	
	
	[[GameManager inst] playSound:sndDoorOpen];
	
	[[CocosWMBridge inst] startGame];
}


- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{

	
	CGPoint location = [touch locationInView: [touch view]];

	
	if(panelState == YES){

		
		for(CSSprite *sprite in panelShopSprites){
			
			if([sprite isKindOfClass:[SimpleButton class]]){
				[(SimpleButton *)sprite ccTouchBegan:touch withEvent:event];
			}
			
		}
		

	}
	
	else if(location.x > 400){
		
		tapState = YES;
		
		for(CSSprite *sprite in panelMainSprites){
			[sprite runAction:[CCEaseSineOut actionWithAction:[CCMoveTo actionWithDuration:0.3  position:CGPointMake(420,sprite.position.y)]]];
		}
		
	}
	
	if(panelState == NO && location.x <= 400){
		
		[[CocosWMBridge inst] sendTouchBegin:location];
	}
	
	return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
	
	CGPoint location = [touch locationInView: [touch view]];
	[[CocosWMBridge inst] sendTouchEnd:location];
	
	tapState = NO;
	
	for(CSSprite *sprite in panelMainSprites){
		[sprite runAction:[CCEaseSineOut actionWithAction:[CCMoveTo actionWithDuration:0.3  position:CGPointMake(480,sprite.position.y)]]];

		if([sprite isKindOfClass:[SimpleButton class]]){
			
			[(SimpleButton *)sprite ccTouchEnded:touch withEvent:event];
			
		}
	}
	
	for(CSSprite *sprite in panelShopSprites){
		
		if([sprite isKindOfClass:[SimpleButton class]]){
			[(SimpleButton *)sprite ccTouchEnded:touch withEvent:event];
		}
		
	}
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
	
	for(CSSprite *sprite in panelMainSprites){
		
		if([sprite isKindOfClass:[SimpleButton class]]){
			
			[(SimpleButton *)sprite ccTouchMoved:touch withEvent:event];
			
		}
		
	}
	
	for(CSSprite *sprite in panelShopSprites){
		
		if([sprite isKindOfClass:[SimpleButton class]]){
			[(SimpleButton *)sprite ccTouchMoved:touch withEvent:event];
		}
		
	}
	

}


-(void) onSelectShop:(id) sender{
	
	panelState = YES;
	
	for(CSSprite *sprite in panelShopSprites){
		[sprite runAction:[CCEaseSineOut actionWithAction:[CCMoveBy actionWithDuration:0.5  position:CGPointMake(0,320)]]];
	}
	
	[[GameManager inst] playSound:sndDoorOpen];
}

-(void) onSelectMap:(id) sender{
	
	MarketRaidBetaAppDelegate *delegate = (MarketRaidBetaAppDelegate *) [UIApplication sharedApplication].delegate;
	[attackView updateLocation];
	
	UIWindow *window = delegate.window;
	[window addSubview:attackView];
	[attackView showUp];
	
	[[GameManager inst] playSound:sndDoorOpen];
}


-(void) onSelectShopBack:(id) sender{
	[self hideShopPanel];
}

-(void) onSelectShopAAGun:(id) sender{
	
	[[GameManager inst] playSound:sndCashier];
	[[CocosWMBridge inst] buyItem:itemAAGun];
	[self hideShopPanel];
}

-(void) hideShopPanel{
	
	panelState = NO;
	
	for(CSSprite *sprite in panelShopSprites){
		[sprite runAction:[CCEaseSineOut actionWithAction:[CCMoveBy actionWithDuration:0.5  position:CGPointMake(0,-320)]]];
	}
	
}

- (void) cleanup{
	[spriteSheetUI removeAllChildrenWithCleanup:YES];
	[self removeAllChildrenWithCleanup:YES];
	
	[super cleanup];
}

-(void) dealloc
{
	
	
	[super dealloc];
}

@end



@implementation SingleModeScene

- (id) init {
	
    self = [super init];
	
    if (self != nil) {
		
		layer = [[SingleModeLayer alloc] init];
	
	}
	
    return self;
}

-(void) onEnter
{
	[super onEnter];
	
	
	
}

- (void) cleanup{
	
	[self removeAllChildrenWithCleanup:YES];
	[super cleanup];
	
}

-(void) dealloc
{
	
	
	[super			dealloc];
	
}


@end