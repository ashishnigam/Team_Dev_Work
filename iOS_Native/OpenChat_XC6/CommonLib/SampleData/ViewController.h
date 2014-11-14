//
//  ViewController.h
//  XMLTester
//
//  Created by Ashish Nigam on 02/10/14.
//  Copyright (c) 2014 bitsAndbytes. All rights reserved.
//

//
// testXMLString =
//    <items>
//        <item id=”0001″ type=”donut”>
//            <name>Cake</name>
//            <ppu>0.55</ppu>
//            <batters>
//                <batter id=”1001″>Regular</batter>
//                <batter id=”1002″>Chocolate</batter>
//                <batter id=”1003″>Blueberry</batter>
//            </batters>
//            <topping id=”5001″>None</topping>
//            <topping id=”5002″>Glazed</topping>
//            <topping id=”5005″>Sugar</topping>
//        </item>
//    </items>
//
// is converted into
//
// xmlDictionary = {
//    items = {
//        item = {
//            id = 0001;
//            type = donut;
//            name = {
//                text = Cake;
//            };
//            ppu = {
//                text = 0.55;
//            };
//            batters = {
//                batter = (
//                    {
//                        id = 1001;
//                        text = Regular;
//                    },
//                    {
//                        id = 1002;
//                        text = Chocolate;
//                    },
//                    {
//                        id = 1003;
//                        text = Blueberry;
//                    }
//                );
//            };
//            topping = (
//                {
//                    id = 5001;
//                    text = None;
//                },
//                {
//                    id = 5002;
//                    text = Glazed;
//                },
//                {
//                    id = 5005;
//                    text = Sugar;
//                }
//            );
//        };
//     };
// }
//


#import <UIKit/UIKit.h>

#define twoWayCompatibility

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

