//
//  MRObjectManager.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 3/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMGameObject.h"
#import "HttpReader.h"
#import "MRObjectManagerState.h" 

@class WMConcreteSubject;
@class CLLocation;
@class MRRootViewController;
//@class CCTexture2D;
@interface MRObjectManager : NSObject <WMGameObjectProtocol, HttpReaderProtocol>
{
	NSMutableArray *objectsArray;
	WMConcreteSubject *concreteSubject;
	//CCTexture2D *tempTex;
	
	id <MRObjectManagerStateProtocol> state;
	id <MRObjectManagerStateProtocol> stateDownloadingURL;
	id <MRObjectManagerStateProtocol> stateDoneProcessing; 

	BOOL downloading;
	BOOL urlDone;
	BOOL doneLoading;
	BOOL startDownloading;
	BOOL running;
	BOOL asyncLoad;
	BOOL initialLoadDone;
	
	NSTimer *downloadTimer;
	NSThread *downloadThread;
	
	float maxDistance;
	
	BOOL changeViewAllowed;
	
	MRRootViewController *RVC;
}

@property(nonatomic, retain) NSMutableArray *objectsArray;
@property(assign) MRRootViewController *RVC;
//props

@property BOOL initialLoadDone;
@property BOOL changeViewAllowed;
@property BOOL running;
@property BOOL startDownloading;
@property BOOL asyncLoad;
@property BOOL downloading;
@property BOOL urlDone;

@property (nonatomic, assign) WMConcreteSubject *concreteSubject;

@property (assign) id <MRObjectManagerStateProtocol> state;
@property (assign) id <MRObjectManagerStateProtocol> stateDownloadingURL;
@property (assign) id <MRObjectManagerStateProtocol> stateDoneProcessing; 

+(MRObjectManager*) sharedInstance;
-(void) startDownload;
-(void) download;
-(void) addObject:(id<WMGameObjectProtocol>) object;
-(void) removeObject:(id<WMGameObjectProtocol>) object;
-(void) removeAllObjects;

-(void) asyncDownloadURL;
-(void) downloadURL;
-(void) getURLData:(NSData*) data;
-(void) doneProcessingModels;

-(BOOL) objectExists:(int) ID;
-(BOOL) objectInRange:(CLLocation*) location;
-(void) disposeDeadObjects:(NSArray*) newObjects;

-(void) stop;
-(void) start;
@end
