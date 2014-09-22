//
//  ScheduleTimer.h
//  PatronApp
//
//  Created by Rahul Singh on 3/20/14.
//  Copyright (c) 2014 Innovative. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleTimer : NSObject

@property (strong, nonatomic) NSTimer *scheduleTimer;
@property (nonatomic) int counter;
@property (strong, nonatomic) void(^timeRemaining)(NSString*);
- (void)startTimer;
- (void)stopTimer;
- (id)initWithCounter:(int) counter;
@end
