//
//  ViewController.h
//  XMLTester
//
//  Created by Ashish Nigam on 02/10/14.
//  Copyright (c) 2014 bitsAndbytes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

// return the written xml string buffer
- (NSMutableString*) toString;
// return the written xml as data, set to the encoding used in the writeStartDocumentWithEncodingAndVersion method (UTF-8 per default)
- (NSData*) toData;

- (void) writeComment:(NSString*)comment;
- (void) writeEmptyElement:(NSString *)localName;

- (void) writeStartDocument;
- (void) writeStartDocumentWithVersion:(NSString*)version;
- (void) writeStartDocumentWithEncodingAndVersion:(NSString*)encoding version:(NSString*)version;
- (void) writeEndDocument; // write any remaining end elements

// Learn what are these things like:"ProcessingInstruction" in xml & CData then implement
- (void) writeProcessingInstruction:(NSString*)target data:(NSString*)data;
- (void) writeCData:(NSString*)cdata;

@end

