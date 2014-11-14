//
//  LoginViewController.m
//  NotingMe
//
//  Created by Ashish Nigam on 11/14/14.
//  Copyright (c) 2014 AshishNigam. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doLogin:(id)sender {
    if ((![self.userNameTF.text isEqualToString:@""]) && (![self.userNameTF.text isEqualToString:@" "])){
        if ((![self.passwordTF.text isEqualToString:@""]) && (![self.passwordTF.text isEqualToString:@" "]))
        {
            NSUserDefaults *NoteUserDefaults = [NSUserDefaults standardUserDefaults];
            [NoteUserDefaults setObject:self.userNameTF.text forKey:@"userName"];
            [NoteUserDefaults setObject:self.passwordTF.text forKey:@"password"];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
    }
    self.userNameTF.placeholder = @"Please enter username";
    self.passwordTF.placeholder = @"Please enter password";
    [self resignFirstResponder];
}
@end
