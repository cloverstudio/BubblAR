//
//  MRPolis.h
//  MarketRaidBeta
//
//  Created by marko.hlebar on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MRPolis : NSObject {

	NSString *title;
	NSString *description;
	UIImage *iconImage;
	NSURL *imageUrl;
	NSURL *url;
	BOOL dispose;

}

@property BOOL dispose;

@property (nonatomic, assign) NSString *title;
@property (nonatomic, assign) NSString *description;
@property (nonatomic, assign) UIImage *iconImage;
@property (nonatomic, assign) NSURL *imageUrl;
@property (nonatomic, assign) NSURL *url;

-(id) initWithTitle:(NSString*)titleArg 
	 andDescription:(NSString*) descriptionArg 
	   andIconImage:(UIImage*) iconImageArg
		andImageUrl:(NSURL*) imageUrlArg 
			 andUrl:(NSURL*) urlArg;

@end
