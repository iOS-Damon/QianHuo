//
//  HSYLoadingManage.h
//  TestHSYLoading
//
//  Created by Sean on 15/12/4.
//  Copyright (c) 2015年 seanhuang1661. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HSYLoadingManage : NSObject

+ (instancetype)sharedInstance;
- (void)showLoadingForParentView:(UIView *)parentView withKey:(NSString*)key;
- (void)showLoadingForParentView:(UIView *)parentView withKey:(NSString*)key backgroundColor:(UIColor*)color;
- (void)hideLoadingWithKey:(NSString*)key;
- (void)showLoadingForWindow;
- (void)hideLoadingForWindow;

@end
