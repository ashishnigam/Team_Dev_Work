//
//  XMLStreamWriter.h
//  xswi
//
//  Created by Thomas Skjølberg on 9/24/10.
//  Copyright 2010 Adactus. All rights reserved.
//
#import <Foundation/Foundation.h>

// xml stream writer
@protocol XMLStreamWriter

- (void) writeStartDocument;
- (void) writeStartDocumentWithVersion:(NSString*)version;
- (void) writeStartDocumentWithEncodingAndVersion:(NSString*)encoding version:(NSString*)version;

- (void) writeStartElement:(NSString *)localName;

- (void) writeEndElement;
- (void) writeEndElement:(NSString *)localName;

- (void) writeEmptyElement:(NSString *)localName;

- (void) writeEndDocument;

- (void) writeAttribute:(NSString *)localName value:(NSString *)value;

- (void) writeCharacters:(NSString*)text;
- (void) writeComment:(NSString*)comment;
- (void) writeProcessingInstruction:(NSString*)target data:(NSString*)data;
- (void) writeCData:(NSString*)cdata;

- (void) close;
- (void) flush;

@end

// xml stream writer with namespace support
@protocol NSXMLStreamWriter <XMLStreamWriter>

- (void) writeStartElementWithNamespace:(NSString *)namespaceURI localName:(NSString *)localName;
- (void) writeEndElementWithNamespace:(NSString *)namespaceURI localName:(NSString *)localName;
- (void) writeEmptyElementWithNamespace:(NSString *)namespaceURI localName:(NSString *)localName;

- (void) writeAttributeWithNamespace:(NSString *)namespaceURI localName:(NSString *)localName value:(NSString *)value;

- (void)setPrefix:(NSString*)prefix namespaceURI:(NSString *)namespaceURI;
- (void)setDefaultNamespace:(NSString*)namespaceURI;

- (void) writeDefaultNamespace:(NSString*)namespaceURI;
- (void) writeNamespace:(NSString*)prefix namespaceURI:(NSString *)namespaceURI;

- (NSString*)getPrefix:(NSString*)namespaceURI;
- (NSString*)getNamespaceURI:(NSString*)prefix;

@end