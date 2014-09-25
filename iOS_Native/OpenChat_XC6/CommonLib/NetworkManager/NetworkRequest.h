//
//  NetworkRequest.h
//  OpenChat
//
//  Created by Ashish Nigam on 25/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ResponseDataDelegate
-(void) notifyResponse:(NSMutableArray *) data Error:(NSError*) error;
@end

@interface NetworkRequest : NSOperation
{
    id <ResponseDataDelegate> responseDataDelegate;
}


@property (nonatomic,readonly) NSString *connectionURL;
@property (nonatomic,assign) id <ResponseDataDelegate>delegate;
@property (nonatomic, strong) NSDictionary * queryParameters;
@property (nonatomic, copy) NSString * HTTPMethod; //GET, POST, PUT, DELETE, UPDATE

- (id)initWithURLString:(NSString*)url delegate:(id)delegate;
@end
