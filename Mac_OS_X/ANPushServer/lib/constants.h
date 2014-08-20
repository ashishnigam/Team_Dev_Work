//
//  constants.h
//  ANPushServer
//
//  Created by Ashish Nigam on 28/03/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#ifndef ANPushServer_constants_h
#define ANPushServer_constants_h

typedef enum {
    kANPusherResultSuccess = -1,
    // APN error codes
    kANPusherResultAPNNoErrorsEncountered = 0,
    kANPusherResultAPNProcessingError = 1,
    kANPusherResultAPNMissingDeviceToken = 2,
    kANPusherResultAPNMissingTopic = 3,
    kANPusherResultAPNMissingPayload = 4,
    kANPusherResultAPNInvalidTokenSize = 5,
    kANPusherResultAPNInvalidTopicSize = 6,
    kANPusherResultAPNInvalidPayloadSize = 7,
    kANPusherResultAPNInvalidToken = 8,
    kANPusherResultAPNUnknownReason = 9,
    kANPusherResultAPNShutdown = 10,
    // Pusher error codes
    kANPusherResultEmptyPayload = 101,
    kANPusherResultInvalidPayload = 102,
    kANPusherResultEmptyToken = 103,
    kANPusherResultInvalidToken = 104,
    kANPusherResultPayloadTooLong = 105,
    kANPusherResultUnableToReadResponse = 106,
    kANPusherResultUnexpectedResponseCommand = 107,
    kANPusherResultUnexpectedResponseLength = 108,
    kANPusherResultUnexpectedTokenLength = 109,
    kANPusherResultIDOutOfSync = 110,
    kANPusherResultNotConnected = 111,
    // Socket error codes
    kANPusherResultIOConnectFailed = 201,
    kANPusherResultIOConnectSSLContext = 202,
    kANPusherResultIOConnectSocketCallbacks = 203,
    kANPusherResultIOConnectSSL = 204,
    kANPusherResultIOConnectPeerDomain = 205,
    kANPusherResultIOConnectAssignCertificate = 206,
    kANPusherResultIOConnectSSLHandshakeConnection = 207,
    kANPusherResultIOConnectSSLHandshakeAuthentication = 208,
    kANPusherResultIOConnectSSLHandshakeError = 209,
    kANPusherResultIOConnectTimeout = 218,
    kANPusherResultIOReadDroppedByServer = 210,
    kANPusherResultIOReadConnectionError = 211,
    kANPusherResultIOReadConnectionClosed = 212,
    kANPusherResultIOReadError = 213,
    kANPusherResultIOWriteDroppedByServer = 214,
    kANPusherResultIOWriteConnectionError = 215,
    kANPusherResultIOWriteConnectionClosed = 216,
    kANPusherResultIOWriteError = 217,
    // Tools error codes
    kANPusherResultCertificateInvalid = 301,
    kANPusherResultCertificatePrivateKeyMissing = 302,
    kANPusherResultCertificateCreateIdentity = 303,
    kANPusherResultCertificateNotFound = 304,
    kANPusherResultPKCS12EmptyData = 305,
    kANPusherResultPKCS12InvalidData = 306,
    kANPusherResultPKCS12NoItems = 307,
    kANPusherResultPKCS12NoIdentity = 308,
} ANPusherServerResultCode;

typedef enum {
    kANNotificationType0 = 0,
    kANNotificationType1 = 1,
    kANNotificationType2 = 2,
} ANNotificationType;

#endif
