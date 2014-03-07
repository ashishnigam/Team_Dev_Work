//
//  DetailViewController.h
//  LoveNetwork
//
//  Created by Ashish Nigam on 10/23/13.
//  Copyright (c) 2013 OneZeroOne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageDetail;
@property (weak, nonatomic) NSString *personName;

- (IBAction)AppCalling:(id)sender;
- (IBAction)AppMessage:(id)sender;
- (IBAction)whatsAppInvoke:(id)sender;

- (IBAction)weChatInvoke:(id)sender;

- (IBAction)fbInvoke:(id)sender;
- (IBAction)googlePlusInvoke:(id)sender;
- (IBAction)mobileMessage:(id)sender;
- (IBAction)MobileMail:(id)sender;
- (IBAction)MobileCall:(id)sender;



@end
