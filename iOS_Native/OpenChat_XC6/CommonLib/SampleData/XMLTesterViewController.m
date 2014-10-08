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
    
    NSString *xmlEncoding;
    
    BOOL documentEnded;
}

@property (nonatomic, strong) NSString *xmlEncoding;
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
    
    NSDictionary *testDict = @{@"key":@"ashish is val",
                               @"node1":@"val1",
                               @"dictA":@{@"dKey1":@"dVal1",
                                          @"dKey2":@"dVal2"},
                               @"arrA":@[@"Str1",@"Str2",@"Str3"],
                               @"KeyAdvance":@"Will CoverAdvance Parsing"};
    
    NSDictionary *testDictAdvance = @{@"key":@"ashish is val",
                                      @"node1":@"val1",
                                      @"dictA":@{@"dKey1":@"dVal1",
                                                 @"dKey2":@"dVal2"},
                                      @"arrA":@[@"Str1",@"Str2",@"Str3"],
                                      @"KeyAdvance":@"Will CoverAdvance Parsing",
                                      @"keyAdvanceDict":@{@"key":@"ashish is val",
                                                          @"node1":@"val1",
                                                          @"dictA":@{@"dKey1":@"dVal1",
                                                                     @"dKey2":@"dVal2"},
                                                          @"arrA":@[@"Str1",@"Str2",@"Str3"],
                                                          @"KeyAdvance":@"Will CoverAdvance Parsing"},
                                      @"keyAdvanceArr":@[@"Str1",@{@"dKey1":@"dVal1",
                                                                   @"dKey2":@"dVal2"},@"Str3",@[@"arr1",@"Str2",@"Str3"],@[@"arr2",@"Str22",@"Str32"]],
                                      @"keyAdvanceArr1":@[@{@"dKey1":@"dVal1",
                                                            @"dKey2":@"dVal2"},@12345,@{@"key":@"ashish is val",
                                                                                        @"node1":@"val1",
                                                                                        @"dictA":@{@"dKey1":@"dVal1",
                                                                                                   @"dKey2":@"dVal2"},
                                                                                        @"arrA":@[@"Str1",@"Str2",@"Str3"],
                                                                                        @"KeyAdvance":@"Will CoverAdvance Parsing"}]};
    
    [self startParsingDictionary:testDictAdvance withRootNodeName:@"root"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) writeStartDocument;
{
    [self writeStartDocumentWithEncodingAndVersion:nil version:nil];
}

- (void) writeStartDocumentWithVersion:(NSString*)version
{
    [self writeStartDocumentWithEncodingAndVersion:nil version:version];
}

- (void) writeStartDocumentWithEncodingAndVersion:(NSString*)encoding version:(NSString*)version
{
    if([xmlCompleteString length] != 0) {
        // raise exception - Starting document which is not empty
        @throw([NSException exceptionWithName:@"XMLWriteException" reason:@"Document has already been started" userInfo:@{@"info":@"Please use this at the start of document"}]);
    }else {
        [xmlCompleteString appendString:@"<?xml version=\""];
        if(version) {
            [xmlCompleteString appendString:version];
        } else {
            // default to 1.0
            [xmlCompleteString appendString:@"1.0"];
        }
        [xmlCompleteString appendString:@"\""];
        
        if(encoding) {
            [xmlCompleteString appendString:@" encoding=\""];
            [xmlCompleteString appendString:encoding];
            [xmlCompleteString appendString:@"\""];
            
            self.xmlEncoding = encoding;
        }
        [xmlCompleteString appendString:@" ?>"];
        
    }
    
}

- (void) writeEndDocument
{
    documentEnded = YES;
    // nothing to do till now, make more understandng for assurance
}

- (NSString*) toString
{
    return [NSString stringWithString:xmlCompleteString]; // check it.
}

- (NSData*) toData
{
    if ([[self.xmlEncoding lowercaseString] isEqualToString:[@"UTF-8" lowercaseString]]) {
        return [xmlCompleteString dataUsingEncoding:NSUTF8StringEncoding];
    }
    return [xmlCompleteString dataUsingEncoding:NSUTF8StringEncoding];
}

