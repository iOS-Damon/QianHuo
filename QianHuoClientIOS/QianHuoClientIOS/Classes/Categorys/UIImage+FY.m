//
//  UIImage+FY.m
//  ThePainter
//
//  Created by Sean on 15/11/4.
//  Copyright (c) 2015年 FeiYu. All rights reserved.
//

#import "UIImage+FY.h"

@implementation UIImage (FY)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
