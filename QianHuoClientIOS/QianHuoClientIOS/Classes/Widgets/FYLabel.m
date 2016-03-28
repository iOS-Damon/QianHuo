//
//  NBLabel.m
//  Sample
//
//  Created by Sean on 15/6/16.
//  Copyright (c) 2015年 gRPC. All rights reserved.
//

#import "FYLabel.h"
@interface FYLabel()

@property (nonatomic, copy) NSString *string;
@property (nonatomic, assign) CGFloat size;
@property (nonatomic) UIColor *color;

- (void)initView;

@end

@implementation FYLabel

- (id)initWithString:(NSString*)string size:(CGFloat)size color:(UIColor*)color {
    if (self = [super init]) {
        self.string = string;
        self.size = size;
        self.color = color;
        [self initView];
    }
    return self;
}

- (void)initView {
    
    self.backgroundColor = [UIColor clearColor];
    self.text = self.string;
    self.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:self.size];
    self.textColor = self.color;
    [self sizeToFit];
}

- (void)setStringAndCenter:(NSString*)string {
    
    CGPoint center = self.center;
    self.text = string;
    [self sizeToFit];
    self.center = center;
}

- (void)setStringAndLeft:(NSString*)string {
    CGPoint p = self.frame.origin;
    self.text = string;
    [self sizeToFit];
    self.frame = CGRectMake(p.x, p.y, self.bounds.size.width, self.bounds.size.height);
}

- (void)setStringAndRight:(NSString*)string {
    CGRect frame = self.frame;
    self.text = string;
    [self sizeToFit];
    self.frame = CGRectMake(frame.origin.x + frame.size.width - self.frame.size.width, frame.origin.y, self.frame.size.width, self.frame.size.height);
}

@end
