//
//  MyButton.h
//  JScoreDemo
//
//  Created by Ashish Nigam on 27/05/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@class MyButton;
@protocol MyButtonExports <JSExport>

@property (readwrite,nonatomic) NSString* name;
@property double top;
@property double left;
@property double bottom;
@property double right;

-(id)onClick:(JSValue*)handler;
-(void)removeButton:(id)handler;

+(MyButton*)createButton:(id)args;

@end

@interface MyButton : UIButton <MyButtonExports>

-(void)clickHappened:(id)args;
@end
