//
//  WMGamestateState.h
//  AirRaidBeta
//
//  Created by marko.hlebar on 3/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WMGamestateStateProtocol

-(void) update;
-(void) draw;
-(void) collisionDetection;
-(void) reset;
-(void) cleanup;

@end

@class WMGamestate;
@interface WMGamestateState : NSObject <WMGamestateStateProtocol>{

	WMGamestate *instance;
	
}

@property (nonatomic, assign) WMGamestate *instance;

-(id) initWithInstance:(WMGamestate*) arg;

@end

@interface WMGamestateGameNotRunningState : WMGamestateState

@end

@interface WMGamestateGameRunningState : WMGamestateState

@end

@interface WMGamestateGamePausedState: WMGamestateState

@end

@interface WMGamestateGameQuitState: WMGamestateState

@end