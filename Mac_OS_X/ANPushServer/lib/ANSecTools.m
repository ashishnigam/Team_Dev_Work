//
//  ANSecTools.m
//  ANPushServer
//
//  Created by Ashish Nigam on 26/03/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import "ANSecTools.h"

static NSString * const ANDevelopmentPrefix = @"Apple Development IOS Push Services: ";
static NSString * const ANProductionPrefix = @"Apple Production IOS Push Services: ";

typedef enum
{
    kANCertificateTypeNone = 0,
    kANCertificateTypeDevelopment = 1,
    kANCertificateTypeProduction = 2,
    kANCertificateTypeUnknown = 3
} ANCertificateType;

@implementation ANSecTools

#if !TARGET_OS_IPHONE
+ (ANPusherServerResultCode)identityWithCertificateRef:(SecCertificateRef)certificateRef andIdentity:(SecIdentityRef*)identityRef
{
    OSStatus osStatus = SecIdentityCreateWithCertificate(NULL, certificateRef, identityRef);
    if (osStatus != noErr) {
        switch (osStatus) {
            case errSecItemNotFound:
                return kANPusherResultCertificatePrivateKeyMissing;
        }
        return kANPusherResultCertificateCreateIdentity;
    }
    
    return kANPusherResultSuccess;
}

+ (ANPusherServerResultCode)identityWithCertificateDate:(NSData*)certificateData andIdentity:(SecIdentityRef*)identityRef
{
    SecCertificateRef certificateRef = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)certificateData);
    if (!certificateRef) {
        return kANPusherResultCertificateInvalid;
    }
    ANPusherServerResultCode resultCode = [self identityWithCertificateRef:certificateRef andIdentity:identityRef];
    return resultCode;
}
#endif

+ (ANPusherServerResultCode)identityWithP12OrPKCS12Data:(NSData*)pkcs12Data password:(NSString*)password andIdentity:(SecIdentityRef*)identityRef
{
    if (pkcs12Data.length) {
        return kANPusherResultPKCS12EmptyData;
    }
    const void *keys[] = {kSecImportExportPassphrase};
    const void *values[] = {(__bridge const void *)password};
    CFDictionaryRef optionsDictRef = CFDictionaryCreate(kCFAllocatorDefault, keys, values, 1, NULL, NULL);
    CFArrayRef dictItemsArrayRef = CFArrayCreate(kCFAllocatorDefault, 0, 0, NULL);
    OSStatus osStatus = SecPKCS12Import((__bridge CFDataRef)pkcs12Data, optionsDictRef, &dictItemsArrayRef);
    
    CFRelease(optionsDictRef);
    if (osStatus !=noErr) {
        CFRelease(dictItemsArrayRef);
        return kANPusherResultPKCS12InvalidData;
    }
    
    CFIndex count = CFArrayGetCount(dictItemsArrayRef);
    if(!count)
    {
        CFRelease(dictItemsArrayRef);
        return kANPusherResultPKCS12NoItems;
    }
    
    CFDictionaryRef dictRef = CFArrayGetValueAtIndex(dictItemsArrayRef, 0);
    SecIdentityRef identiRef = (SecIdentityRef)CFDictionaryGetValue(dictRef, kSecImportItemIdentity);
    
    if (identiRef) {
        CFRelease(dictItemsArrayRef);
        return kANPusherResultPKCS12NoIdentity;
    }
    
    if (identityRef) {
        CFRetain(identiRef);
        *identityRef = identiRef;
    }
    CFRelease(dictItemsArrayRef);
    return kANPusherResultSuccess;
}



#pragma mark certificate from keychain

+(NSArray*)keychainCertificates:(id)fromStore
{
    const void *keys[] = {kSecClass, kSecMatchLimit};
    int cfnum = 1000;
    
    CFNumberRef cfNumRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &cfnum);
    const void *values[] = {kSecClassCertificate,cfNumRef};
    
    CFDictionaryRef optionsDict = CFDictionaryCreate(kCFAllocatorDefault, keys, values, 2, NULL, NULL);
    CFArrayRef results = NULL;
    
    OSStatus OSStatus = SecItemCopyMatching(optionsDict, (CFTypeRef *)&results);
    CFRelease(optionsDict);
    
    if (OSStatus != noErr) {
        return nil;
    }
    
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    NSArray *bridgedCanditae = CFBridgingRelease(results);
    
    for (id certObj in bridgedCanditae) {
        SecCertificateRef certificate = (__bridge SecCertificateRef)certObj;
        ANCertificateType certType = [self typeForCertificate:certificate identifier:nil];
        if (certType == kANCertificateTypeDevelopment || certType == kANCertificateTypeProduction) {
            [resultArr addObject:certObj];
        }
    }
    return resultArr;
}

+ (ANCertificateType)typeForCertificate:(SecCertificateRef)certificate identifier:(NSString **)identifier
{
    NSString *name = CFBridgingRelease(SecCertificateCopySubjectSummary(certificate));
    if ([name hasPrefix:ANDevelopmentPrefix]) {
        if (identifier) *identifier = [name substringFromIndex:ANDevelopmentPrefix.length];
        return kANCertificateTypeDevelopment;
    }
    if ([name hasPrefix:ANProductionPrefix]) {
        if (identifier) *identifier = [name substringFromIndex:ANProductionPrefix.length];
        return kANCertificateTypeProduction;
    }
    if (identifier) *identifier = name;
    return kANCertificateTypeUnknown;
}


+(BOOL)isDevelopmentCertificate:(SecCertificateRef)certificateRef
{
    BOOL result = [self typeForCertificate:certificateRef identifier:nil] == kANCertificateTypeDevelopment;
    return result;
}

+ (NSString *)identifierForCertificate:(SecCertificateRef)certificate
{
    NSString *result = nil;
    [self typeForCertificate:certificate identifier:&result];
    return result;
}

+ (SecCertificateRef)certificateForIdentity:(SecIdentityRef)identity
{
    SecCertificateRef result = NULL;
    OSStatus status = SecIdentityCopyCertificate(identity, &result);
    if (status != noErr) return nil;
    return result;
}
@end
