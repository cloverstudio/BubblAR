//
//  MenuScene.m
//  square
//
//  Created by ken yasue on 7/7/09.
//  Copyright 2009 clover studio. All rights reserved.
//

#import "MenuScene.h"
#import "GameManager.h"
#import "ImageButton.h"

@implementation MenuLayer

- (id) init {
	
    self = [super init];
	
    if (self != nil) {
		
		spriteSheetUI = [[GameManager inst] getTextureAtlas:textureAtlasUI];
		
		sprtBg = [[CSSprite alloc] initWithSpriteSheet:spriteSheetUI rect:CGRectMake(0,0,480,320)];
		sprtCoverTop = [[CSSprite alloc] initWithSpriteSheet:spriteSheetUI rect:CGRectMake(0,320,480,160)];
		sprtCoverBottom = [[CSSprite alloc] initWithSpriteSheet:spriteSheetUI rect:CGRectMake(0,480,480,160)];
		
		sprtBg.position = CGPointMake(0,320);
		sprtCoverTop.position = CGPointMake(0,320);
		sprtCoverBottom.position = CGPointMake(0,160);
		
		[self addChild:spriteSheetUI z:1];
		[spriteSheetUI addChild:sprtBg z:1];
		[spriteSheetUI addChild:sprtCoverTop z:150];
		[spriteSheetUI addChild:sprtCoverBottom z:150];
		
		
		//smokes
		smoke1 = [[CSSprite alloc] initWithSpriteSheet:spriteSheetUI rect:CGRectMake(483,202,220,220)];
		[spriteSheetUI addChild:smoke1 z:3];
		smoke1.position = CGPointMake(-160,180);
		
		id action1 = [CCSequence actions:
					  [CCMoveTo actionWithDuration:10 position:CGPointMake(600,180)],
					  [CCMoveTo actionWithDuration:0.0 position:CGPointMake(-160,120)],
					  nil];
		
		[smoke1 runAction:[CCRepeatForever actionWithAction:action1]];


		smoke2 = [[CSSprite alloc] initWithSpriteSheet:spriteSheetUI rect:CGRectMake(483,202,220,220)];
		[spriteSheetUI addChild:smoke2 z:3];
		smoke2.position = CGPointMake(600,350);
		
		id action2 = [CCSequence actions:
					  [CCMoveTo actionWithDuration:5 position:CGPointMake(-160,350)],
					  [CCMoveTo actionWithDuration:5 position:CGPointMake(600,480)],
					  nil];
		
		[smoke2 runAction:[CCRepeatForever actionWithAction:action2]];
		
		
		smoke3 = [[CSSprite alloc] initWithSpriteSheet:spriteSheetUI rect:CGRectMake(483,202,220,220)];
		[spriteSheetUI addChild:smoke3 z:3];
		smoke3.position = CGPointMake(240,50);
		
		id action3 = [CCSequence actions:
					  [CCMoveTo actionWithDuration:15 position:CGPointMake(240,480)],
					  [CCMoveTo actionWithDuration:0 position:CGPointMake(240,0)],
					  nil];
		
		[smoke3 runAction:[CCRepeatForever actionWithAction:action3]];

		
		smoke4 = [[CSSprite alloc] initWithSpriteSheet:spriteSheetUI rect:CGRectMake(483,202,220,220)];
		[spriteSheetUI addChild:smoke4 z:3];
		smoke4.position = CGPointMake(100,480);
		
		id action4 = [CCSequence actions:
					  [CCMoveTo actionWithDuration:8 position:CGPointMake(100,0)],
					  [CCMoveTo actionWithDuration:0 position:CGPointMake(100,480)],
					  nil];
		
		[smoke4 runAction:[CCRepeatForever actionWithAction:action4]];
		
		
		
		// menues
		menu1 = [[ImageButton alloc] 
				 initWithRect:CGRectMake(480,0,120,50)
				 rectOn:CGRectMake(480,0,120,50)
				 manager:spriteSheetUI
				 target:self 
				 selectorBegin:@selector(onMenu1Begin:)
				 selectorEnd:@selector(onMenu1End:)
				 ];
		
		[menu1 setPosition:CGPointMake(360,320)];
		
		menu2 = [[ImageButton alloc] 
				 initWithRect:CGRectMake(480,49,120,50)
				 rectOn:CGRectMake(480,49,120,50)
				 manager:spriteSheetUI
				 target:self 
				 selectorBegin:@selector(onMenu2Begin:)
				 selectorEnd:@selector(onMenu2End:)
				 ];
		
		[menu2 setPosition:CGPointMake(360,268)];
		
		menu3 = [[ImageButton alloc] 
				 initWithRect:CGRectMake(480,98,120,50)
				 rectOn:CGRectMake(480,98,120,50)
				 manager:spriteSheetUI
				 target:self 
				 selectorBegin:@selector(onMenu3Begin:)
				 selectorEnd:@selector(onMenu3End:)
				 ];
		
		[menu3 setPosition:CGPointMake(360,216)];
		
		menu4 = [[ImageButton alloc] 
				 initWithRect:CGRectMake(480,147,120,50)
				 rectOn:CGRectMake(480,147,120,50)
				 manager:spriteSheetUI
				 target:self 
				 selectorBegin:@selector(onMenu3Begin:)
				 selectorEnd:@selector(onMenu3End:)
				 ];
		
		[menu4 setPosition:CGPointMake(360,164)];
		
	}
	
    return self;
}

