//
//  NetworkManager.m
//  OpenChat
//
//  Created by Ashish Nigam on 18/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager ()
{
    
}

@end


//Implementing singleton design pattern for network manager.
// Considering ARC & NON-ARC both.

static NetworkManager *sharedNWManager = nil;

@implementation NetworkManager
{
    // can have private member here
}

//=================================================================================
// ARC based singleton implementation
//=================================================================================

#if __has_feature(objc_arc)
+(instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedNWManager = [[super allocWithZone:NULL] init];
    });
    
    return sharedNWManager;
    
}

+ (instancetype)allocWithZone:(NSZone *)zone {
    return [self sharedManager];
}

+(instancetype)alloc{
    return [self allocWithZone:NULL];
}

+ (void)initialize
{
    if (self == [NetworkManager class]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken,^{
            sharedNWManager = [[super allocWithZone:NULL] init];
        });
    }
    
}

- (instancetype)init
{
    if (self = [super init]) {
        _someProperty = @"Default Property Value";
        operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (id)copy
{
    return self;
}

- (id)mutableCopy
{
    return self;
}

#endif
//=================================================================================
// ARC based singleton implementation ends
//=================================================================================


#pragma mark Singleton Methods

//=================================================================================
// NON-ARC based singleton implementation
//=================================================================================
#if !__has_feature(objc_arc)

+(id)sharedManager
{
    @synchronized(self) {
        if (sharedNWManager == nil)
            sharedNWManager = [[super allocWithZone:NULL] init];
    }
    return sharedNWManager;
}

-(instancetype)init {
    if (self = [super init]) {
        _someProperty = [[NSString alloc] initWithString:@"Default Property Value"];
    }
    return self;
}

+ (void)initialize {
    if (self == [NetworkManager class]) {
        @synchronized(self) {
            if (sharedNWManager == nil)
                sharedNWManager = [[super allocWithZone:NULL] init];
        }
    }
}

+ (instancetype)allocWithZone:(NSZone *)zone {
    return [[self sharedManager] retain];
}

+(instancetype)alloc{
    return [self allocWithZone:NULL];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

+ (id)copyWithZone:(struct _NSZone *)zone{
    return [[self sharedManager] retain];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [[self sharedManager] retain];
}

- (instancetype)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
    // or
  //  return UINT_MAX; //this number denotes an object that cannot be released
}

- (oneway void)release
{
    // never release
}

- (instancetype)autorelease
{
    return self;
}

- (id)copy
{
    return self;
}

- (id)mutableCopy
{
    return self;
}
#endif

//=================================================================================
// NON-ARC based singleton implementation ends
//=================================================================================


// common use , implemented just for clarity
- (void)dealloc {
    // Should never be called, but just here for clarity really.
#if !__has_feature(objc_arc)
    [_someProperty release];
    [super dealloc];
#endif
}

//=================================================================================
// Singleton design pattern implementation ends here
//=================================================================================




//=================================================================================
// Functional Methods to manage network call through Network manager
//=================================================================================
-(void)manageOperation:(NSOperation*)operation
{
    [operationQueue addOperation:operation];
}

/*
 typedef void (^ operationBlock)(void);
-(void)manageOperationWithBlocks:(void (^)(void))operationB
 or
-(void)manageOperationWithBlocks:(operationBlock)operationB

 are same, one uses block as type another normally
*/

-(void)manageOperationWithBlock:(void (^)(void))operationB
{
    [operationQueue addOperationWithBlock:operationB];
}

-(void)manageOperations:(NSArray*)operationArr waitUntilFinished:(BOOL)wait
{
    [operationQueue addOperations:operationArr waitUntilFinished:wait];
}

-(void)cancelAllRequests
{
    [operationQueue cancelAllOperations];
}

-(void)cancelAllOperations
{
    [operationQueue cancelAllOperations];
}

-(void)waitUntilAllOperationsAreFinished
{
    [operationQueue waitUntilAllOperationsAreFinished];
}

-(void)waitUntilAllRequestsAreFinished
{
    [operationQueue waitUntilAllOperationsAreFinished];
}

-(NSUInteger)requestCount
{
    return [operationQueue operationCount];
}

-(NSArray*)allRequests
{
    // may need modification to return connection or request object rather than operation object directly
    return [operationQueue operations];
}

-(void)manageConnection:(NSURLConnection*)connection
{
    //  create operation from connection and then use manageOperation
    // Will implement after request or connection operation class implementation as per requirement
}

// singleton design pattern common classes, required for implementation as depends

/*
 + (void)load; //not required as calling mechanism is special to class.
 
 // only class which implement this method get the call at very early stage
 // & it does not follow inherientence so does not follow parent child relation.
 // So if i do not implement this, no way it will be called here.
 
 + (void)initialize; //done
 - (instancetype)init; //done
 
 + (instancetype)new; // not done
 + (instancetype)allocWithZone:(struct _NSZone *)zone; //done
 + (instancetype)alloc; //done
 - (void)dealloc; //done
 
 - (void)finalize; // not required, required in GC environment only
 
 - (id)copy; //done
 - (id)mutableCopy; //done
 
 + (id)copyWithZone:(struct _NSZone *)zone OBJC_ARC_UNAVAILABLE;  // done in non-ARC
 + (id)mutableCopyWithZone:(struct _NSZone *)zone OBJC_ARC_UNAVAILABLE; // done in non-ARC
 */

@end
