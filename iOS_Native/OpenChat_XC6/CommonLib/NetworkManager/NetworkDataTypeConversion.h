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
-(id)XMLStringfromDictionary:(id)dictObj;
-(id)XMLDatafromDictionary:(id)dictObj;

-(id)JSONfromXMLString:(id)xmlOBJ;
-(id)JSONfromXMLData:(NSData*)dataObj;
-(id)JSONfromDictionary:(id)dictObj;

-(id)DictionaryFromXMLString:(id)xmlOBJ;
-(id)DictionaryFromXMLData:(id)xmlOBJ;
-(id)DictionaryFromJSON:(id)jsonOBJ;

@end
