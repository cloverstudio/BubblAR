//
//  MRLabelManager.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 3/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMGameObject.h"
#import "HttpReader.h"

@class WMConcreteSubject;
@class MRLabel;
@interface MRLabelManager : NSObject <WMGameObjectProtocol, HttpReaderProtocol>
{

	NSMutableArray *labelsArray;
		
	WMConcreteSubject *concreteSubject;
}

@property (nonatomic, assign) WMConcreteSubject *concreteSubject;

-(id) initWithSubject:(WMConcreteSubject*) subject;
-(void) addObject:(MRLabel*) label;
-(void) removeObject:(MRLabel*) label;

@end
