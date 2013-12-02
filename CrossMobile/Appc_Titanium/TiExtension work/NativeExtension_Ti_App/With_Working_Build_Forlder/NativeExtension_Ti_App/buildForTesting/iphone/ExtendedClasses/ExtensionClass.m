//
//  ExtensionClass.m
//  NativeExtension
//
//  Created by Ashish Nigam on 11/27/13.
//
//

#import "ExtensionClass.h"
#import "TiUIButtonProxy.h"
#import "TiUIButton.h"

@interface ExtensionClass ()

@end

@implementation ExtensionClass

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showAlert:(id)args
{
    NSLog(@"[INFO] %@ loaded",self);
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"test extension" message:@"Done" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    [alertV show];
    
}

+(void)startingPoint:(id)args
{
    NSLog(@"[INFO] %@ loaded",self);
    //    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"test extension" message:@"Done" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    //    [alertV show];
    
    ExtensionClass *ins = [[self alloc] init];
    [ins performSelectorOnMainThread:@selector(showAlert:) withObject:args waitUntilDone:NO];
    
}

-(void)startingPoint:(id)args
{
    if ([NSThread isMainThread]) {
        NSLog(@"[INFO] %@ got the class",[[args objectAtIndex:1] class]);
        TiUIButtonProxy *but = (TiUIButtonProxy*)[args objectAtIndex:1];
        UIButton *btn = (UIButton*)[[but view] button];
        //[[but view]  setTitle_:@"New Title"];
        [btn setTitle:@"native way" forState:UIControlStateNormal];
        
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"test extension new" message:@"Done" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
        [alertV show];
        [alertV release];
    }else{
        NSLog(@"[INFO] %@ from non ui to ui thread",args);
        [self performSelectorOnMainThread:@selector(startingPoint:) withObject:args waitUntilDone:NO];
        
    }
}


@end
