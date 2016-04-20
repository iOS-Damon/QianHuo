//
//  NBHintLayer.m
//  Sample
//
//  Created by Sean on 15/6/23.
//  Copyright (c) 2015年 gRPC. All rights reserved.
//

#import "FYHintLayer.h"
#import "FYUtils.h"
#import "FYLabel.h"
#import "FYTimer.h"
#import "FYMacro.h"
#import "UIViewController+FY.h"
#import "UIScreen+FY.h"

@interface FYHintLayer ()

@property (nonatomic, copy)NSString *messege;
@property (nonatomic, assign)int duration;
@property (nonatomic, strong)Complete complete;

- (void)initView;

@end

@implementation FYHintLayer


- (id)initWithMessege:(NSString*)messege duration:(int)duration complete:(Complete)complete {

    if (self = [super initWithFrame:CGRectMake(0, 0, 0, 0)]) {
        self.messege = messege;
        self.duration = duration;
        self.complete = complete;
        [self initView];
        [[NSNotificationCenter defaultCenter]
         addObserver:self
            selector:@selector(statusBarOrientationChange:)
                name:UIApplicationDidChangeStatusBarOrientationNotification
              object:nil];
    }
    return self;
}

- (void)show {
    
    //清除前面的hint
    for(UIView *view in [UIViewController currentViewController].view.subviews){
        if([view isKindOfClass:[self class]]){
            [view removeFromSuperview];
        }
    }
    
    [[UIViewController currentViewController].view addSubview:self];
    
    FYTimer *timer = [[FYTimer alloc] initWithCompelete:^{
        //渐变消失
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            if (self.complete) {
                self.complete();
            }
        }];
    } duration:self.duration];
    [timer startCountdown];
}

- (void)initView {
    self.layer.zPosition = MAXFLOAT;
    self.backgroundColor = FYColorShadow;
    self.layer.cornerRadius = 5;
    
    FYLabel *labMsg = [[FYLabel alloc] initWithString:self.messege size:16 color:[UIColor whiteColor]];
    
    self.frame = CGRectMake(0, 0, CGRectGetWidth(labMsg.frame) + 30, CGRectGetHeight(labMsg.frame) + 30);
    
    labMsg.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    
    [self addSubview:labMsg];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.center = CGPointMake([UIScreen screenWidth] / 2, [UIScreen screenHeight] / 2);
}

- (void)statusBarOrientationChange:(NSNotification *)notification {
    [self setNeedsLayout];
}

@end
