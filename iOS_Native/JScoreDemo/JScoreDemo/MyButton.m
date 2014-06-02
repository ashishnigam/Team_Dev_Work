//
//  MyButton.m
//  JScoreDemo
//
//  Created by Ashish Nigam on 27/05/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import "MyButton.h"

@interface MyButton ()
{
    JSManagedValue *managedHandler;
}

// not visible in JS
//-(id)myPrivateMethod;

@end

@implementation MyButton

@synthesize name,top,left,bottom,right;
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(id)onClick:(id)handler// callback:(JSValue*)func;
{
    NSLog(@"button click %@",handler);
    managedHandler = [JSManagedValue managedValueWithValue:handler];
    //[[JSContext currentContext].virtualMachine addManagedReference:managedHandler withOwner:self];
    
    return nil;
}

-(void)removeButton:(id)handler
{
    [self removeFromSuperview];

}

+(MyButton*)createButton:(NSDictionary*)args;
{
    NSDictionary *rect = [NSDictionary dictionaryWithDictionary:args];
    float top = [rect[@"top"] floatValue];
    float left = [rect[@"left"] floatValue];
    float width = [rect[@"width"] floatValue];
    float height = [rect[@"height"] floatValue];
    NSString *btnTitle = rect[@"title"];
    
    MyButton *btn = [[self alloc] initWithFrame:CGRectMake(left, top, width, height)];
    [btn.titleLabel setNumberOfLines:0];
    [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btn setTitle:btnTitle forState:UIControlStateNormal];
    return btn;
}



-(void)clickHappened:(id)args
{
    NSLog(@"managedHandler = %@",managedHandler);
    NSLog(@"managedHandler value = %@",[managedHandler value]);
    NSLog(@"managedHandler value = %d",[[managedHandler value] isObject]);
    
    JSValue *callbackVal = [managedHandler value];
    
    
     NSLog(@"managedHandler value = %@",callbackVal[@"callback"]);
    
    [callbackVal callWithArguments:@[@"hello button"]];
}

//-(void)setOnClickHandler:(JSValue*)handler
//{
//    JSManagedValue *managedHandler = [JSManagedValue managedValueWithValue:handler];
//    [context.virtualMachine addManagedReference:managedHandler withOwner:self];
//    _onClickHandler = managedHandler;
//}

@end
