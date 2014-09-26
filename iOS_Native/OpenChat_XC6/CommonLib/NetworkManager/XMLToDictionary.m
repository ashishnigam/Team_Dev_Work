//
//  XMLToDictionary.m
//  OpenChat
//
//  Created by Ashish Nigam on 26/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//


/*
 //
 // XML string from http://labs.adobe.com/technologies/spry/samples/data_region/NestedXMLDataSample.html
 //
 NSString *testXMLString = @"<items><item id=\"0001\" type=\"donut\"><name>Cake</name><ppu>0.55</ppu><batters><batter id=\"1001\">Regular</batter><batter id=\"1002\">Chocolate</batter><batter id=\"1003\">Blueberry</batter></batters><topping id=\"5001\">None</topping><topping id=\"5002\">Glazed</topping><topping id=\"5005\">Sugar</topping></item></items>";
 
 // Parse the XML into a dictionary
 NSError *parseError = nil;
 NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLString:testXMLString error:&parseError];
 
 // Print the dictionary
 NSLog(@"%@", xmlDictionary);
 
 //
 // testXMLString =
 //    <items>
 //        <item id=”0001″ type=”donut”>
 //            <name>Cake</name>
 //            <ppu>0.55</ppu>
 //            <batters>
 //                <batter id=”1001″>Regular</batter>
 //                <batter id=”1002″>Chocolate</batter>
 //                <batter id=”1003″>Blueberry</batter>
 //            </batters>
 //            <topping id=”5001″>None</topping>
 //            <topping id=”5002″>Glazed</topping>
 //            <topping id=”5005″>Sugar</topping>
 //        </item>
 //    </items>
 //
 // is converted into
 //
 // xmlDictionary = {
 //    items = {
 //        item = {
 //            id = 0001;
 //            type = donut;
 //            name = {
 //                text = Cake;
 //            };
 //            ppu = {
 //                text = 0.55;
 //            };
 //            batters = {
 //                batter = (
 //                    {
 //                        id = 1001;
 //                        text = Regular;
 //                    },
 //                    {
 //                        id = 1002;
 //                        text = Chocolate;
 //                    },
 //                    {
 //                        id = 1003;
 //                        text = Blueberry;
 //                    }
 //                );
 //            };
 //            topping = (
 //                {
 //                    id = 5001;
 //                    text = None;
 //                },
 //                {
 //                    id = 5002;
 //                    text = Glazed;
 //                },
 //                {
 //                    id = 5005;
 //                    text = Sugar;
 //                }
 //            );
 //        };
 //     };
 // }
 //
 */

#import "XMLToDictionary.h"

NSString *const kXMLReaderTextNodeKey = @"text";

@interface XMLToDictionary (Internal)

- (id)initWithError:(NSError **)error;
- (NSDictionary *)objectWithData:(NSData *)data;

@end

@implementation XMLToDictionary

#pragma mark -
#pragma mark Public methods

+ (NSDictionary *)dictionaryFromXMLData:(NSData *)data error:(NSError **)error
{
    XMLToDictionary *reader = [[XMLToDictionary alloc] initWithError:error];
    NSDictionary *rootDictionary = [reader objectWithData:data];
#if !__has_feature(objc_arc)
    [reader release];
#endif
    return rootDictionary;
}

+ (NSDictionary *)dictionaryFromXMLString:(NSString *)string error:(NSError **)error
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [XMLToDictionary dictionaryFromXMLData:data error:error];
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

- (NSDictionary *)objectWithData:(NSData *)data
{
#if !__has_feature(objc_arc)
    // Clear out any old data
    [dictionaryStack release];
    [textInProgress release];
#endif
    dictionaryStack = nil;
    textInProgress = nil;
    
    dictionaryStack = [[NSMutableArray alloc] init];
    textInProgress = [[NSMutableString alloc] init];
    
    // Initialize the stack with a fresh dictionary
    [dictionaryStack addObject:[NSMutableDictionary dictionary]];
    
    // Parse the XML
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    BOOL success = [parser parse]; // do it using NSOperation
    
    // Return the stack’s root dictionary on success
    if (success)
    {
        NSDictionary *resultDict = [dictionaryStack objectAtIndex:0];
        return resultDict;
    }
    
    return nil;
}

#pragma mark -
#pragma mark NSXMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // Get the dictionary for the current level in the stack
    NSMutableDictionary *parentDict = [dictionaryStack lastObject];
    
    // Create the child dictionary for the new element, and initilaize it with the attributes
    NSMutableDictionary *childDict = [NSMutableDictionary dictionary];
    [childDict addEntriesFromDictionary:attributeDict];
    
    // If there’s already an item for this key, it means we need to create an array
    id existingValue = [parentDict objectForKey:elementName];
    if (existingValue)
    {
        NSMutableArray *array = nil;
        if ([existingValue isKindOfClass:[NSMutableArray class]])
        {
            // The array exists, so use it
            array = (NSMutableArray *) existingValue;
        }
        else
        {
            // Create an array if it doesn’t exist
            array = [NSMutableArray array];
            [array addObject:existingValue];
            
            // Replace the child dictionary with an array of children dictionaries
            [parentDict setObject:array forKey:elementName];
        }
        
        // Add the new child dictionary to the array
        [array addObject:childDict];
    }
    else
    {
        // No existing value, so update the dictionary
        [parentDict setObject:childDict forKey:elementName];
    }
    
    // Update the stack
    [dictionaryStack addObject:childDict];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    // Update the parent dict with text info
    NSMutableDictionary *dictInProgress = [dictionaryStack lastObject];
    
    // Set the text property
    if ([textInProgress length] > 0)
    {
        // Get rid of leading + trailing whitespace
        [dictInProgress setObject:textInProgress forKey:kXMLReaderTextNodeKey];

#if !__has_feature(objc_arc)
        // Reset the text
        [textInProgress release];
#endif
        textInProgress = nil;
        
        textInProgress = [[NSMutableString alloc] init];
    }
    
    // Pop the current dict
    [dictionaryStack removeLastObject];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // Build the text value
    [textInProgress appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    // Set the error pointer to the parser’s error object
    errorPtr = parseError;
}

@end
