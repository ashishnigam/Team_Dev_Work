//
//  ANSSLPushGatewayConnection.h
//  ANPushServer
//
//  Created by Ashish Nigam on 27/03/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "constants.h"

@interface ANSSLPushGatewayConnection : NSObject

@property (nonatomic, strong) NSString *host;
@property (nonatomic, assign) NSUInteger port;
@property (nonatomic, assign) SecIdentityRef certIdentityRef;
@property (nonatomic, readonly) SecCertificateRef certificateRef;

- (id)initWithHost:(NSString *)host port:(NSUInteger)port identity:(SecIdentityRef)identityRef;
- (ANPusherServerResultCode)connect;
- (ANPusherServerResultCode)read:(NSMutableData *)data length:(NSUInteger *)length;
- (ANPusherServerResultCode)write:(NSData *)data length:(NSUInteger *)length;
- (ANPusherServerResultCode)reconnect;
- (void)disconnect;
- (SecCertificateRef)certificate;

@end
