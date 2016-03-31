//
//  FYTimer.m
//  FYPlatformExampleNative
//
//  Created by Sean on 15/5/24.
//  Copyright (c) 2015年 FeiYu. All rights reserved.
//

#import "FYTimer.h"

@interface FYTimer ()

@property (nonatomic, strong) Compelete compelete;
@property (nonatomic, strong) Each each;
@property (nonatomic) NSTimer* timer;
@property (nonatomic, assign) int secondsCountDown;
@property (nonatomic, assign) int duration;
@property (nonatomic, assign) int eachTime;

- (void)countDown;

@end

@implementation FYTimer

- (id)initWithCompelete:(Compelete)compelete duration:(int)duration {
    if (self = [super init]) {
        self.compelete = compelete;
        self.duration = duration;
    }
    return self;
}

- (id)initWithEach:(Each)each compelete:(Compelete)compelete duration:(int)duration {
    if (self = [super init]) {
        self.each = each;
        self.compelete = compelete;
        self.duration = duration;
    }
    return self;
}

- (void)startCountdown {
    
    self.secondsCountDown = self.duration;
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    } else {
        [self.timer setFireDate:[NSDate distantPast]];
    }
}

- (void)startCountdownWithDuration:(int)duration {
    
    self.secondsCountDown = duration;
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }else {
        [self.timer setFireDate:[NSDate distantPast]];
    }
}

- (void)compeleteCountdown {
    
    if (self.timer != nil) {
        [self.timer setFireDate:[NSDate distantFuture]];
        if (self.compelete != nil) {
            self.compelete();
        }
    }
}

- (void)stopCountdown {
    if (self.timer != nil) {
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)countDown {
    
    self.secondsCountDown -- ;
    if (self.each != nil) {
        self.each(self.secondsCountDown);
    }
    if (self.secondsCountDown == 0) {
        [self compeleteCountdown];
    }
}

@end
