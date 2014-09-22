//
//  ScheduleTimer.m
//  PatronApp
//
//  Created by Rahul Singh on 3/20/14.
//  Copyright (c) 2014 Innovative. All rights reserved.
//

#import "ScheduleTimer.h"

@implementation ScheduleTimer

- (id)initWithCounter:(int) counter {
  self = [super init];
  if (self) {
    self.counter = counter;
  }
  return self;
}

- (void)startTimer {
  [self updateWaitingTime];
  self.scheduleTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector: @selector(updateWaitingTime) userInfo: nil repeats: YES];
}

- (void)stopTimer {
  [self.scheduleTimer invalidate];
}

-(void)updateWaitingTime
{
    NSString *str = [self remainingTime:self.counter];
    self.timeRemaining(str);
  
  NSLog(@"global counter = %@",str);
}

-(NSString*)remainingTime:(int) ptrCounter
{
  int hours,minutes,seconds,localCounter,tCounter;
  NSString *hoursStr,*minStr,*secStr;
  tCounter = ptrCounter;
  
  seconds = (tCounter % 60);
  
  
  if (tCounter>=60) {
    minutes = (tCounter - seconds)/60;
    
  }else{
    minutes = 00;
  }
  
  if (minutes >= 60) {
    localCounter = minutes;
    minutes = (minutes % 60);
    
    hours = (localCounter - minutes)/60;
    
  }else{
    hours = 00;
  }
  
  if (hours<10) {
    hoursStr = [NSString stringWithFormat:@"0%d",hours];
  }
  else{
    hoursStr = [NSString stringWithFormat:@"%d",hours];
  }
  if (minutes<10) {
    minStr = [NSString stringWithFormat:@"0%d",minutes];
  }
  else{
    minStr = [NSString stringWithFormat:@"%d",minutes];
  }
  if (seconds<10) {
    secStr = [NSString stringWithFormat:@"0%d",seconds];
  }
  else{
    secStr = [NSString stringWithFormat:@"%d",seconds];
  }
  
  NSString *timeRemaining = [NSString stringWithFormat:@"%@:%@:%@",hoursStr,minStr,secStr];
  self.counter--;
  
  NSLog(@"local co = %d",self.counter);
  ptrCounter = tCounter;
  return timeRemaining;
}

@end