-(void) onEnter
{
	[super onEnter];

	
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
	[[GameManager inst] playMusic:musicTitle];
}


-(void) onMenu1Begin:(id) sender{
	[[GameManager inst] playSound:sndClick1];
}
-(void) onMenu2Begin:(id) sender{
	[[GameManager inst] playSound:sndClick1];	
}
-(void) onMenu3Begin:(id) sender{
	[[GameManager inst] playSound:sndClick1];
}
-(void) onMenu4Begin:(id) sender{
	[[GameManager inst] playSound:sndClick1];
}
	
-(void) onMenu1End:(id)	  sender{
	[sprtCoverTop runAction:[CCEaseSineOut actionWithAction:[CCMoveTo actionWithDuration:1.0  position:CGPointMake(0,320)]]];
	[sprtCoverBottom runAction:[CCEaseSineOut actionWithAction:[CCMoveTo actionWithDuration:1.0  position:CGPointMake(0,160)]]];	
	
	[[GameManager inst] playSound:sndDoorOpen];
	
	
	[NSTimer scheduledTimerWithTimeInterval:1.5
									 target:self 
								   selector:@selector(nextScene) 
								   userInfo:nil 
									repeats:NO];
	
}
-(void) onMenu2End:(id)   sender{
}
-(void) onMenu3End:(id)   sender{
}
-(void) onMenu4End:(id)   sender{

}



-(void) nextScene{
	
	
	[[GameManager inst] next];
	
}

- (void) cleanup{
	
	[spriteSheetUI removeAllChildrenWithCleanup:YES];
	[self removeAllChildrenWithCleanup:YES];
	
	[menu1 cleanup];
	[menu2 cleanup];
	[menu3 cleanup];
	[menu4 cleanup];
	
	
	[super cleanup];
}

-(void) dealloc
{
	
	[sprtBg					release];
	[sprtCoverTop			release];
	[sprtCoverBottom		release];

	[smoke1					release];
	[smoke2					release];
	[smoke3					release];
	[smoke4					release];
	[smoke5					release];

	[menu1			release];
	[menu2			release];
	[menu3			release];
	[menu4			release];
	
	[super dealloc];
}



@end


@implementation MenuScene

- (id) init {
	
    self = [super init];
	
    if (self != nil) {
		
		layer = [[MenuLayer alloc] init];
		
	}
	
    return self;
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
