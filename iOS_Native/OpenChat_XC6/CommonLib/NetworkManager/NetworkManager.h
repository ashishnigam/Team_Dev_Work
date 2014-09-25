//
//  NetworkManager.h
//  OpenChat
//
//  Created by Ashish Nigam on 18/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

/*
 This NetworkManager will be responsible for handling network requests based users choice
 developer using this can opt for how to manage network request.
 1: Operation Queues
 2: Grand Central Dispatch(GCD)
 3: NSThread
 4: Sysnchronous/ Asynchronous requests
 
 How they want the response like raw response or formatted one.
 1: RAW response, returned as it is.
 2: JSON formatted.
 3: XML formatted.
 4: Blob data.
 5: Image data.
 
 All the network request will be Async until specified as UI blocking sync.
 */
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
