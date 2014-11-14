//
//  DictionaryToXML.m
//  OpenChat
//
//  Created by Ashish Nigam on 29/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import "DictionaryToXML.h"

@interface DictionaryToXML ()
{
    NSMutableString *xmlCompleteString;
    NSMutableString *xmlCurrentNode;
    NSMutableString *xmlCurrentnodeValue;
    
    NSMutableArray *xmlNodes;
    
    NSMutableArray *allKeysOfDict;
    NSMutableArray *allValuesOfDict;
    
    NSString *xmlEncoding_;
    
    BOOL documentEnded;
}

- (id)initWithError:(NSError **)error;
- (NSString *)xmlStringFromDict:(NSDictionary *)dict;

@property (nonatomic, strong) NSString *xmlEncoding;
@end

NSString *const kDictToXMLArrNodeTest = @"array";
NSString *const kDictToXMLDictNodeTest = @"dict";

NSString *const kDictToXMLTextNodeKey = @"text";

int const kDictToXMLProxyRange = 1000;

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

/*
-(void)testMethodWithSampleDict
{
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
    
    //    NSString *xmlDictionary = @"{items = {item = {id = 0001;type = donut;name = {text = Cake;};ppu = {text = 0.55;};batters = {batter = ({id =1001;text = Regular;},{id = 1002;text = Chocolate;},{id = 1003;text = Blueberry;});};topping = ({id = 5001;text = None;},{id = 5002;text = Glazed;},{id = 5005;text = Sugar;});};};}";
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"testDict" ofType:@"txt"];
    
    NSDictionary *myTestDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    [self xmlStringFromDict:myTestDict];
}
*/

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
    
    [self startParsingDictionary:dict withRootNodeName:@"root"];
    
    return xmlCompleteString;
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
    NSRange startRange = [xmlCompleteString rangeOfString:[NSString stringWithFormat:@"<%@>",nodeName]];
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

