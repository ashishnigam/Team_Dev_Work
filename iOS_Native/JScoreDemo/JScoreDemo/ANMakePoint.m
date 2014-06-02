//
//  ANMakePoint.m
//  JScoreDemo
//
//  Created by Ashish Nigam on 26/05/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import "ANMakePoint.h"

@interface ANMakePoint ()
{
   
}

// not visible in JS
-(id)myPrivateMethod;

@end

@implementation ANMakePoint

@synthesize x,y;

-(id)init
{
    if (self = [super init]) {

        return self;
    }
    return self;
}

-(id)initWithX:(double)X Y:(double)Y;
{
    if ([self init]) {
        self.x = X;
        self.y = Y;
        return self;
    }
    return self;
}

-(NSString*)descriptionMethod
{
    return @"ANMakePoint";
}

+(double)makeMyPointWithX:(double)x{
    return 20.0;
}

-(id)myPrivateMethod
{
    return [self descriptionMethod];
}
@end
