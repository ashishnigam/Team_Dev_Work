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
    
    NSMutableArray *xmlNodes;
    
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
    xmlCurrentNode = nil;
    
    xmlCurrentnodeValue = [[NSMutableString alloc] init];
    
    allKeysOfDict = [[NSMutableArray alloc] init];
    allValuesOfDict = [[NSMutableArray alloc] init];
    xmlNodes = [[NSMutableArray alloc] init];
    
     [self startParsingDictionary:@{@"key":@"ashish is val"}];
    return nil;
}



-(void)chnageParentElement:(NSString*)elmtName
{
    NSMutableString *tempRoot = [[NSString stringWithFormat:@"<%@>",elmtName] mutableCopy];
    
    [xmlCompleteString appendString:[NSString stringWithFormat:@"/%@",tempRoot]];
    [tempRoot appendString:xmlCompleteString];
    xmlCompleteString = [tempRoot mutableCopy];
    tempRoot = nil;
}

-(void)writeStartElement:(NSString*)elmtName
{
    if (xmlCurrentNode) {
        [xmlCompleteString appendString:xmlCurrentNode];
    }
    xmlCurrentNode = nil;
    xmlCurrentNode = [[NSMutableString alloc] init];
    [xmlCurrentNode appendString:[NSString stringWithFormat:@"<%@>",elmtName]];
    [xmlNodes addObject:elmtName];
}

-(void)writeEndElement:(NSString*)elmtName
{
    if (xmlCurrentNode) {
        [xmlCompleteString appendString:xmlCurrentNode];
    }
    if (!elmtName) {
        NSMutableString* endNodeName = [xmlNodes lastObject];
        NSMutableString *tempStr = [[NSMutableString alloc] init];
        [tempStr appendString:[NSString stringWithFormat:@"</%@>",endNodeName]];
        
        [xmlCompleteString appendString:tempStr];
        endNodeName = nil;
        tempStr = nil;
        xmlCurrentNode = nil;
        [xmlNodes removeLastObject];
    }else{
        
        //[xmlCurrentNode appendString:[NSString stringWithFormat:@"</%@>",elmtName]];
        NSMutableString *tempStr = [[NSMutableString alloc] init];
        [tempStr appendString:[NSString stringWithFormat:@"</%@>",elmtName]];
        
        [xmlCompleteString appendString:tempStr];
        tempStr = nil;
        xmlCurrentNode = nil;
        [xmlNodes removeLastObject];
        // [xmlNodes removeAllObjects]; //either way is acceppted, not both simultaniously
    }
}

-(void)writeAttribute:(NSString*)attrName Value:(NSString*)attrValue
{
    xmlCurrentNode= [[xmlCurrentNode stringByReplacingOccurrencesOfString:@">" withString:[NSString stringWithFormat:@" %@=\"%@\">",attrName,attrValue]] mutableCopy];
    
    //[xmlCurrentNode appendString:[NSString stringWithFormat:@" %@=\"%@\" >",attrName,attrValue]];
}

// specify node name and attributes will be added to that only
-(void)writeAttribute:(NSString*)attrName Value:(NSString*)attrValue toNode:(NSString*)nodeName
{
    xmlCompleteString= [[xmlCompleteString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<%@>",nodeName] withString:[NSString stringWithFormat:@"<%@ %@=\"%@\">",nodeName ,attrName,attrValue]] mutableCopy];
    
}

-(void)writeAttributes:(NSDictionary*)attrDict
{
    
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    for (NSString* attrName in attrDict) {
        [tempStr appendString:[NSString stringWithFormat:@" %@=\"%@\"",attrName,[attrDict valueForKey:attrName]]];
    }
    // [xmlCurrentNode appendString:[NSString stringWithFormat:@"%@ >",tempStr]];
    
    xmlCurrentNode= [[xmlCurrentNode stringByReplacingOccurrencesOfString:@">" withString:[NSString stringWithFormat:@"%@>",tempStr]] mutableCopy];
    
}

-(void)writeAttributes:(NSDictionary*)attrDict toNode:(NSString*)nodeName
{
    //xmlCurrentNode= [[xmlCurrentNode stringByReplacingOccurrencesOfString:@">" withString:@""] mutableCopy];
    
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    for (NSString* attrName in attrDict) {
        [tempStr appendString:[NSString stringWithFormat:@" %@=\"%@\"",attrName,[attrDict valueForKey:attrName]]];
    }
    [xmlCurrentNode appendString:[NSString stringWithFormat:@"%@",tempStr]];
    
    xmlCompleteString= [[xmlCompleteString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<%@>",nodeName] withString:[NSString stringWithFormat:@"<%@ %@>",nodeName ,tempStr]] mutableCopy];
    
}

-(void)writeElementValue:(NSString*)elementVal
{
    
    [xmlCurrentNode appendString:[NSString stringWithFormat:@"%@",elementVal]];
}

//Think about logic if required.

//-(void)changeElement:(NSString*)elmtName value:(NSString*)elementVal
//{
//NSRange startRange = [xmlCurrentNode rangeOfString:@"<"];
//NSRange endRange = [xmlCurrentNode rangeOfString:@">"];
//
//NSRange searchRange = NSMakeRange(startRange.location, endRange.location);
//
//    [xmlCurrentNode appendString:[NSString stringWithFormat:@"%@",elementVal]];
//}

-(void)startParsingDictionary:(NSDictionary*)dict
{
    // [allKeysOfDict addObjectsFromArray:[dict allKeys]];
    
    NSMutableArray *dictAllKeys = [NSMutableArray arrayWithArray:[dict allKeys]];
    
    [self writeStartElement:@"Root"];
    
    [self writeStartElement:@"child2"];
    
    [self writeAttribute:@"attr1" Value:@"view1"];
    
    [self writeElementValue:@"Ashish is the value"];
    
    [self writeAttribute:@"id" Value:@"view1"];
    
    [self writeEndElement:nil];
    
    [self writeEndElement:nil];
    
    NSLog(@"%@",xmlCompleteString);
    
    //    for (NSUInteger i=0; i < [dictAllKeys count]; i++) {
    //        id objOfKey = [dict valueForKey:[dictAllKeys objectAtIndex:i]];
    //
    //        if ([objOfKey isKindOfClass:[NSDictionary class]])
    //        {
    //            [self startParsingDictionary:objOfKey];
    //
    //        }else if ([objOfKey isKindOfClass:[NSArray class]])
    //        {
    //            [self parseArrayComponent:objOfKey];
    //
    //        }else
    //        {
    //            [self updateXMLStringWithString:objOfKey];
    //        }
    //    }
    
}

-(void)parseArrayComponent:(NSArray*)arrayObj
{
    
}

-(void)updateXMLStringWithString:(NSString*)str
{
    
}

@end
