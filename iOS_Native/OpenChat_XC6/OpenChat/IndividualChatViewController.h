//
//  DetailViewController.h
//  OpenChat
//
//  Created by Ashish Nigam on 17/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#import "UIBubbleTableViewDataSource.h"

@interface IndividualChatViewController : BaseViewController <UIBubbleTableViewDataSource>
{
    IBOutlet UIBubbleTableView *bubbleTable;
    IBOutlet UIView *textInputView;
    IBOutlet UITextField *textField;
    
    NSMutableArray *bubbleData;
    BOOL sendMessage;
}

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

