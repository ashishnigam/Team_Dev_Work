//
//  NetworkRequest.m
//  OpenChat
//
//  Created by Ashish Nigam on 25/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import "NetworkRequest.h"

@interface NetworkRequest ()
{
    BOOL executing_;
    BOOL finished_;
    BOOL cancelled_;
}

@end

@implementation NetworkRequest



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

-(void) start
{
    if(finished_ || [self isCancelled]){
        [self done];
        return;
    }
    [self willChangeValueForKey:@"isExecuting"];
    executing_ = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    NSURL *urlStringFormed = [self connectionURLfromString:[NSMutableString stringWithString:_connectionURL] usingEncoding:NSASCIIStringEncoding];
    
    NSMutableURLRequest *urlRequest = [self formRequestWithURL:urlStringFormed cachePolicy:NSURLRequestReloadIgnoringCacheData andTimeInterval:20.0];
    
    [urlRequest setHTTPMethod:_HTTPMethod];
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
    [self replySynchronousResponse:error response:response data:data];
    
}

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

-(void) done
{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    executing_ = NO;
    finished_ = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
    
}

- (void)cancel
{
    [super cancel];
    responseDataDelegate = nil;
    cancelled_ = YES;
    [self done];
}

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

-(BOOL)isReady
{
    return NO;//will change
}

- (void)main
{
    
}
@end
