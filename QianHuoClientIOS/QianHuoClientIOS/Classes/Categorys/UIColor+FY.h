//
//  UIColor+FY.h
//  ThePainter
//
//  Created by Sean on 15/11/4.
//  Copyright (c) 2015年 FeiYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (FY)

//根据十六进制色值生成颜色
+ (UIColor*)colorWithHexString:(NSString*)hex alpha:(CGFloat)alpha;

@end
