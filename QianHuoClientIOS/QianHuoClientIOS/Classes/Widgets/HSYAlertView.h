//
//  HSYAlertView.h
//  TestHSYAlertView
//
//  Created by Sean on 16/1/15.
//  Copyright (c) 2016年 seanhuang1661. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSYAlertBase.h"
#import "HSYAttributedString.h"

typedef NS_ENUM(NSInteger, HSYAlertViewButtonType) {
    HSYAlertViewCancel,
    HSYAlertViewConfirm
};

@protocol HSYAlertViewDelegate;
@interface HSYAlertView : HSYAlertBase

- (instancetype)initWithTitle:(NSString*)title
                       cancel:(NSString*)cancel
                      confirm:(NSString*)confirm
                     delegate:(id<HSYAlertViewDelegate>)delegate
                      messege:(HSYAttributedString*)messege;

- (instancetype)initWithTitle:(NSString*)title
                       cancel:(NSString*)cancel
                      confirm:(NSString*)confirm
                     delegate:(id<HSYAlertViewDelegate>)delegate
                     messeges:(HSYAttributedString*)messege, ...;

@end


@protocol HSYAlertViewDelegate <NSObject>

@optional
- (void)alertView:(HSYAlertView*)alertView didDismissWithButtonType:(NSInteger)buttonType;

@end