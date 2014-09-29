//
//  XMLToDictionaryOperation.m
//  OpenChat
//
//  Created by Ashish Nigam on 29/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import "XMLToDictionaryOperation.h"

NSString *const kXMLToDictOperationTextNodeKey = @"text";

@interface XMLToDictionaryOperation ()
{
    NSMutableArray *dictionaryStack;
    NSMutableString *textInProgress;
    NSError *errorPtr;
}

@property (nonatomic, strong) NSData *xmlDataToDict;
@property (nonatomic, strong) NSDictionary *xmlDictionary;

- (id)initWithError:(NSError **)error;
- (NSDictionary *)objectWithData:(NSData *)data;

//+ (NSDictionary *)dictionaryFromXMLData:(NSData *)data error:(NSError **)errorPointer;
//+ (NSDictionary *)dictionaryFromXMLString:(NSString *)string error:(NSError **)errorPointer;

@end

@implementation XMLToDictionaryOperation

#pragma mark -
#pragma mark Public methods

// -------------------------------------------------------------------------------
//	initWithData:
// -------------------------------------------------------------------------------
- (id)initWithXMLData:(NSData *)data
{
    self = [super init];
    if (self != nil)
    {
        self.xmlDataToDict = data;
        
    }
    return self;
}

// -------------------------------------------------------------------------------
//	initWithString:
// -------------------------------------------------------------------------------
- (id)initWithXMLString:(NSString *)string
{
    self = [super init];
    if (self != nil)
    {
        self.xmlDataToDict = [string dataUsingEncoding:NSUTF8StringEncoding];
    }
    return self;
}



//+ (NSDictionary *)dictionaryFromXMLData:(NSData *)data error:(NSError **)error
//{
//    XMLToDictionaryOperation *reader = [[XMLToDictionaryOperation alloc] initWithError:error];
//    NSDictionary *rootDictionary = [reader objectWithData:data];
//#if !__has_feature(objc_arc)
//    [reader release];
//#endif
//    return rootDictionary;
//}
//
//+ (NSDictionary *)dictionaryFromXMLString:(NSString *)string error:(NSError **)error
//{
//    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
//    return [XMLToDictionaryOperation dictionaryFromXMLData:data error:error];
//}

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

-(void)main
{
    // The default implemetation of the -start method sets up an autorelease pool
    // just before invoking -main however it does NOT setup an excption handler
    // before invoking -main.  If an exception is thrown here, the app will be
    // terminated.
    
    
    // It's also possible to have NSXMLParser download the data, by passing it a URL, but this is not
    // desirable because it gives less control over the network, particularly in responding to
    // connection errors.
    //
    
//    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.xmlDataToDict];
//    [parser setDelegate:self];
//    [parser parse];
    
     // return dictionary/value ignored as, after completion getting dictionary from dictionaryStack
    NSDictionary *rootDictionary = [self objectWithData:self.xmlDataToDict];
    
    // Though it should be working find, but in case any issue in real time.
    // - (NSDictionary *)objectWithData:(NSData *)data
    // Method implementation can be removed or manipulated as if required
    
    if (![self isCancelled])
    {
        // Set appRecordList to the result of our parsing
        self.xmlDictionary = [dictionaryStack objectAtIndex:0];
        
    }
    
    self.xmlDataToDict = nil;
    
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
        [dictInProgress setObject:textInProgress forKey:kXMLToDictOperationTextNodeKey];
        
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
    if (self.errorHandler)
        self.errorHandler(parseError);
}

@end
