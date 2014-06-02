//
//  ANMakePoint.h
//  JScoreDemo
//
//  Created by Ashish Nigam on 26/05/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

// This Protocol can be used as a JS class and property will work as JS getter and setter.
// instance methods will work as instance methods and class methods as bound with class container object.

@protocol ANMakePointExports <JSExport>

@property double x;
@property double y;

-(NSString*)descriptionMethod;

+(double)makeMyPointWithX:(double)x;
@end

@interface ANMakePoint : NSObject <ANMakePointExports>
-(id)initWithX:(double)x Y:(double)y;
@end
