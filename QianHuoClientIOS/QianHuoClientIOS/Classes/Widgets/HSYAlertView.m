//
//  HSYAlertView.m
//  TestHSYAlertView
//
//  Created by Sean on 16/1/15.
//  Copyright (c) 2016年 seanhuang1661. All rights reserved.
//

#import "HSYAlertView.h"
#import "UIColor+FY.h"
#import "UIView+FY.h"
#import "UIImage+FY.h"
#import "UIViewController+FY.h"
#import "FYMacro.h"
#import "UIScreen+FY.h"
#import "FYLabel.h"

static CGFloat const HSYAlertViewLableDistance = 10;

@interface HSYAlertView ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) HSYAttributedString *messege;
@property (nonatomic, strong) NSMutableArray *messeges;
@property (nonatomic, copy) NSString *cancel;
@property (nonatomic, copy) NSString *confirm;
@property (nonatomic, weak) id<HSYAlertViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *messegeLables;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation HSYAlertView

- (instancetype)initWithTitle:(NSString*)title
                       cancel:(NSString*)cancel
                      confirm:(NSString*)confirm
                     delegate:(id<HSYAlertViewDelegate>)delegate
                      messege:(HSYAttributedString*)messege {
    if (self = [super init]) {
        self.title = title;
        self.messege = messege;
        self.cancel = cancel;
        self.confirm = confirm;
        self.delegate = delegate;
        [self setupTitle];
        [self setupContent];
        [self setupButton];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString*)title
                       cancel:(NSString*)cancel
                      confirm:(NSString*)confirm
                     delegate:(id<HSYAlertViewDelegate>)delegate
                     messeges:(HSYAttributedString*)messege, ... {
    if (self = [super init]) {
        self.title = title;
        self.cancel = cancel;
        self.confirm = confirm;
        self.delegate = delegate;
        self.messeges = [[NSMutableArray alloc] initWithCapacity:3];
        va_list arguments;
        id eachObject;
        if (messege) {
            [self.messeges addObject:messege];
            va_start(arguments, messege);
            while ((eachObject = va_arg(arguments, id))) {
                [self.messeges addObject:eachObject];
            }
            va_end(arguments);
        }
        [self setupTitle];
        [self setupMutableContent];
        [self setupButton];
    }
    return self;
}

#pragma mark - 设置布局
- (void)setupTitle {
    FYLabel *titleLable = [[FYLabel alloc] initWithString:self.title size:FYLabSize4 color:[UIColor whiteColor]];
    titleLable.center = CGPointMake(self.titleContainer.frameWidth / 2, self.titleContainer.frameHeight / 2);
    [self.titleContainer addSubview:titleLable];
    self.titleBackgroundColor = [UIColor colorWithHexString:@"F15757" alpha:1.0];
}

- (void)setupContent {
    UILabel *contentLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    contentLable.text = self.messege.text;
    contentLable.textColor = self.messege.color;
    contentLable.font = self.messege.font;
    contentLable.numberOfLines = 0;
    if (self.messege.align == HSYAttributedStringAlignLeft) {
        contentLable.textAlignment = NSTextAlignmentLeft;
    } else if (self.messege.align == HSYAttributedStringAlignCenter) {
        contentLable.textAlignment = NSTextAlignmentCenter;
    } else {
        contentLable.textAlignment = NSTextAlignmentRight;
    }
    CGRect rect = [contentLable.text boundingRectWithSize:CGSizeMake(self.contentContainer.frameWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: contentLable.font} context:nil];
    contentLable.frameSize = CGSizeMake(rect.size.width, rect.size.height);
    
    if (rect.size.height > self.contentContainer.frameHeight) {
        self.contentContainer.frameHeight = rect.size.height;
        [self refreshLayout];
    }
    contentLable.center = CGPointMake(self.contentContainer.frameWidth / 2, self.contentContainer.frameHeight / 2);
    [self.contentContainer addSubview:contentLable];
}

- (void)setupButton {
    
    CGFloat buttonWidth = self.buttonContainer.frameWidth * 0.3;
    CGFloat buttonHeight = buttonWidth * 0.3;
    
    self.cancelButton = [self createButtonWithFrame:CGRectMake(0, 0, buttonWidth, buttonHeight) title:self.cancel color:[UIColor colorWithHexString:@"56B8B8" alpha:1.0] selector:@selector(cancelAction:)];
    
    self.confirmButton = [self createButtonWithFrame:CGRectMake(0, 0, buttonWidth, buttonHeight) title:self.confirm color:[UIColor colorWithHexString:@"F15757" alpha:1.0] selector:@selector(confirmAction:)];

    if (self.cancel && self.confirm) {
        self.cancelButton.center = CGPointMake(self.buttonContainer.frameWidth * 0.3, self.buttonContainer.frameHeight / 2);
        [self.buttonContainer addSubview:self.cancelButton];
        
        self.confirmButton.center = CGPointMake(self.buttonContainer.frameWidth * 0.7, self.buttonContainer.frameHeight / 2);
        [self.buttonContainer addSubview:self.confirmButton];
        
        return;
    }
    if (self.cancel) {
        self.cancelButton.center = CGPointMake(self.buttonContainer.frameWidth / 2, self.buttonContainer.frameHeight / 2);
        [self.buttonContainer addSubview:self.cancelButton];
        
        return;
    }
    if (self.confirm) {
        self.confirmButton.center = CGPointMake(self.buttonContainer.frameWidth / 2, self.buttonContainer.frameHeight / 2);
        [self.buttonContainer addSubview:self.confirmButton];
        
        return;
    }
}

- (void)setupMutableContent {
    CGFloat tempY = 0;
    for (HSYAttributedString *messege in self.messeges) {
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        lable.backgroundColor = [UIColor clearColor];
        lable.text = messege.text;
        lable.textColor = messege.color;
        lable.textAlignment = NSTextAlignmentLeft;
        lable.font = messege.font;
        lable.numberOfLines = 1;
        [lable sizeToFit];
        if (messege.align == HSYAttributedStringAlignLeft) {
            lable.frameOriginX = self.contentContainer.frameWidth * 0.05;
        } else if (messege.align == HSYAttributedStringAlignCenter) {
            lable.frameOriginX = (self.contentContainer.frameWidth - lable.frameWidth) / 2;
        } else {
            lable.frameOriginX = self.contentContainer.frameWidth * 0.95 - lable.frameWidth;
        }
        tempY = tempY + HSYAlertViewLableDistance;
        lable.frameOriginY = tempY;
        tempY = tempY + lable.frameHeight;
        [self.contentContainer addSubview:lable];
    }
    self.contentContainer.frameHeight = tempY;
    [self refreshLayout];
}

- (UIButton*)createButtonWithFrame:(CGRect)frame title:(NSString*)title color:(UIColor*)color selector:(SEL)selector {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = frame.size.width * 0.05;
    [button setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - 按钮事件
- (void)cancelAction:(id)sender {
    [self hideWithComplete:^{
        if (self.delegate) {
            [self.delegate alertView:self didDismissWithButtonType:HSYAlertViewCancel];
        }
    }];
}

- (void)confirmAction:(id)sender {
    [self hideWithComplete:^{
        if (self.delegate) {
            [self.delegate alertView:self didDismissWithButtonType:HSYAlertViewConfirm];
        }
    }];
}


@end
