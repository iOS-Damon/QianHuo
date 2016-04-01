//
//  HSYLoading.m
//  TestHSYLoading
//
//  Created by Sean on 15/12/4.
//  Copyright (c) 2015年 seanhuang1661. All rights reserved.
//

#import "HSYLoading.h"
#import "UIColor+FY.h"
#import "UIView+FY.h"

static NSString * const HSYLoadingImage = @"Logo.png";

@interface HSYLoading ()

@end

@implementation HSYLoading

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    [self initBackground];
    [self initLoadingLayer];
}

- (void)initBackground {
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)initLoadingLayer {
    CGFloat shortWidth = MIN(self.frameWidth, self.frameHeight);
    
    CGFloat loadingLayerWidth = shortWidth * 0.2;
    CALayer *loadingLayer = [CALayer layer];
    [loadingLayer setFrame:CGRectMake(0, 0, loadingLayerWidth, loadingLayerWidth)];
    [loadingLayer setPosition:CGPointMake(self.frameWidth / 2, self.frameHeight / 2)];
    [loadingLayer setBackgroundColor:[[UIColor whiteColor] CGColor]];
    [loadingLayer setCornerRadius:loadingLayerWidth * 0.1];
    [loadingLayer setShadowColor:[[UIColor grayColor] CGColor]];
    [loadingLayer setShadowOffset:CGSizeMake(1, 1)];
    [loadingLayer setShadowOpacity:0.2];
    [self.layer addSublayer:loadingLayer];
    
    CGFloat imageLayerWidth = loadingLayerWidth * 0.4;
    CALayer *imageLayer = [CALayer layer];
    [imageLayer setFrame:CGRectMake(0, 0, imageLayerWidth, imageLayerWidth)];
    [imageLayer setPosition:CGPointMake(loadingLayer.frame.size.width / 2, loadingLayer.frame.size.height / 2)];
    [imageLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    UIImage *loadingImage = [UIImage imageNamed:HSYLoadingImage];
    [imageLayer setContents:(id)[loadingImage CGImage]];
    [loadingLayer addSublayer:imageLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    [animation setFromValue:0];
    [animation setToValue:[NSNumber numberWithFloat:(M_PI * 2)]];
    [animation setDuration:3.0];
    [animation setRepeatCount:HUGE_VALF];
    [imageLayer addAnimation:animation forKey:nil];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGColorSpaceRelease(space);
    CGFloat components[8]={
        0.0, 0.0, 0.0, 0.0,     //start color(r,g,b,alpha)
        0.0, 0.0, 0.0, 0.8      //end color
    };
    CGGradientRef gradient = CGGradientCreateWithColorComponents(space, components, NULL, 2);
    CGPoint centerPoint = CGPointMake(self.frameWidth / 2, self.frameHeight / 2);
    CGFloat endRadius = MAX(self.frameWidth, self.frameHeight);
    CGContextDrawRadialGradient(context, gradient, centerPoint, 0, centerPoint, endRadius, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
    gradient = NULL;
}

@end
