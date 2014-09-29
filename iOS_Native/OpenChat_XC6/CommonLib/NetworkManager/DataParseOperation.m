//
//  DataParseOperation.m
//  OpenChat
//
//  Created by Ashish Nigam on 25/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import "DataParseOperation.h"

@interface DataParseOperation () <NSXMLParserDelegate>
{
    //NSArray* xmlNodeNames;
}
@property (nonatomic, strong) NSArray *appRecordList;
@property (nonatomic, strong) NSData *dataToParse;

@property (nonatomic, strong) NSMutableArray *workingArray;
@property (nonatomic, strong) NSMutableArray *workingArray1;
@property (nonatomic, strong) NSMutableArray *workingArray2;

@property (nonatomic, strong) AppRecord *workingEntry;

@property (nonatomic, strong) NSMutableArray *xmlNodeValues;
@property (nonatomic, strong) NSMutableDictionary *xmlNodeDict;

@property (nonatomic, strong) NSArray *xmlNodesValueList;
@property (nonatomic, strong) NSArray *xmlNodesValueDict;

@property (nonatomic, strong) NSMutableString *workingPropertyString;
@property (nonatomic, strong) NSArray *elementsToParse;
@property (nonatomic, readwrite) BOOL storingCharacterData;

@end

@implementation DataParseOperation
{
    NSArray* xmlNodeNames;
    NSString* kParentNodeName;
}

// -------------------------------------------------------------------------------
//	initWithData:
// -------------------------------------------------------------------------------
- (id)initWithData:(NSData *)data
{
    self = [super init];
    if (self != nil)
    {
        _dataToParse = data;
        _elementsToParse = [[NSArray alloc] initWithArray:xmlNodeNames];
    }
    return self;
}

// -------------------------------------------------------------------------------
//	main
//  Entry point for the operation.
//  Given data to parse, use NSXMLParser and process all the top paid apps.
// -------------------------------------------------------------------------------

// Using main instead of start method to override, as i do not want multiple parsing operaton at the same time.
// main is used for non-concurrent operation
- (void)main
{
    // The default implemetation of the -start method sets up an autorelease pool
    // just before invoking -main however it does NOT setup an excption handler
    // before invoking -main.  If an exception is thrown here, the app will be
    // terminated.
    
    self.workingArray = [NSMutableArray array];
    self.workingArray1 = [NSMutableArray array];
    self.workingArray2 = [NSMutableArray array];
    
    self.workingPropertyString = [NSMutableString string];
    
    // It's also possible to have NSXMLParser download the data, by passing it a URL, but this is not
    // desirable because it gives less control over the network, particularly in responding to
    // connection errors.
    //
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.dataToParse];
    [parser setDelegate:self];
    [parser parse];
    
    if (![self isCancelled])
    {
        // Set appRecordList to the result of our parsing
        self.appRecordList = [NSArray arrayWithArray:self.workingArray];
        
        self.xmlNodesValueList = [NSArray arrayWithArray:self.workingArray1];
        self.xmlNodesValueDict = [NSArray arrayWithArray:self.workingArray2];
        
    }
    
    self.workingArray = nil;
    self.workingArray1 = nil;
    self.workingArray2 = nil;
    self.workingPropertyString = nil;
    self.dataToParse = nil;
}

#pragma mark - RSS processing

// -------------------------------------------------------------------------------
//	parser:didStartElement:namespaceURI:qualifiedName:attributes:
// -------------------------------------------------------------------------------
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    // entry: { id (link), im:name (app name), im:image (variable height) }
    //
    if ([elementName isEqualToString:kParentNodeName])
    {
        self.workingEntry = [[AppRecord alloc] init];
        
        self.xmlNodeValues = [[NSMutableArray alloc] init];
        self.xmlNodeDict = [[NSMutableDictionary alloc] init];
    }
    self.storingCharacterData = [self.elementsToParse containsObject:elementName];
}

// -------------------------------------------------------------------------------
//	parser:didEndElement:namespaceURI:qualifiedName:
// -------------------------------------------------------------------------------
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if (self.workingEntry || self.xmlNodeValues || self.xmlNodeDict)
    {
        if (self.storingCharacterData)
        {
            NSString *trimmedString = [self.workingPropertyString stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [self.workingPropertyString setString:@""];  // clear the string for next time
            
            for (id obj in self.elementsToParse) {
                if ([elementName isEqualToString:obj])
                {
                    //self.workingEntry.appURLString = trimmedString;
                    [self.workingEntry.propertyNames addObject:trimmedString];
                    
                     [self.xmlNodeValues addObject:trimmedString];
                }
            }
            
            for (id obj in self.elementsToParse) {
                if ([elementName isEqualToString:obj])
                {
                    //self.workingEntry.appURLString = trimmedString;
                    [self.workingEntry.propertyNamesDict setObject:trimmedString forKey:obj];
                    
                    [self.xmlNodeDict setObject:trimmedString forKey:obj];
                }
            }
            
            
        }
        else if ([elementName isEqualToString:kParentNodeName])
        {
            [self.workingArray addObject:self.workingEntry];
            
            [self.workingArray1 addObject:self.xmlNodeValues];
            
            [self.workingArray2 addObject:self.xmlNodeDict];
            
            self.workingEntry = nil;
            self.xmlNodeValues = nil;
            self.xmlNodeDict = nil;
        }
    }
    
}

// -------------------------------------------------------------------------------
//	parser:foundCharacters:
// -------------------------------------------------------------------------------
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.storingCharacterData)
    {
        [self.workingPropertyString appendString:string];
    }
}

// -------------------------------------------------------------------------------
//	parser:parseErrorOccurred:
// -------------------------------------------------------------------------------
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    if (self.errorHandler)
        self.errorHandler(parseError);
}

@end
