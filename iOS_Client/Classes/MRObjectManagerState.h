//
//  MRObjectManagerState.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 3/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MRObjectManager;

@protocol MRObjectManagerStateProtocol

-(id) initWithInstance:(MRObjectManager*) arg;
-(void) asyncDownloadURL;
-(void) downloadURL;
-(void) getURLData:(NSData*) data;
-(void) doneProcessingModels;

@end

@interface MRObjectManagerState : NSObject <MRObjectManagerStateProtocol>
{
	MRObjectManager *instance;
}
@end


@interface MRObjectManagerStateDownloadingURL : MRObjectManagerState
{
	
}
@end


@interface MRObjectManagerStateDoneProcessing : MRObjectManagerState
{

}
@end
