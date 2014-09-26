//
//  NetworkDataTypeConversion.h
//  OpenChat
//
//  Created by Ashish Nigam on 26/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkDataTypeConversion : NSObject
{
}

-(id)XMLfromJSON:(id)jsonObj;
-(id)XMLfromDictionary:(id)dictObj;
-(id)XMLfromNSdata:(NSData*)dataObj;

-(id)JSONfromXML:(id)xmlOBJ;
-(id)JSONfromDictionary:(id)dictObj;
-(id)JSONfromNSdata:(NSData*)dataObj;

-(id)DictionaryFromXML:(id)xmlOBJ;
-(id)DictionaryFromJSON:(id)jsonOBJ;
-(id)DictionaryFromNSdata:(id)dataObj;

@end
