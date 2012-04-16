//
//  MRObjectState.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MRObject;
@interface MRObjectState : NSObject {

	MRObject *instance;
	
}

-(id) initWithInstance:(MRObject*) instanceArg;
-(void) updateObject;
-(void) drawObject;
-(void) updateBubble;
-(void) drawBubble;
-(void) updateDetailObject;
-(void) drawDetailObject;

@end

@interface MRObjectStateAlive : MRObjectState
{

}
@end

@interface MRObjectStateAliveAndVisible : MRObjectState
{
	
}
@end

@interface MRObjectStatePopped : MRObjectState
{
	
}
@end

@interface MRObjectStatePoppedAndVisible : MRObjectState
{
	
}
@end

@interface MRObjectStateDoneAnimating : MRObjectState
{
	
}
@end

