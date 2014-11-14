//
//  JSLibManager.m
//  OpenChat
//
//  Created by Ashish Nigam on 10/13/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import "JSLibManager.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <UIKit/UIKit.h>

@interface JSLibManager ()
{
    JSManagedValue *myplugin;
    JSContext *context;
    JSManagedValue *managedHandler;
    
   // NSString* ScriptFile;
}

@property (nonatomic, strong) NSString* libName;
@property (nonatomic, strong) NSString* libPath;

@property (nonatomic, strong) NSString* ScriptFile;

@end

@implementation JSLibManager

// The initializer for this NSOperation subclass.
- (id)initWithLibName:(NSString *)name
{
    self = [super init];
    if (self != nil)
    {
        self.libName = name;
        
    }
    return self;
}

- (id)initWithLibPath:(NSString *)path
{
    self = [super init];
    if (self != nil)
    {
        self.libPath = path;
        
    }
    return self;
}

-(NSString*)loadJSLib:(NSString*)name
{
    NSString *myJS = [[NSBundle mainBundle] pathForResource:name ofType:@"js"];
    NSString *Script = [NSString stringWithContentsOfFile:myJS encoding:NSUTF8StringEncoding error:nil];
    
    self.ScriptFile = Script;
    return Script;
}

-(NSString*)loadJSLibFromPath:(NSString*)path
{
    NSString *Script = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    self.ScriptFile = Script;
    return Script;
}


-(id)performJSSelector:(SEL)aSelector withObject:(id)object
{
    context = [[JSContext alloc] init];
    
    NSLog(@"context retuned = %@",context);
    
    context[@"JSLibManager"] = self;
    context[@"DelegateClass"] = self.delegate;
    
    NSDictionary *Ti = [NSDictionary dictionaryWithObjectsAndKeys:[self class],@"UI", nil];
    context[@"Ti"] = Ti;
    // JS-->OBJC calling example using bloacks
    
    context[@"makeNSColor"] = ^(NSDictionary *rgb){
        float red = [rgb[@"red"] floatValue];
        float green = [rgb[@"green"] floatValue];
        float blue = [rgb[@"blue"] floatValue];
        float alpha = 1.0f;
        
        UIColor *colorReturn = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
        return colorReturn;
    };
    
    __block JSLibManager *blockSelf = self;
    
    context[@"JSFunction"] = ^(NSDictionary *rect){
        float top = [rect[@"top"] floatValue];
        float left = [rect[@"left"] floatValue];
        float width = [rect[@"width"] floatValue];
        float height = [rect[@"height"] floatValue];
        
        
        [blockSelf performSelector:@selector(funcCall:) withObject:[NSNumber numberWithFloat:top]];
    };
    
    
    context[@"alert"] = ^(id message){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"alert" message:[NSString stringWithFormat:@"%@",message] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    };
    
    NSLog(@"context with ANViewController returned = %@",context);
    
    JSValue *value = [context evaluateScript:self.ScriptFile];
    
    NSLog(@"value retuned = %@",value);
    
    
    //Wrok starts here
    // from here on calling will work
    JSValue *function = context[@"initiateJSObj"];
    
    // OBJC-->JS calling example
    value = [function callWithArguments:@[]];
    
    NSLog(@"value afterfunc call retuned = %@",value);
    
    //creating managed object, having week ref
    myplugin = [JSManagedValue managedValueWithValue:value];
    
    NSLog(@"JSManagedValue retuned = %@",myplugin);
    
    [context.virtualMachine addManagedReference:myplugin withOwner:self];
    
    NSLog(@"context.virtualMachine addManagedReference retuned = %@ and VM = %@",context,context.virtualMachine);
    
    return nil;
}

-(id)performJSSelector:(SEL)aSelector withObject1:(id)object withObject2:(id)object1
{
    return nil;
}

-(void)unloadJSManagedRef
{
    JSContext *ctx = [JSContext currentContext];
    [ctx.virtualMachine removeManagedReference:myplugin withOwner:self];
    ctx = nil;
    myplugin = nil;
}

-(void)setOnClickHandler:(JSValue*)handler
{
    managedHandler = [JSManagedValue managedValueWithValue:handler];
    [context.virtualMachine addManagedReference:managedHandler withOwner:self];
}

@end
