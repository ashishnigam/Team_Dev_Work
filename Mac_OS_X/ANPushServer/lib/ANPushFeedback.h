//
//  ANPushFeedback.h
//  ANPushServer
//
//  Created by Ashish Nigam on 27/03/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ANSecTools.h"

@interface ANPushFeedback : NSObject

#if !TARGET_OS_IPHONE
- (ANPusherServerResultCode)connectWithCertificateRef:(SecCertificateRef)certificateRef;
#endif
- (ANPusherServerResultCode)connectWithIdentityRef:(SecIdentityRef)identityRef;
- (ANPusherServerResultCode)connectWithP12OrPKCS12Data:(NSData *)data password:(NSString *)password;
- (ANPusherServerResultCode)readTokenData:(NSData **)token date:(NSDate **)date;
- (ANPusherServerResultCode)readToken:(NSString **)token date:(NSDate **)date;
- (ANPusherServerResultCode)readTokenDatePairs:(NSArray **)toekDatePairs max:(NSUInteger)max;
- (void)disconnect;

@end
