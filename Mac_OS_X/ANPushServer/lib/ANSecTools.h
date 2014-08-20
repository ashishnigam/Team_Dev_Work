//
//  ANSecTools.h
//  ANPushServer
//
//  Created by Ashish Nigam on 26/03/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "constants.h"

@interface ANSecTools : NSObject

#if !TARGET_OS_IPHONE
+ (ANPusherServerResultCode)identityWithCertificateRef:(SecCertificateRef)certificateRef andIdentity:(SecIdentityRef*)identityRef;
+ (ANPusherServerResultCode)identityWithCertificateDate:(NSData*)certificateData andIdentity:(SecIdentityRef*)identityRef;
#endif
+ (ANPusherServerResultCode)identityWithP12OrPKCS12Data:(NSData*)pkcs12Data password:(NSString*)password andIdentity:(SecIdentityRef*)identityRef;

+(NSArray*)keychainCertificates:(id)fromStore;
+(BOOL)isDevelopmentCertificate:(SecCertificateRef)certificateRef;
+ (NSString *)identifierForCertificate:(SecCertificateRef)certificate;
+ (SecCertificateRef)certificateForIdentity:(SecIdentityRef)identity;


@end
