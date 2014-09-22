//
//  UIBubbleTableViewDataSource.h
//  PatronApp
//
//  Created by Ashish Nigam on 10/03/14.
//  Copyright (c) 2014 GlobalLogic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSBubbleData;
@class UIBubbleTableView;
@protocol UIBubbleTableViewDataSource <NSObject>

@optional

@required

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView;
- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row;

@end
