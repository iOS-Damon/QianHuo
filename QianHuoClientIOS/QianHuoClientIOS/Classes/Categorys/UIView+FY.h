//
//  UIView+FY.h
//  ThePainter
//
//  Created by Sean on 15/11/4.
//  Copyright (c) 2015年 FeiYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FY)

@property (nonatomic, assign) CGPoint frameOrigin;
@property (nonatomic, assign) CGSize frameSize;

@property (nonatomic, assign) CGFloat frameOriginX;
@property (nonatomic, assign) CGFloat frameOriginY;

@property (nonatomic, assign) CGFloat frameWidth;
@property (nonatomic, assign) CGFloat frameHeight;

@end
