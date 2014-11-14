//
//  LoginViewController.h
//  NotingMe
//
//  Created by Ashish Nigam on 11/14/14.
//  Copyright (c) 2014 AshishNigam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

- (IBAction)doLogin:(id)sender;
@end
