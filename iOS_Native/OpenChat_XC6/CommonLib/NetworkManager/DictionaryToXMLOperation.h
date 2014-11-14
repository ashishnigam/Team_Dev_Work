//
//  DictionaryToXMLOperation.h
//  OpenChat
//
//  Created by Ashish Nigam on 29/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DictionaryToXMLOperation : NSOperation

// A block to call when an error is encountered during parsing.
@property (nonatomic, copy) void (^errorHandler)(NSError *error);

// from the input data.
// Only meaningful after the operation has completed.
@property (nonatomic, strong, readonly) NSString *xmlString;

// Only meaningful after the operation has completed.
@property (nonatomic, strong, readonly) NSData *xmlData;

// The initializer for this NSOperation subclass.
- (id)initWithDictionary:(NSDictionary *)dict;
- (id)initWithDictionary:(NSDictionary *)dict withBackwardCompatibility:(BOOL)enabled;

@end
