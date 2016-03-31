//
//  UIWebView+FY.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/31.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (FY)

- (void)cleanWhenDidFinishLoad;
- (void)cleanForDealloc;

@end
