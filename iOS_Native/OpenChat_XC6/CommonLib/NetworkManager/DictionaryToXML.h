//
//  DictionaryToXML.h
//  OpenChat
//
//  Created by Ashish Nigam on 29/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

#define twoWayCompatibility // comment or uncomment this macro based on backward compatibility with  another transformation of XMLToDict

@interface DictionaryToXML : NSObject
{
    NSError *errorPtr;
}

+ (NSData *)XMLDataFromDictionary:(NSDictionary *)dict error:(NSError **)errorPointer;
+ (NSString *)XMLStringFromDictionary:(NSDictionary *)dict error:(NSError **)errorPointer;


/*
 
 -(void)writeMyTestXML:(id)args
 {
 
 [self writeStartElement:@"Root"];
 
 [self writeStartElement:@"child2"];
 
 [self writeAttribute:@"attr1" Value:@"view1"];
 
 [self writeElementValue:@"Ashish is the value"];
 
 [self writeAttribute:@"id" Value:@"view1"];
 
 [self writeEndElement:nil];
 
 [self writeStartElement:@"child3"];
 
 [self writeAttribute:@"attr1" Value:@"view1"];
 
 [self writeElementValue:@"Ashish is the champ"];
 
 [self writeAttribute:@"id" Value:@"view1"];
 
 [self writeEndElement:nil];
 
 [self writeEndElement:nil];
 
 NSLog(@"%@",xmlCompleteString);
 
 }
 
*/
@end
