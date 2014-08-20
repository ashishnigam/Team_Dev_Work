//
//  ANPushHub.h
//  ANPushServer
//
//  Created by Ashish Nigam on 26/03/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANPushServer.h"
#import "ANNotification.h"

@protocol ANHubDelegate;

// it will connect with Push Server and resturn what server will return.

@interface ANPushHub : NSObject

@property (nonatomic,strong) ANPushServer *pushServer;
@property (nonatomic,assign) id<ANHubDelegate> hubDelegate;
@property (nonatomic,assign) ANNotificationType notificationType;
@property (nonatomic,assign) NSTimeInterval feedbackTime;


-(id)initWithDelegate: (id<ANHubDelegate>)delegate;
-(id)initWithPushServer:(ANPushServer *) pushServer delegate:(id<ANHubDelegate>)delegate;

#if !TARGET_OS_IPHONE
-(ANPusherServerResultCode)connectWithCertificateRef:(SecCertificateRef)certificate;
#endif

-(ANPusherServerResultCode)connectWithIdentityRef:(SecIdentityRef)identifyRef;
-(ANPusherServerResultCode)connectWithP12OrPKCS12Data:(NSData*) p12data password:(NSString*)password;
-(ANPusherServerResultCode)reconnect;
-(void)disconnect;

#pragma mark push methods

- (NSUInteger)pushPayload:(NSString *)payload withToken:(NSString *)token;
- (NSUInteger)pushPayload:(NSString *)payload withTokens:(NSArray *)tokens;
- (NSUInteger)pushPayloads:(NSArray *)payloads withToken:(NSString *)token;
- (NSUInteger)pushNotifications:(NSArray *)notifications autoReconnect:(BOOL)reconnect;
- (NSUInteger)flushError;

@end


@protocol ANHubDelegate <NSObject>

-(void)notification:(ANNotification*)notification didFailWithResult:(ANPusherServerResultCode)pushResultCode;

@end