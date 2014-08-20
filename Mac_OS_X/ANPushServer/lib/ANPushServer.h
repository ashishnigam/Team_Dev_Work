//
//  ANPushServer.h
//  ANPushServer
//
//  Created by Ashish Nigam on 26/03/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "constants.h"


@class ANNotification, ANSSLPushGatewayConnection;

@interface ANPushServer : NSObject

@property (nonatomic, readonly) ANSSLPushGatewayConnection *connection;

+ (NSString *)stringFromResult:(ANPusherServerResultCode)result;

#if !TARGET_OS_IPHONE
-(ANPusherServerResultCode)connectWithCertificateRef:(SecCertificateRef)certificateRef;
#endif

-(ANPusherServerResultCode)connectWithIdentityRef:(SecIdentityRef)identityRef;
-(ANPusherServerResultCode)connectWithP12OrPKCS12Data:(NSData*) p12data password:(NSString*)password;

- (ANPusherServerResultCode)pushPayload:(NSString *)payload token:(NSString *)token identifier:(NSUInteger)identifier;
- (ANPusherServerResultCode)pushNotification:(ANNotification *)notification type:(ANNotificationType)notificationType;
- (ANPusherServerResultCode)fetchFailedIdentifier:(NSUInteger *)identifier;

-(ANPusherServerResultCode)reconnect;
-(void)disconnect;


@end
