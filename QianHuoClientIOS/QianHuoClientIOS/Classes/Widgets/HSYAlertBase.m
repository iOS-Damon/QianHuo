//
//  HSYAlertBase.m
//  TestHSYAlertView2
//
//  Created by Sean on 16/3/15.
//  Copyright (c) 2016年 seanhuang1661. All rights reserved.
//

#import "HSYAlertBase.h"
#import "UIColor+FY.h"
#import "FYMacro.h"
#import "UIScreen+FY.h"
#import "UIViewController+FY.h"
#import "UIView+FY.h"

@interface HSYAlertBase ()

@property (nonatomic, strong) UIView *canvas;

@property (nonatomic, strong) UIView *titleBackground;
@property (nonatomic, strong) UIView *contentBackground;
@property (nonatomic, strong) UIView *buttonBackground;

@property (nonatomic, assign) CGFloat canvasWidth;
@property (nonatomic, assign) CGFloat canvasHeight;
@property (nonatomic, assign) CGFloat titleBackgroundHeight;
@property (nonatomic, assign) CGFloat contentBackgroundHeight;
@property (nonatomic, assign) CGFloat buttonBackgroundHeight;

@end

@implementation HSYAlertBase

- (instancetype)init {
    if (self = [super initWithFrame:[[UIScreen mainScreen] bounds]]) {
        if (FYIsPad) {
            self.canvasWidth = [UIScreen screenShortSide] * 0.5;
        } else {
            self.canvasWidth = [UIScreen screenShortSide] * 0.9;
        }
        self.canvasHeight = self.canvasWidth * 0.6;
        self.titleBackgroundHeight = self.canvasHeight * 0.2;
        self.contentBackgroundHeight = self.canvasHeight * 0.6;
        self.buttonBackgroundHeight = self.canvasHeight * 0.2;
        self.edgeWidth = self.canvasWidth * 0.05;
        [self setupLayout];
    }
    return self;
}

#pragma mark - 设置布局
- (void)setupLayout {
    self.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.65];
    self.layer.zPosition = MAXFLOAT;
    
    self.canvas = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.canvasWidth, self.canvasHeight)];
    self.canvas.center = CGPointMake([UIScreen screenWidth] / 2, [UIScreen screenHeight] / 2);
    self.canvas.backgroundColor = [UIColor clearColor];
    self.canvas.layer.masksToBounds = YES;
    self.canvas.layer.cornerRadius = self.canvasWidth * 0.03;
    [self addSubview:self.canvas];
    
    self.titleBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.canvasWidth, self.titleBackgroundHeight)];
    self.titleBackground.backgroundColor = [UIColor whiteColor];
    [self.canvas addSubview:self.titleBackground];
    
    self.contentBackground = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleBackgroundHeight, self.canvasWidth, self.contentBackgroundHeight)];
    self.contentBackground.backgroundColor = [UIColor whiteColor];
    [self.canvas addSubview:self.contentBackground];
    
    self.buttonBackground = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleBackgroundHeight + self.contentBackgroundHeight, self.canvasWidth, self.buttonBackgroundHeight)];
    self.buttonBackground.backgroundColor = [UIColor whiteColor];
    [self.canvas addSubview:self.buttonBackground];
    
    self.titleContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.canvasWidth - self.edgeWidth, self.titleBackgroundHeight - self.edgeWidth)];
    self.titleContainer.center = CGPointMake(self.canvasWidth / 2, self.titleBackgroundHeight / 2);
    self.titleContainer.backgroundColor = [UIColor clearColor];
    [self.titleBackground addSubview:self.titleContainer];
    
    self.contentContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.canvasWidth - self.edgeWidth, self.contentBackgroundHeight - self.edgeWidth)];
    self.contentContainer.backgroundColor = [UIColor clearColor];
    self.contentContainer.center = CGPointMake(self.canvasWidth / 2, self.contentBackgroundHeight / 2);
    [self.contentBackground addSubview:self.contentContainer];
    
    self.buttonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.canvasWidth - self.edgeWidth, self.buttonBackgroundHeight - self.edgeWidth)];
    self.buttonContainer.backgroundColor = [UIColor clearColor];
    self.buttonContainer.center = CGPointMake(self.canvasWidth / 2, self.buttonBackgroundHeight / 2);
    [self.buttonBackground addSubview:self.buttonContainer];
}

#pragma mark - 刷新布局
- (void)refreshLayout {
    self.titleBackgroundHeight = self.titleContainer.frameHeight + self.edgeWidth;
    self.contentBackgroundHeight = self.contentContainer.frameHeight + self.edgeWidth;
    self.buttonBackgroundHeight = self.buttonContainer.frameHeight + self.edgeWidth;
    
    self.canvasHeight = self.titleBackgroundHeight + self.contentBackgroundHeight + self.buttonBackgroundHeight;
    self.canvas.frameHeight = self.canvasHeight;
    self.canvas.center = CGPointMake([UIScreen screenWidth] / 2, [UIScreen screenHeight] / 2);
    
    self.titleBackground.frameHeight = self.titleBackgroundHeight;
    self.titleContainer.center = CGPointMake(self.canvasWidth / 2, self.titleBackgroundHeight / 2);
    self.titleBackground.frameOriginY = 0;
    
    self.contentBackground.frameHeight = self.contentBackgroundHeight;
    self.contentContainer.center = CGPointMake(self.canvasWidth / 2, self.contentBackgroundHeight / 2);
    self.contentBackground.frameOriginY = self.titleBackgroundHeight;
    
    self.buttonBackground.frameHeight = self.buttonBackgroundHeight;
    self.buttonContainer.center = CGPointMake(self.canvasWidth / 2, self.buttonBackgroundHeight / 2);
    self.buttonBackground.frameOriginY = self.titleBackgroundHeight + self.contentBackgroundHeight;
}

#pragma mark - 背景颜色
- (UIColor *)titleBackgroundColor {
    return self.titleBackground.backgroundColor;
}

- (void)setTitleBackgroundColor:(UIColor *)titleBackgroundColor {
    self.titleBackground.backgroundColor = titleBackgroundColor;
}

- (UIColor *)contentBackgroundColor {
    return self.contentBackground.backgroundColor;
}

- (void)setContentBackgroundColor:(UIColor *)contentBackgroundColor {
    self.contentBackground.backgroundColor = contentBackgroundColor;
}

- (UIColor *)buttonBackgroundColor {
    return self.buttonBackground.backgroundColor;
}

- (void)setButtonBackgroundColor:(UIColor *)buttonBackgroundColor {
    self.buttonBackground.backgroundColor = buttonBackgroundColor;
}

#pragma mark - 显示隐藏
- (void)show {
    [[UIViewController currentViewController].view addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideWithComplete:(void(^)())complete {
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        complete();
    }];
}

@end
