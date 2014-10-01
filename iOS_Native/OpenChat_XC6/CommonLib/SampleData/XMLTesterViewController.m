//
//  ViewController.m
//  XMLTester
//
//  Created by Ashish Nigam on 30/09/14.
//  Copyright (c) 2014 OpenChat. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSMutableString *xmlCompleteString;
    NSMutableString *xmlCurrentNode;
    NSMutableString *xmlCurrentnodeValue;
    
     NSMutableArray *xmlNodes;
    
    NSMutableArray *allKeysOfDict;
    NSMutableArray *allValuesOfDict;
}

@end

NSString *const kDictToXMLArrNodeTest = @"array";
NSString *const kDictToXMLDictNodeTest = @"dict";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    xmlCompleteString = nil;
    
    xmlCompleteString = [[NSMutableString alloc] init];
    xmlCurrentNode = nil;
    
    xmlCurrentnodeValue = [[NSMutableString alloc] init];
    
    allKeysOfDict = [[NSMutableArray alloc] init];
    allValuesOfDict = [[NSMutableArray alloc] init];
    xmlNodes = [[NSMutableArray alloc] init];
    
    [self startParsingDictionary:@{@"key":@"ashish is val"}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [self writeStartElement:@"child3"];
    
    [self writeAttribute:@"attr1" Value:@"view1"];
    
    [self writeElementValue:@"Ashish is the champ"];
    
    [self writeAttribute:@"id" Value:@"view1"];
    
    [self writeEndElement:nil];
    
    [self writeEndElement:nil];
    
    NSLog(@"%@",xmlCompleteString);
    
    for (NSUInteger i=0; i < [dictAllKeys count]; i++) {
        
        NSString *keyName = [dictAllKeys objectAtIndex:i];
        
        id objOfKey = [dict valueForKey:keyName];
        
        if ([objOfKey isKindOfClass:[NSDictionary class]])
        {
//            [self writeStartElement:[dictAllKeys objectAtIndex:i]];
//            [self startParsingDictionary:objOfKey];
            [self writeStartElement:keyName];
            [self parseDictComponent:objOfKey forXMLNodeName:keyName];
            [self writeEndElement:keyName];
            
        }else if ([objOfKey isKindOfClass:[NSArray class]])
        {
            [self parseArrayComponent:objOfKey forXMLNodeName:keyName];
            
        }else
        {
            [self updateXMLStringWithString:objOfKey];
        }
    }
    
}

-(void)writeArrayCorrespondingXMLNode:(NSString*)nodeName value:(NSString*)nodeValue
{
    [self writeStartElement:nodeName];
    [self writeElementValue:nodeValue];
    [self writeEndElement:nil];
}

-(void)writeDictCorrespondingXMLNode:(NSString*)nodeName value:(NSString*)nodeValue
{
    [self writeStartElement:nodeName];
    [self writeElementValue:nodeValue];
    [self writeEndElement:nil];
}

-(void)parseArrayComponent:(NSArray*)arrayObj forXMLNodeName:(NSString*)dictKeyName
{
    for (id obj in arrayObj) {
        if ([obj isKindOfClass:[NSArray class]]) {
            [self parseArrayComponent:obj forXMLNodeName:kDictToXMLArrNodeTest];
        }else if([obj isKindOfClass:[NSDictionary class]]){
            [self writeStartElement:kDictToXMLDictNodeTest];
            [self parseDictComponent:obj forXMLNodeName:kDictToXMLDictNodeTest];
            [self writeEndElement:kDictToXMLDictNodeTest];
        }else{
            [self writeArrayCorrespondingXMLNode:dictKeyName value:[NSString stringWithFormat:@"%@",obj]];
            //[self writeElementValue:[NSString stringWithFormat:@"%@",obj]];
        }
    }
}

-(void)parseDictComponent:(NSDictionary*)dictObj forXMLNodeName:(NSString*)dictKeyName
{
    for (NSString* obj in dictObj) {
        if ([[dictObj valueForKey:obj] isKindOfClass:[NSArray class]]) {
            [self parseArrayComponent:[dictObj valueForKey:obj] forXMLNodeName:obj];
        }else if([[dictObj valueForKey:obj] isKindOfClass:[NSDictionary class]]){
            [self parseDictComponent:[dictObj valueForKey:obj] forXMLNodeName:obj];
        }else{
            [self writeDictCorrespondingXMLNode:obj value:[NSString stringWithFormat:@"%@",[dictObj valueForKey:obj]]];
        }
    }
}

-(void)updateXMLStringWithString:(NSString*)str
{
    
}

@end
