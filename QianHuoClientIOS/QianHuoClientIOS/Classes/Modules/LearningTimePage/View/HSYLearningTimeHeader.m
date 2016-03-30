//
//  HSYLearningTimeHeader.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYLearningTimeHeader.h"
#import "UIView+FY.h"
#import "NSString+FY.h"


@implementation HSYLearningTimeHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.contentView.backgroundColor = FYColorMain;
}

- (void)setTitle:(NSString *)title {
    _title = FYClearNil(title);
    self.textLabel.attributedText = [[NSAttributedString alloc] initWithString:_title attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:FYLabSize3] ,NSForegroundColorAttributeName:FYColorSub}];
    [self setNeedsLayout];
}

#pragma mark - override
- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.center = CGPointMake(self.frameWidth / 2, self.frameHeight / 2);
}

@end
