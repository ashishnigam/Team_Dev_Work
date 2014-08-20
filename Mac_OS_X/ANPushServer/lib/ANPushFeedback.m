//
//  ANPushFeedback.m
//  ANPushServer
//
//  Created by Ashish Nigam on 27/03/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import "ANPushFeedback.h"

#import "ANNotification.h"
#import "ANSSLPushGatewayConnection.h"


static NSString * const applePushSandboxHost = @"feedback.sandbox.push.apple.com";
static NSString * const applePushHost = @"feedback.push.apple.com";
static NSUInteger const applePushFeedbackPort = 2196;
static NSUInteger const applePushTokenMaxSize = 32;

@implementation ANPushFeedback
{
    ANSSLPushGatewayConnection *sslConnection;
}

#if !TARGET_OS_IPHONE
- (ANPusherServerResultCode)connectWithCertificateRef:(SecCertificateRef)certificateRef
{
    SecIdentityRef identity = NULL;
    ANPusherServerResultCode result = [ANSecTools identityWithCertificateRef:certificateRef andIdentity:&identity];
    if (result != kANPusherResultSuccess) {
        if (identity) CFRelease(identity);
        return result;
    }
    result = [self connectWithIdentityRef:identity];
    if (identity) CFRelease(identity);
    return result;
}
#endif

- (ANPusherServerResultCode)connectWithIdentityRef:(SecIdentityRef)identityRef
{
    SecCertificateRef certificate = [ANSecTools certificateForIdentity:identityRef];
    BOOL sandbox = [ANSecTools isDevelopmentCertificate:certificate];
    NSString *host = sandbox ? applePushSandboxHost : applePushHost;
    
    if (sslConnection) [sslConnection disconnect]; sslConnection = nil;
    ANSSLPushGatewayConnection *localSSLConnection = [[ANSSLPushGatewayConnection alloc] initWithHost:host port:applePushFeedbackPort identity:identityRef];
    
    ANPusherServerResultCode resultCode = [localSSLConnection connect];
    if (resultCode == kANPusherResultSuccess) {
        sslConnection = localSSLConnection;
    }
    return resultCode;
}

- (ANPusherServerResultCode)connectWithP12OrPKCS12Data:(NSData *)data password:(NSString *)password
{
    SecIdentityRef identity = NULL;
    ANPusherServerResultCode result = [ANSecTools identityWithP12OrPKCS12Data:data password:password andIdentity:&identity];
    if (result != kANPusherResultSuccess) {
        if (identity) CFRelease(identity);
        return result;
    }
    result = [self connectWithIdentityRef:identity];
    if (identity) CFRelease(identity);
    return result;
}
- (ANPusherServerResultCode)readTokenData:(NSData **)token date:(NSDate **)date
{
    NSMutableData *data = [NSMutableData dataWithLength:sizeof(uint32_t) + sizeof(uint16_t) + applePushTokenMaxSize];
    NSUInteger length = 0;
    ANPusherServerResultCode read = [sslConnection read:data length:&length];
    if (read != kANPusherResultSuccess) {
        return read;
    }
    if (length != data.length) {
        return kANPusherResultUnexpectedResponseLength;
    }
    
    uint32_t time = 0;
    [data getBytes:&time range:NSMakeRange(0, 4)];
    if (date) *date = [NSDate dateWithTimeIntervalSince1970:htonl(time)];
    
    uint16_t l = 0;
    [data getBytes:&l range:NSMakeRange(4, 2)];
    NSUInteger tokenLength = htons(l);
    if (tokenLength != applePushTokenMaxSize) {
        return kANPusherResultUnexpectedTokenLength;
    }
    
    if (token) *token = [data subdataWithRange:NSMakeRange(6, length - 6)];
    
    return kANPusherResultSuccess;
}
- (ANPusherServerResultCode)readToken:(NSString **)token date:(NSDate **)date
{
    NSData *data = nil;
    ANPusherServerResultCode read = [self readTokenData:&data date:date];
    if (read != kANPusherResultSuccess) {
        return read;
    }
    *token = [ANNotification hexFromData:data];
    return read;
}

- (ANPusherServerResultCode)readTokenDatePairs:(NSArray **)toekDatePairs max:(NSUInteger)max
{
    NSMutableArray *all = @[].mutableCopy;
    *toekDatePairs = all;
    for (NSUInteger i = 0; i < max; i++) {
        NSString *token = nil;
        NSDate *date = nil;
        ANPusherServerResultCode readCode = [self readToken:&token date:&date];
        if (readCode == kANPusherResultIOReadConnectionClosed) {
            break;
        }
        if (readCode != kANPusherResultSuccess) {
            return readCode;
        }
        if (token && date) {
            [all addObject:@[token, date]];
        }
    }
    return kANPusherResultSuccess;
}

- (void)disconnect
{
    [sslConnection disconnect]; sslConnection = nil;
}

@end
