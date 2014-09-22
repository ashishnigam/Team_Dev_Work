//
//  UIBubbleHeaderTableViewCell.h
//  PatronApp
//
//  Created by Ashish Nigam on 10/03/14.
//  Copyright (c) 2014 GlobalLogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBubbleHeaderTableViewCell : UITableViewCell

+ (CGFloat)height;

@property (nonatomic, strong) NSDate *date;

@end
