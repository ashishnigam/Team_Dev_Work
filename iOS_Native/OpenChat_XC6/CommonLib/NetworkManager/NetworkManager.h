//
//  NetworkManager.h
//  OpenChat
//
//  Created by Ashish Nigam on 18/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject
{
    @private
    NSOperationQueue *operationQueue;
}

#if !__has_feature(objc_arc)
@property (nonatomic, retain) NSString *someProperty;
#endif

#if __has_feature(objc_arc)
@property (nonatomic, strong) NSString *someProperty;
#endif

+(instancetype)sharedManager;

@end
