//
//  ARLabelObject.h
//  infovisionTest
//
//  Created by ken yasue on 3/18/10.
//  Copyright 2010 clover studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ARLabelObject : NSObject {
	
	NSString *title;
	NSString *url;
	NSString *description;
	float	longitude;
	float	latitude;
	float	altitude;
	int		labelId;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *description;
@property (readwrite) float longitude;
@property (readwrite) float latitude;
@property (readwrite) float altitude;
@property (readwrite) int labelId;


@end
