//
//  ANViewController.m
//  JScoreDemo
//
//  Created by Ashish Nigam on 23/05/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import "ANViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ANViewController ()
{
    JSManagedValue *myplugin;
    JSContext *context;
    JSManagedValue *managedHandler;
    
    ANMakePoint *point1,*point2;
}

@end

@implementation ANViewController

-(NSString*)loadMyJavaScript:(NSString*)name
{
    NSString *myJS = [[NSBundle mainBundle] pathForResource:name ofType:@"js"];
    NSString *Script = [NSString stringWithContentsOfFile:myJS encoding:NSUTF8StringEncoding error:nil];
    return Script;
}

-(id)JSCoreFundamental:(id)args
{
    
   // NSString *myJSPath = [self loadMyJavaScript:@"CompleteWorkingSample"];
    //[NSString stringWithContentsOfFile:myJSPath encoding:NSUTF8StringEncoding error:nil];
    NSString *Script = [self loadMyJavaScript:@"CompleteWorkingSample"];
    NSLog(@"Script retuned = %@",Script);
    
    context = [[JSContext alloc] init];
    
    NSLog(@"context retuned = %@",context);
    
    context[@"ANViewController"] = self;
    context[@"Button"] = [MyButton class];
    
    NSDictionary *Ti = [NSDictionary dictionaryWithObjectsAndKeys:[MyButton class],@"UI", nil];
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
    
    __block ANViewController *blockSelf = self;
    context[@"createButton"] = ^(NSDictionary *rect){
        float top = [rect[@"top"] floatValue];
        float left = [rect[@"left"] floatValue];
        float width = [rect[@"width"] floatValue];
        float height = [rect[@"height"] floatValue];
        
        MyButton *button = [[MyButton alloc] initWithFrame:CGRectMake(left, top, width, height)];
        
        [button setBackgroundColor:[UIColor grayColor]];
        [button addTarget:button action:@selector(clickHappened:) forControlEvents:UIControlEventTouchUpInside];
        [blockSelf.completeSampleView addSubview:button];
        return button;
    };
    
    
    context[@"alert"] = ^(id message){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"alert" message:[NSString stringWithFormat:@"%@",message] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    };
    
    NSLog(@"context with ANViewController retuned = %@",context);
    
    JSValue *value = [context evaluateScript:Script];
    
    NSLog(@"value retuned = %@",value);
    
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

-(id)loadBasicJSCalling:(id)args
{
    // Do any additional setup after loading the view, typically from a nib.
    NSString *myJSPath =[[NSBundle mainBundle] pathForResource:@"SimpleJSCalling" ofType:@"js"];
    
    NSString *Script = [NSString stringWithContentsOfFile:myJSPath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"Script retuned = %@",Script);
    
    JSContext *contextLocal = [[JSContext alloc] init];
    
    NSLog(@"context object = %@",contextLocal);
    
   // contextLocal[@"ANViewController"] = self;
    JSValue *basicScriptResult = [contextLocal evaluateScript:@"2+2"];
    
    NSLog(@"basicScriptResult result = %@",basicScriptResult);
    
    JSValue *selfCallingFuncResult = [contextLocal evaluateScript:Script];
    
    NSLog(@"selfCallingFuncResult retuned = %@",selfCallingFuncResult);
    
    JSValue *PrintHelloFunction = contextLocal[@"PrintHello"];
    
    // OBJC-->JS calling example
    JSValue *PrintHelloFuncResult = [PrintHelloFunction callWithArguments:@[@"Ashish"]];
    
    NSLog(@"PrintHelloFuncResult retuned = %@",PrintHelloFuncResult);
    
    UIAlertView *helloAlert = [[UIAlertView alloc] initWithTitle:@"JS Calling Works" message:[PrintHelloFuncResult toString] delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
    [helloAlert show];
    
    return nil;
}


-(id)bothWayFuncCalling:(id)args
{
    // Do any additional setup after loading the view, typically from a nib.
    NSString *myJSPath =[[NSBundle mainBundle] pathForResource:@"BothWayCalling" ofType:@"js"];
    
    NSString *Script = [NSString stringWithContentsOfFile:myJSPath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"Script retuned = %@",Script);
    
    JSContext *contextLocal = [[JSContext alloc] init];
    
    NSLog(@"context object = %@",contextLocal);
    
    //contextLocal[@"ANViewController"] = self;
    JSValue *basicScriptResult = [contextLocal evaluateScript:@"2+2"];
    
    NSLog(@"basicScriptResult result = %@",basicScriptResult);
    
    JSValue *selfCallingFuncResult = [contextLocal evaluateScript:Script];
    
    NSLog(@"selfCallingFuncResult retuned = %@",selfCallingFuncResult);
    
    JSValue *PrintHelloFunction = contextLocal[@"PrintHello"];
    
    // OBJC-->JS calling example
    JSValue *PrintHelloFuncResult = [PrintHelloFunction callWithArguments:@[@"Ashish"]];
    
    NSLog(@"PrintHelloFuncResult retuned = %@",PrintHelloFuncResult);
    
    UIAlertView *helloAlert = [[UIAlertView alloc] initWithTitle:@"JS Calling Works" message:[PrintHelloFuncResult toString] delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
    [helloAlert show];
    
    
    contextLocal[@"objcMethodCall"] = ^(NSString *parms){
        
        UIAlertView *helloAlert1 = [[UIAlertView alloc] initWithTitle:@"I received a call from Java Script" message:parms delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
        [helloAlert1 show];
    };
    
    contextLocal[@"sendMyName"] = ^(NSString *parms){
        
        UIAlertView *helloAlert2 = [[UIAlertView alloc] initWithTitle:@"JS called me with Name" message:parms delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
        [helloAlert2 show];
    };
    
    JSValue *objcCallFunction = contextLocal[@"willCallObjcMethod"];
    NSLog(@"PrintHelloFuncResult retuned = %@",objcCallFunction);
    
    JSValue *objcCallFuncResult = [objcCallFunction callWithArguments:@[@"Hello JS"]];
    NSLog(@"PrintHelloFuncResult retuned = %@",objcCallFuncResult);
    
    JSValue *objcCallByNameFunction = contextLocal[@"objcCallByName"];
    NSLog(@"PrintHelloFuncResult retuned = %@",objcCallByNameFunction);
    
    JSValue *sendMyName = [JSValue valueWithObject:contextLocal[@"sendMyName"] inContext:contextLocal];
    
    JSValue *objcCallByNameFuncResult = [objcCallByNameFunction callWithArguments:@[sendMyName]];
    NSLog(@"PrintHelloFuncResult retuned = %@",objcCallByNameFuncResult);
    
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
 //   [self loadBasicJSCalling:nil];
    
 //   [self bothWayFuncCalling:nil];
    
    [self JSCoreFundamental:nil];
    
    
}

- (IBAction)multiplyFunc:(id)sender {
    
    JSValue *plgIn = [myplugin value];
    
    NSLog(@"plgIn retuned = %@",plgIn);
    
    JSValue *multiplyFunction = plgIn[@"multiply"];
    
    NSLog(@"multiplyFunction retuned = %@",multiplyFunction);
    
    JSValue *result1 = [multiplyFunction callWithArguments:@[@3]];
    
    NSLog(@"isObject = %d",[result1 isObject]);
    
    if ([result1 isObject]) {
        JSValue *resultVal = result1[@"rs"];
        NSString *str = [NSString stringWithFormat:@"Received an object while expecting number but object contains result = %d",[resultVal toInt32]];
        
        UIAlertView *helloAlert2 = [[UIAlertView alloc] initWithTitle:@"Alert" message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [helloAlert2 show];
        self.resultLbl.text = [NSString stringWithFormat:@"Object Contains = %d",[resultVal toInt32]];
        
    }else{
        self.resultLbl.text = [NSString stringWithFormat:@"%d",[result1 toInt32]];
    }
}

- (IBAction)divisionFunc:(id)sender {
    
    
    JSValue *plgIn = [myplugin value];
    
    NSLog(@"plgIn retuned = %@",plgIn);
    
    JSValue *divisionFunction = plgIn[@"division"];
    
    NSLog(@"division retuned = %@",divisionFunction);
    
    JSValue *result1 = [divisionFunction callWithArguments:@[@5]];
    
    self.resultLbl.text = [NSString stringWithFormat:@"%d",[result1 toInt32]];
    
}

- (IBAction)addFunc:(id)sender {
    
    JSValue *plgIn = [myplugin value];
    
    NSLog(@"plgIn retuned = %@",plgIn);
   // context[@"Button.ParentView"] = [self.view class];
    
    JSValue *willCreateButton = plgIn[@"willCreateButton"];
    
    NSLog(@"multiFunction retuned = %@",willCreateButton);
    
    JSValue *result1 = [willCreateButton callWithArguments:@[@3]];
    
    NSLog(@"result1 retuned = %d",[result1 isObject]);
    
    if ([result1 isObject]) {
        [[result1 toObjectOfClass:[MyButton class]] setTitle:@"WOW Wonder" forState:UIControlStateNormal];
    }else{
        self.resultLbl.text = [NSString stringWithFormat:@"%d",[result1 toInt32]];
    }
}

- (IBAction)subFunc:(id)sender {
    
    JSValue *plgIn = [myplugin value];
    
    NSLog(@"plgIn retuned = %@",plgIn);
    
    JSValue *willRemoveButton = plgIn[@"willRemoveButton"];
    
    NSLog(@"multiFunction retuned = %@",willRemoveButton);
    
   // JSValue *result1 = [willRemoveButton callWithArguments:@[@"class"]];
    JSValue *result1 = [willRemoveButton callWithArguments:@[]];
    
    NSLog(@"Class Button removed = %d",[result1 toBool]);
    
}

- (IBAction)addlabel:(id)sender {
    JSValue *plgIn = [myplugin value];
    
    NSLog(@"plgIn retuned = %@",plgIn);
    
    JSValue *addLabelFunction = plgIn[@"addLabel"];
    
    NSLog(@"addLabelFunction retuned = %@",addLabelFunction);
    
    JSValue *result1 = [addLabelFunction callWithArguments:@[@3]];
    
    NSLog(@"result1 retuned = %d",[result1 isObject]);
    
    if ([result1 isObject]) {
        self.resultLbl.text = @"ashish nigam";
        self.resultLbl.textColor = [result1 toObjectOfClass:[UIColor class]];
        self.resultLbl.backgroundColor = [UIColor yellowColor];//[result1 toObjectOfClass:[UIColor class]];
    }else{
        self.resultLbl.text = [NSString stringWithFormat:@"%d",[result1 toInt32]];
    }
}

- (IBAction)usingClassCreateButton:(id)sender {
    
    JSValue *plgIn = [myplugin value];
    
    NSLog(@"plgIn retuned = %@",plgIn);
    // context[@"Button.ParentView"] = [self.view class];
    
    JSValue *useClassCreateButton = plgIn[@"useClassCreateButton"];
    
    NSLog(@"useClassCreateButton retuned = %@",useClassCreateButton);
    
    JSValue *result1 = [useClassCreateButton callWithArguments:@[]];
    
    NSLog(@"result1 retuned = %d",[result1 isObject]);
    
    if ([result1 isObject]) {
        MyButton *btn = [result1 toObjectOfClass:[MyButton class]];
        [btn setBackgroundColor:[UIColor greenColor]];
        [btn addTarget:btn action:@selector(clickHappened:) forControlEvents:UIControlEventTouchUpInside];
        
        NSLog(@"btn retuned = %@",btn);
        [btn.titleLabel setNumberOfLines:0];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
       // [btn setTitle:@"Usign JS Class\n Wonder again" forState:UIControlStateNormal];
        
        [self.completeSampleView addSubview:btn];
    }
    
}

- (IBAction)resetFunc:(id)sender {
    
    self.resultLbl.text = @"0";
    [self JSCoreFundamental:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
