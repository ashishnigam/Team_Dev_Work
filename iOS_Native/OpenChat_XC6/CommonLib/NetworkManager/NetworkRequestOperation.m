//
//  NetworkRequest.m
//  OpenChat
//
//  Created by Ashish Nigam on 25/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import "NetworkRequestOperation.h"

@interface NetworkRequestOperation ()
{
    BOOL executing_;
    BOOL finished_;
    BOOL cancelled_;
    BOOL ready_;
}

@end

@implementation NetworkRequestOperation
{
    BOOL macroDefined;
    NSURLConnection *asyncConnection;
    NSRunLoop* asyncConnRunLoop;
    NSPort* asyncConnRunLoopPort;
    
    BOOL userWillImplementDelegate;
    
    // will be defined by developer
    BOOL needAsyncDelegate;
    BOOL needSyncDelegate;
    BOOL willHandleConnectionDelegate;
}



- (id)initWithURLString:(NSString*)url delegate:(id)delegate{
    self = [super init];
    if(self != nil)
    {
        _connectionURL = [url copy];
        self.delegate = delegate;
        
    }
    return self;
}

-(NSURL*)connectionURLfromString:(NSMutableString*)urlString usingEncoding:(NSStringEncoding)encoding
{
    NSMutableString *urlStr;
    if (_queryParameters) {
        urlStr = [self urlString:urlString withQueryParameter:_queryParameters];
    }else{
        urlStr = urlString;//[self urlString:urlString withQueryParameter:nil];
    }
    
    NSString *str1 = [urlStr stringByAddingPercentEscapesUsingEncoding:encoding];
    return [NSURL URLWithString:str1];
}

-(NSMutableURLRequest*)formRequestWithString:(NSMutableString*)urlString usingEncoding:(NSStringEncoding)encoding cachePolicy:(NSURLRequestCachePolicy)cachePolicy andTimeInterval:(NSTimeInterval)interval
{
    NSURL *connURL = [self connectionURLfromString:urlString usingEncoding:encoding];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:connURL cachePolicy:cachePolicy timeoutInterval:interval];
    return urlRequest;
}

-(NSMutableURLRequest*)formRequestWithURL:(NSURL*)url cachePolicy:(NSURLRequestCachePolicy)cachePolicy andTimeInterval:(NSTimeInterval)interval
{
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:cachePolicy timeoutInterval:interval];
    return urlRequest;
}

-(NSMutableString*)urlString:(NSMutableString*)urlString withQueryParameter:(NSDictionary*)dict
{
    NSMutableString *urlStr = [urlString mutableCopy];
    
    for (NSString * key in dict) {
        [urlStr appendFormat:@"&%@=%@",key,[dict valueForKey:key]];
    }
    
    return urlStr;
}

-(NSMutableURLRequest*)addHeaders:(NSURLRequest*)urlRequest fromDict:(NSDictionary*)headerKeyValue
{
    NSMutableURLRequest *urlReq = [urlRequest mutableCopy];
    
    for (NSString * key in headerKeyValue) {
        [urlReq addValue:[headerKeyValue valueForKey:key] forHTTPHeaderField:(NSString *)key];
    }
    
    return urlReq;
}
// start method override is required for concurrent operation, whilte for non-concurrent operations override main method.

-(void)sendSyncRequest
{
    NSURL *urlStringFormed = [self connectionURLfromString:[NSMutableString stringWithString:_connectionURL] usingEncoding:NSASCIIStringEncoding];
    
    NSMutableURLRequest *urlRequest = [self formRequestWithURL:urlStringFormed cachePolicy:NSURLRequestReloadIgnoringCacheData andTimeInterval:20.0];
    
    [urlRequest setHTTPMethod:_HTTPMethod];
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
    [self replySynchronousResponse:error response:response data:data];
}

-(void)sendAsyncRequest
{
    NSURL* url = [self connectionURLfromString:[NSMutableString stringWithString:_connectionURL] usingEncoding:NSASCIIStringEncoding];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    asyncConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO]; // ivar
    
#if !__has_feature(objc_arc)
    [request release];
    [url release];
#endif
    // Here is the trick
    asyncConnRunLoopPort = [NSPort port];
    asyncConnRunLoop = [NSRunLoop currentRunLoop]; // Get the runloop
    [asyncConnRunLoop addPort:asyncConnRunLoopPort forMode:NSDefaultRunLoopMode];
    [asyncConnection scheduleInRunLoop:asyncConnRunLoop forMode:NSDefaultRunLoopMode];
    [asyncConnection start];
    [asyncConnRunLoop run];
}

//#define needAsyncCallBack = Yes
//#define needSyncCallBack = Yes

// NSOperation subclass implementation starts here