- (void) writeComment:(NSString*)comment beforeAttributedNode:(NSString*)nodeName
{
    NSRange startRange = [xmlCompleteString rangeOfString:[NSString stringWithFormat:@"<%@ ",nodeName]];
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

-(void)changeParentElement:(NSString*)elmtName
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

// specify node name and attributes will be added to that only
-(void)writeAttribute:(NSString*)attrName Value:(NSString*)attrValue toAttributedNode:(NSString*)nodeName
{
    xmlCompleteString= [[xmlCompleteString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<%@ ",nodeName] withString:[NSString stringWithFormat:@"<%@ %@=\"%@\" ",nodeName ,attrName,attrValue]] mutableCopy];
    
    //Below code will perform similar action as above
    //    NSRange startRange = [xmlCompleteString rangeOfString:[NSString stringWithFormat:@"<%@ ",nodeName]];
    //
    //    NSRange searchRange = NSMakeRange(startRange.location, [xmlCompleteString length]-startRange.location);
    //
    //    NSMutableString *tempStr = [[xmlCompleteString substringWithRange:searchRange] mutableCopy];
    //
    //    NSRange angBrLocation = [tempStr rangeOfString:@">"];
    //
    //    NSRange nodeRange = NSMakeRange(startRange.location, angBrLocation.location+1);
    //
    //    NSString *strToReplace = [xmlCompleteString substringWithRange:nodeRange];
    //
    //    NSMutableString* tempNodeStr = [strToReplace mutableCopy];
    //
    //    NSString *strWillReplace = [tempNodeStr stringByReplacingOccurrencesOfString:@">" withString:[NSString stringWithFormat:@" %@=\"%@\">",attrName,attrValue]];
    //
    //    xmlCompleteString= [[xmlCompleteString stringByReplacingOccurrencesOfString:strToReplace withString:strWillReplace] mutableCopy];
    
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

-(void)writeAttributes:(NSDictionary*)attrDict toAttributedNode:(NSString*)nodeName
{
    //xmlCurrentNode= [[xmlCurrentNode stringByReplacingOccurrencesOfString:@">" withString:@""] mutableCopy];
    
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    for (NSString* attrName in attrDict) {
        [tempStr appendString:[NSString stringWithFormat:@" %@=\"%@\"",attrName,[attrDict valueForKey:attrName]]];
    }
    [xmlCurrentNode appendString:[NSString stringWithFormat:@"%@",tempStr]];
    
    xmlCompleteString= [[xmlCompleteString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<%@ ",nodeName] withString:[NSString stringWithFormat:@"<%@ %@",nodeName ,tempStr]] mutableCopy];
    
}

-(void)writeElementValue:(NSString*)elementVal
{
    
    [xmlCurrentNode appendString:[NSString stringWithFormat:@"\"%@\"",elementVal]];
}

-(void)replaceNodeNameFrom:(NSString*)oldName toName:(NSString*)newName
{
    xmlCompleteString= [[xmlCompleteString stringByReplacingOccurrencesOfString:oldName withString:newName] mutableCopy];
}

-(void) performReplacementFrom:(NSString*)oldValue toNewValue:(NSString*)newValue
{
    xmlCompleteString = [[xmlCompleteString stringByReplacingOccurrencesOfString:oldValue withString:newValue] mutableCopy];
}

-(NSString*)valueAtFirstOccurenceOfNode:(NSString*)nodeName
{
    NSRange startRange = [xmlCompleteString rangeOfString:[NSString stringWithFormat:@"<%@>",nodeName]]; //prob resolved by making diff between node and attributed node
    
    NSRange endRange = [xmlCompleteString rangeOfString:[NSString stringWithFormat:@"</%@>",nodeName]];
    
    NSRange searchRange = NSMakeRange(startRange.location, (endRange.location-startRange.location)+endRange.length);
    
    NSMutableString *tempStr = [[xmlCompleteString substringWithRange:searchRange] mutableCopy];
    
    NSRange angBrLocation = [tempStr rangeOfString:@">"];
    NSLog(@"%lu %ld",angBrLocation.location , angBrLocation.length);
    
    NSRange endRange2 = [tempStr rangeOfString:[NSString stringWithFormat:@"</%@>",nodeName]];
    NSRange valueLength = NSMakeRange(angBrLocation.location+1, (endRange2.location-angBrLocation.location-1));
    
    NSString *nodeValue = [tempStr substringWithRange:valueLength];
    
    return nodeValue;
}

-(NSString*)valueAtFirstOccurenceOfAttributedNode:(NSString*)nodeName
{
    NSRange startRange = [xmlCompleteString rangeOfString:[NSString stringWithFormat:@"<%@ ",nodeName]]; //attributed node
    
    NSRange endRange = [xmlCompleteString rangeOfString:[NSString stringWithFormat:@"</%@>",nodeName]];
    
    NSRange searchRange = NSMakeRange(startRange.location, (endRange.location-startRange.location)+endRange.length);
    
    NSMutableString *tempStr = [[xmlCompleteString substringWithRange:searchRange] mutableCopy];
    
    NSRange angBrLocation = [tempStr rangeOfString:@">"];
    NSLog(@"%lu %ld",angBrLocation.location , angBrLocation.length);
    
    NSRange endRange2 = [tempStr rangeOfString:[NSString stringWithFormat:@"</%@>",nodeName]];
    NSRange valueLength = NSMakeRange(angBrLocation.location+1, (endRange2.location-angBrLocation.location-1));
    
    NSString *nodeValue = [tempStr substringWithRange:valueLength];
    
    return nodeValue;
}

-(NSString*)valueOfNode:(NSString*)nodeName atLocation:(NSRange)range
{
    NSRange startRange = range;
    
    NSRange endRange = [xmlCompleteString rangeOfString:[NSString stringWithFormat:@"</%@>",nodeName]];
    
    NSRange searchRange = NSMakeRange(startRange.location, (endRange.location-startRange.location)+endRange.length);
    
    NSMutableString *tempStr = [[xmlCompleteString substringWithRange:searchRange] mutableCopy];
    
    NSRange angBrLocation = [tempStr rangeOfString:@">"];
    NSLog(@"%lu %ld",angBrLocation.location , angBrLocation.length);
    
    NSRange endRange2 = [tempStr rangeOfString:[NSString stringWithFormat:@"</%@>",nodeName]];
    NSRange valueLength = NSMakeRange(angBrLocation.location+1, (endRange2.location-angBrLocation.location-1));
    
    NSString *nodeValue = [tempStr substringWithRange:valueLength];
    
    return nodeValue;
}

//Call this if all occurences of node have same value and wants replacement of all.
// value at the first occurence of node will be taken as replacement value
-(void)replaceNode:(NSString*)nodeName toValue:(NSString*)newValue
{
    NSString *nodeValue = [self valueAtFirstOccurenceOfNode:nodeName];
    
    xmlCompleteString = [[xmlCompleteString stringByReplacingOccurrencesOfString:nodeValue withString:newValue] mutableCopy];
    /*
     NSLog(@"%lu %ld",startRange.location , startRange.length);
     NSLog(@"%lu %ld",endRange.location , endRange.length);
     NSLog(@"%lu %ld",searchRange.location , searchRange.length);
     NSLog(@"%@",tempStr);
     NSLog(@"%@",nodeValue);
     NSLog(@"%@",xmlCompleteString);
     */
    
    // [self allLocationsOfNode:@"batter"];
}

//Call this if all occurences of node have same value and wants replacement of all.
// value at the first occurence of node will be taken as replacement value
-(void)replaceAttributedNode:(NSString*)nodeName toValue:(NSString*)newValue
{
    NSString *nodeValue = [self valueAtFirstOccurenceOfAttributedNode:nodeName];
    
    xmlCompleteString = [[xmlCompleteString stringByReplacingOccurrencesOfString:nodeValue withString:newValue] mutableCopy];
    /*
     NSLog(@"%lu %ld",startRange.location , startRange.length);
     NSLog(@"%lu %ld",endRange.location , endRange.length);
     NSLog(@"%lu %ld",searchRange.location , searchRange.length);
     NSLog(@"%@",tempStr);
     NSLog(@"%@",nodeValue);
     NSLog(@"%@",xmlCompleteString);
     */
    
    //  [self allLocationsOfCompleteNodeValue:@"node1"];
}

//Call this if all occurences of node have same value and wants replacement of all.
-(void)replaceNode:(NSString*)nodeName toValue:(NSString*)newValue atNodeLocation:(NSRange)location
{
    NSString *nodeValue = [self valueOfNode:nodeName atLocation:location];
    
    NSMutableArray *allLocationArr = [[self allOccurencesOf:nodeValue] mutableCopy];
    
    for (NSTextCheckingResult *match in allLocationArr) {
        NSRange matchRange = [match range];
        if (matchRange.location>location.location) {
            xmlCompleteString = [[xmlCompleteString stringByReplacingCharactersInRange:matchRange withString:newValue] mutableCopy];
        }
        break;
    }
    
    // xmlCompleteString = [[xmlCompleteString stringByReplacingOccurrencesOfString:nodeValue withString:newValue] mutableCopy];
    
}

//Call this if all occurences of node have same value and wants replacement of all.
-(void)replaceNode:(NSString*)nodeName toValue:(NSString*)newValue atValueLocation:(NSRange)location
{
    xmlCompleteString = [[xmlCompleteString stringByReplacingCharactersInRange:location withString:newValue] mutableCopy];
}

-(NSArray*)allOccurencesOf:(NSString*)name
{
    NSString *string = [NSString stringWithString:xmlCompleteString];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:name options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, [string length])];
    NSArray* allMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    NSLog(@"Found %lu",(unsigned long)numberOfMatches);
    
    return allMatches;
}

//Will return NSDictionary of length & location
//loction will be start of node location i.e index even before "<".
// length will be complete lenth with value and node end included. i.e length of <node>value here</node>
-(NSDictionary*)allLocationsOfCompleteNodeValue:(NSString*)nodeName
{
    NSMutableDictionary *allLocation = [[NSMutableDictionary alloc] init];
    
    
    NSMutableArray* allMatchesOfNodeStart = [[self allOccurencesOf:[NSString stringWithFormat:@"<%@",nodeName]] mutableCopy];
    
    NSMutableArray* allMatchesOfNodeEnd = [[self allOccurencesOf:[NSString stringWithFormat:@"</%@>",nodeName]] mutableCopy];
    
    if ([allMatchesOfNodeStart count]>[allMatchesOfNodeEnd count]) {
        while ([allMatchesOfNodeStart count]>[allMatchesOfNodeEnd count])
        {
            [allMatchesOfNodeStart removeObjectAtIndex:0];
        }
        
    }
    
    for (NSTextCheckingResult *match in allMatchesOfNodeStart) {
        NSRange matchStartRange = [match range];
        
        NSRange matchEndRange = [(NSTextCheckingResult *)[allMatchesOfNodeEnd objectAtIndex:[allMatchesOfNodeStart indexOfObject:match]] range];
        
        NSRange searchRange = NSMakeRange(matchStartRange.location, (matchEndRange.location-matchStartRange.location)+matchEndRange.length);
        
        [allLocation setObject:@{@"length":[NSNumber numberWithUnsignedInteger:searchRange.length], @"location":[NSNumber numberWithUnsignedInteger:searchRange.location]} forKey:[NSString stringWithFormat:@"%ld",[allMatchesOfNodeStart indexOfObject:match]]];
    }
    
    // NSLog(@"Found %@",allMatches);
    NSLog(@"Found %@",allLocation);
    
    return allLocation;
}

//Will return NSDictionary of length & location
//loction will be start of node location i.e index even before "<".
// length will be node lenth without value. i.e length of <node att="if any included">
-(NSDictionary*)allLocationsOfNode:(NSString*)nodeName
{
    NSMutableDictionary *allLocation = [[NSMutableDictionary alloc] init];
    
    
    NSMutableArray* allMatchesOfNodeStart = [[self allOccurencesOf:[NSString stringWithFormat:@"<%@",nodeName]] mutableCopy];
    
    NSMutableArray* allMatchesOfNodeEnd = [[self allOccurencesOf:[NSString stringWithFormat:@"</%@>",nodeName]] mutableCopy];
    
    if ([allMatchesOfNodeStart count]>[allMatchesOfNodeEnd count]) {
        while ([allMatchesOfNodeStart count]>[allMatchesOfNodeEnd count])
        {
            [allMatchesOfNodeStart removeObjectAtIndex:0];
        }
        
    }
    
    for (NSTextCheckingResult *match in allMatchesOfNodeStart) {
        NSRange matchStartRange = [match range];
        
        NSRange matchEndRange = [(NSTextCheckingResult *)[allMatchesOfNodeEnd objectAtIndex:[allMatchesOfNodeStart indexOfObject:match]] range];
        
        NSRange searchRange = NSMakeRange(matchStartRange.location, (matchEndRange.location-matchStartRange.location)+matchEndRange.length);
        
        NSMutableString *tempStr = [[xmlCompleteString substringWithRange:searchRange] mutableCopy];
        
        NSRange angOpenBrLocation = [tempStr rangeOfString:@"<"];
        NSRange angCloseBrLocation = [tempStr rangeOfString:@">"];
        
        //NSRange endRange2 = [tempStr rangeOfString:[NSString stringWithFormat:@"</%@>",nodeName]];
        NSRange nodeRange = NSMakeRange(matchStartRange.location, angCloseBrLocation.location-angOpenBrLocation.location+1);
        
        [allLocation setObject:@{@"length":[NSNumber numberWithUnsignedInteger:nodeRange.length], @"location":[NSNumber numberWithUnsignedInteger:nodeRange.location]} forKey:[NSString stringWithFormat:@"%ld",[allMatchesOfNodeStart indexOfObject:match]]];
    }
    
    // NSLog(@"Found %@",allMatches);
    NSLog(@"Found %@",allLocation);
    
    return allLocation;
}

-(void)allLocationsOfValuesOfNode:(NSString*)nodeName
{
    NSMutableDictionary *allLocation = [[NSMutableDictionary alloc] init];
    
    //considering regex pattern matching will go sequential matching.
    NSMutableArray* allMatches = [[self allOccurencesOf:[NSString stringWithFormat:@"<%@",nodeName]] mutableCopy];
    
    NSMutableArray* allMatchesOfNodeEnd = [[self allOccurencesOf:[NSString stringWithFormat:@"</%@>",nodeName]] mutableCopy];
    
    if ([allMatches count]>[allMatchesOfNodeEnd count]) {
        while ([allMatches count]>[allMatchesOfNodeEnd count])
        {
            [allMatches removeObjectAtIndex:0]; //considering regex pattern matching will go sequential matching.
        }
        
    }
    
    for (NSTextCheckingResult *match in allMatches) {
        NSRange matchRange = [match range];
        
        NSString *nodeValue = [self valueOfNode:nodeName atLocation:matchRange];
        
        NSRange nodeValueRange = [xmlCompleteString rangeOfString:nodeValue];
        
        [allLocation setObject:@{@"length":[NSNumber numberWithUnsignedInteger:nodeValueRange.length], @"location":[NSNumber numberWithUnsignedInteger:nodeValueRange.location]} forKey:[NSString stringWithFormat:@"%ld",[allMatches indexOfObject:match]]];
    }
    
    // NSLog(@"Found %@",allMatches);
    NSLog(@"Found %@",allLocation);
}

-(NSDictionary*)allValuesWithNode:(NSString*)nodeName
{
    NSMutableDictionary *allLocation = [[NSMutableDictionary alloc] init];
    
    
    NSMutableArray* allMatches = [[self allOccurencesOf:[NSString stringWithFormat:@"<%@",nodeName]] mutableCopy];
    
    NSMutableArray* allMatchesOfNodeEnd = [[self allOccurencesOf:[NSString stringWithFormat:@"</%@>",nodeName]] mutableCopy];
    
    if ([allMatches count]>[allMatchesOfNodeEnd count]) {
        while ([allMatches count]>[allMatchesOfNodeEnd count])
        {
            [allMatches removeObjectAtIndex:0]; //considering regex pattern matching will go sequential matching.
        }
        
    }
    
    for (NSTextCheckingResult *match in allMatches) {
        NSRange matchRange = [match range];
        
        NSString *nodeValue = [self valueOfNode:nodeName atLocation:matchRange];
        
        [allLocation setObject:nodeValue forKey:[NSString stringWithFormat:@"value%ld",[allMatches indexOfObject:match]]];
    }
    
    // NSLog(@"Found %@",allMatches);
    NSLog(@"Found %@",allLocation);
    
    return allLocation;
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
            
            
#ifdef twoWayCompatibility
            if ([keyName isEqualToString:kDictToXMLTextNodeKey]) {
                [self writeElementValue:[NSString stringWithFormat:@"%@",objOfKey]];
            }else{
                if (xmlCurrentNode) {
                    [self writeAttribute:keyName Value:[NSString stringWithFormat:@"%@",objOfKey]];
                }else{
                    [self writeAttribute:keyName Value:[NSString stringWithFormat:@"%@",objOfKey] toAttributedNode:nodeName];
                }
            }
#endif
#ifndef twoWayCompatibility
            
            [self writeValueCorrespondingXMLNode:keyName value:objOfKey];
#endif
        }
    }
    [self writeEndElement:nil];
    
    // [self allLocationsOfNode:@"batter"];
    // [self replaceNode:@"node1" toValue:@"11111111111"];
    
    // [self writeComment:@"test comment beforenode Ashsih Nigam" beforeNode:@"node1"];
    NSLog(@"%@",xmlCompleteString);
    documentEnded = YES;
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
#ifdef twoWayCompatibility
            if ([keyName isEqualToString:kDictToXMLTextNodeKey]) {
                [self writeElementValue:[NSString stringWithFormat:@"%@",obj]];
            }else{
                if (xmlCurrentNode) {
                    [self writeAttribute:keyName Value:[NSString stringWithFormat:@"%@",obj]];
                }else{
                    [self writeAttribute:keyName Value:[NSString stringWithFormat:@"%@",obj] toAttributedNode:dictKeyName];
                }
                
            }
#endif
#ifndef twoWayCompatibility
            [self writeDictCorrespondingXMLNode:keyName value:[NSString stringWithFormat:@"%@",obj]];
#endif
        }
    }
}

@end