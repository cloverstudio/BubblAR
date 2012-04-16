//
//  MenuScene.h
//  square
//
//  Created by ken yasue on 7/7/09.
//  Copyright 2009 clover studio. All rights reserved.
//

#import "BaseScene.h"
#import "CSSprite.h"

@class ImageButton;

@interface MenuLayer : BaseLayer {
	
	CSSprite		*sprtBg;
	CSSprite		*sprtCoverTop;
	CSSprite		*sprtCoverBottom;
	CCSpriteSheet	*spriteSheetUI;
	
	ImageButton	*menu1,*menu2,*menu3,*menu4;
	
	
	CSSprite		*smoke1,*smoke2,*smoke3,*smoke4,*smoke5; 
}



@end


@interface MenuScene : BaseScene {
	
}

@end
