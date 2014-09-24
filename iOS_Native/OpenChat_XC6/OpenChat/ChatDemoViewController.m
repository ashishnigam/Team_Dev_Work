//
//  ChatDemoViewController.m
//  OpenChat
//
//  Created by Ashish Nigam on 24/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import "ChatDemoViewController.h"

#import "UIColor+Expanded.h"

#import "UIBubbleTableView.h"
#import "NSBubbleData.h"

@interface ChatDemoViewController ()
{
}

@end

@implementation ChatDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Chat UI
    
    [self updateChatUI];
    
    // Chat UI End
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

-(NSArray*)chatDefaultData
{
    NSBubbleData *heyBubble = [NSBubbleData dataWithText:@"I think this is what you are looking for" date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeSomeoneElse];
    heyBubble.avatar = [UIImage imageNamed:CHAT_SCREEN_USER_OTHER_AVATAR_IMG];
    
    UIView *otherChatView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 255, 50)];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 1, 50, 48)];
    img.image = [UIImage imageNamed:@"Page.png"];
    [img setContentMode:UIViewContentModeCenter];
    img.backgroundColor = [UIColor colorWithHexString:@"#f07919"];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 150, 50)];
    lbl.text = @"A Feast for Crows";
    
    UIImageView *imgRight = [[UIImageView alloc] initWithFrame:CGRectMake(240, 17, 10, 16)];
    imgRight.image = [UIImage imageNamed:@"VCCarrotArrow.png"];
    
    [otherChatView addSubview:img];
    [otherChatView addSubview:lbl];
    [otherChatView addSubview:imgRight];
    
    NSBubbleData *viewBubble = [NSBubbleData dataWithView:otherChatView date:[NSDate dateWithTimeIntervalSinceNow:-290] type:BubbleTypeSomeoneElse insets:UIEdgeInsetsMake(0, 0, 0, 0)];
    viewBubble.avatar = [UIImage imageNamed:CHAT_SCREEN_USER_OTHER_AVATAR_IMG];
    
    //    NSBubbleData *photoBubble = [NSBubbleData dataWithImage:[UIImage imageNamed:@"halloween.jpg"] date:[NSDate dateWithTimeIntervalSinceNow:-290] type:BubbleTypeSomeoneElse];
    //    photoBubble.avatar = [UIImage imageNamed:@"plh_textChat_Otheruser.png"];
    
    NSBubbleData *replyBubble = [NSBubbleData dataWithText:@"Thanks Jane" date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
    
    replyBubble.avatar = [UIImage imageNamed:CHAT_SCREEN_USER_ME_AVATAR_IMG];
    
    NSBubbleData *reply2Bubble = [NSBubbleData dataWithText:@"No problem! Can i help with anything \nelse?" date:[NSDate dateWithTimeIntervalSinceNow:+200] type:BubbleTypeSomeoneElse];
    reply2Bubble.avatar = [UIImage imageNamed:CHAT_SCREEN_USER_OTHER_AVATAR_IMG];
    
    NSBubbleData *reply3Bubble = [NSBubbleData dataWithText:@"Test Message 1" date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
    
    reply3Bubble.avatar = [UIImage imageNamed:CHAT_SCREEN_USER_ME_AVATAR_IMG];
    
    NSBubbleData *reply4Bubble = [NSBubbleData dataWithText:@"Test Message 1" date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
    
    reply4Bubble.avatar = [UIImage imageNamed:CHAT_SCREEN_USER_ME_AVATAR_IMG];
    
    NSBubbleData *reply5Bubble = [NSBubbleData dataWithText:@"Test Message 5" date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
    
    reply5Bubble.avatar = [UIImage imageNamed:CHAT_SCREEN_USER_ME_AVATAR_IMG];
    
    NSBubbleData *reply6Bubble = [NSBubbleData dataWithText:@"Test Message 6" date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
    
    reply6Bubble.avatar = [UIImage imageNamed:CHAT_SCREEN_USER_ME_AVATAR_IMG];
    
    NSBubbleData *reply7Bubble = [NSBubbleData dataWithText:@"Test Message 7" date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
    
    reply7Bubble.avatar = [UIImage imageNamed:CHAT_SCREEN_USER_ME_AVATAR_IMG];
    
    NSBubbleData *reply8Bubble = [NSBubbleData dataWithText:@"Test Message 8" date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
    
    reply8Bubble.avatar = [UIImage imageNamed:CHAT_SCREEN_USER_ME_AVATAR_IMG];
    
    NSBubbleData *reply9Bubble = [NSBubbleData dataWithText:@"Test Message 9" date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
    
    reply9Bubble.avatar = [UIImage imageNamed:CHAT_SCREEN_USER_ME_AVATAR_IMG];
    
    NSMutableArray *defaultData = [[NSMutableArray alloc] initWithObjects:heyBubble, viewBubble, replyBubble, reply2Bubble,reply3Bubble,reply4Bubble,reply5Bubble,reply6Bubble,reply7Bubble,reply8Bubble,reply9Bubble,nil];
    
    return defaultData;
}

-(void)updateChatUI
{
   // bubbleData = [[self chatDefaultData] mutableCopy];
    
    bubbleTable.bubbleDataSource = self;
    
    // The line below sets the snap interval in seconds. This defines how the bubbles will be grouped in time.
    // Interval of 120 means that if the next messages comes in 2 minutes since the last message, it will be added into the same group.
    // Groups are delimited with header which contains date and time for the first message in the group.
    
    bubbleTable.snapInterval = 120;
    
    // The line below enables avatar support. Avatar can be specified for each bubble with .avatar property of NSBubbleData.
    // Avatars are enabled for the whole table at once. If particular NSBubbleData misses the avatar, a default placeholder will be set (missingAvatar.png)
    
    bubbleTable.showAvatars = YES;
    
    // Uncomment the line below to add "Now typing" bubble
    // Possible values are
    //    - NSBubbleTypingTypeSomebody - shows "now typing" bubble on the left
    //    - NSBubbleTypingTypeMe - shows "now typing" bubble on the right
    //    - NSBubbleTypingTypeNone - no "now typing" bubble
    
    bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    
    [bubbleTable reloadData];
    
    // Keyboard events
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    bubbleTable.backgroundColor = [UIColor colorWithHexString:@"ccffcc"];
    
   // [self updateTableViewCells:0];
    
}



// Chat UI

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}

#pragma mark - Keyboard events

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    sendMessage = YES;
    //self.chatTextEntryTxtField.text = @"";
    bubbleTable.typingBubble = NSBubbleTypingTypeMe;
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = textInputView.frame;
        frame.origin.y -= kbSize.height;
        textInputView.frame = frame;
        
        frame = bubbleTable.frame;
        frame.size.height -= kbSize.height;
        bubbleTable.frame = frame;
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    // [self updateChatTextFieldUI];
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = textInputView.frame;
        frame.origin.y += kbSize.height;
        textInputView.frame = frame;
        
        frame = bubbleTable.frame;
        frame.size.height += kbSize.height;
        bubbleTable.frame = frame;
    }];
    
}

#pragma mark - Actions
- (IBAction)SendMessage:(id)sender {
    if (sendMessage) {
        bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
        
        NSString *chatText = nil;
        if ([textField.text isEqualToString:@""]) {
            chatText = @"Hi";
        }else{
            chatText = textField.text;
        }
        
        NSBubbleData *sayBubble = [NSBubbleData dataWithText:chatText date:[NSDate dateWithTimeIntervalSinceNow:+300] type:BubbleTypeMine];
        sayBubble.avatar = [UIImage imageNamed:CHAT_SCREEN_USER_ME_AVATAR_IMG];
        
        [bubbleData addObject:sayBubble];
        [bubbleTable reloadData];
        textField.text = @"";
        [textField resignFirstResponder];
        [self updateTableViewCells:0];
        sendMessage = NO;
    }
}

-(void)updateTableViewCells:(NSUInteger)rowNumber
{
    [bubbleTable reloadData];
    NSUInteger noOfSection = [bubbleTable numberOfSections] - 1;
    NSUInteger lastRowNumber = [bubbleTable numberOfRowsInSection:noOfSection] - 1;
    NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:noOfSection];
    [bubbleTable scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    // another of achieving the similar result but will take much more calculation to calculate every row height at run time.
    
    //bubbleTableY = bubbleTableY+60;
    // [bubbleTable setContentOffset:CGPointMake(bubbleTable.frame.origin.x, bubbleTableY) animated:YES];
}

-(NSArray*)userChatData:(id)args
{
    NSBubbleData *reply8Bubble = [NSBubbleData dataWithText:@"Test Message 8" date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
    
    reply8Bubble.avatar = [UIImage imageNamed:CHAT_SCREEN_USER_ME_AVATAR_IMG];
    
    NSBubbleData *reply9Bubble = [NSBubbleData dataWithText:@"Test Message 9" date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
    
    reply9Bubble.avatar = [UIImage imageNamed:CHAT_SCREEN_USER_ME_AVATAR_IMG];
    
    bubbleData = [[NSMutableArray alloc] initWithObjects:reply8Bubble,reply9Bubble,nil];
    
    return bubbleData;
}

-(void)reloadTableData:(NSArray*)chatData
{
    bubbleData  = [NSMutableArray arrayWithArray:chatData];
    [bubbleTable reloadData];
}

// Chat UI End

@end
