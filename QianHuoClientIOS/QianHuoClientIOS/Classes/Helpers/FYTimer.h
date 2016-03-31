//
//  FYTimer.h
//  FYPlatformExampleNative
//
//  Created by Sean on 15/5/24.
//  Copyright (c) 2015年 FeiYu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Compelete)();
typedef void (^Each)(int current);

@interface FYTimer : NSObject

- (id)initWithCompelete:(Compelete)compelete duration:(int)duration;
- (id)initWithEach:(Each)each compelete:(Compelete)compelete duration:(int)duration;
- (void)startCountdown;
- (void)startCountdownWithDuration:(int)duration;
- (void)compeleteCountdown;
- (void)stopCountdown;

@end
