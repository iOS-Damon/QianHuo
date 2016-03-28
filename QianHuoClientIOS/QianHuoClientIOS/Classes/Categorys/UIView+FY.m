//
//  UIView+FY.m
//  ThePainter
//
//  Created by Sean on 15/11/4.
//  Copyright (c) 2015年 FeiYu. All rights reserved.
//

#import "UIView+FY.h"
#import "FYMacro.h"

@implementation UIView (FY)

- (void)setFrameOrigin:(CGPoint)frameOrigin {
    self.frame = CGRectMake(frameOrigin.x, frameOrigin.y, self.frame.size.width, self.frame.size.height);
}

- (CGPoint)frameOrigin {
    return self.frame.origin;
}

- (void)setFrameSize:(CGSize)frameSize {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, frameSize.width, frameSize.height);
}

- (CGSize)frameSize {
    return self.frame.size;
}

- (void)setFrameOriginX:(CGFloat)frameOriginX {
    self.frame = CGRectMake(frameOriginX, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameOriginX {
    return self.frame.origin.x;
}

- (void)setFrameOriginY:(CGFloat)frameOriginY {
    self.frame = CGRectMake(self.frame.origin.x, frameOriginY, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameOriginY {
    return self.frame.origin.y;
}

- (void)setFrameWidth:(CGFloat)frameWidth {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, frameWidth, self.frame.size.height);
}

- (CGFloat)frameWidth {
    return self.frame.size.width;
}

- (void)setFrameHeight:(CGFloat)frameHeight {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, frameHeight);
}

- (CGFloat)frameHeight {
    return self.frame.size.height;
}

@end
