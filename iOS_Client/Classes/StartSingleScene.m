//
//  StartSingleScene.m
//  AirRaidBeta
//
//  Created by ken yasue on 3/4/10.
//  Copyright 2010 clover studio. All rights reserved.
//

#import "StartSingleScene.h"
#import "GameManager.h"
#import "ImageButton.h"
#import "MarketRaidBetaAppDelegate.h"

@implementation StartSingleLayer

- (id) init {
	
    self = [super init];
	
    if (self != nil) {


		spriteSheetUI = [[GameManager inst] getTextureAtlas:textureAtlasUI];
		
		sprtBg = [[CSSprite alloc] initWithSpriteSheet:spriteSheetUI rect:CGRectMake(0,640,480,320)];
		sprtCoverTop = [[CSSprite alloc] initWithSpriteSheet:spriteSheetUI rect:CGRectMake(0,320,480,160)];
		sprtCoverBottom = [[CSSprite alloc] initWithSpriteSheet:spriteSheetUI rect:CGRectMake(0,480,480,160)];
		
		sprtBg.position = CGPointMake(0,320);
		sprtCoverTop.position = CGPointMake(0,320);
		sprtCoverBottom.position = CGPointMake(0,160);
		
		[self addChild:spriteSheetUI z:1];
		
		//[spriteSheetUI addChild:sprtBg z:1];
		[spriteSheetUI addChild:sprtCoverTop z:150];
		[spriteSheetUI addChild:sprtCoverBottom z:150];


		
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		// UIViews 
		////////////////////////////////////////////////////////////////////////////////////////////////

		MarketRaidBetaAppDelegate *delegate = (MarketRaidBetaAppDelegate *) [UIApplication sharedApplication].delegate;
		
		UIWindow *window = delegate.window;
		UIView	*mainView = delegate.glView;
		CGRect winrect = [[UIScreen mainScreen] bounds];
		
		[mainView removeFromSuperview];
		
		baseView = [[UIView alloc] initWithFrame:winrect];
		
		behindView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,480)];
		behindView.backgroundColor = [UIColor whiteColor];
		topView.userInteractionEnabled = YES;
		[baseView addSubview:behindView];
		
		backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UIBackground.png"]];
		[behindView addSubview:backgroundView];
		
		CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(0.5 * M_PI);
		landscapeTransform = CGAffineTransformTranslate (landscapeTransform,-80,80);
		[behindView setTransform:landscapeTransform];
		
		btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
		btnNext.frame = CGRectMake(260,220,218,93);		 
		[btnNext setBackgroundImage:[UIImage imageNamed:@"uibtn_start.png"] forState:UIControlStateNormal];
		[btnNext addTarget:self action:@selector(onStart) forControlEvents:UIControlEventTouchUpInside];
		[behindView addSubview:btnNext];
		
		slider = [[UISlider alloc] initWithFrame:CGRectMake(20,20,218,50)];
		[behindView addSubview:slider];
		
		
		topView = [[UIView alloc] initWithFrame:winrect];
		topView.backgroundColor = [UIColor clearColor];
		[topView addSubview:mainView];
		[baseView addSubview:topView];
		
		[baseView bringSubviewToFront:topView];
		
		
		[window addSubview:baseView];
		
	}
	
    return self;
}

-(void) onEnter
{
	[super onEnter];
	
	id action = [CCSequence actions:
				 [CCEaseSineOut actionWithAction:[CCMoveTo actionWithDuration:1.0  position:CGPointMake(0,480)]],
				 [CCCallFunc actionWithTarget:self selector:@selector(callbackOpened)],
				 nil];
	
	[sprtCoverTop runAction:action];
	[sprtCoverBottom runAction:[CCEaseSineOut actionWithAction:[CCMoveTo actionWithDuration:1.0  position:CGPointMake(0,0)]]];	
	
	[[GameManager inst] playSound:sndDoorOpen];
}

- (void) callbackOpened{
	
	// bring front to handle touch events
	[baseView bringSubviewToFront:behindView];

	
}

- (void) callbackClosed{
	
	MarketRaidBetaAppDelegate *delegate = (MarketRaidBetaAppDelegate *) [UIApplication sharedApplication].delegate;
	UIView	*mainView = delegate.glView;
	UIWindow *window = delegate.window;
	
	[mainView removeFromSuperview];
	[topView removeFromSuperview];
	[behindView removeFromSuperview];
	[baseView removeFromSuperview];

	[window addSubview:mainView];
	
	[[GameManager inst] stopMusic:musicTitle];
	[[GameManager inst] next];
	
}

- (void) onStart{
	
	
	[baseView bringSubviewToFront:topView];
	
	id action = [CCSequence actions:
				 [CCEaseSineOut actionWithAction:[CCMoveTo actionWithDuration:1.0  position:CGPointMake(0,320)]],
				 [CCCallFunc actionWithTarget:self selector:@selector(callbackClosed)],
				 nil];
	
	[sprtCoverTop runAction:action];
	[sprtCoverBottom runAction:[CCEaseSineOut actionWithAction:[CCMoveTo actionWithDuration:1.0  position:CGPointMake(0,160)]]];	
	
}

- (void) cleanup{
	[spriteSheetUI removeAllChildrenWithCleanup:YES];
	[self removeAllChildrenWithCleanup:YES];
	
	[super cleanup];
}

-(void) dealloc
{
	
	[sprtBg					release];
	[sprtCoverTop			release];
	[sprtCoverBottom		release];


	[baseView		release];
	[behindView		release];
	[topView		release];

	
	[super dealloc];
}

@end



@implementation StartSingleScene

- (id) init {
	
    self = [super init];
	
    if (self != nil) {
		
		layer = [[StartSingleLayer alloc] init];

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

	
	[super	dealloc];
	
}


@end