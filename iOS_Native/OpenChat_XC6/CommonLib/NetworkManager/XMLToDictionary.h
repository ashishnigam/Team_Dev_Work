//
//  XMLToDictionary.h
//  OpenChat
//
//  Created by Ashish Nigam on 26/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLToDictionary : NSObject <NSXMLParserDelegate>
{
    NSMutableArray *dictionaryStack;
    NSMutableString *textInProgress;
    NSError *errorPtr;
    
}

+ (NSDictionary *)dictionaryFromXMLData:(NSData *)data error:(NSError **)errorPointer;
+ (NSDictionary *)dictionaryFromXMLString:(NSString *)string error:(NSError **)errorPointer;

@end
