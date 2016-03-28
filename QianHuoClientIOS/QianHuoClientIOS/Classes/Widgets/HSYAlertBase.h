//
//  HSYAlertBase.h
//  TestHSYAlertView2
//
//  Created by Sean on 16/3/15.
//  Copyright (c) 2016年 seanhuang1661. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSYAlertBase : UIView

@property (nonatomic, strong) UIColor *titleBackgroundColor;
@property (nonatomic, strong) UIColor *contentBackgroundColor;
@property (nonatomic, strong) UIColor *buttonBackgroundColor;

@property (nonatomic, strong) UIView *titleContainer;
@property (nonatomic, strong) UIView *contentContainer;
@property (nonatomic, strong) UIView *buttonContainer;

@property (nonatomic, assign) CGFloat edgeWidth;

- (void)refreshLayout;
- (void)show;
- (void)hideWithComplete:(void(^)())complete;

@end
