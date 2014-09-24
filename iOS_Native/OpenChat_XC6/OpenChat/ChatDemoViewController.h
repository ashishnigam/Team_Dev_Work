//
//  ChatDemoViewController.h
//  OpenChat
//
//  Created by Ashish Nigam on 24/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableViewDataSource.h"

#import "BaseViewController.h"

@interface ChatDemoViewController : BaseViewController <UIBubbleTableViewDataSource>
{
    IBOutlet UIBubbleTableView *bubbleTable;
    IBOutlet UIView *textInputView;
    IBOutlet UITextField *textField;
    
    NSMutableArray *bubbleData;
    BOOL sendMessage;
}

-(void)reloadTableData:(NSArray*)chatData;
-(NSArray*)userChatData:(id)args;
-(NSArray*)chatDefaultData;

@end
