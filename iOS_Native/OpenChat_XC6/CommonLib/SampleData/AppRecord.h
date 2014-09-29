//
//  AppRecord.h
//  OpenChat
//
//  Created by Ashish Nigam on 26/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppRecord : NSObject

@property (nonatomic,strong) NSMutableArray *propertyNames; // make these 2 property part of data parse operation class, as user may not create class like this
@property (nonatomic,strong) NSMutableDictionary *propertyNamesDict;

@end
