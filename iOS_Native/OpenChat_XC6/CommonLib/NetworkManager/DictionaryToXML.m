//
//  DictionaryToXML.m
//  OpenChat
//
//  Created by Ashish Nigam on 29/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import "DictionaryToXML.h"

NSString *const kDictToXMLTextNodeKey = @"text";

@interface DictionaryToXML () <NSXMLParserDelegate>
{
    NSMutableString *xmlCompleteString;
    NSMutableString *xmlCurrentNode;
    NSMutableString *xmlCurrentnodeValue;
    
    NSMutableArray *allKeysOfDict;
    NSMutableArray *allValuesOfDict;
}

- (id)initWithError:(NSError **)error;
- (NSString *)xmlStringFromDict:(NSDictionary *)dict;

@end

@implementation DictionaryToXML

#pragma mark -
#pragma mark Public methods

+ (NSString *)XMLStringFromDictionary:(NSDictionary *)dict error:(NSError **)errorPointer
{
    DictionaryToXML *dataConvertor = [[DictionaryToXML alloc] initWithError:errorPointer];
    NSString *xmlString = [dataConvertor xmlStringFromDict:dict];
#if !__has_feature(objc_arc)
    [dataConvertor release];
#endif
    return xmlString;
}

+ (NSData *)XMLDataFromDictionary:(NSDictionary *)dict error:(NSError **)errorPointer
{
    NSString *xmlString = [DictionaryToXML XMLStringFromDictionary:dict error:errorPointer];
    return [xmlString dataUsingEncoding:NSUTF8StringEncoding];
}



#pragma mark -
#pragma mark Parsing

- (id)initWithError:(NSError **)error
{
    if (self = [super init])
    {
        errorPtr = *error; //check for solution if this does not work, as we can not store error in an instance variable
    }
    return self;
}

- (void)dealloc
{
#if !__has_feature(objc_arc)
    [dictionaryStack release];
    [textInProgress release];
    [super dealloc];
#endif
}

- (NSString *)xmlStringFromDict:(NSDictionary *)dict
{
#if !__has_feature(objc_arc)
    // Clear out any old data
    [xmlCompleteString release];
    [textInProgress release];
#endif
    
    xmlCompleteString = nil;
    
    xmlCompleteString = [[NSMutableString alloc] init];
    xmlCurrentNode = [[NSMutableString alloc] init];
    
    xmlCurrentnodeValue = [[NSMutableString alloc] init];
    
    allKeysOfDict = [[NSMutableArray alloc] init];
    allValuesOfDict = [[NSMutableArray alloc] init];
    
    return nil;
}



-(void)writeStartElement:(NSString*)elmtName
{
    if (xmlCurrentNode) {
        [xmlCompleteString appendString:xmlCurrentNode];
    }
    xmlCurrentNode = nil;
    xmlCurrentNode = [[NSMutableString alloc] init];
    [xmlCurrentNode appendString:[NSString stringWithFormat:@"<%@>",elmtName]];
}

-(void)writeEndElement:(NSString*)elmtName
{
    [xmlCurrentNode appendString:[NSString stringWithFormat:@"</%@>",elmtName]];
}

-(void)writeAttribute:(NSString*)attrName Value:(NSString*)attrValue
{
    xmlCompleteString= [[xmlCompleteString stringByReplacingOccurrencesOfString:@">" withString:@""] mutableCopy];
    
    [xmlCompleteString appendString:[NSString stringWithFormat:@" %@=\"%@\" >",attrName,attrValue]];
}

-(void)writeAttributes:(NSDictionary*)attrDict
{
    xmlCompleteString= [[xmlCompleteString stringByReplacingOccurrencesOfString:@">" withString:@""] mutableCopy];
    
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    for (NSString* attrName in attrDict) {
        [tempStr appendString:[NSString stringWithFormat:@" %@=\"%@\"",attrName,[attrDict valueForKey:attrName]]];
    }
    [xmlCompleteString appendString:[NSString stringWithFormat:@"%@ >",tempStr]];
}

-(void)writeElementValue:(NSString*)elementVal
{
    [xmlCompleteString appendString:[NSString stringWithFormat:@"%@",elementVal]];
}

-(void)startParsingDictionary:(NSDictionary*)dict
{
   // [allKeysOfDict addObjectsFromArray:[dict allKeys]];
    
    NSMutableArray *dictAllKeys = [NSMutableArray arrayWithArray:[dict allKeys]];
    
    [self writeStartElement:@"Root"];
    
    [self writeStartElement:@"child2"];
    
    [self writeElementValue:@"Ashish is the value"];
    [self writeEndElement:@"child2"];
    
    [self writeEndElement:@"Root"];

    for (NSUInteger i=0; i < [dictAllKeys count]; i++) {
        id objOfKey = [dict valueForKey:[dictAllKeys objectAtIndex:i]];
        
        if ([objOfKey isKindOfClass:[NSDictionary class]])
        {
            [self startParsingDictionary:objOfKey];
            
        }else if ([objOfKey isKindOfClass:[NSArray class]])
        {
            [self parseArrayComponent:objOfKey];
            
        }else
        {
            [self updateXMLStringWithString:objOfKey];
        }
    }
    
}

-(void)parseArrayComponent:(NSArray*)arrayObj
{
    
}

-(void)updateXMLStringWithString:(NSString*)str
{
    
}

@end
