//
//  MRPolisManager.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpReader.h"

#define MAGIC_POLIS_NUM -841984

typedef enum 
{
	POLIS_TYPE_USER = 0,
	POLIS_TYPE_FEATURED = 1
}POLIS_TYPE;	

@protocol MRPolisManagerListener

-(void) updateData;
-(void) downloadError;

@end

@class MRPolis;
@class MRRootViewController;
@interface MRPolisManager : NSObject <HttpReaderProtocol> 
{	
	BOOL downloading;
	BOOL downloadError;
	BOOL doneLoading;
	
	NSMutableArray *polisArray;
	NSMutableArray *listeners;
	
	MRPolis *userPolis;
	NSString *userPolisURL;
	
	BOOL isPolisSelected;
	int selectedPolis;
	int polisType;
	
	NSURL *userUrl;
	
	MRRootViewController *RVC;
}

@property (nonatomic, retain) NSString *userPolisURL;


@property (assign) MRRootViewController *RVC;
@property (nonatomic, retain) NSURL *userUrl;
@property BOOL isPolisSelected;
@property int polisType;
@property int selectedPolis;
@property (nonatomic, retain) NSMutableArray *polisArray;
@property BOOL downloading;
@property BOOL downloadError;
@property BOOL doneLoading;

+(MRPolisManager*) sharedInstance;
-(void) startDownload:(NSString*) strUrl;
-(void) addListener:(id <MRPolisManagerListener>) listener;
-(void) removeListener:(id <MRPolisManagerListener>) listener;
-(void) updateListeners;
-(void) updateListenersForError;
-(BOOL) objectExists:(NSURL*) urlArg;
-(void) disposeDeadObjects:(NSArray*) newObjects;
-(void) reset;
-(MRPolis*) polis;

@end
