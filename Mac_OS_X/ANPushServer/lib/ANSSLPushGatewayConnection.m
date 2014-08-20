//
//  ANSSLPushGatewayConnection.m
//  ANPushServer
//
//  Created by Ashish Nigam on 27/03/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import "ANSSLPushGatewayConnection.h"
#import "ioSock.h"
#import <sys/socket.h>

@implementation ANSSLPushGatewayConnection
{
    otSocket otSocketConnection;
    SSLContextRef sslContextRef;
}

- (id)initWithHost:(NSString *)host port:(NSUInteger)port identity:(SecIdentityRef)identityRef
{
    self = [super init];
    if (self) {
        _host = host;
        _port = port;
        _certIdentityRef = identityRef;
       // otSocketConnection = 0;
        CFRetain(identityRef);
    }
    return self;
}

- (void)dealloc
{
    [self disconnect];
    if (_certIdentityRef) CFRelease(_certIdentityRef); _certIdentityRef = NULL;
}


- (ANPusherServerResultCode)connect
{
    PeerSpec spec;
    int nonBlockingConnection = 1;
    
    OSStatus status = MakeServerConnection(_host.UTF8String, (int)_port,nonBlockingConnection, &otSocketConnection, &spec);
    if (status != noErr) {
        [self disconnect];
        return kANPusherResultIOConnectFailed;
    }
    
    sslContextRef = SSLCreateContext(NULL, kSSLClientSide, kSSLStreamType);
    if (!sslContextRef) {
        [self disconnect];
        return kANPusherResultIOConnectSSLContext;
    }
    
    status = SSLSetIOFuncs(sslContextRef, SocketRead, SocketWrite);
    if (status != noErr) {
        [self disconnect];
        return kANPusherResultIOConnectSocketCallbacks;
    }
    
    // otSock typedef chaged in ioSock.h file,so changes made to take care differences
    status = SSLSetConnection(sslContextRef, (SSLConnectionRef)otSocketConnection);
    if (status != noErr) {
        [self disconnect];
        return kANPusherResultIOConnectSSL;
    }
    
    status = SSLSetPeerDomainName(sslContextRef, _host.UTF8String, strlen(_host.UTF8String));
    if (status != noErr) {
        [self disconnect];
        return kANPusherResultIOConnectPeerDomain;
    }
    
    CFArrayRef certificates = CFArrayCreate(NULL, (const void **)&_certIdentityRef, 1, NULL);
    status = SSLSetCertificate(sslContextRef, certificates);
    CFRelease(certificates);
    if (status != noErr) {
        [self disconnect];
        return kANPusherResultIOConnectAssignCertificate;
    }
    
    status = errSSLWouldBlock;
    for (NSUInteger i = 0; i < 1 << 26 && status == errSSLWouldBlock; i++) {
        status = SSLHandshake(sslContextRef);
    }
    if (status != noErr) {
        [self disconnect];
        switch (status) {
            case ioErr: return kANPusherResultIOConnectSSLHandshakeConnection;
            case errSecAuthFailed: return kANPusherResultIOConnectSSLHandshakeAuthentication;
            case errSSLWouldBlock: return kANPusherResultIOConnectTimeout;
        }
        return kANPusherResultIOConnectSSLHandshakeError;
    }
    
    int set = 1;
    setsockopt((int)otSocketConnection, SOL_SOCKET, SO_NOSIGPIPE, (void *)&set, sizeof(int));
    
    return kANPusherResultSuccess;
}
- (ANPusherServerResultCode)read:(NSMutableData *)data length:(NSUInteger *)length
{
    size_t processed = 0;
    void *bytes = data.mutableBytes;
    OSStatus status = errSSLWouldBlock;
    for (NSUInteger i = 0; i < 4 && status == errSSLWouldBlock; i++) {
        status = SSLRead(sslContextRef, bytes, data.length, &processed);
    }
    if (status != noErr && status != errSSLWouldBlock) {
        switch (status) {
            case ioErr: return kANPusherResultIOReadDroppedByServer;
            case errSSLClosedAbort: return kANPusherResultIOReadConnectionError;
            case errSSLClosedGraceful: return kANPusherResultIOReadConnectionClosed;
        }
        return kANPusherResultIOReadError;
    }
    
    if (length) *length = processed;
    return kANPusherResultSuccess;
}
- (ANPusherServerResultCode)write:(NSData *)data length:(NSUInteger *)length
{
    size_t processed = 0;
    const void *bytes = data.bytes;
    OSStatus status = errSSLWouldBlock;
    for (NSUInteger i = 0; i < 4 && status == errSSLWouldBlock; i++) {
        status = SSLWrite(sslContextRef, bytes, data.length, &processed);
    }
    if (status != noErr && status != errSSLWouldBlock) {
        switch (status) {
            case ioErr: return kANPusherResultIOWriteDroppedByServer;
            case errSSLClosedAbort: return kANPusherResultIOWriteConnectionError;
            case errSSLClosedGraceful: return kANPusherResultIOWriteConnectionClosed;
        }
        return kANPusherResultIOWriteError;
    }
    
    if (length) *length = processed;
    return kANPusherResultSuccess;
}
- (ANPusherServerResultCode)reconnect
{
    [self disconnect];
    return [self connect];
}

- (SecCertificateRef)certificateRef
{
    SecCertificateRef result = NULL;
    OSStatus status = SecIdentityCopyCertificate(_certIdentityRef, &result);
    if (status != noErr) return nil;
    return result;
}

- (SecCertificateRef)certificate
{
    return [self certificateRef];
}


- (void)disconnect
{
    if (sslContextRef) SSLClose(sslContextRef);
    if (otSocketConnection) close((int)otSocketConnection); otSocketConnection = 0; // due to changes in two version of ioSock source
    if (sslContextRef) CFRelease(sslContextRef); sslContextRef = NULL;
}

@end
