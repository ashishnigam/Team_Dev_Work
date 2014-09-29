//
//  XMLToDictionaryOperation.h
//  OpenChat
//
//  Created by Ashish Nigam on 29/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//


// How to use

/*
 
 // -------------------------------------------------------------------------------
 //	handleError:error
 // -------------------------------------------------------------------------------
 - (void)handleError:(NSError *)error
 {
 NSString *errorMessage = [error localizedDescription];
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"message"
 message:errorMessage
 delegate:nil
 cancelButtonTitle:@"OK"
 otherButtonTitles:nil];
 [alertView show];
 }
 
 // create the queue to run our ParseOperation
 self.queue = [[NSOperationQueue alloc] init];
 
 // create an ParseOperation (NSOperation subclass) to parse the RSS feed data
 // so that the UI is not blocked
 XMLToDictionaryOperation *parser = [[XMLToDictionaryOperation alloc] initWithData:self.appListData];
 
 parser.errorHandler = ^(NSError *parseError) {
 dispatch_async(dispatch_get_main_queue(), ^{
 [self handleError:parseError];
 });
 };
 
 // Referencing parser from within its completionBlock would create a retain
 // cycle.
 __weak XMLToDictionaryOperation *weakParser = parser;
 
 parser.completionBlock = ^(void) {
 if (weakParser.xmlDictionary) {
 // The completion block may execute on any thread.  Because operations
 // involving the UI are about to be performed, make sure they execute
 // on the main thread.
 dispatch_async(dispatch_get_main_queue(), ^{
 // The root rootViewController is the only child of the navigation
 // controller, which is the window's rootViewController.
 RootViewController *rootViewController = (RootViewController*)[(UINavigationController*)self.window.rootViewController topViewController];
 
 rootViewController.NSDictRefOfXML = weakParser.xmlDictionary;
 
 });
 }
 
 // we are finished with the queue and our ParseOperation
 self.queue = nil;
 };
 
 [self.queue addOperation:parser]; // this will start the "ParseOperation"
 
 */

#import <Foundation/Foundation.h>

// This NSOpearion is going to be non-concurrent operaiton, and wiull implememnt main method in this class.
// If concurrent version is also required then instead of main implement other required mewthod with the overriding of start method.

//===========================================================
// Concurrent Operation implementing "main()" mehtod.
//===========================================================


@interface XMLToDictionaryOperation : NSOperation <NSXMLParserDelegate>
{
   
}

// A block to call when an error is encountered during parsing.
@property (nonatomic, copy) void (^errorHandler)(NSError *error);

// from the input data.
// Only meaningful after the operation has completed.
@property (nonatomic, strong, readonly) NSDictionary *xmlDictionary;

// The initializer for this NSOperation subclass.
- (id)initWithXMLData:(NSData *)data;
- (id)initWithXMLString:(NSString *)string;

@end
