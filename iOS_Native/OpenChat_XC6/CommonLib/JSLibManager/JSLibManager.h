//
//  JSLibManager.h
//  OpenChat
//
//  Created by Ashish Nigam on 10/13/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSLibManagerProtocol

-(id)valueReturnedFromLib:(id)obj;

@end

@interface JSLibManager : NSObject

@property (nonatomic,assign) id <JSLibManagerProtocol> delegate;

@end
