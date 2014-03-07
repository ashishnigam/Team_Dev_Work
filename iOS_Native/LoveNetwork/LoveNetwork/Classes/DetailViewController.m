//
//  DetailViewController.m
//  LoveNetwork
//
//  Created by Ashish Nigam on 10/23/13.
//  Copyright (c) 2013 OneZeroOne. All rights reserved.
//

#import "DetailViewController.h"
#import "FlyOutView.h"

@interface DetailViewController ()
{
    NSTimer* myTimer;
}
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@property (weak, nonatomic) IBOutlet FlyOutView *flyOutView1;
@end

@implementation DetailViewController

@synthesize imageDetail;
@synthesize detailDescriptionLabel;
@synthesize personName;


#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"timeStamp"] description];
    }
    if (self.imageDetail) {
        self.imageDetail.image = [UIImage imageNamed:self.personName];
    }
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval: 6.0 target:self
                                                      selector: @selector(showFlyOut:) userInfo: nil repeats: YES];
    NSLog(@"Timer ticking %@",myTimer);
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [myTimer invalidate];
    [super viewDidDisappear:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - FlyOut Menu View

-(void)showFlyOut:(id)callingArgs
{
    NSLog(@"Calling showFlyOut");
    CGRect screeenRect = [[UIScreen mainScreen] bounds];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.flyOutView1 setFrame:CGRectMake((screeenRect.size.width)-(self.flyOutView1.frame.size.width), self.flyOutView1.frame.origin.y, self.flyOutView1.frame.size.width,self.flyOutView1.frame.size.height)];
                         
                     }
                     completion:nil];
}

-(void)hideFlyOut:(id)callingArgs
{
    CGRect screeenRect = [[UIScreen mainScreen] bounds];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.flyOutView1 setFrame:CGRectMake(screeenRect.size.width-10, self.flyOutView1.frame.origin.y, self.flyOutView1.frame.size.width,self.flyOutView1.frame.size.height)];
                         
                     }
                     completion:nil];
}

#pragma mark - FlyOut Menu Options

- (IBAction)AppCalling:(id)sender {
    NSLog(@"Calling inapp");
    
    [self hideFlyOut:nil];
    
}

- (IBAction)AppMessage:(id)sender {
    NSLog(@"Calling inapp");
    
    [self hideFlyOut:nil];
}

- (IBAction)whatsAppInvoke:(id)sender {
    NSLog(@"Calling inapp");
    
    [self hideFlyOut:nil];
}

- (IBAction)weChatInvoke:(id)sender {
    NSLog(@"Calling inapp");
    
    [self hideFlyOut:nil];
}

- (IBAction)fbInvoke:(id)sender {
    NSLog(@"Calling inapp");
    
    [self hideFlyOut:nil];
}

- (IBAction)googlePlusInvoke:(id)sender {
    NSLog(@"Calling inapp");
    
    [self hideFlyOut:nil];
}

- (IBAction)mobileMessage:(id)sender {
    NSLog(@"Calling inapp");
    
    [self hideFlyOut:nil];
}

- (IBAction)MobileMail:(id)sender {
    NSLog(@"Calling inapp");
    
    [self hideFlyOut:nil];
}

- (IBAction)MobileCall:(id)sender {
    NSLog(@"Calling inapp");
    
    [self hideFlyOut:nil];
}
@end
