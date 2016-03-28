//
//  UIScreen+FY.m
//  TestHSYAlertView
//
//  Created by Sean on 16/1/15.
//  Copyright (c) 2016年 seanhuang1661. All rights reserved.
//

#import "UIScreen+FY.h"
#import "FYMacro.h"

@implementation UIScreen (FY)

//屏幕宽
+ (CGFloat)screenWidth {
    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
    CGFloat h = [[UIScreen mainScreen] bounds].size.height;
    
    if (FYIsLandscape) {
        return MAX(w, h);
    }
    if (FYIsPortrait){
        return MIN(w, h);
    }
    return w;
}

//屏幕高
+ (CGFloat)screenHeight {
    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
    CGFloat h = [[UIScreen mainScreen] bounds].size.height;
    
    if (FYIsLandscape) {
        return MIN(w, h);
    }
    if (FYIsPortrait) {
        return MAX(w, h);
    }
    return w;
}

//屏幕长边
+ (CGFloat)screenLongSide {
    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
    CGFloat h = [[UIScreen mainScreen] bounds].size.height;
    return MAX(w, h);
}

//屏幕短边
+ (CGFloat)screenShortSide {
    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
    CGFloat h = [[UIScreen mainScreen] bounds].size.height;
    return MIN(w, h);
}

@end
