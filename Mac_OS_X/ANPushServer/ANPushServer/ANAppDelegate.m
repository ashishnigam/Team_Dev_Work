//
//  ANAppDelegate.m
//  ANPushServer
//
//  Created by Ashish Nigam on 25/03/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import "ANAppDelegate.h"

#import "ANSecTools.h"
#import "ANPushServer.h"
#import "ANPushHub.h"

@interface ANAppDelegate () <ANHubDelegate>
{
    dispatch_queue_t _serial;
    NSArray *certificatesArr;
    NSDictionary *configuration;
}

@property (weak) IBOutlet NSPopUpButton *certificateSelector;
@property (weak) IBOutlet NSComboBox *deviceTokenComboBx;
@property (weak) IBOutlet NSPopUpButton *expirySelector;
@property (weak) IBOutlet NSPopUpButton *prioritySelector;

@property (unsafe_unretained) IBOutlet NSTextView *payloadField;

@property (weak) IBOutlet NSButton *pushBtn;
@property (weak) IBOutlet NSButton *connectBtn;
@property (weak) IBOutlet NSTextField *charCountLbl;

@property (weak) IBOutlet NSTextField *counterField;
@end

@implementation ANAppDelegate
{
    NSUInteger index;
    __weak NSTextField *_counterField;
    ANPushHub *pushHub;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    _serial = dispatch_queue_create("ANPushServer_Serial", DISPATCH_QUEUE_SERIAL);
    
    [self loadCertificateFromKeychain];
    [self loadConfiguration];
    
    NSString *payload = [configuration valueForKey:@"payload"];
    self.payloadField.string = payload.length ? payload : @"";
    self.payloadField.font = [NSFont fontWithName:@"Courier" size:10];
    self.payloadField.enabledTextCheckingTypes = 0;
    [self textDidChange:nil];
    index = 1;
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    
    NSLog(@"Application will terminate");
     [pushHub disconnect]; pushHub.hubDelegate = nil; pushHub = nil;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)application
{
    return YES;
}

#pragma mark - Actions
-(void)loadCertificateFromKeychain
{
    NSArray *certificates = [ANSecTools keychainCertificates:nil];
    if (!certificates.count) {
        NSLog(@"No push certificates in keychain.");
    }
    certificates = [certificates sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        BOOL adev = [ANSecTools isDevelopmentCertificate:(__bridge SecCertificateRef)(a)];
        BOOL bdev = [ANSecTools isDevelopmentCertificate:(__bridge SecCertificateRef)(b)];
        if (adev != bdev) {
            return adev ? NSOrderedAscending : NSOrderedDescending;
        }
        NSString *aname = [ANSecTools identifierForCertificate:(__bridge SecCertificateRef)(a)];
        NSString *bname = [ANSecTools identifierForCertificate:(__bridge SecCertificateRef)(b)];
        return [aname compare:bname];
    }];
    certificatesArr = certificates;
    
    [self.certificateSelector removeAllItems];
    [_certificateSelector addItemWithTitle:@"Select Push Certificate"];
    for (id certObj in certificatesArr) {
        BOOL sandbox = [ANSecTools isDevelopmentCertificate:(__bridge SecCertificateRef)(certObj)];
        NSString *name = [ANSecTools identifierForCertificate:(__bridge SecCertificateRef)(certObj)];
        [_certificateSelector addItemWithTitle:[NSString stringWithFormat:@"%@%@", name, sandbox ? @" ( - Development)" : @" - Production"]];
    }
}

