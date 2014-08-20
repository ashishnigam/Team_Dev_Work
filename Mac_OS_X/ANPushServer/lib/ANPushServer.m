//
//  ANPushServer.m
//  ANPushServer
//
//  Created by Ashish Nigam on 26/03/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import "ANPushServer.h"
#import "ANSSLPushGatewayConnection.h"
#import "ANSecTools.h"
#import "ANNotification.h"

static NSString * const applePushSandboxServer = @"gateway.sandbox.push.apple.com";
static NSString * const applePushServer = @"gateway.push.apple.com";
static NSUInteger const applePushPort = 2195;

@implementation ANPushServer
{
    NSUInteger index;
}

#pragma mark - Helpers

+ (NSString *)stringFromResult:(ANPusherServerResultCode)result
{
    switch (result) {
        case kANPusherResultSuccess: return @"Success";
        case kANPusherResultAPNNoErrorsEncountered: return @"APN: No errors encountered";
        case kANPusherResultAPNProcessingError: return @"APN: Processing error";
        case kANPusherResultAPNMissingDeviceToken: return @"APN: Missing device token";
        case kANPusherResultAPNMissingTopic: return @"APN: Missing topic";
        case kANPusherResultAPNMissingPayload: return @"APN: Missing payload";
        case kANPusherResultAPNInvalidTokenSize: return @"APN: Invalid token size";
        case kANPusherResultAPNInvalidTopicSize: return @"APN: Invalid topic size";
        case kANPusherResultAPNInvalidPayloadSize: return @"APN: Invalid payload size";
        case kANPusherResultAPNInvalidToken: return @"APN: Invalid token (you might need to reconnect now)";
        case kANPusherResultAPNUnknownReason: return @"APN: Unkown reason";
        case kANPusherResultAPNShutdown: return @"APN: Shutdown";
        case kANPusherResultEmptyPayload: return @"Payload is empty";
        case kANPusherResultInvalidPayload: return @"Invalid payload format";
        case kANPusherResultEmptyToken: return @"Device token is emtpy";
        case kANPusherResultInvalidToken: return @"Device token should be 64 hex characters)";
        case kANPusherResultPayloadTooLong: return @"Payload cannot be more than 256 bytes (UTF8)";
        case kANPusherResultUnableToReadResponse: return @"Unable to read response";
        case kANPusherResultUnexpectedResponseCommand: return @"Unexpected response command";
        case kANPusherResultUnexpectedResponseLength: return @"Unexpected response length";
        case kANPusherResultUnexpectedTokenLength: return @"Unexpected token length";
        case kANPusherResultIDOutOfSync: return @"Push identifier out-of-sync :(";
        case kANPusherResultNotConnected: return @"Not connected, connect first";
        case kANPusherResultIOConnectFailed: return @"Unable to create connection to server";
        case kANPusherResultIOConnectSSLContext: return @"Unable create SSL context";
        case kANPusherResultIOConnectSocketCallbacks: return @"Unable to set socket callbacks";
        case kANPusherResultIOConnectSSL: return @"Unable to set SSL connection ";
        case kANPusherResultIOConnectPeerDomain: return @"Unable to set peer domain";
        case kANPusherResultIOConnectAssignCertificate: return @"Unable to assign certificate";
        case kANPusherResultIOConnectSSLHandshakeConnection: return @"Unable to perform SSL handshake, no connection";
        case kANPusherResultIOConnectSSLHandshakeAuthentication: return @"Unable to perform SSL handshake, authentication failed";
        case kANPusherResultIOConnectSSLHandshakeError: return @"Unable to perform SSL handshake";
        case kANPusherResultIOConnectTimeout: return @"Timeout SSL handshake";
        case kANPusherResultIOReadDroppedByServer: return @"Failed to read, connection dropped by server";
        case kANPusherResultIOReadConnectionError: return @"Failed to read, connection error";
        case kANPusherResultIOReadConnectionClosed: return @"Failed to read, connection closed";
        case kANPusherResultIOReadError: return @"Failed to read";
        case kANPusherResultIOWriteDroppedByServer: return @"Failed to write, connection dropped by server";
        case kANPusherResultIOWriteConnectionError: return @"Failed to write, connection error";
        case kANPusherResultIOWriteConnectionClosed: return @"Failed to write, connection closed";
        case kANPusherResultIOWriteError: return @"Failed to write";
        case kANPusherResultCertificateInvalid: return @"Unable to read certificate";
        case kANPusherResultCertificatePrivateKeyMissing: return @"Unable to create identitiy, private key missing";
        case kANPusherResultCertificateCreateIdentity: return @"Unable to create identitiy";
        case kANPusherResultCertificateNotFound: return @"Unable to find certificate";
        case kANPusherResultPKCS12EmptyData: return @"PKCS12 data is empty";
        case kANPusherResultPKCS12InvalidData: return @"Unable to import PKCS12 data";
        case kANPusherResultPKCS12NoItems: return @"No items in PKCS12 data";
        case kANPusherResultPKCS12NoIdentity: return @"No identity in PKCS12 data";
    }
    return @"Unkown";
}

