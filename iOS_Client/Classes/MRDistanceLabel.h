//
//  MRDistanceLabel.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 3/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MRDistanceLabel : NSObject {

	NSMutableArray *numbersArray;
}


+(MRDistanceLabel*) sharedInstance;
-(CGRect) drawNumber:(int) num atOrigin:(CGPoint) origin;

@end
