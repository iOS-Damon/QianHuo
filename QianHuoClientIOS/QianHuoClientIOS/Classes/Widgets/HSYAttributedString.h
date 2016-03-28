//
//  HSYAttributedString.h
//  TestHSYAlertView
//
//  Created by Sean on 16/1/16.
//  Copyright (c) 2016年 seanhuang1661. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HSYAttributedStringAlign) {
    HSYAttributedStringAlignLeft,
    HSYAttributedStringAlignCenter,
    HSYAttributedStringAlignRight
};

@interface HSYAttributedString : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) NSInteger align;

@end
