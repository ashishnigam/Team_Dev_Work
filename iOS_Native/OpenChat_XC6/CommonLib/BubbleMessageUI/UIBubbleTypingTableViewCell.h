//
//  UIBubbleTypingTableViewCell.h
//  PatronApp
//
//  Created by Ashish Nigam on 10/03/14.
//  Copyright (c) 2014 GlobalLogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableView.h"


@interface UIBubbleTypingTableViewCell : UITableViewCell

+ (CGFloat)height;

@property (nonatomic) NSBubbleTypingType type;
@property (nonatomic) BOOL showAvatar;

@end