-(void) start
{
    if(finished_ || [self isCancelled]){
        [self done];
        return;
    }
    [self willChangeValueForKey:@"isExecuting"];
    executing_ = YES;
    macroDefined = NO;
    [self didChangeValueForKey:@"isExecuting"];
    
#ifdef needAsyncCallBack
     macroDefined = YES;
    [self sendAsyncRequest];
#endif
    
#ifdef needSyncCallBack
     macroDefined = YES;
    [self sendSyncRequest];
#endif

    if (!macroDefined) {
        if (needAsyncDelegate) {
            [self sendAsyncRequest];
        }else{
            [self sendSyncRequest];
        }
    }
    
}

-(void) done
{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    executing_ = NO;
    finished_ = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
    
    if (asyncConnRunLoop) {
        [asyncConnRunLoop removePort:asyncConnRunLoopPort forMode:NSDefaultRunLoopMode];
    }
    if (asyncConnection && asyncConnRunLoop) {
        [asyncConnection unscheduleFromRunLoop:asyncConnRunLoop forMode:NSDefaultRunLoopMode];
    }
    asyncConnRunLoop = nil;
    asyncConnection = nil;
    asyncConnRunLoopPort = nil;
    
}

- (void)cancel
{
    [super cancel];
    responseDataDelegate = nil;
    cancelled_ = YES;
    [self done];
}

/// Apple doc says: Your own code should not have to send KVO notifications for this key path
// Thats why not sending KVO notification like for isFinished or isExecuting

//   [self willChangeValueForKey:@"isExecuting"];
//   [self willChangeValueForKey:@"isFinished"];

-(BOOL)isCancelled{
    return cancelled_;
}

- (BOOL)isExecuting
{
    return executing_;
}

- (BOOL)isFinished{
    return finished_;
}

- (BOOL)isConcurrent{
    return YES;
}

-(BOOL)isAsynchronous
{
    return YES;
}

// check for dealloc requirement
-(void)dealloc
{
    if (asyncConnRunLoop) {
        [asyncConnRunLoop removePort:asyncConnRunLoopPort forMode:NSDefaultRunLoopMode];
    }
    if (asyncConnection && asyncConnRunLoop) {
        [asyncConnection unscheduleFromRunLoop:asyncConnRunLoop forMode:NSDefaultRunLoopMode];
    }
    asyncConnRunLoop = nil;
    asyncConnection = nil;
    asyncConnRunLoopPort = nil;
}

// Apple doc says, its not required to implement this method until NSOperation dependency is based on your program.
//https://developer.apple.com/LIBRARY/ios/documentation/Cocoa/Reference/NSOperation_class/index.html
/*
-(BOOL)isReady
{
  //value of ready_ should be derived from your program logic if you have some external dependency
  // when user adds dependency using adddependency method then he can check the ready state with isReady default implementation.
 
  // Apple Doc: In most cases, you do not have to manage the state of this key path yourself.
 
    return ready_;

}
*/

// main method override is required for non-concurrent operation, whilte for concurrent operations override start method.
/*
- (void)main
{
    
}
*/

// Sync URLConnection Delegates
-(void)replySynchronousResponse:(NSError*)error response:(NSURLResponse*)response data:(NSData*)data
{
    if(error)
        [responseDataDelegate notifyResponse:nil Error:error];
    else{
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger statusCode = [httpResponse statusCode];
        if( statusCode == 200 ) {
            
            // Do data Parsing or play with response
            
            //            xmlParser_ = [[NSXMLParser alloc] initWithData:data];
            //            xmlParser_.delegate = self;
            //            [xmlParser_ parse];
            
            [responseDataDelegate notifyResponse:[data mutableCopy] Error:nil];
            
        } else {
            NSString* statusError  = [NSString stringWithFormat:NSLocalizedString(@"HTTP Error: %ld", nil), statusCode];
            NSDictionary* userInfo = [NSDictionary dictionaryWithObject:statusError forKey:NSLocalizedDescriptionKey];
            NSError *err = [NSError errorWithDomain:@"DownloadUrlOperation"
                                               code:statusCode
                                           userInfo:userInfo];
            [responseDataDelegate notifyResponse:nil Error:err];
            [self done];
        }
    }
}

//#if (willHandleConnectionDelegate == YES)
//#endif

// Async URLConnection Delegates

#ifndef willHandleConnectionDelegate
// NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

// will be defined when required, DEPRECATED methods will not be implemented throughout the framework.
/*
 - (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection;
 - (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
 */

// NSURLConnectionDataDelegate

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    return nil;
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
}

- (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request
{
    return nil;
}
- (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
}

// NSURLConnectionDownloadDelegate
- (void)connection:(NSURLConnection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long) expectedTotalBytes
{
    
}
- (void)connectionDidResumeDownloading:(NSURLConnection *)connection totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long) expectedTotalBytes
{
    
}

- (void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *) destinationURL
{
    
}

#endif

@end
