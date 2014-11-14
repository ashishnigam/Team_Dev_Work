//
//  NetworkDataTypeConversion.m
//  OpenChat
//
//  Created by Ashish Nigam on 26/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import "NetworkDataTypeConversion.h"
#import "XMLToDictionary.h"
#import "DictionaryToXML.h"

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

-(id)XMLStringfromDictionary:(id)dictObj
{
    // Parse the XML into a dictionary
    NSError *parseError = nil;
    NSString *xmlString = [DictionaryToXML XMLStringFromDictionary:dictObj error:&parseError];
    
    // Print the dictionary
    NSLog(@"%@", xmlString);
    return xmlString;
}

-(id)XMLDatafromDictionary:(id)dictObj
{
    NSString* xmlString = [self XMLStringfromDictionary:dictObj];
    return [xmlString dataUsingEncoding:NSUTF8StringEncoding];
}

-(NSData*)propertyListFromDict:(NSDictionary*)dict
{
    NSError *error = nil;
    
    NSData *xmlData = [NSPropertyListSerialization dataWithPropertyList:dict format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    
    NSLog(@"Apple Property list type XML created from dictionary %@",xmlData);
    
    return xmlData;
}

-(NSDictionary*)dictFromPropertyList:(NSData*)plistData
{
    NSError *error = nil;
    
    NSPropertyListFormat plistFormat;
    //    Getting back dictionary from plist type XML formed using Apple APIs
    NSDictionary *plistDict = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListImmutable format:&plistFormat error:&error];
    
    NSLog(@"Dictionary created from plist %@",plistDict);
    
    return plistDict;
}

@end
