//
//  DetailViewController.m
//  NotingMe
//
//  Created by Ashish Nigam on 11/14/14.
//  Copyright (c) 2014 AshishNigam. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.noteTextView.text = [[self.detailItem valueForKey:@"noteText"] description];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
     NSLog(@"=============== mynote=============== textViewDidBeginEditing");
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"=============== mynote=============== textViewDidEndEditing");
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"=============== mynote=============== textViewDidChange");

    [self.detailItem setValue:textView.text forKey:@"noteText"];
}

- (IBAction)textChangesDone:(id)sender {
    if ([self.noteTextView.text isEqualToString:@""]) {
        // move back
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.noteTextView resignFirstResponder];
    }
}
@end
