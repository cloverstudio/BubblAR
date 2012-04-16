//
//  StartSingleScene.h
//  AirRaidBeta
//
//  Created by ken yasue on 3/4/10.
//  Copyright 2010 clover studio. All rights reserved.
//

#import "BaseScene.h"
#import "CSSprite.h"

@class ImageButton;

@interface StartSingleLayer : BaseLayer {

	CSSprite		*sprtCoverTop;
	CSSprite		*sprtCoverBottom;
	CSSprite		*sprtBg;
	CCSpriteSheet	*spriteSheetUI;

	
	
	UIButton	*btnNext;
	
	UISlider	*slider;
	
	UIView		*topView;
	UIView		*behindView;
	UIView		*baseView;
	UIImageView	*backgroundView;
}

@end

@interface StartSingleScene : BaseScene {
	

	
}

@end