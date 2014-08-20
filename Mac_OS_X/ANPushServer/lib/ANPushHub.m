//
//  ANPushHub.m
//  ANPushServer
//
//  Created by Ashish Nigam on 26/03/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import "ANPushHub.h"


@interface ANPushHub()
{
    
}

- (BOOL)pushNotification:(ANNotification *)notification autoReconnect:(BOOL)reconnectVal;
- (BOOL)fetchFailed;
@end

@implementation ANPushHub
{
    NSUInteger index;
    NSMutableDictionary *notificationForIdentifier;
}

- (id)init
{
    return [self initWithPushServer:[[ANPushServer alloc] init] delegate:nil];
}

- (id)initWithDelegate:(id<ANHubDelegate>)delegate
{
    return [self initWithPushServer:[[ANPushServer alloc] init] delegate:delegate];
}

-(id)initWithPushServer:(ANPushServer *) pushServer delegate:(id<ANHubDelegate>)delegate
{
    self = [super init];
    if (self) {
        index = 1;
        self.feedbackTime = 30;
        self.pushServer = pushServer;
        self.hubDelegate = delegate;
        notificationForIdentifier = @{}.mutableCopy;
        self.notificationType = kANNotificationType2;
    }
    return self;
}


#pragma mark - Connecting

#if !TARGET_OS_IPHONE
-(ANPusherServerResultCode)connectWithCertificateRef:(SecCertificateRef)certificate
{
    return [_pushServer connectWithCertificateRef:certificate];
}
#endif

- (ANPusherServerResultCode)connectWithIdentityRef:(SecIdentityRef)identity
{
    return [_pushServer connectWithIdentityRef:identity];
}

-(ANPusherServerResultCode)connectWithP12OrPKCS12Data:(NSData*) p12data password:(NSString*)password
{
    return [_pushServer connectWithP12OrPKCS12Data:p12data password:password];
}

- (ANPusherServerResultCode)reconnect
{
    return [_pushServer reconnect];
}

- (void)disconnect
{
    [_pushServer disconnect];
}

#pragma mark push methods

- (NSUInteger)pushPayload:(NSString *)payload withToken:(NSString *)token
{
    NSUInteger identifier = index++;
    ANNotification *notification = [[ANNotification alloc] initWithPayload:payload token:token identifier:identifier expirationDate:nil priority:0];
    
    return [self pushNotifications:@[notification] autoReconnect:YES];
    
}
- (NSUInteger)pushPayload:(NSString *)payload withTokens:(NSArray *)tokens
{
    NSMutableArray *notifications = @[].mutableCopy;
    for (NSString *token in tokens) {
    NSUInteger identifier = index++;
    ANNotification *notification = [[ANNotification alloc] initWithPayload:payload token:token identifier:identifier expirationDate:nil priority:0];
        [notifications addObject:notification];
    }
    return [self pushNotifications:notifications autoReconnect:YES];
    
}
- (NSUInteger)pushPayloads:(NSArray *)payloads withToken:(NSString *)token
{
    NSMutableArray *notifications = @[].mutableCopy;
    for (NSString *payload in payloads) {
    NSUInteger identifier = index++;
    ANNotification *notification = [[ANNotification alloc] initWithPayload:payload token:token identifier:identifier expirationDate:nil priority:0];
        [notifications addObject:notification];
    }
    return [self pushNotifications:notifications autoReconnect:YES];
    
}
- (NSUInteger)pushNotifications:(NSArray *)notifications autoReconnect:(BOOL)reconnect
{
    NSUInteger count = 0;
    for (ANNotification *notification in notifications) {
        if (!notification.identifier) notification.identifier = index++;
        BOOL failed = [self pushNotification:notification autoReconnect:reconnect];
        if (failed) count++;
    }
    return count;
}

- (BOOL)pushNotification:(ANNotification *)notification autoReconnect:(BOOL)reconnectVal
{
    ANPusherServerResultCode pushReturnCore = [_pushServer pushNotification:notification type:_notificationType];
    if (pushReturnCore != kANPusherResultSuccess) {
        [self.hubDelegate notification:notification didFailWithResult:pushReturnCore];
    }
    if (reconnectVal && pushReturnCore == kANPusherResultIOWriteConnectionClosed) {
        [self reconnect];
    }
    notificationForIdentifier[@(notification.identifier)] = @[notification, NSDate.date];
    return pushReturnCore != kANPusherResultSuccess;
}

- (BOOL)fetchFailed
{
    NSUInteger identifier = 0;
    ANPusherServerResultCode failed = [_pushServer fetchFailedIdentifier:&identifier];
    if (!identifier) return NO;
    ANNotification *notification = notificationForIdentifier[@(identifier)][0];
    [self.hubDelegate notification:notification didFailWithResult:failed];
    return YES;
}

- (NSUInteger)collectGarbage
{
    NSDate *oldBefore = [NSDate dateWithTimeIntervalSinceNow:-_feedbackTime];
    NSArray *old = [[notificationForIdentifier keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
        return [oldBefore compare:obj[1]] == NSOrderedDescending;
    }] allObjects];
    [notificationForIdentifier removeObjectsForKeys:old];
    return old.count;
}


- (NSUInteger)flushError
{
    NSUInteger count = 0;
    for (BOOL failed = YES; failed; count++) {
        failed = [self fetchFailed];
    }
    [self collectGarbage];
    return count - 1;    
}
@end