- (void) writeComment:(NSString*)comment
{
    [xmlCompleteString appendString:@"<!--"];
    [xmlCompleteString appendString:comment]; // no escape
    [xmlCompleteString appendString:@"-->"];
}

- (void) writeComment:(NSString*)comment beforeNode:(NSString*)nodeName
{
    NSRange startRange = [xmlCompleteString rangeOfString:[NSString stringWithFormat:@"<%@",nodeName]];
    NSRange firstStrRange = NSMakeRange(0, startRange.location);
    
    NSLog(@"%ld %ld",firstStrRange.location,firstStrRange.length);
    NSMutableString *str1 = [[xmlCompleteString substringWithRange:firstStrRange] mutableCopy];
    NSLog(@"%@",str1);
    
    NSRange secondStrRange = NSMakeRange(startRange.location, [xmlCompleteString length]-startRange.location);
    NSString *str2 = [xmlCompleteString substringWithRange:secondStrRange];
    NSLog(@"%@",str2);
    
    
    
    [str1 appendString:@"<!--"];
    [str1 appendString:comment]; // no escape
    [str1 appendString:@"-->"];
    [str1 appendString:str2];
    
    xmlCompleteString = str1;
}

- (void) writeEmptyElement:(NSString *)localName
{
    [self writeStartElement:localName];
    [self writeEndElement:nil];
}

- (void) writeEmptyElement:(NSString *)localName withAttributes:(NSDictionary*)attrDict
{
    [self writeStartElement:localName withAttributes:attrDict];
    [self writeEndElement:nil];
}

-(void)chnageParentElement:(NSString*)elmtName
{
    NSMutableString *tempRoot = [[NSString stringWithFormat:@"<%@>",elmtName] mutableCopy];
    
    [xmlCompleteString appendString:[NSString stringWithFormat:@"/%@",tempRoot]];
    [tempRoot appendString:xmlCompleteString];
    xmlCompleteString = [tempRoot mutableCopy];
    tempRoot = nil;
}

//Think
-(void)writeStartElement:(NSString*)elmtName withAttributes:(NSDictionary*)attrDict
{
    [self writeStartElement:elmtName];
    [self writeAttributes:attrDict];
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
    
    [xmlCurrentNode appendString:[NSString stringWithFormat:@"\"%@\"",elementVal]];
}

-(void)replaceNodeNameFrom:(NSString*)oldName toName:(NSString*)newName
{
    xmlCompleteString= [[xmlCompleteString stringByReplacingOccurrencesOfString:oldName withString:newName] mutableCopy];
}

//Think about logic if required.
-(void)replaceNode:(NSString*)nodeName toValue:(NSString*)newValue
{
    NSRange startRange = [xmlCompleteString rangeOfString:[NSString stringWithFormat:@"<%@",nodeName]];
    
    NSRange endRange = [xmlCompleteString rangeOfString:[NSString stringWithFormat:@"</%@>",nodeName]];
    
    NSRange searchRange = NSMakeRange(startRange.location, (endRange.location-startRange.location)+endRange.length);
    
    NSMutableString *tempStr = [[xmlCompleteString substringWithRange:searchRange] mutableCopy];
    
    NSRange angBrLocation = [tempStr rangeOfString:@">"];
    NSLog(@"%lu %ld",angBrLocation.location , angBrLocation.length);
    
    NSRange endRange2 = [tempStr rangeOfString:[NSString stringWithFormat:@"</%@>",nodeName]];
    NSRange valueLength = NSMakeRange(angBrLocation.location+1, (endRange2.location-angBrLocation.location-1));
    
    NSString *nodeValue = [tempStr substringWithRange:valueLength];
    
    xmlCompleteString = [[xmlCompleteString stringByReplacingOccurrencesOfString:nodeValue withString:newValue] mutableCopy];
    /*
     NSLog(@"%lu %ld",startRange.location , startRange.length);
     NSLog(@"%lu %ld",endRange.location , endRange.length);
     NSLog(@"%lu %ld",searchRange.location , searchRange.length);
     NSLog(@"%@",tempStr);
     NSLog(@"%@",nodeValue);
     NSLog(@"%@",xmlCompleteString);
     */
    
    NSString *string = [NSString stringWithString:xmlCompleteString];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"node1" options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, [string length])];
    NSArray* allMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    NSLog(@"Found %lu",(unsigned long)numberOfMatches);
    
    for (NSTextCheckingResult *match in allMatches) {
        NSRange matchRange = [match range];
        
        NSLog(@"%@", [xmlCompleteString substringWithRange:matchRange]);
    }
    
    NSLog(@"Found %@",allMatches);
}


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