- (void)loadConfiguration
{
    NSURL *defaultURL = [NSBundle.mainBundle URLForResource:@"configuration" withExtension:@"plist"];
    configuration = [NSDictionary dictionaryWithContentsOfURL:defaultURL];
    NSURL *libraryURL = [[NSFileManager.defaultManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *configURL = [libraryURL URLByAppendingPathComponent:@"ANPushServer_Mac" isDirectory:YES];
    if (configURL) {
        NSError *error = nil;
        BOOL exists = [NSFileManager.defaultManager createDirectoryAtURL:configURL withIntermediateDirectories:YES attributes:nil error:&error];
        
        NSLog(@"%@",error);
        
        if (exists) {
            NSURL *plistURL = [configURL URLByAppendingPathComponent:@"configuration.plist"];
            NSDictionary *config = [NSDictionary dictionaryWithContentsOfURL:plistURL];
            if ([config isKindOfClass:NSDictionary.class]) {
                NSLog(@"Read configuration from ~/Library/ANPushServer_Mac/configuration.plist");
                configuration = config;
            } else if (![NSFileManager.defaultManager fileExistsAtPath:plistURL.path]){
                [configuration writeToURL:plistURL atomically:NO];
                NSLog(@"Created default configuration in ~/Library/ANPushServer_Mac/configuration.plist");
            } else {
                NSLog(@"Unable to read configuration from ~/Library/ANPushServer_Mac/configuration.plist");
            }
        }
    }
}

- (NSArray *)tokensForCertificate:(id)certificate
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    BOOL sandbox = [ANSecTools isDevelopmentCertificate:(__bridge SecCertificateRef)certificate];
    NSString *identifier = [ANSecTools identifierForCertificate:(__bridge SecCertificateRef)certificate];
    for (NSDictionary *dict in [configuration valueForKey:@"tokens"]) {
        NSArray *identifiers = [dict valueForKey:@"identifiers"];
        BOOL match = !identifiers;
        for (NSString *i in identifiers) {
            if ([i isEqualToString:identifier]) {
                match = YES;
                break;
            }
        }
        if (match) {
            NSArray *tokens = sandbox ? [dict valueForKey:@"development"] : [dict valueForKey:@"production"];
            if (tokens.count) {
                [result addObjectsFromArray:tokens];
            }
        }
    }
    return result;
}

- (void)selectCertificate:(id)certificate
{
    if (pushHub) {
        [pushHub disconnect]; pushHub = nil;
        self.pushBtn.enabled = NO;
        self.connectBtn.enabled = NO;
        NSLog(@"Disconnected from APN");
    }
    
    NSArray *tokens = [self tokensForCertificate:certificate];
    [self.deviceTokenComboBx removeAllItems];
    //_tokenCombo.stringValue = @"";
    [self.deviceTokenComboBx addItemsWithObjectValues:tokens];
    
    if (certificate) {
        dispatch_async(_serial, ^{
            ANPushHub *phub = [[ANPushHub alloc] initWithDelegate:self];
            ANPusherServerResultCode connected = [phub connectWithCertificateRef:(__bridge SecCertificateRef)certificate];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (connected == kANPusherResultSuccess) {
                    BOOL sandbox = [ANSecTools isDevelopmentCertificate:(__bridge SecCertificateRef)certificate];
                    NSString *identifier = [ANSecTools identifierForCertificate:(__bridge SecCertificateRef)certificate];
                    NSLog(@"Connected to APN: %@%@", identifier, sandbox ? @" (sandbox)" : @"");
                    pushHub = phub;
                    self.pushBtn.enabled = YES;
                    self.connectBtn.enabled = YES;
                } else {
                    NSLog(@"Unable to connect: %@", [ANPushServer stringFromResult:connected]);
                    [phub disconnect];
                    [self.certificateSelector selectItemAtIndex:0];
                }
            });
        });
    }
}

- (void)push
{
    NSString *payload = _payloadField.string;
    NSString *token = _deviceTokenComboBx.stringValue;
    NSDate *expiry = self.expirySelected;
    NSUInteger priority = self.prioritySelected;
    if (token.length > 2) {
        NSLog(@"Pushing..");
        dispatch_async(_serial, ^{
            ANNotification *notification = [[ANNotification alloc] initWithPayload:payload token:token identifier:0 expirationDate:expiry priority:priority];
            NSUInteger failed = [pushHub pushNotifications:@[notification] autoReconnect:NO];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
            dispatch_after(popTime, _serial, ^(void){
                NSUInteger failed2 = failed + [pushHub flushError];
                if (!failed2) NSLog(@"Payload has been pushed");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self upPayloadTextIndex];
                });
            });
        });
    }else
    {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Device Token is required" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"You forgot to add device token in device token box"];
        [alert runModal];
        
    }
    
}

