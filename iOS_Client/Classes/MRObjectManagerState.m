//
//  MRObjectManagerState.m
//  MarketRaidBeta
//
//  Created by marko.hlebar on 3/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRObjectManagerState.h"
#import "MRObjectManager.h"

@implementation MRObjectManagerState

-(id) initWithInstance:(MRObjectManager*) arg;
{
	if (self = [super init]) 
	{
		instance = arg;
	}
	
	return self;
}
-(void) asyncDownloadURL
{}
-(void) downloadURL
{}
-(void) getURLData:(NSData*) data
{}
-(void) doneProcessingModels
{}

@end


@implementation MRObjectManagerStateDownloadingURL

-(void) downloadURL
{
	
	if (!instance.downloading && !instance.urlDone) {
		if (!instance.asyncLoad) 
			[instance downloadURL];
		else 
			[instance asyncDownloadURL];
	}
	
	if (instance.urlDone) 
	{
		[instance doneProcessingModels];
		instance.state = instance.stateDoneProcessing;
	}
}

-(void) getURLData:(NSData*) data
{
	if (!instance.urlDone) {
		[instance getURLData:data];
	}

}

@end


@implementation MRObjectManagerStateDoneProcessing

-(void) doneProcessingModels
{

}

@end