-(void)startParsingDictionary:(NSDictionary*)dict withRootNodeName:(NSString*)nodeName
{
    documentEnded = NO;
    [self writeStartElement:nodeName];
    
    for (NSString* keyName in dict) {
        
        id objOfKey = [dict valueForKey:keyName];
        
        if ([objOfKey isKindOfClass:[NSDictionary class]])
        {
            [self writeStartElement:keyName];
            [self parseDictComponent:objOfKey forXMLNodeName:keyName];
            [self writeEndElement:keyName];
            
        }else if ([objOfKey isKindOfClass:[NSArray class]])
        {
            
            [self parseArrayComponent:objOfKey forXMLNodeName:keyName];
            // [self writeComment:@"test comment Ashsih Nigam"];
            
        }else
        {
            [self writeValueCorrespondingXMLNode:keyName value:objOfKey];
        }
    }
    [self writeEndElement:nil];
    
    [self replaceNode:@"node1" toValue:@"11111111111"];
    
    // [self writeComment:@"test comment beforenode Ashsih Nigam" beforeNode:@"node1"];
    NSLog(@"%@",xmlCompleteString);
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

-(void)writeValueCorrespondingXMLNode:(NSString*)nodeName value:(NSString*)nodeValue
{
    [self writeStartElement:nodeName];
    [self writeElementValue:nodeValue];
    [self writeEndElement:nil];
}

-(void)parseArrayComponent:(NSArray*)arrayObj forXMLNodeName:(NSString*)dictKeyName
{
    for (id obj in arrayObj) {
        if ([obj isKindOfClass:[NSArray class]]) {
            
            [self writeStartElement:dictKeyName]; //made changes after 2nd advanced test
            [self parseArrayComponent:obj forXMLNodeName:kDictToXMLArrNodeTest];
            [self writeEndElement:nil]; //made changes after 2nd advanced test
            
        }else if([obj isKindOfClass:[NSDictionary class]]){
            //[self writeStartElement:kDictToXMLDictNodeTest]; made changes after advanced test
            
            [self writeStartElement:dictKeyName];
            [self parseDictComponent:obj forXMLNodeName:kDictToXMLDictNodeTest];
            [self writeEndElement:nil];
            
            //[self writeEndElement:kDictToXMLDictNodeTest];
        }else{
            [self writeArrayCorrespondingXMLNode:dictKeyName value:[NSString stringWithFormat:@"%@",obj]];
            //[self writeElementValue:[NSString stringWithFormat:@"%@",obj]];
        }
    }
}

-(void)parseDictComponent:(NSDictionary*)dictObj forXMLNodeName:(NSString*)dictKeyName
{
    for (NSString* keyName in dictObj) {
        id obj = [dictObj valueForKey:keyName];
        
        if ([obj isKindOfClass:[NSArray class]]) {
            [self parseArrayComponent:obj forXMLNodeName:keyName];
        }else if([obj isKindOfClass:[NSDictionary class]]){
            [self writeStartElement:keyName]; //made changes after advanced test
            [self parseDictComponent:obj forXMLNodeName:keyName];
            [self writeEndElement:nil]; //made changes after advanced test
        }else{
            [self writeDictCorrespondingXMLNode:keyName value:[NSString stringWithFormat:@"%@",obj]];
        }
    }
}

@end
