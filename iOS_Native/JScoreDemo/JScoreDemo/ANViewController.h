//
//  ANViewController.h
//  JScoreDemo
//
//  Created by Ashish Nigam on 23/05/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ANMakePoint.h"
#import "MyButton.h"

@interface ANViewController : UIViewController

- (IBAction)multiplyFunc:(id)sender;
- (IBAction)divisionFunc:(id)sender;
- (IBAction)addFunc:(id)sender;
- (IBAction)subFunc:(id)sender;
- (IBAction)addlabel:(id)sender;
- (IBAction)usingClassCreateButton:(id)sender;

- (IBAction)resetFunc:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *resultLbl;
@property (weak, nonatomic) IBOutlet UIView *simpleJSView;
@property (weak, nonatomic) IBOutlet UIView *twoWayCallingView;
@property (weak, nonatomic) IBOutlet UIView *completeSampleView;
@end