- (void)reconnect
{
    NSLog(@"Reconnecting..");
    self.pushBtn.enabled = NO;
    self.connectBtn.enabled = NO;
    dispatch_async(_serial, ^{
        ANPusherServerResultCode connected = [pushHub reconnect];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (connected == kANPusherResultSuccess) {
                NSLog(@"Reconnected");
                self.pushBtn.enabled = YES;
            } else {
                NSLog(@"Unable to reconnect: %@", [ANPushServer stringFromResult:connected]);
            }
            self.connectBtn.enabled = YES;
        });
    });
}


#pragma mark - Events

- (IBAction)certificateSelected:(NSPopUpButton *)sender
{
    if (self.certificateSelector.indexOfSelectedItem) {
        id certificate = [certificatesArr objectAtIndex:self.certificateSelector.indexOfSelectedItem - 1];
        [self selectCertificate:certificate];
    } else {
        [self selectCertificate:nil];
    }
}

- (NSDate *)expirySelected
{
    switch(self.expirySelector.indexOfSelectedItem) {
        case 1: return [NSDate dateWithTimeIntervalSince1970:0];
        case 2: return [NSDate dateWithTimeIntervalSinceNow:60];
        case 3: return [NSDate dateWithTimeIntervalSince1970:300];
        case 4: return [NSDate dateWithTimeIntervalSinceNow:3600];
        case 5: return [NSDate dateWithTimeIntervalSinceNow:86400];
        case 6: return [NSDate dateWithTimeIntervalSince1970:1];
        case 7: return [NSDate dateWithTimeIntervalSince1970:UINT32_MAX];
    }
    return nil;
}

- (NSUInteger)prioritySelected
{
    switch(self.prioritySelector.indexOfSelectedItem) {
        case 1: return 5;
        case 2: return 10;
    }
    return 0;
}

- (void)textDidChange:(NSNotification *)notification
{
    NSString *payload = _payloadField.string;
    BOOL isJSON = !![NSJSONSerialization JSONObjectWithData:[payload dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    _counterField.stringValue = [NSString stringWithFormat:@"%@  %lu", isJSON ? @"" : @"malformed", payload.length];
    _counterField.textColor = payload.length > 256 || !isJSON ? NSColor.redColor : NSColor.darkGrayColor;
    if (payload.length > 256 && isJSON) {
         _counterField.stringValue = [NSString stringWithFormat:@"%@  %lu", @"oversize(<256)", payload.length];
    }
}

- (IBAction)push:(NSButton *)sender
{
    if (pushHub) {
        [self push];
    } else {
        NSLog(@"No certificate selected");
    }
}

- (IBAction)reconnect:(NSButton *)sender
{
    if (pushHub) {
        [self reconnect];
    } else {
        NSLog(@"No certificate selected");
    }
}

- (void)notification:(ANNotification *)notification didFailWithResult:(ANPusherServerResultCode)result
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //NSLog(@"failed notification: %@ %@ %lu %lu %lu", notification.payload, notification.token, notification.identifier, notification.expires, notification.priority);
        NSLog(@"Notification could not be pushed: %@", [ANPushServer stringFromResult:result]);
    });
}

- (void)upPayloadTextIndex
{
    NSString *payload = _payloadField.string;
    NSRange range = [payload rangeOfString:@"Testing.. \\([0-9]+\\)" options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        range.location += 11;
        range.length -= 12;
        NSString *before = [payload substringToIndex:range.location];
        NSUInteger value = [payload substringWithRange:range].integerValue + 1;
        NSString *after = [payload substringFromIndex:range.location + range.length];
        _payloadField.string = [NSString stringWithFormat:@"%@%lu%@", before, value, after];
    }
}


@end