#pragma mark - Apple SSLPush Server Connection

#if !TARGET_OS_IPHONE
-(ANPusherServerResultCode)connectWithCertificateRef:(SecCertificateRef)certificateRef
{
    SecIdentityRef identity = NULL;
    ANPusherServerResultCode resultCode = [ANSecTools identityWithCertificateRef:certificateRef andIdentity:&identity];
    
    if (resultCode != kANPusherResultSuccess) {
        if (identity) CFRelease(identity);
        return resultCode;
    }
    resultCode = [self connectWithIdentityRef:identity];
    if (identity) CFRelease(identity);
    return resultCode;
}
#endif

-(ANPusherServerResultCode)connectWithIdentityRef:(SecIdentityRef)identityRef
{
    SecCertificateRef certificate = [ANSecTools certificateForIdentity:identityRef];
    BOOL sandbox = [ANSecTools isDevelopmentCertificate:certificate];
    NSString *host = sandbox ? applePushSandboxServer : applePushServer;
    
    if (_connection) [_connection disconnect]; _connection = nil;
    ANSSLPushGatewayConnection *connection = [[ANSSLPushGatewayConnection alloc] initWithHost:host port:applePushPort identity:identityRef];
    
    ANPusherServerResultCode result = [connection connect];
    if (result == kANPusherResultSuccess) {
        _connection = connection;
    }
    return result;
}
-(ANPusherServerResultCode)connectWithP12OrPKCS12Data:(NSData*) p12data password:(NSString*)password
{
    SecIdentityRef identity = NULL;
    ANPusherServerResultCode resultCode = [ANSecTools identityWithP12OrPKCS12Data:p12data password:password andIdentity:&identity];
    if (resultCode != kANPusherResultSuccess) {
        if (identity) CFRelease(identity);
        return resultCode;
    }
    resultCode = [self connectWithIdentityRef:identity];
    if (identity) CFRelease(identity);
    return resultCode;
}
-(ANPusherServerResultCode)reconnect
{
    if (!_connection) return kANPusherResultNotConnected;
    return [_connection reconnect];
}

-(void)disconnect
{
     [_connection disconnect]; _connection = nil;
}


#pragma mark - Apple push

- (ANPusherServerResultCode)pushPayload:(NSString *)payload token:(NSString *)token identifier:(NSUInteger)identifier
{
    return [self pushNotification:[[ANNotification alloc] initWithPayload:payload token:token identifier:identifier expirationDate:nil priority:0] type:kANNotificationType2];
}

- (ANPusherServerResultCode)pushNotification:(ANNotification *)notification type:(ANNotificationType)type
{
    return [_connection write:[notification dataWithType:type] length:NULL];
}

- (ANPusherServerResultCode)fetchFailedIdentifier:(NSUInteger *)identifier
{
    NSMutableData *data = [NSMutableData dataWithLength:sizeof(uint8_t) * 2 + sizeof(uint32_t)];
    NSUInteger length = 0;
    ANPusherServerResultCode readReturnCode = [_connection read:data length:&length];
    if (readReturnCode != kANPusherResultSuccess) return kANPusherResultUnableToReadResponse;
    if (!length) return kANPusherResultSuccess;
    return [ANNotification parseAPNSResponseData:data withIdentifier:identifier];
}

@end
