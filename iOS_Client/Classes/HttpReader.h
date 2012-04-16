//
//  HttpReader.h
//  vijesti
//
//  Created by Bruno on 5/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HttpReaderProtocol
- (void)dataReceived:(NSData *)data;
- (void)connectionError;
@end

@interface HttpReader : NSObject {
	NSInvocation *invocation;
	NSURL *url;
	NSStringEncoding encoding;
	NSMutableData *receivedData;
	
	id <HttpReaderProtocol> delegate;
}

-(HttpReader *) readUrl:(NSURL *)p_url encoding:(NSStringEncoding)p_encoding delegate:(id)p_delegate;

+(HttpReader *)getInstance;

@property (nonatomic, retain) NSInvocation *invocation;
@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, assign) id <HttpReaderProtocol> delegate;

@end


