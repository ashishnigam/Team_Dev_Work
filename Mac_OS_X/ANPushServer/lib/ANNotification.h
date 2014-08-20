//
//  ANNotification.h
//  ANPushServer
//
//  Created by Ashish Nigam on 27/03/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "constants.h"

@interface ANNotification : NSObject

@property (nonatomic, strong) NSString *payload;
@property (nonatomic, strong) NSData *payloadData;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSData *tokenData;
@property (nonatomic, assign) NSUInteger identifier;
@property (nonatomic, strong) NSDate *expirationDate;
@property (nonatomic, assign) NSUInteger expirationStamp;
@property (nonatomic, assign) NSUInteger priority;
@property (nonatomic, assign) BOOL addExpiration;


- (id)initWithPayload:(NSString *)payload token:(NSString *)token identifier:(NSUInteger)identifier expirationDate:(NSDate *)expirationDate priority:(NSUInteger)priority;

- (id)initWithPayloadData:(NSData *)payload tokenData:(NSData *)token identifier:(NSUInteger)identifier expirationStamp:(NSUInteger)expirationStamp addExpiration:(BOOL)addExpiration priority:(NSUInteger)priority;

- (NSData *)dataWithType:(ANNotificationType)type;
+ (ANPusherServerResultCode)parseAPNSResponseData:(NSData *)data withIdentifier:(NSUInteger *)identifier;

+ (NSData *)dataFromHex:(NSString *)hex;
+ (NSString *)hexFromData:(NSData *)data;

@end
