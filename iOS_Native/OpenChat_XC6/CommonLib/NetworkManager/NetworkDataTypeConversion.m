//
//  NetworkDataTypeConversion.m
//  OpenChat
//
//  Created by Ashish Nigam on 26/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import "NetworkDataTypeConversion.h"
#import "XMLToDictionary.h"

@interface NetworkDataTypeConversion ()

@end

@implementation NetworkDataTypeConversion

-(id)DictionaryFromXML:(id)xmlOBJ
{
    // Parse the XML into a dictionary
    NSError *parseError = nil;
    NSDictionary *xmlDictionary = [XMLToDictionary dictionaryFromXMLString:xmlOBJ error:&parseError];
    
    // Print the dictionary
    NSLog(@"%@", xmlDictionary);
    return xmlDictionary;
}

@end
