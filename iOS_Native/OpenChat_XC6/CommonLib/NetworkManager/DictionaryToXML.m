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
    [dictionaryStack release];
    [textInProgress release];
#endif
    dictionaryStack = nil;
    textInProgress = nil;
    
    dictionaryStack = [[NSMutableArray alloc] init];
    textInProgress = [[NSMutableString alloc] init];
    
    // Initialize the stack with a fresh dictionary
    [dictionaryStack addObject:[NSMutableDictionary dictionary]];
    
    
    
    // Return the stack’s root dictionary on success
    if (YES)
    {
        NSString *resultStr = [dictionaryStack objectAtIndex:0];
        return resultStr;
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
        [dictInProgress setObject:textInProgress forKey:kDictToXMLTextNodeKey];
        
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
