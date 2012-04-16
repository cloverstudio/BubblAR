//
//  HttpReader.m
//  vijesti
//
//  Created by Bruno on 5/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HttpReader.h"

static HttpReader *_HttpReader = nil;

@implementation HttpReader

@synthesize invocation;
@synthesize receivedData;
@synthesize delegate;

-(HttpReader *) readUrl:(NSURL *)p_url encoding:(NSStringEncoding)p_encoding delegate:(id)p_delegate{
	
	url = p_url;
	encoding = p_encoding;
	if (receivedData != nil) 
		[receivedData release];
	
	receivedData = [[NSMutableData alloc] initWithLength:1];//[[NSMutableString alloc] initWithString:@""

	self.delegate = p_delegate;
	
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:10.0f];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	[connection release];
		
	return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if(receivedData != nil)
	{
		[receivedData appendData:data];
	}
	/*
	NSString *tmp = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:encoding];
	
	if(tmp != nil)
		[receivedString appendString:tmp];
	 */
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	
	
	//if(delegate && [delegate respondsToSelector:@selector(dataReceived:)]){
	if(delegate){
		[delegate dataReceived:receivedData];
	}
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	
	if(delegate){
		[delegate connectionError];
	}
}

+(HttpReader *)getInstance
{
	@synchronized([HttpReader class])
	{
		if (!_HttpReader)
			_HttpReader = [[self alloc] init];
		
		return _HttpReader;
	}
	
	// to avoid compiler warning
	return nil;
}


@end
