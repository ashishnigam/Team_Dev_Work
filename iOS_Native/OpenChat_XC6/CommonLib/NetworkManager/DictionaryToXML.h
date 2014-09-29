//
//  DictionaryToXML.h
//  OpenChat
//
//  Created by Ashish Nigam on 29/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DictionaryToXML : NSObject
{
    NSMutableArray *dictionaryStack;
    NSMutableString *textInProgress;
    NSError *errorPtr;
}

+ (NSData *)XMLDataFromDictionary:(NSDictionary *)dict error:(NSError **)errorPointer;
+ (NSString *)XMLStringFromDictionary:(NSDictionary *)dict error:(NSError **)errorPointer;

@end
