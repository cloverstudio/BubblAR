//
//  MRBubbleState.h
//  EffectTestGround
//
//  Created by marko.hlebar on 4/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MRBubble;
@interface MRBubbleState : NSObject 
{
	MRBubble *instance;
}

-(void) update;
-(void) draw; 
-(void) updateBubbles;
-(void) drawBubbles;
-(void) dispose;


-(id) initWithInstance:(MRBubble*) instArg;
@end

@interface MRBubbleStateAlive : MRBubbleState
{

}
@end

@interface MRBubbleStateAliveAndVisible : MRBubbleState
{

}
@end

@interface MRBubbleStatePopped : MRBubbleState
{

}
@end

@interface MRBubbleStatePoppedAndVisible: MRBubbleState
{

}
@end

@interface MRBubbleStateDoneAnimating: MRBubbleState
{

}
@end