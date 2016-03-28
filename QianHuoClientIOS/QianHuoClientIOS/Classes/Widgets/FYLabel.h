//
//  NBLabel.h
//  Sample
//
//  Created by Sean on 15/6/16.
//  Copyright (c) 2015年 gRPC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYLabel : UILabel

- (id)initWithString:(NSString*)string size:(CGFloat)size color:(UIColor*)color;

- (void)setStringAndCenter:(NSString*)string;

- (void)setStringAndLeft:(NSString*)string;

- (void)setStringAndRight:(NSString*)string;

@end
