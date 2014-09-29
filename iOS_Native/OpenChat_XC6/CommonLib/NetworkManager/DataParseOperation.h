//
//  DataParseOperation.h
//  OpenChat
//
//  Created by Ashish Nigam on 25/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//


// AppRecord.h interface, nothing to do in implementaiton

/*
//
//  AppRecord.h
//  OpenChat
//
//  Created by Ashish Nigam on 26/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppRecord : NSObject

@property (nonatomic,strong) NSMutableArray *propertyNames; // make these 2 property part of data parse operation class, as user may not create class like this
@property (nonatomic,strong) NSMutableDictionary *propertyNamesDict;

@end
*/



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
 DataParseOperation *parser = [[DataParseOperation alloc] initWithData:self.appListData];
 
 parser.errorHandler = ^(NSError *parseError) {
 dispatch_async(dispatch_get_main_queue(), ^{
 [self handleError:parseError];
 });
 };
 
 // Referencing parser from within its completionBlock would create a retain
 // cycle.
 __weak DataParseOperation *weakParser = parser;
 
 parser.completionBlock = ^(void) {
 if (weakParser.appRecordList) {
 // The completion block may execute on any thread.  Because operations
 // involving the UI are about to be performed, make sure they execute
 // on the main thread.
 dispatch_async(dispatch_get_main_queue(), ^{
 // The root rootViewController is the only child of the navigation
 // controller, which is the window's rootViewController.
 RootViewController *rootViewController = (RootViewController*)[(UINavigationController*)self.window.rootViewController topViewController];
 
 rootViewController.entries = weakParser.appRecordList;
 
 // tell our table view to reload its data, now that parsing has completed
 [rootViewController.tableView reloadData];
 });
 }
 
 // we are finished with the queue and our ParseOperation
 self.queue = nil;
 };
 
 [self.queue addOperation:parser]; // this will start the "ParseOperation"
 
 */

#import <Foundation/Foundation.h>

#ifndef AppRecordUsed
    #define AppRecordUsed // will be removed in future build due to generic implementation
#endif

#ifdef AppRecordUsed

#import "AppRecord.h" // this class will be implemented by developer using this lib, see example above as hint.

#endif

extern NSArray* xmlNodeNames;

//Example string to be parsed
/*
 // string contants found in the RSS feed
 static NSString *kIDStr     = @"id";
 static NSString *kNameStr   = @"im:name";
 static NSString *kImageStr  = @"im:image";
 static NSString *kArtistStr = @"im:artist";
 static NSString *kParentNodeName  = @"entry";  //Parent node name
 */

//NSArray* xmlNodeNames = [[NSArray alloc] initWithObjects:kIDStr, kNameStr, kImageStr, kArtistStr, nil];

extern NSString* kParentNodeName;

@interface DataParseOperation : NSOperation

// A block to call when an error is encountered during parsing.
@property (nonatomic, copy) void (^errorHandler)(NSError *error);

// NSArray containing AppRecord instances for each entry parsed
// from the input data.
// Only meaningful after the operation has completed.
@property (nonatomic, strong, readonly) NSArray *appRecordList; // will be used when user provide separate AppRecord 

@property (nonatomic, strong, readonly) NSArray *xmlNodesValueList;
@property (nonatomic, strong, readonly) NSArray *xmlNodesValueDict;

// The initializer for this NSOperation subclass.
- (id)initWithData:(NSData *)data;

@end
