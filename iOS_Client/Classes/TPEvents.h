//
//  TPEvents.h
//  Tadpole
//
//  Created by marko.hlebar on 10/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum 
{
	BUTTON_START = 0,
	BUTTON_OPTIONS,
	BUTTON_HS
} 
BUTTON_NAMES;

typedef struct  {
	NSString *name;
	BOOL onEvent;
} 
TPEvent;
