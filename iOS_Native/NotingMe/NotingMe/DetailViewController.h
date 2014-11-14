//
//  DetailViewController.h
//  NotingMe
//
//  Created by Ashish Nigam on 11/14/14.
//  Copyright (c) 2014 AshishNigam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
- (IBAction)textChangesDone:(id)sender;



@end

